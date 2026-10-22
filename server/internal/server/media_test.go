// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"aiddiary/syncserver/internal/accounts"
)

func mediaPath(body string) string {
	hash := sha256.Sum256([]byte(body))
	return "/dav/space/media/chunks/photo/" + hex.EncodeToString(hash[:])
}

func (h *harness) mediaFolders() {
	h.t.Helper()
	for _, dir := range []string{"space", "space/media", "space/media/chunks", "space/media/chunks/photo", "space/media/manifests", "space/packs"} {
		h.expect(h.do("alice", "MKCOL", "/dav/"+dir, ""), http.StatusCreated)
	}
}

func (h *harness) remaining() int64 {
	h.t.Helper()
	var response struct {
		Media struct {
			Remaining int64 `json:"transferRemainingBytes"`
			MaxObject int64 `json:"maxObjectBytes"`
			Cache     int64 `json:"cacheBytes"`
			TTL       int64 `json:"cacheTtlSeconds"`
		} `json:"media"`
	}
	body := h.expect(h.do("alice", "GET", "/api/sync/policy", ""), 200)
	if err := json.Unmarshal([]byte(body), &response); err != nil {
		h.t.Fatal(err)
	}
	if response.Media.MaxObject <= 0 || response.Media.Cache <= 0 || response.Media.TTL <= 0 {
		h.t.Fatalf("invalid policy: %s", body)
	}
	return response.Media.Remaining
}

func TestMediaPolicyLimitsAndHashes(t *testing.T) {
	h := start(t)
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 10, CacheBytes: 12, DailyTransferBytes: 100, CacheTTL: time.Hour}
	h.add("alice", 0)
	h.mediaFolders()
	h.expect(h.do("", "GET", "/api/sync/policy", ""), http.StatusUnauthorized)
	if h.remaining() != 100 {
		t.Fatal("initial allowance")
	}
	h.expect(h.do("alice", "PUT", mediaPath("123456"), "123456"), 201)
	h.expect(h.do("alice", "PUT", mediaPath("abcdef"), "abcdef"), 201)
	h.expect(h.do("alice", "PUT", mediaPath("7"), "7"), 507)
	h.expect(h.do("alice", "PUT", mediaPath("12345678901"), "12345678901"), 413)
	// Metadata remains usable even when the separate media cache is full.
	h.expect(h.do("alice", "PUT", "/dav/space/packs/pack-a", strings.Repeat("x", 100)), 201)
	h.expect(h.do("alice", "DELETE", mediaPath("abcdef"), ""), 204)
	h.expect(h.do("alice", "PUT", mediaPath("other"), "wrong"), 422)
	h.expect(h.do("alice", "GET", mediaPath("other"), ""), 404)
	h.expect(h.do("alice", "PUT", "/dav/space/media/chunks/photo/not-a-hash", "bad"), 400)
	if got := h.remaining(); got != 83 {
		t.Fatalf("uploads including rejected hash consumed bytes: %d", got)
	}
}

func TestMediaExpiryKeepsManifestsAndPacks(t *testing.T) {
	h := start(t)
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 10, CacheBytes: 100, DailyTransferBytes: 100, CacheTTL: time.Hour}
	h.add("alice", 0)
	h.mediaFolders()
	h.expect(h.do("alice", "PUT", mediaPath("photo"), "photo"), 201)
	h.expect(h.do("alice", "PUT", "/dav/space/media/manifests/photo", "manifest"), 201)
	h.expect(h.do("alice", "PUT", "/dav/space/packs/pack-a", "entry"), 201)
	h.expect(h.do("alice", "MKCOL", "/dav/space/blobs", ""), 201)
	h.expect(h.do("alice", "PUT", "/dav/space/blobs/old", "old"), 201)
	h.advance(2 * time.Hour)
	h.expect(h.do("alice", "GET", mediaPath("photo"), ""), 404)
	h.expect(h.do("alice", "GET", "/dav/space/blobs/old", ""), 404)
	if h.expect(h.do("alice", "GET", "/dav/space/media/manifests/photo", ""), 200) != "manifest" {
		t.Fatal("manifest lost")
	}
	if h.expect(h.do("alice", "GET", "/dav/space/packs/pack-a", ""), 200) != "entry" {
		t.Fatal("pack lost")
	}
}

