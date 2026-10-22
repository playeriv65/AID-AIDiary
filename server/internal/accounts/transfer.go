// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"context"
	"database/sql"
	"errors"
)

// ErrTransferLimit means today's media allowance is exhausted.
var ErrTransferLimit = errors.New("daily media transfer limit exceeded")

// ReserveTransfer durably charges bytes before I/O. Atomic conditional updates
// include concurrent reservations. A crash keeps reservations charged so a
// restart cannot accidentally grant another allowance.
func (s *Store) ReserveTransfer(ctx context.Context, userID int64, day string, bytes, limit int64) error {
	if bytes < 0 || bytes > limit {
		return ErrTransferLimit
	}
	result, err := s.db.ExecContext(ctx, `INSERT INTO media_transfer (user_id, day, bytes)
VALUES (?, ?, ?) ON CONFLICT(user_id, day) DO UPDATE SET bytes = bytes + excluded.bytes
WHERE bytes <= ? - excluded.bytes`, userID, day, bytes, limit)
	if err != nil {
		return err
	}
	n, err := result.RowsAffected()
	if err == nil && n == 0 {
		return ErrTransferLimit
	}
	return err
}

// RefundTransfer releases bytes that were reserved but not actually transferred.
func (s *Store) RefundTransfer(ctx context.Context, userID int64, day string, bytes int64) error {
	_, err := s.db.ExecContext(ctx, `UPDATE media_transfer SET bytes = max(0, bytes - ?)
WHERE user_id = ? AND day = ?`, bytes, userID, day)
	return err
}

// TransferUsed includes active reservations as well as completed transfers.
func (s *Store) TransferUsed(ctx context.Context, userID int64, day string) (int64, error) {
	var used int64
	err := s.db.QueryRowContext(ctx, `SELECT bytes FROM media_transfer WHERE user_id = ? AND day = ?`, userID, day).Scan(&used)
	if errors.Is(err, sql.ErrNoRows) {
		return 0, nil
	}
	return used, err
}
