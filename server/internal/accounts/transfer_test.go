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

func TestTransferReservationsAreAtomicAcrossStoresAndPersisted(t *testing.T) {
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
	var wg sync.WaitGroup
	var granted atomic.Int64
	for i := range 40 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			store := a
			if i%2 == 0 {
				store = b
			}
			err := store.ReserveTransfer(ctx, 1, "2026-10-22", 7, 100)
			if err == nil {
				granted.Add(1)
			} else if !errors.Is(err, ErrTransferLimit) {
				t.Error(err)
			}
		}()
	}
	wg.Wait()
	if granted.Load() != 14 {
		t.Fatalf("reservations granted: %d", granted.Load())
	}
	if err := a.RefundTransfer(ctx, 1, "2026-10-22", 5); err != nil {
		t.Fatal(err)
	}
	a.Close()
	b.Close()
	reopened, err := Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	defer reopened.Close()
	used, err := reopened.TransferUsed(ctx, 1, "2026-10-22")
	if err != nil || used != 93 {
		t.Fatalf("persisted usage: %d %v", used, err)
	}
	if err := reopened.ReserveTransfer(ctx, 1, "2026-10-22", 7, 100); err != nil {
		t.Fatal(err)
	}
	if err := reopened.ReserveTransfer(ctx, 1, "2026-10-22", 1, 100); !errors.Is(err, ErrTransferLimit) {
		t.Fatalf("overflow: %v", err)
	}
	if err := reopened.ReserveTransfer(ctx, 2, "2026-10-22", 100, 100); err != nil {
		t.Fatal("other user shares allowance", err)
	}
	if err := reopened.ReserveTransfer(ctx, 1, "2026-10-23", 100, 100); err != nil {
		t.Fatal("next day shares allowance", err)
	}
}
