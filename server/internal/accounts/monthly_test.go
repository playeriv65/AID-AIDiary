package accounts

import (
	"context"
	"errors"
	"path/filepath"
	"sync"
	"sync/atomic"
	"testing"
)

func TestMonthlyBudgetCombinesCacheRelayAndPersistsAcrossStores(t *testing.T) {
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
			var err error
			if i%3 == 0 {
				err = store.ReserveCloudMedia(ctx, 1, "2026-10-22", 7, 1000, 100)
			} else {
				err = store.ReserveCloudNetwork(ctx, 1, "2026-10-23", "relay", 7, 1000, 100)
			}
			if err == nil {
				granted.Add(1)
			} else if !errors.Is(err, ErrMonthlyTransferLimit) {
				t.Error(err)
			}
		}()
	}
	wg.Wait()
	if granted.Load() != 14 {
		t.Fatalf("granted %d", granted.Load())
	}
	used, err := a.MonthlyMediaUsed(ctx, 1, "2026-10")
	if err != nil || used != 98 {
		t.Fatalf("usage %d %v", used, err)
	}
	if err := a.ReserveCloudNetwork(ctx, 1, "2026-10-24", "signal", 100, 100, 100); err != nil {
		t.Fatal(err)
	}
	a.Close()
	b.Close()
	reopened, err := Open(file, cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	defer reopened.Close()
	used, err = reopened.MonthlyMediaUsed(ctx, 1, "2026-10")
	if err != nil || used != 98 {
		t.Fatalf("persisted %d %v", used, err)
	}
	if err := reopened.ReserveCloudMedia(ctx, 1, "2026-10-31", 3, 1000, 100); !errors.Is(err, ErrMonthlyTransferLimit) {
		t.Fatalf("next day bypass %v", err)
	}
	if err := reopened.ReserveCloudMedia(ctx, 1, "2026-11-01", 100, 1000, 100); err != nil {
		t.Fatal(err)
	}
	if err := reopened.ReserveCloudMedia(ctx, 2, "2026-10-22", 100, 1000, 100); err != nil {
		t.Fatal(err)
	}
}

func TestMonthlyReservationRollsBackDailyFailuresAndRefunds(t *testing.T) {
	store, err := Open(filepath.Join(t.TempDir(), "accounts.db"), cheap, 8)
	if err != nil {
		t.Fatal(err)
	}
	defer store.Close()
	ctx := context.Background()
	if err := store.ReserveCloudMedia(ctx, 1, "2026-10-22", 8, 10, 20); err != nil {
		t.Fatal(err)
	}
	if err := store.ReserveCloudMedia(ctx, 1, "2026-10-22", 3, 10, 20); !errors.Is(err, ErrTransferLimit) {
		t.Fatal(err)
	}
	used, _ := store.MonthlyMediaUsed(ctx, 1, "2026-10")
	if used != 8 {
		t.Fatal(used)
	}
	if err := store.RefundTransfer(ctx, 1, "2026-10-22", 2); err != nil {
		t.Fatal(err)
	}
	if err := store.ReserveCloudNetwork(ctx, 1, "2026-10-23", "relay", 14, 100, 20); err != nil {
		t.Fatal(err)
	}
	if err := store.ReserveCloudMedia(ctx, 1, "2026-10-24", 1, 100, 20); !errors.Is(err, ErrMonthlyTransferLimit) {
		t.Fatal(err)
	}
	if err := store.RefundNetwork(ctx, 1, "2026-10-23", "relay", 5); err != nil {
		t.Fatal(err)
	}
	used, _ = store.MonthlyMediaUsed(ctx, 1, "2026-10")
	if used != 15 {
		t.Fatal(used)
	}
}
