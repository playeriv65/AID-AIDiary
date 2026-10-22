// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

// Package accounts keeps the server's users in SQLite: names, password
// hashes and storage quotas. Passwords are stored only as Argon2id hashes.
package accounts

import (
	"context"
	"crypto/rand"
	"crypto/subtle"
	"database/sql"
	"encoding/base64"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"time"

	"golang.org/x/crypto/argon2"
	_ "modernc.org/sqlite"
)

// ErrNotFound means no user has that name.
var ErrNotFound = errors.New("no such user")

// ErrExists means the name is taken.
var ErrExists = errors.New("user already exists")

// ErrBadName means the name has characters a folder name cannot.
var ErrBadName = errors.New("names are 3 to 32 letters, digits, '-' or '_'")

// ErrShortPassword means the password is under the minimum length.
var ErrShortPassword = errors.New("password too short")

var namePattern = regexp.MustCompile(`^[a-z0-9_-]{3,32}$`)

// Hashing holds the Argon2id cost; the defaults follow OWASP's minimum.
type Hashing struct {
	MemoryKiB uint32
	Time      uint32
	Threads   uint8
}

// DefaultHashing is OWASP's recommended minimum for Argon2id.
var DefaultHashing = Hashing{MemoryKiB: 19 * 1024, Time: 2, Threads: 1}

// User is one account.
type User struct {
	ID         int64
	Name       string
	QuotaBytes int64
	Created    time.Time
}

// Store is the accounts database.
type Store struct {
	db          *sql.DB
	hashing     Hashing
	minPassword int
}

// Open opens or creates the database at path.
func Open(path string, hashing Hashing, minPassword int) (*Store, error) {
	db, err := sql.Open("sqlite", "file:"+path+"?_pragma=busy_timeout(5000)&_pragma=journal_mode(WAL)")
	if err != nil {
		return nil, err
	}
	// One writer at a time; SQLite serialises writes anyway.
	db.SetMaxOpenConns(1)
	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  quota_bytes INTEGER NOT NULL,
  created INTEGER NOT NULL
)`); err != nil {
		db.Close()
		return nil, err
	}
	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS media_transfer (
  user_id INTEGER NOT NULL,
  day TEXT NOT NULL,
  bytes INTEGER NOT NULL CHECK (bytes >= 0),
  PRIMARY KEY (user_id, day)
)`); err != nil {
		db.Close()
		return nil, err
	}
	if _, err := db.Exec(`CREATE TABLE IF NOT EXISTS network_transfer (
  user_id INTEGER NOT NULL,
  day TEXT NOT NULL,
  kind TEXT NOT NULL CHECK (kind IN ('signal', 'relay')),
  bytes INTEGER NOT NULL CHECK (bytes >= 0),
  PRIMARY KEY (user_id, day, kind)
)`); err != nil {
		db.Close()
		return nil, err
	}
	return &Store{db: db, hashing: hashing, minPassword: minPassword}, nil
}

// Close closes the database.
func (s *Store) Close() error { return s.db.Close() }

// Add creates a user with a storage quota.
func (s *Store) Add(ctx context.Context, name, password string, quotaBytes int64) (User, error) {
	name = strings.ToLower(name)
	if !namePattern.MatchString(name) {
		return User{}, ErrBadName
	}
	if len([]rune(password)) < s.minPassword {
		return User{}, ErrShortPassword
	}
	hash, err := s.hash(password)
	if err != nil {
		return User{}, err
	}
	now := time.Now().UTC()
	result, err := s.db.ExecContext(ctx,
		`INSERT INTO users (name, password_hash, quota_bytes, created) VALUES (?, ?, ?, ?)`,
		name, hash, quotaBytes, now.Unix())
	if err != nil {
		if strings.Contains(err.Error(), "UNIQUE") {
			return User{}, ErrExists
		}
		return User{}, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return User{}, err
	}
	return User{ID: id, Name: name, QuotaBytes: quotaBytes, Created: now.Truncate(time.Second)}, nil
}

