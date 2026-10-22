// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"errors"
	"io"
	"net/http"
	"strconv"
	"time"

	"aiddiary/syncserver/internal/accounts"
)

type readCloseBudget struct {
	io.Reader
	io.Closer
}

// Metadata shares the small daily control budget. Otherwise a renamed video
// could bypass media allowances by repeatedly uploading to a metadata path.
func (s *Server) reserveControl(w http.ResponseWriter, r *http.Request, user accounts.User, n int64) bool {
	err := s.reserveNetwork(r.Context(), user.ID, s.transferDay(), "signal", n)
	if err == nil {
		return true
	}
	if errors.Is(err, accounts.ErrTransferLimit) {
		now := s.cfg.Now().UTC()
		w.Header().Del("Content-Length")
		w.Header().Set("Retry-After", strconv.FormatInt(int64(now.Truncate(24*time.Hour).Add(24*time.Hour).Sub(now).Seconds())+1, 10))
		http.Error(w, "daily control allowance exhausted", 429)
	} else {
		http.Error(w, "control accounting unavailable", 503)
	}
	return false
}

type controlWriter struct {
	http.ResponseWriter
	server    *Server
	request   *http.Request
	user      accounts.User
	status    int
	committed bool
	denied    bool
}

func (w *controlWriter) WriteHeader(status int) {
	if w.status == 0 {
		w.status = status
	}
}
func (w *controlWriter) finish() {
	if !w.committed && !w.denied {
		if w.status == 0 {
			w.status = 200
		}
		w.ResponseWriter.WriteHeader(w.status)
		w.committed = true
	}
}
func (w *controlWriter) Write(p []byte) (int, error) {
	if w.denied {
		return 0, accounts.ErrTransferLimit
	}
	day := w.server.transferDay()
	// Defer the status until the first bytes, so a refused response can be 429.
	if !w.server.reserveControl(w.ResponseWriter, w.request, w.user, int64(len(p))) {
		w.denied = true
		return 0, accounts.ErrTransferLimit
	}
	w.finish()
	n, err := w.ResponseWriter.Write(p)
	w.server.refundNetwork(w.user.ID, day, "signal", int64(len(p)-n))
	return n, err
}
