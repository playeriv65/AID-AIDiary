// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"context"
	"database/sql"
	"errors"
)

// ReserveNetwork charges a signal or relay allowance independently of storage.
// Conditional UPSERT is atomic across connections, concurrent frames and restarts.
func (s *Store) ReserveNetwork(ctx context.Context, user int64, day, kind string, bytes, limit int64) error {
	if (kind != "signal" && kind != "relay") || bytes < 0 || bytes > limit {
		return ErrTransferLimit
	}
	result, err := s.db.ExecContext(ctx, `INSERT INTO network_transfer (user_id, day, kind, bytes)
VALUES (?, ?, ?, ?) ON CONFLICT(user_id, day, kind) DO UPDATE SET bytes = bytes + excluded.bytes
WHERE bytes <= ? - excluded.bytes`, user, day, kind, bytes, limit)
	if err != nil {
		return err
	}
	n, err := result.RowsAffected()
	if err == nil && n == 0 {
		return ErrTransferLimit
	}
	return err
}

// RefundNetwork releases a queued frame cancelled before its write begins.
func (s *Store) RefundNetwork(ctx context.Context, user int64, day, kind string, bytes int64) error {
	_, err := s.db.ExecContext(ctx, `UPDATE network_transfer SET bytes=max(0, bytes-?)
WHERE user_id=? AND day=? AND kind=?`, bytes, user, day, kind)
	return err
}

func (s *Store) NetworkUsed(ctx context.Context, user int64, day, kind string) (int64, error) {
	var used int64
	err := s.db.QueryRowContext(ctx, `SELECT bytes FROM network_transfer WHERE user_id=? AND day=? AND kind=?`, user, day, kind).Scan(&used)
	if errors.Is(err, sql.ErrNoRows) {
		return 0, nil
	}
	return used, err
}
