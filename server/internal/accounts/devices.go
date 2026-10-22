// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package accounts

import (
	"bytes"
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"crypto/x509"
	"database/sql"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"time"
)

var ErrDeviceDenied = errors.New("device authorization denied")

type Device struct {
	ID          string `json:"id"`
	Label       string `json:"label"`
	Fingerprint string `json:"fingerprint"`
	Created     int64  `json:"created"`
	Revoked     bool   `json:"revoked"`
}

func (s *Store) initDevices() error {
	for _, schema := range []string{
		`CREATE TABLE IF NOT EXISTS devices (user_id INTEGER NOT NULL, id TEXT NOT NULL,
   spki BLOB NOT NULL, label TEXT NOT NULL, created INTEGER NOT NULL, revoked INTEGER NOT NULL DEFAULT 0,
   PRIMARY KEY(user_id,id))`,
		`CREATE TABLE IF NOT EXISTS device_challenges (id TEXT PRIMARY KEY, user_id INTEGER NOT NULL,
   device TEXT NOT NULL, message BLOB NOT NULL, spki BLOB NOT NULL, expires INTEGER NOT NULL)`,
		`CREATE TABLE IF NOT EXISTS device_tokens (hash BLOB PRIMARY KEY, user_id INTEGER NOT NULL,
   device TEXT NOT NULL, expires INTEGER NOT NULL)`,
	} {
		if _, err := s.db.Exec(schema); err != nil {
			return err
		}
	}
	return nil
}

func DeviceKey(spki []byte) (*ecdsa.PublicKey, error) {
	raw, err := x509.ParsePKIXPublicKey(spki)
	if err != nil {
		return nil, ErrDeviceDenied
	}
	key, ok := raw.(*ecdsa.PublicKey)
	if !ok || key.Curve != elliptic.P256() {
		return nil, ErrDeviceDenied
	}
	return key, nil
}

func DeviceEnrollmentMessage(username, id string, spki []byte) []byte {
	return []byte("aid-device-enroll-v1\n" + username + "\n" + id + "\n" + base64.StdEncoding.EncodeToString(spki))
}

func VerifyDeviceProof(spki, message, signature []byte) bool {
	key, err := DeviceKey(spki)
	if err != nil {
		return false
	}
	hash := sha256.Sum256(message)
	return ecdsa.VerifyASN1(key, hash[:], signature)
}

func (s *Store) HasDevices(ctx context.Context, user int64) (bool, error) {
	var count int
	err := s.db.QueryRowContext(ctx, `SELECT COUNT(*) FROM devices WHERE user_id=?`, user).Scan(&count)
	return count > 0, err
}

// RegisterDevice serializes bootstrap so simultaneous password holders cannot
// both become the first device. A revoked identifier cannot be registered again.
func (s *Store) RegisterDevice(ctx context.Context, user int64, id, label string, spki []byte, bootstrap bool, max int, now time.Time) error {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	var all, active int
	if err = tx.QueryRowContext(ctx, `SELECT COUNT(*),COALESCE(SUM(CASE WHEN revoked=0 THEN 1 ELSE 0 END),0) FROM devices WHERE user_id=?`, user).Scan(&all, &active); err != nil {
		return err
	}
	if !bootstrap {
		var existing []byte
		if err = tx.QueryRowContext(ctx, `SELECT spki FROM devices WHERE user_id=? AND id=? AND revoked=0`, user, id).Scan(&existing); err == nil && bytes.Equal(existing, spki) {
			return tx.Commit()
		}
	}
	if bootstrap && all != 0 || active >= max {
		return ErrDeviceDenied
	}
	if _, err = tx.ExecContext(ctx, `INSERT INTO devices(user_id,id,spki,label,created) VALUES(?,?,?,?,?)`, user, id, spki, label, now.Unix()); err != nil {
		return ErrDeviceDenied
	}
	return tx.Commit()
}

func (s *Store) Devices(ctx context.Context, user int64) ([]Device, error) {
	rows, err := s.db.QueryContext(ctx, `SELECT id,label,spki,created,revoked FROM devices WHERE user_id=? ORDER BY created,id`, user)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := []Device{}
	for rows.Next() {
		var d Device
		var key []byte
		if err = rows.Scan(&d.ID, &d.Label, &key, &d.Created, &d.Revoked); err != nil {
			return nil, err
		}
		hash := sha256.Sum256(key)
		d.Fingerprint = hex.EncodeToString(hash[:])
		result = append(result, d)
	}
	return result, rows.Err()
}