func TestMediaReadsChargeRangesButNotHeadOrNotModified(t *testing.T) {
	h := start(t)
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 10, CacheBytes: 100, DailyTransferBytes: 15, CacheTTL: time.Hour}
	h.add("alice", 0)
	h.mediaFolders()
	p := mediaPath("0123456789")
	h.expect(h.do("alice", "PUT", p, "0123456789"), 201)
	head := h.do("alice", "HEAD", p, "")
	h.expect(head, 200)
	for _, test := range []struct {
		headers map[string]string
		status  int
		body    string
	}{
		{map[string]string{"Range": "bytes=2-4"}, 206, "234"},
		{map[string]string{"Range": "bytes=0-1,4-5"}, 416, ""},
		{map[string]string{"Range": "bytes=-2"}, 206, "89"},
		{map[string]string{"If-None-Match": head.Header.Get("ETag")}, 304, ""},
		{map[string]string{}, 429, ""},
	} {
		r, _ := http.NewRequest("GET", h.url+p, nil)
		r.SetBasicAuth("alice", "alice password")
		for name, value := range test.headers {
			r.Header.Set(name, value)
		}
		response, err := http.DefaultClient.Do(r)
		if err != nil {
			t.Fatal(err)
		}
		body := h.expect(response, test.status)
		response.Body.Close()
		if test.body != "" && body != test.body {
			t.Fatalf("range bytes %q", body)
		}
	}
	if h.remaining() != 0 {
		t.Fatal("range accounting")
	}
	h.advance(24 * time.Hour)
	if h.remaining() != 15 {
		t.Fatal("UTC daily allowance did not renew")
	}
}

func TestMediaParallelDownloadsCannotOverspend(t *testing.T) {
	h := start(t)
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 10, CacheBytes: 100, DailyTransferBytes: 50, CacheTTL: time.Hour}
	h.add("alice", 0)
	h.mediaFolders()
	p := mediaPath("0123456789")
	h.expect(h.do("alice", "PUT", p, "0123456789"), 201)
	var successes atomic.Int64
	var wg sync.WaitGroup
	for range 20 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			r, _ := http.NewRequest("GET", h.url+p, nil)
			r.SetBasicAuth("alice", "alice password")
			response, err := http.DefaultClient.Do(r)
			if err != nil {
				t.Error(err)
				return
			}
			io.Copy(io.Discard, response.Body)
			response.Body.Close()
			if response.StatusCode == 200 {
				successes.Add(1)
			} else if response.StatusCode != 429 {
				t.Errorf("status %d", response.StatusCode)
			}
		}()
	}
	wg.Wait()
	if successes.Load() != 4 || h.remaining() != 0 {
		t.Fatalf("successful downloads: %d", successes.Load())
	}
}

func TestMediaAccountingSurvivesServerAndDatabaseRestart(t *testing.T) {
	h := start(t)
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 10, CacheBytes: 100, DailyTransferBytes: 20, CacheTTL: time.Hour}
	h.add("alice", 0)
	h.mediaFolders()
	p := mediaPath("0123456789")
	h.expect(h.do("alice", "PUT", p, "0123456789"), 201)
	h.expect(h.do("alice", "GET", p, ""), 200)
	cfg := h.server.cfg
	if err := h.store.Close(); err != nil {
		t.Fatal(err)
	}
	store, err := accounts.Open(filepath.Join(h.data, "accounts.db"), accounts.Hashing{MemoryKiB: 64, Time: 1, Threads: 1}, 8)
	if err != nil {
		t.Fatal(err)
	}
	defer store.Close()
	web := httptest.NewServer(New(cfg, store, h.server.log).Handler())
	defer web.Close()
	h.url = web.URL
	if h.remaining() != 0 {
		t.Fatal("restart reset allowance")
	}
	h.expect(h.do("alice", "GET", p, ""), 429)
	used, err := store.TransferUsed(context.Background(), 1, cfg.Now().UTC().Format(time.DateOnly))
	if err != nil || used != 20 {
		t.Fatalf("persisted usage %d: %v", used, err)
	}
}

