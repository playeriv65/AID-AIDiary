// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"net/http"
	"strings"
	"testing"
	"time"
)

func TestFeedbackIsKeptWithoutSigningIn(t *testing.T) {
	h := start(t)
	response := h.do("", http.MethodPost, "/api/feedback",
		`{"text":"  同步很好用 ","version":"0.1.0+26102501","platform":"android","locale":"zh"}`)
	if response.StatusCode != http.StatusNoContent {
		t.Fatalf("status %d", response.StatusCode)
	}
	kept, err := ReadFeedback(h.data)
	if err != nil || len(kept) != 1 {
		t.Fatalf("kept %v, %v", kept, err)
	}
	one := kept[0]
	if one.Text != "同步很好用" || one.Platform != "android" || one.Locale != "zh" ||
		!one.Time.Equal(h.now) {
		t.Fatalf("kept %+v", one)
	}
}

func TestFeedbackRefusesEmptyLongAndTooMuch(t *testing.T) {
	h := start(t)
	for body, status := range map[string]int{
		`{"text":"   "}`: http.StatusBadRequest,
		`not json`:       http.StatusBadRequest,
		`{"text":"` + strings.Repeat("a", 9<<10) + `"}`: http.StatusRequestEntityTooLarge,
	} {
		if got := h.do("", http.MethodPost, "/api/feedback", body).StatusCode; got != status {
			t.Errorf("%.20s: status %d, want %d", body, got, status)
		}
	}
	for i := 0; i < 5; i++ {
		if got := h.do("", http.MethodPost, "/api/feedback", `{"text":"hi"}`).StatusCode; got != http.StatusNoContent {
			t.Fatalf("message %d: status %d", i, got)
		}
	}
	if got := h.do("", http.MethodPost, "/api/feedback", `{"text":"hi"}`).StatusCode; got != http.StatusTooManyRequests {
		t.Fatalf("sixth in an hour: status %d", got)
	}
	h.advance(time.Hour)
	if got := h.do("", http.MethodPost, "/api/feedback", `{"text":"hi"}`).StatusCode; got != http.StatusNoContent {
		t.Fatalf("an hour later: status %d", got)
	}
	// Long app details are dropped, not refused.
	h.do("", http.MethodPost, "/api/feedback", `{"text":"x","platform":"`+strings.Repeat("p", 100)+`"}`)
	kept, _ := ReadFeedback(h.data)
	if last := kept[len(kept)-1]; last.Platform != "" {
		t.Fatalf("kept platform %q", last.Platform)
	}
}
