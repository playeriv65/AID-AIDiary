// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"context"
	"database/sql"
	"fmt"
	"time"
)

var ErrMonthlyTransferLimit = fmt.Errorf("%w: monthly cloud media allowance exhausted", ErrTransferLimit)

// MonthlyMediaUsed combines both directions of cache and live-relay traffic.
// It uses the existing durable ledgers, so refunds and restarts stay consistent.
func (s *Store) MonthlyMediaUsed(ctx context.Context, user int64, month string) (int64, error) {
	next, err := time.Parse("2006-01", month)
	if err != nil {
		return 0, err
	}
	return monthlyMediaUsed(ctx, s.db, user, month+"-01", next.AddDate(0, 1, 0).Format(time.DateOnly))
}

type budgetReader interface {
	QueryRowContext(context.Context, string, ...any) *sql.Row
}

func monthlyMediaUsed(ctx context.Context, db budgetReader, user int64, start, end string) (int64, error) {
	var used int64
	err := db.QueryRowContext(ctx, `SELECT
 (SELECT coalesce(sum(bytes),0) FROM media_transfer WHERE user_id=? AND day>=? AND day<?) +
 (SELECT coalesce(sum(bytes),0) FROM network_transfer WHERE user_id=? AND kind='relay' AND day>=? AND day<?)`, user, start, end, user, start, end).Scan(&used)
	return used, err
}

// reserveBudget serializes the shared month check with the daily reservation.
// Rolling back either limit leaves both ledgers unchanged.
func (s *Store) reserveBudget(ctx context.Context, user int64, day, kind string, bytes, daily, monthly int64) error {
	date, err := time.Parse(time.DateOnly, day)
	if err != nil {
		return err
	}
	if bytes < 0 || bytes > daily {
		return ErrTransferLimit
	}
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	// Acquire the SQLite writer lock before reading the shared month total.
	// This also serializes reservations through separate Store connections.
	if _, err = tx.ExecContext(ctx, `UPDATE media_transfer SET bytes=bytes WHERE user_id=? AND day=?`, user, day); err != nil {
		return err
	}
	if kind != "signal" {
		start := time.Date(date.Year(), date.Month(), 1, 0, 0, 0, 0, time.UTC)
		used, err := monthlyMediaUsed(ctx, tx, user, start.Format(time.DateOnly), start.AddDate(0, 1, 0).Format(time.DateOnly))
		if err != nil {
			return err
		}
		if monthly <= 0 || bytes > monthly || used > monthly-bytes {
			return ErrMonthlyTransferLimit
		}
	}
	var result sql.Result
	if kind == "media" {
		result, err = tx.ExecContext(ctx, `INSERT INTO media_transfer(user_id,day,bytes) VALUES(?,?,?)
 ON CONFLICT(user_id,day) DO UPDATE SET bytes=bytes+excluded.bytes WHERE bytes<=?-excluded.bytes`, user, day, bytes, daily)
	} else if kind == "signal" || kind == "relay" {
		result, err = tx.ExecContext(ctx, `INSERT INTO network_transfer(user_id,day,kind,bytes) VALUES(?,?,?,?)
 ON CONFLICT(user_id,day,kind) DO UPDATE SET bytes=bytes+excluded.bytes WHERE bytes<=?-excluded.bytes`, user, day, kind, bytes, daily)
	} else {
		return ErrTransferLimit
	}
	if err != nil {
		return err
	}
	n, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if n == 0 {
		return ErrTransferLimit
	}
	return tx.Commit()
}

func (s *Store) ReserveCloudMedia(ctx context.Context, user int64, day string, bytes, daily, monthly int64) error {
	return s.reserveBudget(ctx, user, day, "media", bytes, daily, monthly)
}

func (s *Store) ReserveCloudNetwork(ctx context.Context, user int64, day, kind string, bytes, daily, monthly int64) error {
	return s.reserveBudget(ctx, user, day, kind, bytes, daily, monthly)
}
