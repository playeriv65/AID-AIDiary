// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"net/url"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"aiddiary/syncserver/internal/accounts"
	"github.com/coder/websocket"
)

const testRoom = "00112233445566778899aabbccddeeff"
const otherRoom = "ffeeddccbbaa99887766554433221100"

func (h *harness) socket(name, room, device string) (*websocket.Conn, networkMessage) {
	h.t.Helper()
	headers := http.Header{}
	r, _ := http.NewRequest("GET", h.url, nil)
	r.SetBasicAuth(name, name+" password")
	headers.Set("Authorization", r.Header.Get("Authorization"))
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	conn, response, err := websocket.Dial(ctx, strings.Replace(h.url, "http", "ws", 1)+"/api/sync/network?"+url.Values{"space": {room}, "device": {device}}.Encode(), &websocket.DialOptions{HTTPHeader: headers})
	if err != nil {
		if response != nil {
			h.t.Fatalf("dial: %s: %v", response.Status, err)
		}
		h.t.Fatal(err)
	}
	h.t.Cleanup(func() { conn.CloseNow() })
	welcome := socketRead(h.t, conn, "welcome")
	if welcome.Session == "" || welcome.Peers == nil || welcome.Relay == nil || welcome.Relay.MaxFrameBytes <= 0 {
		h.t.Fatalf("invalid welcome: %+v", welcome)
	}
	return conn, welcome
}

func socketRead(t *testing.T, conn *websocket.Conn, want string) networkMessage {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	for range 20 {
		_, data, err := conn.Read(ctx)
		if err != nil {
			t.Fatalf("read %s: %v", want, err)
		}
		var message networkMessage
		if err := json.Unmarshal(data, &message); err != nil {
			t.Fatal(err)
		}
		if message.Type == want {
			return message
		}
	}
	t.Fatalf("no %s message", want)
	return networkMessage{}
}
func socketSend(t *testing.T, conn *websocket.Conn, message networkMessage) []byte {
	t.Helper()
	data, err := json.Marshal(message)
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	if err := conn.Write(ctx, websocket.MessageText, data); err != nil {
		t.Fatal(err)
	}
	return data
}

func TestNetworkPresenceForwardingAndSeparateLedgers(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	a, aw := h.socket("alice", testRoom, "phone")
	b, bw := h.socket("alice", testRoom, "desktop")
	if len(*aw.Peers) != 0 || len(*bw.Peers) != 1 || (*bw.Peers)[0].Session != aw.Session {
		t.Fatalf("welcome peers: %+v", bw.Peers)
	}
	join := socketRead(t, a, "join")
	if join.Device != "desktop" || join.Session != bw.Session {
		t.Fatalf("join %+v", join)
	}
	payload := base64.StdEncoding.EncodeToString([]byte("opaque encrypted offer"))
	input := socketSend(t, a, networkMessage{Type: "signal", To: "desktop", Session: bw.Session, Payload: payload})
	got := socketRead(t, b, "signal")
	if got.From != "phone" || got.Session != aw.Session || got.Payload != payload || got.To != "" {
		t.Fatalf("forward %+v", got)
	}
	before, _ := h.store.NetworkUsed(context.Background(), 1, h.server.transferDay(), "relay")
	input = socketSend(t, a, networkMessage{Type: "relay", To: "desktop", Session: bw.Session, Payload: payload})
	got = socketRead(t, b, "relay")
	forward, _ := json.Marshal(got)
	budget := socketRead(t, a, "budget")
	used, err := h.store.NetworkUsed(context.Background(), 1, h.server.transferDay(), "relay")
	if err != nil || used-before != int64(len(input)+len(forward)) {
		t.Fatalf("relay bytes=%d expected=%d err=%v", used-before, len(input)+len(forward), err)
	}
	if budget.Relay.RemainingBytes != h.server.cfg.Network.RelayDailyBytes-used {
		t.Fatal("stale relay budget")
	}
	media, _ := h.store.TransferUsed(context.Background(), 1, h.server.transferDay())
	if media != 0 {
		t.Fatal("network borrowed media allowance")
	}
	b.CloseNow()
	leave := socketRead(t, a, "leave")
	if leave.Device != "desktop" || leave.Session != bw.Session {
		t.Fatalf("leave %+v", leave)
	}
}

func TestNetworkRoomAccountAndTargetSessionIsolation(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.add("bob", 0)
	a, _ := h.socket("alice", testRoom, "phone")
	b, bw := h.socket("alice", testRoom, "desktop")
	socketRead(t, a, "join")
	_, wrongRoom := h.socket("alice", otherRoom, "room-peer")
	_, wrongAccount := h.socket("bob", testRoom, "bob-peer")
	for _, target := range []struct{ device, session string }{{"room-peer", wrongRoom.Session}, {"bob-peer", wrongAccount.Session}, {"desktop", strings.Repeat("0", 32)}} {
		socketSend(t, a, networkMessage{Type: "signal", To: target.device, Session: target.session, Payload: "YQ=="})
		failure := socketRead(t, a, "error")
		if failure.Code != "offline" || failure.Kind != "signal" {
			t.Fatalf("isolation failure %+v", failure)
		}
	}
	socketSend(t, a, networkMessage{Type: "signal", To: "desktop", Session: bw.Session, Payload: "YQ=="})
	if socketRead(t, b, "signal").Payload != "YQ==" {
		t.Fatal("valid room failed")
	}
}

