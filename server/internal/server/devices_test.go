// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"aiddiary/syncserver/internal/accounts"
	"bytes"
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"github.com/coder/websocket"
	"io"
	"net/http"
	"strings"
	"sync"
	"testing"
	"time"
)

func deviceKey(t *testing.T) *ecdsa.PrivateKey {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	return key
}
func keySPKI(t *testing.T, key *ecdsa.PrivateKey) []byte {
	t.Helper()
	b, err := x509.MarshalPKIXPublicKey(&key.PublicKey)
	if err != nil {
		t.Fatal(err)
	}
	return b
}
func deviceSign(t *testing.T, key *ecdsa.PrivateKey, message []byte) string {
	t.Helper()
	hash := sha256.Sum256(message)
	b, err := ecdsa.SignASN1(rand.Reader, key, hash[:])
	if err != nil {
		t.Fatal(err)
	}
	return base64.StdEncoding.EncodeToString(b)
}
func deviceRequest(t *testing.T, h *harness, method, path, auth string, body any) (int, map[string]any) {
	t.Helper()
	var data []byte
	if body != nil {
		data, _ = json.Marshal(body)
	}
	req, err := http.NewRequest(method, h.url+path, bytes.NewReader(data))
	if err != nil {
		t.Fatal(err)
	}
	if auth != "" {
		req.Header.Set("Authorization", auth)
	}
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatal(err)
	}
	defer resp.Body.Close()
	result := map[string]any{}
	raw, _ := io.ReadAll(resp.Body)
	_ = json.Unmarshal(raw, &result)
	return resp.StatusCode, result
}
func deviceEnroll(t *testing.T, h *harness, name, id, auth string, key *ecdsa.PrivateKey) int {
	spki := keySPKI(t, key)
	status, _ := deviceRequest(t, h, "POST", "/api/sync/devices", auth, enrollment{ID: id, Label: id, PublicKey: base64.StdEncoding.EncodeToString(spki), Signature: deviceSign(t, key, accounts.DeviceEnrollmentMessage(name, id, spki))})
	return status
}
func basicDevice(name string) string {
	return "Basic " + base64.StdEncoding.EncodeToString([]byte(name+":"+name+" password"))
}
func deviceLogin(t *testing.T, h *harness, name, id string, key *ecdsa.PrivateKey) (string, map[string]any) {
	t.Helper()
	status, challenge := deviceRequest(t, h, "POST", "/api/sync/auth/challenge", "", map[string]string{"username": name, "device": id})
	if status != 200 {
		t.Fatalf("challenge: %d", status)
	}
	message, _ := base64.StdEncoding.DecodeString(challenge["message"].(string))
	proof := map[string]any{"challenge": challenge["challenge"], "signature": deviceSign(t, key, message)}
	status, response := deviceRequest(t, h, "POST", "/api/sync/auth/token", "", proof)
	if status != 200 {
		t.Fatalf("token: %d", status)
	}
	return "Bearer " + response["token"].(string), proof
}

func TestDeviceBootstrapAuthorizationRevokeAndRotation(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.add("bob", 0)
	a, b, c := deviceKey(t), deviceKey(t), deviceKey(t)
	if status := deviceEnroll(t, h, "alice", "alice-a", basicDevice("alice"), a); status != 200 {
		t.Fatal(status)
	}
	if status := deviceEnroll(t, h, "alice", "alice-b", basicDevice("alice"), b); status != 403 {
		t.Fatalf("password reopened bootstrap: %d", status)
	}
	if status, _ := deviceRequest(t, h, "GET", "/api/sync/policy", basicDevice("alice"), nil); status != 401 {
		t.Fatalf("password still granted storage: %d", status)
	}
	token, proof := deviceLogin(t, h, "alice", "alice-a", a)
	if status, _ := deviceRequest(t, h, "POST", "/api/sync/auth/token", "", proof); status != 403 {
		t.Fatalf("replay: %d", status)
	}
	if status := deviceEnroll(t, h, "alice", "alice-b", token, b); status != 200 {
		t.Fatal(status)
	}
	if status := deviceEnroll(t, h, "alice", "alice-b", token, b); status != 200 {
		t.Fatalf("authorized retry was not idempotent: %d", status)
	}
	bToken, _ := deviceLogin(t, h, "alice", "alice-b", b)
	if status := deviceEnroll(t, h, "bob", "bob-c", basicDevice("bob"), c); status != 200 {
		t.Fatal(status)
	}
	cToken, _ := deviceLogin(t, h, "bob", "bob-c", c)
	if status, _ := deviceRequest(t, h, "DELETE", "/api/sync/devices/alice-b", cToken, nil); status != 404 {
		t.Fatalf("cross-account revoke: %d", status)
	}
	// Device-authorized websocket identity is bound to the token, not a query hint.
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*2)
	defer cancel()
	_, response, err := websocket.Dial(ctx, strings.Replace(h.url, "http:", "ws:", 1)+"/api/sync/network?space="+strings.Repeat("a", 32)+"&device=alice-a", &websocket.DialOptions{HTTPHeader: http.Header{"Authorization": []string{bToken}}})
	if err == nil || response.StatusCode != 403 {
		t.Fatalf("WS impersonation: %v", err)
	}
	if status, _ := deviceRequest(t, h, "DELETE", "/api/sync/devices/alice-b", token, nil); status != 200 {
		t.Fatal(status)
	}
	if status, _ := deviceRequest(t, h, "GET", "/api/sync/policy", bToken, nil); status != 401 {
		t.Fatalf("revoked token: %d", status)
	}
	rotated := deviceKey(t)
	spki := keySPKI(t, rotated)
	rotate := enrollment{ID: "alice-a", PublicKey: base64.StdEncoding.EncodeToString(spki), Signature: deviceSign(t, rotated, append([]byte("aid-device-rotate-v1\n"), accounts.DeviceEnrollmentMessage("alice", "alice-a", spki)...))}
	if status, _ := deviceRequest(t, h, "POST", "/api/sync/devices/rotate", token, rotate); status != 200 {
		t.Fatalf("rotate: %d", status)
	}
	if status, _ := deviceRequest(t, h, "GET", "/api/sync/policy", token, nil); status != 401 {
		t.Fatalf("rotation kept token: %d", status)
	}
	newToken, _ := deviceLogin(t, h, "alice", "alice-a", rotated)
	if status, _ := deviceRequest(t, h, "GET", "/api/sync/policy", newToken, nil); status != 200 {
		t.Fatal(status)
	}
}

