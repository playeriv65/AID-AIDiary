package server

import (
	"context"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestMetadataCannotBypassCloudTrafficByRenamingMedia(t *testing.T) {
	h := start(t)
	h.add("alice", 100000)
	h.server.cfg.Network.SignalDailyBytes = 128
	h.expect(h.do("alice", "PUT", "/dav/renamed-video", strings.Repeat("x", 129)), 429)
	if _, err := os.Stat(filepath.Join(h.data, "users", "1", "renamed-video")); !os.IsNotExist(err) {
		t.Fatalf("refused body persisted %v", err)
	}
	// Refusal bodies also consume control traffic. Use a fresh account for the
	// exact successful upload/download boundary.
	h = start(t)
	h.add("alice", 100000)
	h.server.cfg.Network.SignalDailyBytes = 128
	h.expect(h.do("alice", "PUT", "/dav/metadata", strings.Repeat("x", 64)), http.StatusCreated)
	// WebDAV's successful PUT also returns a counted "Created" body. Begin the
	// exact 128-byte boundary on the next UTC day with two 64-byte downloads.
	h.advance(24 * time.Hour)
	h.expect(h.do("alice", "GET", "/dav/metadata", ""), 200)
	h.expect(h.do("alice", "GET", "/dav/metadata", ""), 200)
	response := h.do("alice", "GET", "/dav/metadata", "")
	if response.StatusCode != 429 || response.Header.Get("Retry-After") == "" {
		t.Fatal(response.StatusCode)
	}
	response.Body.Close()
	for i := 0; i < 3; i++ {
		h.expect(h.do("alice", "GET", "/dav/metadata", ""), http.StatusTooManyRequests)
	}
	users, err := h.store.List(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	used, err := h.store.NetworkUsed(context.Background(), users[0].ID, h.server.transferDay(), "signal")
	if err != nil || used != 128 {
		t.Fatalf("control charged %d %v", used, err)
	}
	// Month media allowance was not charged by metadata, including refused data.
	media, err := h.store.MonthlyMediaUsed(context.Background(), users[0].ID, "2026-10")
	if err != nil || media != 0 {
		t.Fatalf("media charged %d %v", media, err)
	}
}