// SetPassword replaces a user's password.
func (s *Store) SetPassword(ctx context.Context, name, password string) error {
	if len([]rune(password)) < s.minPassword {
		return ErrShortPassword
	}
	hash, err := s.hash(password)
	if err != nil {
		return err
	}
	return s.affectOne(s.db.ExecContext(ctx,
		`UPDATE users SET password_hash = ? WHERE name = ?`, hash, strings.ToLower(name)))
}

// SetQuota changes a user's storage quota.
func (s *Store) SetQuota(ctx context.Context, name string, quotaBytes int64) error {
	return s.affectOne(s.db.ExecContext(ctx,
		`UPDATE users SET quota_bytes = ? WHERE name = ?`, quotaBytes, strings.ToLower(name)))
}

// Delete removes a user's account; their files are the caller's to remove.
func (s *Store) Delete(ctx context.Context, name string) error {
	return s.affectOne(s.db.ExecContext(ctx,
		`DELETE FROM users WHERE name = ?`, strings.ToLower(name)))
}

// List returns every user, by name.
func (s *Store) List(ctx context.Context) ([]User, error) {
	rows, err := s.db.QueryContext(ctx,
		`SELECT id, name, quota_bytes, created FROM users ORDER BY name`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var users []User
	for rows.Next() {
		var user User
		var created int64
		if err := rows.Scan(&user.ID, &user.Name, &user.QuotaBytes, &created); err != nil {
			return nil, err
		}
		user.Created = time.Unix(created, 0).UTC()
		users = append(users, user)
	}
	return users, rows.Err()
}

// Verify checks a name and password; it returns ErrNotFound for both an
// unknown name and a wrong password, so callers cannot tell them apart.
func (s *Store) Verify(ctx context.Context, name, password string) (User, error) {
	var user User
	var hash string
	var created int64
	err := s.db.QueryRowContext(ctx,
		`SELECT id, name, password_hash, quota_bytes, created FROM users WHERE name = ?`,
		strings.ToLower(name)).Scan(&user.ID, &user.Name, &hash, &user.QuotaBytes, &created)
	if errors.Is(err, sql.ErrNoRows) {
		// Spend the same work as a real check, so timing reveals nothing.
		_, _ = s.hash(password)
		return User{}, ErrNotFound
	}
	if err != nil {
		return User{}, err
	}
	if !matches(hash, password) {
		return User{}, ErrNotFound
	}
	user.Created = time.Unix(created, 0).UTC()
	return user, nil
}

func (s *Store) affectOne(result sql.Result, err error) error {
	if err != nil {
		return err
	}
	n, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if n == 0 {
		return ErrNotFound
	}
	return nil
}

// hash encodes a password as $argon2id$v=19$m=..,t=..,p=..$salt$key.
func (s *Store) hash(password string) (string, error) {
	salt := make([]byte, 16)
	if _, err := rand.Read(salt); err != nil {
		return "", err
	}
	h := s.hashing
	key := argon2.IDKey([]byte(password), salt, h.Time, h.MemoryKiB, h.Threads, 32)
	return fmt.Sprintf("$argon2id$v=%d$m=%d,t=%d,p=%d$%s$%s", argon2.Version,
		h.MemoryKiB, h.Time, h.Threads,
		base64.RawStdEncoding.EncodeToString(salt),
		base64.RawStdEncoding.EncodeToString(key)), nil
}

// matches checks a password against an encoded hash, with the cost the
// hash was made with.
func matches(encoded, password string) bool {
	parts := strings.Split(encoded, "$")
	if len(parts) != 6 || parts[1] != "argon2id" {
		return false
	}
	var memory, time uint32
	var threads uint8
	if _, err := fmt.Sscanf(parts[3], "m=%d,t=%d,p=%d", &memory, &time, &threads); err != nil {
		return false
	}
	salt, err := base64.RawStdEncoding.DecodeString(parts[4])
	if err != nil {
		return false
	}
	want, err := base64.RawStdEncoding.DecodeString(parts[5])
	if err != nil {
		return false
	}
	got := argon2.IDKey([]byte(password), salt, time, memory, threads, uint32(len(want)))
	return subtle.ConstantTimeCompare(got, want) == 1
}
