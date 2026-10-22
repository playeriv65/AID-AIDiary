// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"aiddiary/syncserver/internal/accounts"
)

// MediaLimits apply per account; zero values select finite defaults.
type MediaLimits struct {
	MaxObjectBytes     int64
	MaxManifestBytes   int64
	CacheBytes         int64
	DailyTransferBytes int64
	CacheTTL           time.Duration
}

func (m MediaLimits) defaults() MediaLimits {
	if m.MaxObjectBytes <= 0 {
		m.MaxObjectBytes = 2 << 20
	}
	if m.MaxManifestBytes <= 0 {
		m.MaxManifestBytes = 256 << 10
	}
	if m.CacheBytes <= 0 {
		m.CacheBytes = 128 << 20
	}
	if m.DailyTransferBytes <= 0 {
		m.DailyTransferBytes = 256 << 20
	}
	if m.CacheTTL <= 0 {
		m.CacheTTL = 7 * 24 * time.Hour
	}
	return m
}

// mediaKind accepts canonical path components, so encoded separators and '..'
// receive exactly the same classification as the WebDAV filesystem.
func mediaKind(name string) string {
	parts := strings.Split(strings.ToLower(strings.Trim(path.Clean("/"+name), "/")), "/")
	for i, part := range parts {
		if part == "blobs" {
			return "chunk"
		}
		if part == "media" && i+1 < len(parts) {
			if parts[i+1] == "chunks" {
				return "chunk"
			}
			return "manifest"
		}
	}
	return ""
}

func isMedia(name string) bool { return mediaKind(name) != "" }

func (s *Server) policy(w http.ResponseWriter, r *http.Request) {
	user, ok := s.authenticate(w, r)
	if !ok {
		return
	}
	w.Header().Set("Cache-Control", "no-store")
	w.Header().Set("Content-Type", "application/json")
	network, err := s.networkPolicy(r.Context(), user.ID)
	if err != nil {
		http.Error(w, "network accounting unavailable", http.StatusServiceUnavailable)
		return
	}
	if !s.cfg.OperatorLimits {
		json.NewEncoder(w).Encode(map[string]any{"operatorLimited": false, "network": network})
		return
	}
	used, err := s.accounts.TransferUsed(r.Context(), user.ID, s.transferDay())
	if err != nil {
		http.Error(w, "transfer accounting unavailable", http.StatusServiceUnavailable)
		return
	}
	traffic, err := s.cloudTrafficPolicy(r.Context(), user.ID)
	if err != nil {
		http.Error(w, "traffic accounting unavailable", http.StatusServiceUnavailable)
		return
	}
	json.NewEncoder(w).Encode(map[string]any{"operatorLimited": true, "traffic": traffic, "network": network, "media": map[string]int64{
		"maxObjectBytes":         min(s.cfg.Media.MaxObjectBytes, s.cfg.MaxUploadBytes),
		"maxManifestBytes":       min(s.cfg.Media.defaults().MaxManifestBytes, min(s.cfg.Media.MaxObjectBytes, s.cfg.MaxUploadBytes)),
		"transferRemainingBytes": min(max(0, s.cfg.Media.DailyTransferBytes-used), traffic.MonthlyRemainingBytes),
		"cacheTtlSeconds":        int64(s.cfg.Media.CacheTTL.Seconds()),
		"cacheBytes":             s.cfg.Media.CacheBytes,
	}})
}

func (s *Server) transferDay() string { return s.cfg.Now().UTC().Format(time.DateOnly) }

func (s *Server) reserve(w http.ResponseWriter, r *http.Request, user accounts.User, bytes int64) (string, bool) {
	day := s.transferDay()
	if !s.cfg.OperatorLimits {
		return day, true
	}
	if err := s.accounts.ReserveCloudMedia(r.Context(), user.ID, day, bytes, s.cfg.Media.DailyTransferBytes, s.cfg.MonthlyMediaBytes); err != nil {
		if errors.Is(err, accounts.ErrTransferLimit) {
			now := s.cfg.Now().UTC()
			reset := now.Truncate(24 * time.Hour).Add(24 * time.Hour)
			if errors.Is(err, accounts.ErrMonthlyTransferLimit) {
				reset = nextMonth(now)
			}
			w.Header().Set("Retry-After", strconv.FormatInt(int64(reset.Sub(now).Seconds())+1, 10))
			http.Error(w, err.Error(), http.StatusTooManyRequests)
		} else {
			http.Error(w, "transfer accounting unavailable", http.StatusServiceUnavailable)
		}
		return "", false
	}
	return day, true
}

