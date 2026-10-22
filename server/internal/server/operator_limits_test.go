// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"net/http"
	"strings"
	"testing"
	"time"
)

func TestPersonalStorageRetainsMediaWithoutOperatorAccounting(t *testing.T) {
	h := startMode(t, false)
	h.add("alice", 0)
	// Deliberately tiny operator settings must be inactive on a personal server.
	h.server.cfg.MonthlyMediaBytes = 1
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 1, MaxManifestBytes: 1, CacheBytes: 1, DailyTransferBytes: 1, CacheTTL: time.Second}
	h.server.cfg.Network.SignalDailyBytes = 1
	h.server.cfg.Network.RelayDailyBytes = 1
	h.mediaFolders()
	body := "persistent encrypted photo"
	h.expect(h.do("alice", "PUT", mediaPath(body), body), 201)
	h.expect(h.do("alice", "PUT", "/dav/space/media/manifests/photo", "manifest"), 201)
	h.expect(h.do("alice", "PUT", "/dav/space/packs/pack-a", "metadata"), 201)
	assertNoOperatorCharges(t, h)
	h.advance(365 * 24 * time.Hour)
	if got := h.expect(h.do("alice", "GET", mediaPath(body), ""), 200); got != body {
		t.Fatalf("personal media lost: %q", got)
	}
	h.expect(h.do("alice", "GET", "/dav/space/media/manifests/photo", ""), 200)
	h.expect(h.do("alice", "PUT", mediaPath("wrong"), "other"), 422)
	h.expect(h.do("alice", "PUT", mediaPath(strings.Repeat("x", (1<<20)+1)), strings.Repeat("x", (1<<20)+1)), http.StatusRequestEntityTooLarge)
	assertNoOperatorCharges(t, h)
	policy := h.expect(h.do("alice", "GET", "/api/sync/policy", ""), 200)
	var decoded map[string]json.RawMessage
	if err := json.Unmarshal([]byte(policy), &decoded); err != nil {
		t.Fatal(err)
	}
	if string(decoded["operatorLimited"]) != "false" || decoded["network"] == nil || decoded["media"] != nil || decoded["traffic"] != nil || strings.Contains(policy, "remainingBytes") {
		t.Fatalf("personal policy exposes operator allowances: %s", policy)
	}
}

func TestPersonalRelayHasNoDailyOrMonthlyAllowance(t *testing.T) {
	h := startMode(t, false)
	h.add("alice", 0)
	h.server.cfg.MonthlyMediaBytes = 1
	h.server.cfg.Network.SignalDailyBytes = 1
	h.server.cfg.Network.RelayDailyBytes = 1
	a, _ := h.socket("alice", testRoom, "phone")
	b, welcome := h.socket("alice", testRoom, "desktop")
	socketRead(t, a, "join")
	payload := base64.StdEncoding.EncodeToString([]byte("encrypted peer data"))
	socketSend(t, a, networkMessage{Type: "relay", To: "desktop", Session: welcome.Session, Payload: payload})
	if got := socketRead(t, b, "relay"); got.Payload != payload {
		t.Fatalf("relay payload: %+v", got)
	}
	if budget := socketRead(t, a, "budget"); budget.Relay.RemainingBytes < 1<<40 {
		t.Fatalf("personal relay incorrectly limited: %+v", budget.Relay)
	}
	assertNoOperatorCharges(t, h)
}

func assertNoOperatorCharges(t *testing.T, h *harness) {
	t.Helper()
	ctx := context.Background()
	for _, kind := range []string{"signal", "relay"} {
		if used, err := h.store.NetworkUsed(ctx, 1, h.server.transferDay(), kind); err != nil || used != 0 {
			t.Fatalf("personal %s charged %d: %v", kind, used, err)
		}
	}
	if used, err := h.store.TransferUsed(ctx, 1, h.server.transferDay()); err != nil || used != 0 {
		t.Fatalf("personal cache charged %d: %v", used, err)
	}
	if used, err := h.store.MonthlyMediaUsed(ctx, 1, h.server.cfg.Now().UTC().Format("2006-01")); err != nil || used != 0 {
		t.Fatalf("personal month charged %d: %v", used, err)
	}
}

func TestOperatorPolicyExplicitlyAdvertisesTemporaryMeteredStorage(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	body := h.expect(h.do("alice", "GET", "/api/sync/policy", ""), 200)
	var policy struct {
		OperatorLimited bool               `json:"operatorLimited"`
		Traffic         cloudTrafficPolicy `json:"traffic"`
		Media           map[string]int64   `json:"media"`
	}
	if err := json.Unmarshal([]byte(body), &policy); err != nil {
		t.Fatal(err)
	}
	if !policy.OperatorLimited || policy.Traffic.MonthlyLimitBytes != 1000000000 || policy.Media["cacheTtlSeconds"] <= 0 {
		t.Fatalf("missing operator limits: %s", body)
	}
}
