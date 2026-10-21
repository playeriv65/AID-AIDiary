// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"context"
	"database/sql"
	"errors"
	"path/filepath"
	"strings"
	"testing"
)

// cheap keeps tests fast; production uses DefaultHashing.
var cheap = Hashing{MemoryKiB: 64, Time: 1, Threads: 1}

func open(t *testing.T) *Store {
	t.Helper()
	store, err := Open(filepath.Join(t.TempDir(), "accounts.db"), cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { store.Close() })
	return store
}

func TestAddVerifyAndWrongPassword(t *testing.T) {
	store := open(t)
	ctx := context.Background()
	user, err := store.Add(ctx, "Alice", "correct horse", 1<<20)
	if err != nil {
		t.Fatal(err)
	}
	if user.Name != "alice" || user.QuotaBytes != 1<<20 {
		t.Fatalf("got %+v", user)
	}
	got, err := store.Verify(ctx, "ALICE", "correct horse")
	if err != nil || got.ID != user.ID {
		t.Fatalf("verify: %+v, %v", got, err)
	}
	if _, err := store.Verify(ctx, "alice", "wrong horse"); !errors.Is(err, ErrNotFound) {
		t.Fatalf("wrong password: %v", err)
	}
	// An unknown name fails the same way as a wrong password.
	if _, err := store.Verify(ctx, "bob", "correct horse"); !errors.Is(err, ErrNotFound) {
		t.Fatalf("unknown user: %v", err)
	}
}

func TestPasswordsAreStoredOnlyAsSaltedHashes(t *testing.T) {
	path := filepath.Join(t.TempDir(), "accounts.db")
	store, err := Open(path, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	ctx := context.Background()
	for _, name := range []string{"alice", "bob"} {
		if _, err := store.Add(ctx, name, "same password", 0); err != nil {
			t.Fatal(err)
		}
	}
	store.Close()
	db, err := sql.Open("sqlite", path)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	rows, err := db.Query(`SELECT password_hash FROM users`)
	if err != nil {
		t.Fatal(err)
	}
	defer rows.Close()
	var hashes []string
	for rows.Next() {
		var hash string
		rows.Scan(&hash)
		if strings.Contains(hash, "same password") || !strings.HasPrefix(hash, "$argon2id$") {
			t.Fatalf("stored %q", hash)
		}
		hashes = append(hashes, hash)
	}
	if hashes[0] == hashes[1] {
		t.Fatal("the same password must not hash the same twice")
	}
}

func TestNamesAndPasswordsAreChecked(t *testing.T) {
	store := open(t)
	ctx := context.Background()
	for _, name := range []string{"ab", "has space", "../etc", "x/y", strings.Repeat("a", 33)} {
		if _, err := store.Add(ctx, name, "long enough", 0); !errors.Is(err, ErrBadName) {
			t.Errorf("%q: %v", name, err)
		}
	}
	if _, err := store.Add(ctx, "alice", "short", 0); !errors.Is(err, ErrShortPassword) {
		t.Errorf("short password: %v", err)
	}
	if _, err := store.Add(ctx, "alice", "long enough", 0); err != nil {
		t.Fatal(err)
	}
	if _, err := store.Add(ctx, "ALICE", "long enough", 0); !errors.Is(err, ErrExists) {
		t.Errorf("duplicate: %v", err)
	}
}

func TestChangePasswordQuotaAndDelete(t *testing.T) {
	store := open(t)
	ctx := context.Background()
	if _, err := store.Add(ctx, "alice", "first password", 10); err != nil {
		t.Fatal(err)
	}
	if err := store.SetPassword(ctx, "alice", "second password"); err != nil {
		t.Fatal(err)
	}
	if _, err := store.Verify(ctx, "alice", "first password"); !errors.Is(err, ErrNotFound) {
		t.Fatal("the old password still works")
	}
	if err := store.SetQuota(ctx, "alice", 99); err != nil {
		t.Fatal(err)
	}
	user, err := store.Verify(ctx, "alice", "second password")
	if err != nil || user.QuotaBytes != 99 {
		t.Fatalf("%+v, %v", user, err)
	}
	users, _ := store.List(ctx)
	if len(users) != 1 {
		t.Fatalf("list: %+v", users)
	}
	if err := store.Delete(ctx, "alice"); err != nil {
		t.Fatal(err)
	}
	if err := store.Delete(ctx, "alice"); !errors.Is(err, ErrNotFound) {
		t.Fatalf("second delete: %v", err)
	}
	if err := store.SetPassword(ctx, "nobody", "long enough"); !errors.Is(err, ErrNotFound) {
		t.Fatalf("set password of nobody: %v", err)
	}
}