func (s *Server) refund(user accounts.User, day string, bytes int64) {
	if !s.cfg.OperatorLimits || bytes <= 0 {
		return
	}
	// The request may already be cancelled. Failure leaves the unused reservation
	// charged, which is conservative and cannot overspend the daily allowance.
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := s.accounts.RefundTransfer(ctx, user.ID, day, bytes); err != nil {
		s.log.Error("refund media transfer", "user", user.ID, "err", err)
	}
}

func (s *Server) mediaUsage(f *folder) (int64, error) {
	var bytes int64
	err := filepath.WalkDir(f.root, func(name string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(f.root, name)
		if err != nil {
			return err
		}
		if entry.IsDir() || !isMedia(filepath.ToSlash(rel)) {
			return nil
		}
		info, err := entry.Info()
		if err != nil {
			return err
		}
		bytes += info.Size()
		return nil
	})
	return bytes, err
}

// expireMedia only evicts ciphertext chunks (including old blob objects).
// Manifests, pairing files, packs and snapshots are never cache victims.
func (s *Server) expireMedia(f *folder) error {
	if !s.cfg.OperatorLimits {
		return nil
	}
	return filepath.WalkDir(f.root, func(name string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if entry.IsDir() {
			return nil
		}
		rel, err := filepath.Rel(f.root, name)
		if err != nil {
			return err
		}
		if mediaKind(filepath.ToSlash(rel)) != "chunk" {
			return nil
		}
		info, err := entry.Info()
		if err != nil {
			return err
		}
		if s.cfg.Now().Sub(info.ModTime()) < s.cfg.Media.CacheTTL {
			return nil
		}
		if err := os.Remove(name); err != nil {
			return err
		}
		f.used -= info.Size()
		return nil
	})
}

func (s *Server) putMedia(w http.ResponseWriter, r *http.Request, user accounts.User, f *folder) {
	limit := s.cfg.MaxUploadBytes
	if s.cfg.OperatorLimits {
		limit = min(limit, s.cfg.Media.MaxObjectBytes)
		if mediaKind(r.URL.Path) == "manifest" {
			limit = min(limit, s.cfg.Media.defaults().MaxManifestBytes)
		}
	}
	if r.ContentLength < 0 {
		http.Error(w, "media upload requires Content-Length", http.StatusLengthRequired)
		return
	}
	if r.ContentLength > limit {
		http.Error(w, "media object too large", http.StatusRequestEntityTooLarge)
		return
	}
	target := f.path(r.URL.Path)
	var before int64
	if info, err := os.Stat(target); err == nil {
		if info.IsDir() {
			http.Error(w, "target is a directory", http.StatusConflict)
			return
		}
		before = info.Size()
	}
	var used int64
	if s.cfg.OperatorLimits {
		var err error
		used, err = s.mediaUsage(f)
		if err != nil {
			http.Error(w, "storage unavailable", 500)
			return
		}
	}
	if (s.cfg.OperatorLimits && used-before+r.ContentLength > s.cfg.Media.CacheBytes) ||
		(user.QuotaBytes > 0 && f.used-before+r.ContentLength > user.QuotaBytes) {
		http.Error(w, "media cache full; wait for direct transfer", http.StatusInsufficientStorage)
		return
	}
	// Chunks are immutable ciphertext addressed by their SHA-256. Older blob
	// objects remain bounded without assuming that their names are hashes.
	wantHash := ""
	if strings.Contains(strings.ToLower(path.Clean(r.URL.Path)), "/media/chunks/") {
		wantHash = path.Base(r.URL.Path)
		decoded, err := hex.DecodeString(wantHash)
		if err != nil || len(decoded) != sha256.Size || wantHash != strings.ToLower(wantHash) {
			http.Error(w, "chunk name must be a ciphertext SHA-256", http.StatusBadRequest)
			return
		}
	}
	file, err := os.CreateTemp(filepath.Dir(target), ".media-upload-*")
	if err != nil {
		http.Error(w, "create media parent collection first", http.StatusConflict)
		return
	}
	defer os.Remove(file.Name())
	defer file.Close()
	day, ok := s.reserve(w, r, user, r.ContentLength)
	if !ok {
		return
	}
	hash := sha256.New()
	reader := &mediaReader{Reader: io.LimitReader(r.Body, r.ContentLength)}
	n, err := io.Copy(io.MultiWriter(file, hash), reader)
	defer func() { s.refund(user, day, r.ContentLength-reader.bytes) }()
	if err != nil || n != r.ContentLength {
		http.Error(w, "incomplete media upload", http.StatusBadRequest)
		return
	}
	if wantHash != "" && hex.EncodeToString(hash.Sum(nil)) != wantHash {
		http.Error(w, "ciphertext hash mismatch", http.StatusUnprocessableEntity)
		return
	}
	if err := file.Close(); err != nil {
		http.Error(w, "storage unavailable", 500)
		return
	}
	if err := os.Chtimes(file.Name(), s.cfg.Now(), s.cfg.Now()); err != nil {
		http.Error(w, "storage unavailable", 500)
		return
	}
	if err := os.Rename(file.Name(), target); err != nil {
		http.Error(w, "storage unavailable", 500)
		return
	}
	f.used += n - before
	w.WriteHeader(http.StatusCreated)
}

