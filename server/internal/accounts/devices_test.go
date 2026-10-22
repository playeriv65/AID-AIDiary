// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"crypto/x509"
	"path/filepath"
	"testing"
	"time"
)

func TestDeviceCredentialsSurviveRestartAndRevocationCannotRebootstrap(t *testing.T) {
	ctx := context.Background()
	file := filepath.Join(t.TempDir(), "devices.db")
	store, err := Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	user, err := store.Add(ctx, "alice", "password alice", 0)
	if err != nil {
		t.Fatal(err)
	}
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	spki, _ := x509.MarshalPKIXPublicKey(&key.PublicKey)
	now := time.Now()
	if err = store.RegisterDevice(ctx, user.ID, "device", "phone", spki, true, 16, now); err != nil {
		t.Fatal(err)
	}
	challenge, message, err := store.NewDeviceChallenge(ctx, "alice", "device", now, time.Minute)
	if err != nil {
		t.Fatal(err)
	}
	hash := sha256.Sum256(message)
	signature, _ := ecdsa.SignASN1(rand.Reader, key, hash[:])
	store.Close()
	store, err = Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	token, err := store.DeviceToken(ctx, challenge, signature, now, time.Minute*15)
	if err != nil {
		t.Fatal(err)
	}
	store.Close()
	store, err = Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	defer store.Close()
	if _, id, err := store.VerifyDeviceToken(ctx, token, now); err != nil || id != "device" {
		t.Fatalf("persisted token: %s %v", id, err)
	}
	if _, err = store.DeviceToken(ctx, challenge, signature, now, time.Minute*15); err == nil {
		t.Fatal("challenge replay after restart")
	}
	if err = store.RevokeDevice(ctx, user.ID, "device"); err != nil {
		t.Fatal(err)
	}
	if _, _, err = store.VerifyDeviceToken(ctx, token, now); err == nil {
		t.Fatal("revoked token accepted")
	}
	if err = store.RegisterDevice(ctx, user.ID, "another-device", "phone", spki, true, 16, now); err != ErrDeviceDenied {
		t.Fatalf("password rebootstrap: %v", err)
	}
}
