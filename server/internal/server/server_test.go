// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"aiddiary/syncserver/internal/accounts"
)

type harness struct {
	t      *testing.T
	url    string
	data   string
	store  *accounts.Store
	server *Server
	now    time.Time
	mu     sync.Mutex
}

func start(t *testing.T) *harness {
	t.Helper()
	data := t.TempDir()
	store, err := accounts.Open(filepath.Join(data, "accounts.db"),
		accounts.Hashing{MemoryKiB: 64, Time: 1, Threads: 1}, 8)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { store.Close() })
	h := &harness{t: t, data: data, store: store, now: time.Date(2026, 10, 21, 9, 0, 0, 0, time.UTC)}
	h.server = New(Config{
		DataDir:        data,
		MaxUploadBytes: 1 << 20,
		CredentialTTL:  time.Minute,
		FailLimit:      3,
		FailWindow:     10 * time.Minute,
		Now: func() time.Time {
			h.mu.Lock()
			defer h.mu.Unlock()
			return h.now
		},
	}, store, slog.New(slog.NewTextHandler(io.Discard, nil)))
	web := httptest.NewServer(h.server.Handler())
	t.Cleanup(web.Close)
	h.url = web.URL
	return h
}

func (h *harness) add(name string, quota int64) {
	h.t.Helper()
	if _, err := h.store.Add(context.Background(), name, name+" password", quota); err != nil {
		h.t.Fatal(err)
	}
}

func (h *harness) advance(d time.Duration) {
	h.mu.Lock()
	h.now = h.now.Add(d)
	h.mu.Unlock()
}

// do sends a request as name (or anonymously for ""), with its password
// unless one is given.
func (h *harness) do(name, method, p, body string, password ...string) *http.Response {
	h.t.Helper()
	request, err := http.NewRequest(method, h.url+p, strings.NewReader(body))
	if err != nil {
		h.t.Fatal(err)
	}
	if name != "" {
		secret := name + " password"
		if len(password) > 0 {
			secret = password[0]
		}
		request.SetBasicAuth(name, secret)
	}
	if method == "PROPFIND" {
		request.Header.Set("Depth", "1")
	}
	response, err := http.DefaultClient.Do(request)
	if err != nil {
		h.t.Fatal(err)
	}
	h.t.Cleanup(func() { response.Body.Close() })
	return response
}

func (h *harness) expect(response *http.Response, status int) string {
	h.t.Helper()
	body, _ := io.ReadAll(response.Body)
	if response.StatusCode != status {
		h.t.Fatalf("%s %s: got %d, want %d: %s", response.Request.Method,
			response.Request.URL.Path, response.StatusCode, status, body)
	}
	return string(body)
}

func TestHealth(t *testing.T) {
	h := start(t)
	if body := h.expect(h.do("", "GET", "/healthz", ""), 200); body != "ok\n" {
		t.Fatalf("health said %q", body)
	}
}

func TestSignInIsRequired(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	response := h.do("", "PROPFIND", "/dav/", "")
	h.expect(response, http.StatusUnauthorized)
	if !strings.Contains(response.Header.Get("WWW-Authenticate"), "Basic") {
		t.Fatal("no Basic challenge")
	}
	h.expect(h.do("alice", "PROPFIND", "/dav/", "", "wrong password"), http.StatusUnauthorized)
	h.expect(h.do("mallory", "PROPFIND", "/dav/", ""), http.StatusUnauthorized)
	h.expect(h.do("alice", "PROPFIND", "/dav/", ""), http.StatusMultiStatus)
}