type mediaReader struct {
	io.Reader
	bytes int64
}

func (r *mediaReader) Read(p []byte) (int, error) {
	n, err := r.Reader.Read(p)
	r.bytes += int64(n)
	return n, err
}

type mediaWriter struct {
	http.ResponseWriter
	server   *Server
	request  *http.Request
	user     accounts.User
	day      string
	reserved int64
	bytes    int64
	denied   bool
	status   int
}

func (w *mediaWriter) WriteHeader(status int) {
	if w.status != 0 {
		return
	}
	w.status = status
	if status == http.StatusOK || status == http.StatusPartialContent {
		// ServeContent has already resolved conditions and ranges and set the
		// exact response length. Reserve before committing headers or any bytes.
		n, err := strconv.ParseInt(w.Header().Get("Content-Length"), 10, 64)
		if err != nil || n < 0 {
			w.denied = true
			w.Header().Del("Content-Length")
			http.Error(w.ResponseWriter, "unknown media response length", http.StatusInternalServerError)
			return
		}
		day, ok := w.server.reserve(w.ResponseWriter, w.request, w.user, n)
		if !ok {
			w.denied = true
			return
		}
		w.day, w.reserved = day, n
	}
	w.ResponseWriter.WriteHeader(status)
}

func (w *mediaWriter) Write(p []byte) (int, error) {
	if w.status == 0 {
		w.WriteHeader(http.StatusOK)
	}
	if w.denied {
		return 0, accounts.ErrTransferLimit
	}
	n, err := w.ResponseWriter.Write(p)
	if w.status == http.StatusOK || w.status == http.StatusPartialContent {
		w.bytes += int64(n)
	}
	return n, err
}

func (s *Server) getMedia(w http.ResponseWriter, r *http.Request, user accounts.User, f *folder) {
	file, err := os.Open(f.path(r.URL.Path))
	if err != nil {
		http.NotFound(w, r)
		return
	}
	defer file.Close()
	info, err := file.Stat()
	if err != nil || info.IsDir() {
		http.NotFound(w, r)
		return
	}
	etag := fmt.Sprintf(`"%x-%x"`, info.ModTime().UnixNano(), info.Size())
	w.Header().Set("ETag", etag)
	w.Header().Set("Cache-Control", "private, no-cache")
	if r.Method == http.MethodHead {
		http.ServeContent(w, r, info.Name(), info.ModTime(), file)
		return
	}
	if strings.Contains(r.Header.Get("Range"), ",") {
		w.Header().Set("Content-Range", fmt.Sprintf("bytes */%d", info.Size()))
		http.Error(w, "one byte range required", http.StatusRequestedRangeNotSatisfiable)
		return
	}
	counter := &mediaWriter{ResponseWriter: w, server: s, request: r, user: user}
	http.ServeContent(counter, r, info.Name(), info.ModTime(), file)
	s.refund(user, counter.day, counter.reserved-min(counter.bytes, counter.reserved))
}