func TestNetworkReplacementFencesOldSession(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	a, _ := h.socket("alice", testRoom, "phone")
	old, oldWelcome := h.socket("alice", testRoom, "desktop")
	socketRead(t, a, "join")
	replacement, newWelcome := h.socket("alice", testRoom, "desktop")
	if oldWelcome.Session == newWelcome.Session {
		t.Fatal("session was reused")
	}
	join := socketRead(t, a, "join")
	if join.Session != newWelcome.Session {
		t.Fatal("replacement not announced")
	}
	old.CloseNow()
	socketSend(t, a, networkMessage{Type: "relay", To: "desktop", Session: oldWelcome.Session, Payload: "YQ=="})
	if socketRead(t, a, "error").Code != "offline" {
		t.Fatal("old session accepted")
	}
	socketSend(t, a, networkMessage{Type: "relay", To: "desktop", Session: newWelcome.Session, Payload: "YQ=="})
	if socketRead(t, replacement, "relay").Session == "" {
		t.Fatal("stale disconnect removed replacement")
	}
}

func TestNetworkBudgetSurvivesRestart(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.server.cfg.Network.RelayDailyBytes = 320
	a, aw := h.socket("alice", testRoom, "a")
	b, bw := h.socket("alice", testRoom, "b")
	socketRead(t, a, "join")
	input := socketSend(t, a, networkMessage{Type: "relay", To: "b", Session: bw.Session, Payload: "YQ=="})
	got := socketRead(t, b, "relay")
	forward, _ := json.Marshal(got)
	socketRead(t, a, "budget")
	expected := int64(len(input) + len(forward))
	// The next ingress fits but forwarding does not. Both sides of accepted
	// transfers share the account ledger, never another user's allowance.
	second := socketSend(t, a, networkMessage{Type: "relay", To: "b", Session: bw.Session, Payload: "YQ=="})
	if failure := socketRead(t, a, "error"); failure.Code != "budget" || failure.Kind != "relay" {
		t.Fatalf("budget response %+v", failure)
	}
	used, _ := h.store.NetworkUsed(context.Background(), 1, h.server.transferDay(), "relay")
	expected += int64(len(second))
	if used != expected || used > 320 {
		t.Fatalf("used=%d expected=%d", used, expected)
	}
	a.CloseNow()
	b.CloseNow()
	h.server.Close()
	if err := h.store.Close(); err != nil {
		t.Fatal(err)
	}
	store, err := accounts.Open(filepath.Join(h.data, "accounts.db"), accounts.Hashing{MemoryKiB: 64, Time: 1, Threads: 1}, 8)
	if err != nil {
		t.Fatal(err)
	}
	server := New(h.server.cfg, store, h.server.log)
	web := httptest.NewServer(server.Handler())
	t.Cleanup(func() { server.Close(); web.Close(); store.Close() })
	h.url = web.URL
	_, welcome := h.socket("alice", testRoom, "a")
	if welcome.Session == aw.Session || welcome.Relay.RemainingBytes != 320-expected {
		t.Fatalf("restart welcome %+v", welcome)
	}
}

func TestNetworkFramePeerAndHandshakeLimits(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.server.cfg.Network.RelayFrameBytes = 1024
	h.server.cfg.Network.MaxPeers = 2
	a, _ := h.socket("alice", testRoom, "a")
	_, bw := h.socket("alice", testRoom, "b")
	socketRead(t, a, "join")
	socketSend(t, a, networkMessage{Type: "relay", To: "b", Session: bw.Session, Payload: base64.StdEncoding.EncodeToString(make([]byte, 1100))})
	failure := socketRead(t, a, "error")
	if failure.Code != "too_large" || failure.Kind != "relay" {
		t.Fatalf("oversize %+v", failure)
	}
	for _, test := range []struct {
		name, query string
		status      int
	}{{"", "space=" + testRoom + "&device=c", 401}, {"alice", "space=bad&device=c", 400}, {"alice", "space=" + testRoom + "&device=c", 429}} {
		request, _ := http.NewRequest("GET", h.url+"/api/sync/network?"+test.query, nil)
		if test.name != "" {
			request.SetBasicAuth(test.name, test.name+" password")
		}
		response, err := http.DefaultClient.Do(request)
		if err != nil {
			t.Fatal(err)
		}
		response.Body.Close()
		if response.StatusCode != test.status {
			t.Fatalf("status=%d want=%d", response.StatusCode, test.status)
		}
	}
}

func TestNetworkCredentialRevocationClosesLiveSession(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.server.cfg.Network.HeartbeatInterval = 10 * time.Millisecond
	h.server.cfg.CredentialTTL = time.Millisecond
	conn, _ := h.socket("alice", testRoom, "phone")
	if err := h.store.SetPassword(context.Background(), "alice", "replacement password"); err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	if _, _, err := conn.Read(ctx); err == nil {
		t.Fatal("revoked credential kept live session")
	}
	if ctx.Err() != nil {
		t.Fatal("session was not revoked before read timeout")
	}
}

func TestNetworkHandshakeRateIsBoundedBeforeAuthentication(t *testing.T) {
	h := start(t)
	h.server.cfg.Network.ConnectsPerMinute = 2
	for i := range 3 {
		response := h.do("", "GET", "/api/sync/network?space="+testRoom+"&device=a", "")
		want := 401
		if i == 2 {
			want = 429
		}
		h.expect(response, want)
	}
	h.advance(time.Minute)
	h.expect(h.do("", "GET", "/api/sync/network?space="+testRoom+"&device=a", ""), 401)
}
