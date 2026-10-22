// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package main

import (
	"strings"
	"testing"
	"time"
)

func TestMediaEnvironmentOverridesAreBounded(t *testing.T) {
	t.Setenv("AID_SYNC_MEDIA_MAX_OBJECT_BYTES", "8192")
	t.Setenv("AID_SYNC_MEDIA_MAX_MANIFEST_BYTES", "4096")
	t.Setenv("AID_SYNC_MEDIA_CACHE_BYTES", "32768")
	t.Setenv("AID_SYNC_MEDIA_DAILY_TRANSFER_BYTES", "65536")
	t.Setenv("AID_SYNC_MEDIA_CACHE_TTL", "48h")
	s, err := load()
	if err != nil {
		t.Fatal(err)
	}
	if s.media.MaxObjectBytes != 8192 || s.media.MaxManifestBytes != 4096 || s.media.CacheBytes != 32768 || s.media.DailyTransferBytes != 65536 || s.media.CacheTTL != 48*time.Hour {
		t.Fatalf("configuration: %+v", s.media)
	}
	for _, name := range []string{"AID_SYNC_MEDIA_MAX_OBJECT_BYTES", "AID_SYNC_MEDIA_MAX_MANIFEST_BYTES", "AID_SYNC_MEDIA_CACHE_BYTES", "AID_SYNC_MEDIA_DAILY_TRANSFER_BYTES", "AID_SYNC_MEDIA_CACHE_TTL"} {
		t.Run(name, func(t *testing.T) {
			for _, bad := range []string{"0", "-1", "unlimited"} {
				t.Setenv(name, bad)
				if _, err := load(); err == nil || !strings.Contains(err.Error(), name) {
					t.Fatalf("%s=%s accepted: %v", name, bad, err)
				}
			}
		})
	}
}