func TestMediaCannotBypassLimitsWithCopyOrMove(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.mediaFolders()
	h.expect(h.do("alice", "PUT", "/dav/space/packs/pack-a", "body"), 201)
	for _, method := range []string{"COPY", "MOVE"} {
		for _, source := range []string{"/dav/space", "/dav/space/packs/pack-a"} {
			r, _ := http.NewRequest(method, h.url+source, nil)
			r.SetBasicAuth("alice", "alice password")
			r.Header.Set("Destination", h.url+mediaPath("body"))
			response, err := http.DefaultClient.Do(r)
			if err != nil {
				t.Fatal(err)
			}
			h.expect(response, 405)
			response.Body.Close()
		}
	}
}

type brokenDownload struct {
	header http.Header
	status int
	bytes  int64
}

func (w *brokenDownload) Header() http.Header    { return w.header }
func (w *brokenDownload) WriteHeader(status int) { w.status = status }
func (w *brokenDownload) Write(body []byte) (int, error) {
	n := min(3, len(body))
	w.bytes += int64(n)
	return n, io.ErrClosedPipe
}

func TestMediaInterruptedTransfersChargeOnlyActualBytes(t *testing.T) {
	h := start(t)
	h.server.cfg.Media = MediaLimits{MaxObjectBytes: 10, CacheBytes: 100, DailyTransferBytes: 100, CacheTTL: time.Hour}
	h.add("alice", 0)
	h.mediaFolders()
	p := mediaPath("0123456789")
	r := httptest.NewRequest("PUT", p, strings.NewReader("01234"))
	r.ContentLength = 10
	r.SetBasicAuth("alice", "alice password")
	recorder := httptest.NewRecorder()
	h.server.Handler().ServeHTTP(recorder, r)
	if recorder.Code != 400 {
		t.Fatalf("incomplete upload status %d", recorder.Code)
	}
	if h.remaining() != 95 {
		t.Fatal("incomplete upload was not settled to five bytes")
	}
	h.expect(h.do("alice", "GET", p, ""), 404)
	h.expect(h.do("alice", "PUT", p, "0123456789"), 201)
	r = httptest.NewRequest("GET", p, nil)
	r.SetBasicAuth("alice", "alice password")
	broken := &brokenDownload{header: make(http.Header)}
	h.server.Handler().ServeHTTP(broken, r)
	if broken.status != 200 || broken.bytes != 3 || h.remaining() != 82 {
		t.Fatalf("download did not settle actual bytes: status=%d bytes=%d remaining=%d", broken.status, broken.bytes, h.remaining())
	}
}

func TestMediaRequiresKnownUploadSizeAndCanonicalPaths(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.mediaFolders()
	r := httptest.NewRequest("PUT", mediaPath("photo"), strings.NewReader("photo"))
	r.ContentLength = -1
	r.SetBasicAuth("alice", "alice password")
	recorder := httptest.NewRecorder()
	h.server.Handler().ServeHTTP(recorder, r)
	if recorder.Code != 411 {
		t.Fatalf("unknown length status %d", recorder.Code)
	}
	for _, p := range []string{"/dav/space/media%5Cchunks/photo/file", "/dav/space/media./chunks/photo/file", "/dav/space/media/chunks/photo/file:stream"} {
		h.expect(h.do("alice", "PUT", p, "photo"), 400)
	}
}

func TestMediaManifestLimitSupportsVideoAndOperatorOverride(t *testing.T) {
	h := start(t)
	h.add("alice", 0)
	h.mediaFolders()
	h.expect(h.do("alice", "PUT", "/dav/space/media/manifests/video", strings.Repeat("x", 160<<10)), 201)
	h.expect(h.do("alice", "PUT", "/dav/space/media/manifests/oversize", strings.Repeat("x", (256<<10)+1)), 413)
	h.server.cfg.Media.MaxManifestBytes = 1024
	h.expect(h.do("alice", "PUT", "/dav/space/media/manifests/custom", strings.Repeat("x", 1025)), 413)
}
