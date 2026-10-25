// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"
	"unicode/utf8"
)

// FeedbackFile is where feedback sent from the app is kept, one JSON object
// per line, in the data folder.
const FeedbackFile = "feedback.jsonl"

// FeedbackLimits bound what anyone, signed in or not, can send from the
// app's help page.
type FeedbackLimits struct {
	// MaxBytes caps one message's text.
	MaxBytes int
	// PerHour caps messages from one address.
	PerHour int
}

func (l FeedbackLimits) defaults() FeedbackLimits {
	if l.MaxBytes <= 0 {
		l.MaxBytes = 8 << 10
	}
	if l.PerHour <= 0 {
		l.PerHour = 5
	}
	return l
}

// Feedback is one message as it is kept.
type Feedback struct {
	Time     time.Time `json:"time"`
	Text     string    `json:"text"`
	Version  string    `json:"version,omitempty"`
	Platform string    `json:"platform,omitempty"`
	Locale   string    `json:"locale,omitempty"`
}

// shortField caps what the app says about itself.
const shortField = 64

func (s *Server) feedback(w http.ResponseWriter, r *http.Request) {
	limits := s.cfg.Feedback
	var sent Feedback
	body := http.MaxBytesReader(w, r.Body, int64(limits.MaxBytes)+4<<10)
	if err := json.NewDecoder(body).Decode(&sent); err != nil {
		http.Error(w, "feedback is a JSON object", http.StatusBadRequest)
		return
	}
	sent.Text = strings.TrimSpace(sent.Text)
	if sent.Text == "" || !utf8.ValidString(sent.Text) {
		http.Error(w, "feedback needs text", http.StatusBadRequest)
		return
	}
	if len(sent.Text) > limits.MaxBytes {
		http.Error(w, "feedback is too long", http.StatusRequestEntityTooLarge)
		return
	}
	for _, field := range []*string{&sent.Version, &sent.Platform, &sent.Locale} {
		if len(*field) > shortField || !utf8.ValidString(*field) {
			*field = ""
		}
	}
	now := s.cfg.Now()
	key := "feedback " + s.clientAddress(r)
	s.mu.Lock()
	recent := s.recentWithin(now, key, time.Hour)
	if len(recent) >= limits.PerHour {
		s.mu.Unlock()
		w.Header().Set("Retry-After", "3600")
		http.Error(w, "too much feedback from here; try later", http.StatusTooManyRequests)
		return
	}
	s.failures[key] = append(recent, now)
	s.mu.Unlock()

	sent.Time = now.UTC()
	if err := s.keepFeedback(sent); err != nil {
		s.log.Error("keep feedback", "err", err)
		http.Error(w, "feedback could not be kept", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

// keepFeedback appends one message; the file is only ever appended to.
func (s *Server) keepFeedback(sent Feedback) error {
	line, err := json.Marshal(sent)
	if err != nil {
		return err
	}
	s.feedbackMu.Lock()
	defer s.feedbackMu.Unlock()
	file, err := os.OpenFile(filepath.Join(s.cfg.DataDir, FeedbackFile),
		os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0o600)
	if err != nil {
		return err
	}
	if _, err := file.Write(append(line, '\n')); err != nil {
		file.Close()
		return err
	}
	return file.Close()
}

// ReadFeedback lists the messages kept in dataDir, oldest first.
func ReadFeedback(dataDir string) ([]Feedback, error) {
	file, err := os.Open(filepath.Join(dataDir, FeedbackFile))
	if errors.Is(err, os.ErrNotExist) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	defer file.Close()
	var all []Feedback
	decoder := json.NewDecoder(file)
	for {
		var one Feedback
		if err := decoder.Decode(&one); errors.Is(err, io.EOF) {
			return all, nil
		} else if err != nil {
			return all, err
		}
		all = append(all, one)
	}
}

// recentWithin is [Server.recent] over another window; call with s.mu held.
func (s *Server) recentWithin(now time.Time, key string, window time.Duration) []time.Time {
	kept := s.failures[key][:0]
	for _, at := range s.failures[key] {
		if now.Sub(at) < window {
			kept = append(kept, at)
		}
	}
	if len(kept) == 0 {
		delete(s.failures, key)
		return nil
	}
	s.failures[key] = kept
	return kept
}
