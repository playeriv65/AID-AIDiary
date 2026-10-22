// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package main

import (
	"os"
	"strings"
	"testing"
	"time"
)

func TestOperatorLimitsRequireExplicitOptIn(t *testing.T) {
	t.Setenv("AID_SYNC_OPERATOR_LIMITS", "false")
	t.Setenv("AID_SYNC_DEFAULT_QUOTA_MB", "0")
	if err := os.Unsetenv("AID_SYNC_DEFAULT_QUOTA_MB"); err != nil {
		t.Fatal(err)
	}
	if err := os.Unsetenv("AID_SYNC_OPERATOR_LIMITS"); err != nil {
		t.Fatal(err)
	}
	if s, err := load(); err != nil || s.operatorLimits || s.defaultQuotaMB != 0 {
		t.Fatalf("default operator mode: %+v %v", s, err)
	}
	for _, value := range []string{"false", "true"} {
		t.Setenv("AID_SYNC_OPERATOR_LIMITS", value)
		s, err := load()
		var wantQuota int64
		if value == "true" {
			wantQuota = 2048
		}
		if err != nil || s.operatorLimits != (value == "true") || s.defaultQuotaMB != wantQuota {
			t.Fatalf("operator flag %s: %+v %v", value, s, err)
		}
	}
	t.Setenv("AID_SYNC_OPERATOR_LIMITS", "false")
	t.Setenv("AID_SYNC_DEFAULT_QUOTA_MB", "500")
	if s, err := load(); err != nil || s.defaultQuotaMB != 500 {
		t.Fatalf("explicit personal disk quota: %+v %v", s, err)
	}
	t.Setenv("AID_SYNC_OPERATOR_LIMITS", "unlimited")
	if _, err := load(); err == nil || !strings.Contains(err.Error(), "AID_SYNC_OPERATOR_LIMITS") {
		t.Fatalf("invalid boolean accepted: %v", err)
	}
}

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