func TestRevocationClosesEstablishedDeviceWebSocket(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	a, b := deviceKey(t), deviceKey(t)
	if status := deviceEnroll(t, h, "alice", "a", basicDevice("alice"), a); status != 200 {
		t.Fatal(status)
	}
	aToken, _ := deviceLogin(t, h, "alice", "a", a)
	if status := deviceEnroll(t, h, "alice", "b", aToken, b); status != 200 {
		t.Fatal(status)
	}
	bToken, _ := deviceLogin(t, h, "alice", "b", b)
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	conn, _, err := websocket.Dial(ctx, strings.Replace(h.url, "http:", "ws:", 1)+"/api/sync/network?space="+testRoom+"&device=b",
		&websocket.DialOptions{HTTPHeader: http.Header{"Authorization": []string{bToken}}})
	if err != nil {
		t.Fatal(err)
	}
	defer conn.CloseNow()
	socketRead(t, conn, "welcome")
	if status, _ := deviceRequest(t, h, "DELETE", "/api/sync/devices/b", aToken, nil); status != 200 {
		t.Fatal(status)
	}
	if _, _, err = conn.Read(ctx); err == nil {
		t.Fatal("revoked device kept websocket")
	}
}

func TestFailedDeviceProofBurnsChallenge(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	key := deviceKey(t)
	if status := deviceEnroll(t, h, "alice", "device", basicDevice("alice"), key); status != 200 {
		t.Fatal(status)
	}
	_, challenge := deviceRequest(t, h, "POST", "/api/sync/auth/challenge", "", map[string]string{"username": "alice", "device": "device"})
	message, _ := base64.StdEncoding.DecodeString(challenge["message"].(string))
	bad := deviceSign(t, deviceKey(t), message)
	proof := map[string]any{"challenge": challenge["challenge"], "signature": bad}
	if status, _ := deviceRequest(t, h, "POST", "/api/sync/auth/token", "", proof); status != 403 {
		t.Fatal(status)
	}
	proof["signature"] = deviceSign(t, key, message)
	if status, _ := deviceRequest(t, h, "POST", "/api/sync/auth/token", "", proof); status != 403 {
		t.Fatalf("failed proof did not burn nonce: %d", status)
	}
}

func TestDeviceChallengeConcurrentReplayAndExpiry(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	key := deviceKey(t)
	if status := deviceEnroll(t, h, "alice", "device", basicDevice("alice"), key); status != 200 {
		t.Fatal(status)
	}
	status, challenge := deviceRequest(t, h, "POST", "/api/sync/auth/challenge", "", map[string]string{"username": "alice", "device": "device"})
	if status != 200 {
		t.Fatal(status)
	}
	message, _ := base64.StdEncoding.DecodeString(challenge["message"].(string))
	proof := map[string]any{"challenge": challenge["challenge"], "signature": deviceSign(t, key, message)}
	var wg sync.WaitGroup
	statuses := make(chan int, 2)
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			s, _ := deviceRequest(t, h, "POST", "/api/sync/auth/token", "", proof)
			statuses <- s
		}()
	}
	wg.Wait()
	close(statuses)
	wins := 0
	for s := range statuses {
		if s == 200 {
			wins++
		} else if s != 403 {
			t.Fatal(s)
		}
	}
	if wins != 1 {
		t.Fatalf("issued %d tokens", wins)
	}
	_, challenge = deviceRequest(t, h, "POST", "/api/sync/auth/challenge", "", map[string]string{"username": "alice", "device": "device"})
	message, _ = base64.StdEncoding.DecodeString(challenge["message"].(string))
	proof = map[string]any{"challenge": challenge["challenge"], "signature": deviceSign(t, key, message)}
	h.advance(3 * time.Minute)
	if status, _ = deviceRequest(t, h, "POST", "/api/sync/auth/token", "", proof); status != 403 {
		t.Fatalf("expired challenge: %d", status)
	}
	token, _ := deviceLogin(t, h, "alice", "device", key)
	h.advance(16 * time.Minute)
	if status, _ = deviceRequest(t, h, "GET", "/api/sync/policy", token, nil); status != 401 {
		t.Fatalf("expired token: %d", status)
	}
}