// RevokeDevice leaves a tombstone. Losing every authorized device needs an
// explicit administrative recovery; the old account password cannot undo it.
func (s *Store) RevokeDevice(ctx context.Context, user int64, id string) error {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	if err = s.affectOne(tx.ExecContext(ctx, `UPDATE devices SET revoked=1 WHERE user_id=? AND id=?`, user, id)); err != nil {
		return err
	}
	if err = clearDeviceCredentials(ctx, tx, user, id); err != nil {
		return err
	}
	return tx.Commit()
}
func clearDeviceCredentials(ctx context.Context, tx *sql.Tx, user int64, id string) error {
	for _, table := range []string{"device_tokens", "device_challenges"} {
		if _, err := tx.ExecContext(ctx, `DELETE FROM `+table+` WHERE user_id=? AND device=?`, user, id); err != nil {
			return err
		}
	}
	return nil
}
func (s *Store) RotateDevice(ctx context.Context, user int64, id string, spki []byte) error {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()
	if err = s.affectOne(tx.ExecContext(ctx, `UPDATE devices SET spki=? WHERE user_id=? AND id=? AND revoked=0`, spki, user, id)); err != nil {
		return err
	}
	if err = clearDeviceCredentials(ctx, tx, user, id); err != nil {
		return err
	}
	return tx.Commit()
}

func randomCredential() (string, error) {
	var b [32]byte
	if _, err := rand.Read(b[:]); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b[:]), nil
}

func (s *Store) NewDeviceChallenge(ctx context.Context, name, id string, now time.Time, ttl time.Duration) (string, []byte, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return "", nil, err
	}
	defer tx.Rollback()
	_, err = tx.ExecContext(ctx, `DELETE FROM device_challenges WHERE expires<=?`, now.Unix())
	if err != nil {
		return "", nil, err
	}
	var user int64
	var spki []byte
	if err = tx.QueryRowContext(ctx, `SELECT d.user_id,d.spki FROM devices d JOIN users u ON u.id=d.user_id WHERE u.name=? AND d.id=? AND d.revoked=0`, name, id).Scan(&user, &spki); err != nil {
		return "", nil, ErrDeviceDenied
	}
	var count int
	if err = tx.QueryRowContext(ctx, `SELECT COUNT(*) FROM device_challenges WHERE user_id=?`, user).Scan(&count); err != nil {
		return "", nil, err
	}
	if count >= 32 {
		return "", nil, ErrDeviceDenied
	}
	challenge, err := randomCredential()
	if err != nil {
		return "", nil, err
	}
	hash := sha256.Sum256(spki)
	message := []byte("aid-device-token-v1\n" + name + "\n" + id + "\n" + hex.EncodeToString(hash[:]) + "\n" + challenge)
	_, err = tx.ExecContext(ctx, `INSERT INTO device_challenges(id,user_id,device,message,spki,expires) VALUES(?,?,?,?,?,?)`, challenge, user, id, message, spki, now.Add(ttl).Unix())
	if err != nil {
		return "", nil, err
	}
	return challenge, message, tx.Commit()
}

// A challenge is consumed even after a bad proof. Deletion and token issuance
// share one transaction, fencing replay across concurrent requests and restarts.
func (s *Store) DeviceToken(ctx context.Context, challenge string, signature []byte, now time.Time, ttl time.Duration) (string, error) {
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return "", err
	}
	defer tx.Rollback()
	var user int64
	var id string
	var message, key []byte
	var expires int64
	err = tx.QueryRowContext(ctx, `SELECT c.user_id,c.device,c.message,c.spki,c.expires FROM device_challenges c JOIN devices d ON d.user_id=c.user_id AND d.id=c.device WHERE c.id=? AND d.revoked=0 AND d.spki=c.spki`, challenge).Scan(&user, &id, &message, &key, &expires)
	if err != nil {
		return "", ErrDeviceDenied
	}
	if _, err = tx.ExecContext(ctx, `DELETE FROM device_challenges WHERE id=?`, challenge); err != nil {
		return "", err
	}
	if expires <= now.Unix() || !VerifyDeviceProof(key, message, signature) {
		if err = tx.Commit(); err != nil {
			return "", err
		}
		return "", ErrDeviceDenied
	}
	token, err := randomCredential()
	if err != nil {
		return "", err
	}
	hash := sha256.Sum256([]byte(token))
	// Bound storage even when an active device repeatedly refreshes tokens.
	if _, err = tx.ExecContext(ctx, `DELETE FROM device_tokens WHERE expires<=? OR (user_id=? AND device=?)`, now.Unix(), user, id); err != nil {
		return "", err
	}
	if _, err = tx.ExecContext(ctx, `INSERT INTO device_tokens(hash,user_id,device,expires) VALUES(?,?,?,?)`, hash[:], user, id, now.Add(ttl).Unix()); err != nil {
		return "", err
	}
	return token, tx.Commit()
}

func (s *Store) VerifyDeviceToken(ctx context.Context, token string, now time.Time) (User, string, error) {
	if len(token) != 43 {
		return User{}, "", ErrDeviceDenied
	}
	hash := sha256.Sum256([]byte(token))
	var user User
	var id string
	var created int64
	err := s.db.QueryRowContext(ctx, `SELECT u.id,u.name,u.quota_bytes,u.created,d.id FROM device_tokens t JOIN devices d ON d.user_id=t.user_id AND d.id=t.device JOIN users u ON u.id=d.user_id WHERE t.hash=? AND t.expires>? AND d.revoked=0`, hash[:], now.Unix()).Scan(&user.ID, &user.Name, &user.QuotaBytes, &created, &id)
	if err != nil {
		return User{}, "", ErrDeviceDenied
	}
	user.Created = time.Unix(created, 0).UTC()
	return user, id, nil
}
