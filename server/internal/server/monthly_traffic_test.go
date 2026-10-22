package server

import (
	"context"
	"encoding/json"
	"net/http"
	"testing"
	"time"
)

func TestMonthlyCloudPolicyDefersMediaAndKeepsMetadata(t *testing.T) {
	h := start(t)
	h.add("alice", 100000)
	h.mediaFolders()
	h.server.cfg.MonthlyMediaBytes = 15
	path := mediaPath("12345678")
	h.expect(h.do("alice", "PUT", path, "12345678"), http.StatusCreated)
	var policy struct {
		Traffic cloudTrafficPolicy `json:"traffic"`
	}
	body := h.expect(h.do("alice", "GET", "/api/sync/policy", ""), 200)
	if err := json.Unmarshal([]byte(body), &policy); err != nil {
		t.Fatal(err)
	}
	if policy.Traffic.MonthlyLimitBytes != 15 || policy.Traffic.MonthlyUsedBytes != 8 || policy.Traffic.MonthlyRemainingBytes != 7 || policy.Traffic.ResetsAt != "2026-11-01T00:00:00Z" {
		t.Fatalf("policy %s", body)
	}
	response := h.do("alice", "GET", path, "")
	if response.StatusCode != 429 || response.Header.Get("Retry-After") == "" {
		t.Fatal(response.StatusCode)
	}
	response.Body.Close()
	h.expect(h.do("alice", "PUT", "/dav/space/packs/pack-test", "text"), http.StatusCreated)
	h.advance(24 * time.Hour)
	h.expect(h.do("alice", "GET", path, ""), 429)
	// Relay shares the remaining cache budget, independently of daily limits.
	users, err := h.store.List(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if err := h.server.reserveNetwork(context.Background(), users[0].ID, h.server.transferDay(), "relay", 7); err != nil {
		t.Fatal(err)
	}
	if left, err := h.server.networkRemaining(context.Background(), users[0].ID, "relay"); err != nil || left != 0 {
		t.Fatalf("remaining %d %v", left, err)
	}
}