func TestFilesRoundTripWithETags(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.expect(h.do("alice", "MKCOL", "/dav/AID%20Diary/", ""), http.StatusCreated)
	h.expect(h.do("alice", "MKCOL", "/dav/AID%20Diary/items/", ""), http.StatusCreated)
	put := h.do("alice", "PUT", "/dav/AID%20Diary/items/a", "sealed bytes")
	h.expect(put, http.StatusCreated)
	if body := h.expect(h.do("alice", "GET", "/dav/AID%20Diary/items/a", ""), 200); body != "sealed bytes" {
		t.Fatalf("read back %q", body)
	}
	listing := h.expect(h.do("alice", "PROPFIND", "/dav/AID%20Diary/items/", ""), http.StatusMultiStatus)
	if !strings.Contains(listing, "getetag") || !strings.Contains(listing, "/items/a") {
		t.Fatalf("listing: %s", listing)
	}
	h.expect(h.do("alice", "DELETE", "/dav/AID%20Diary/items/a", ""), http.StatusNoContent)
	h.expect(h.do("alice", "GET", "/dav/AID%20Diary/items/a", ""), http.StatusNotFound)
}

func TestUsersCannotReachEachOther(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.add("bob", 0)
	h.expect(h.do("alice", "PUT", "/dav/diary", "alice's"), http.StatusCreated)
	h.expect(h.do("bob", "GET", "/dav/diary", ""), http.StatusNotFound)
	// Climbing out of the folder lands back inside it.
	for _, p := range []string{"/dav/../1/diary", "/dav/%2e%2e/1/diary", "/dav/..%2f1/diary"} {
		if response := h.do("bob", "GET", p, ""); response.StatusCode == 200 {
			t.Fatalf("%s reached another user's file", p)
		}
	}
	bob := h.expect(h.do("bob", "PROPFIND", "/dav/", ""), http.StatusMultiStatus)
	if strings.Contains(bob, "diary") {
		t.Fatalf("bob sees alice's file: %s", bob)
	}
}

func TestQuotaIsEnforcedAndFreedOnDelete(t *testing.T) {
	h := start(t)
	h.add("alice", 10)
	h.expect(h.do("alice", "PUT", "/dav/a", "123456"), http.StatusCreated)
	h.expect(h.do("alice", "PUT", "/dav/b", "123456"), http.StatusInsufficientStorage)
	// Replacing a file counts only the difference.
	h.expect(h.do("alice", "PUT", "/dav/a", "1234567890"), http.StatusCreated)
	h.expect(h.do("alice", "DELETE", "/dav/a", ""), http.StatusNoContent)
	h.expect(h.do("alice", "PUT", "/dav/b", "123456"), http.StatusCreated)
}

func TestUploadsAreCapped(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	big := strings.Repeat("x", (1<<20)+1)
	h.expect(h.do("alice", "PUT", "/dav/big", big), http.StatusRequestEntityTooLarge)
	if _, err := os.Stat(filepath.Join(h.data, "users", "1", "big")); err == nil {
		t.Fatal("the oversized file was kept")
	}
}

func TestRepeatedFailuresAreBlockedForAWhile(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	for range 3 {
		h.expect(h.do("alice", "PROPFIND", "/dav/", "", "guess"), http.StatusUnauthorized)
	}
	// Blocked even with the right password, until the window passes.
	blocked := h.do("alice", "PROPFIND", "/dav/", "")
	h.expect(blocked, http.StatusTooManyRequests)
	if blocked.Header.Get("Retry-After") == "" {
		t.Fatal("no Retry-After")
	}
	h.advance(11 * time.Minute)
	h.expect(h.do("alice", "PROPFIND", "/dav/", ""), http.StatusMultiStatus)
}

func TestAChangedPasswordTakesEffectAfterTheTrustExpires(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.expect(h.do("alice", "PROPFIND", "/dav/", ""), http.StatusMultiStatus)
	if err := h.store.SetPassword(context.Background(), "alice", "a new password"); err != nil {
		t.Fatal(err)
	}
	h.advance(2 * time.Minute)
	h.expect(h.do("alice", "PROPFIND", "/dav/", ""), http.StatusUnauthorized)
	h.expect(h.do("alice", "PROPFIND", "/dav/", "", "a new password"), http.StatusMultiStatus)
}
