// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"context"
	"errors"
	"path/filepath"
	"sync"
	"sync/atomic"
	"testing"
)

func TestNetworkReservationsConcurrentPersistentAndIsolated(t *testing.T) {
	file := filepath.Join(t.TempDir(), "accounts.db")
	a, err := Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	b, err := Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	ctx := context.Background()
	day := "2026-10-22"
	var granted atomic.Int64
	var wg sync.WaitGroup
	for i := range 40 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			store := a
			if i%2 == 0 {
				store = b
			}
			err := store.ReserveNetwork(ctx, 1, day, "relay", 7, 100)
			if err == nil {
				granted.Add(1)
			} else if !errors.Is(err, ErrTransferLimit) {
				t.Error(err)
			}
		}()
	}
	wg.Wait()
	if granted.Load() != 14 {
		t.Fatalf("relay reservations=%d", granted.Load())
	}
	if err := a.ReserveNetwork(ctx, 1, day, "signal", 100, 100); err != nil {
		t.Fatal("signal borrowed relay budget", err)
	}
	if err := a.ReserveTransfer(ctx, 1, day, 100, 100); err != nil {
		t.Fatal("media borrowed network budget", err)
	}
	if err := a.ReserveNetwork(ctx, 2, day, "relay", 100, 100); err != nil {
		t.Fatal("user allowance shared", err)
	}
	if err := a.RefundNetwork(ctx, 1, day, "relay", 5); err != nil {
		t.Fatal(err)
	}
	a.Close()
	b.Close()
	c, err := Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	defer c.Close()
	used, err := c.NetworkUsed(ctx, 1, day, "relay")
	if err != nil || used != 93 {
		t.Fatalf("restart used=%d err=%v", used, err)
	}
	if err := c.ReserveNetwork(ctx, 1, day, "relay", 8, 100); !errors.Is(err, ErrTransferLimit) {
		t.Fatalf("restart overspend: %v", err)
	}
	if err := c.ReserveNetwork(ctx, 1, "2026-10-23", "relay", 100, 100); err != nil {
		t.Fatal("daily reset", err)
	}
	if err := c.ReserveNetwork(ctx, 1, day, "unknown", 1, 100); !errors.Is(err, ErrTransferLimit) {
		t.Fatal("invalid ledger kind accepted")
	}
}
