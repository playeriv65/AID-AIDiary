// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

// Command aid-sync runs the AID Diary sync server and manages its users.
//
//	aid-sync serve
//	aid-sync adduser NAME [QUOTA_MB]   (password on standard input)
//	aid-sync passwd NAME               (password on standard input)
//	aid-sync quota NAME QUOTA_MB
//	aid-sync deluser NAME              (also removes the user's files)
//	aid-sync users
//
// Settings come from the environment; see README.md.
package main

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"time"

	"aiddiary/syncserver/internal/accounts"
	"aiddiary/syncserver/internal/server"
)

// settings are read from AID_SYNC_* variables, with these defaults.
type settings struct {
	dataDir        string
	addr           string
	defaultQuotaMB int64
	maxUploadMB    int64
	minPassword    int
	failLimit      int
	failWindow     time.Duration
	credentialTTL  time.Duration
	trustProxy     bool
	media          server.MediaLimits
}

func load() (settings, error) {
	s := settings{
		dataDir:    env("AID_SYNC_DATA", "data"),
		addr:       env("AID_SYNC_ADDR", ":8080"),
		trustProxy: env("AID_SYNC_TRUST_PROXY", "false") == "true",
	}
	var err error
	ints := []struct {
		name string
		into *int64
		def  int64
	}{
		{"AID_SYNC_DEFAULT_QUOTA_MB", &s.defaultQuotaMB, 2048},
		{"AID_SYNC_MAX_UPLOAD_MB", &s.maxUploadMB, 256},
		{"AID_SYNC_MEDIA_MAX_OBJECT_BYTES", &s.media.MaxObjectBytes, 2 << 20},
		{"AID_SYNC_MEDIA_MAX_MANIFEST_BYTES", &s.media.MaxManifestBytes, 256 << 10},
		{"AID_SYNC_MEDIA_CACHE_BYTES", &s.media.CacheBytes, 128 << 20},
		{"AID_SYNC_MEDIA_DAILY_TRANSFER_BYTES", &s.media.DailyTransferBytes, 256 << 20},
	}
	for _, v := range ints {
		if *v.into, err = strconv.ParseInt(env(v.name, strconv.FormatInt(v.def, 10)), 10, 64); err != nil {
			return s, fmt.Errorf("%s: %w", v.name, err)
		}
		if *v.into < 0 || (strings.HasPrefix(v.name, "AID_SYNC_MEDIA_") && *v.into == 0) {
			return s, fmt.Errorf("%s must be positive (quota may be zero)", v.name)
		}
	}
	if s.media.CacheTTL, err = time.ParseDuration(env("AID_SYNC_MEDIA_CACHE_TTL", "168h")); err != nil || s.media.CacheTTL <= 0 {
		return s, fmt.Errorf("AID_SYNC_MEDIA_CACHE_TTL must be a positive duration")
	}
	if s.minPassword, err = strconv.Atoi(env("AID_SYNC_MIN_PASSWORD", "12")); err != nil {
		return s, fmt.Errorf("AID_SYNC_MIN_PASSWORD: %w", err)
	}
	if s.failLimit, err = strconv.Atoi(env("AID_SYNC_FAIL_LIMIT", "10")); err != nil {
		return s, fmt.Errorf("AID_SYNC_FAIL_LIMIT: %w", err)
	}
	if s.failWindow, err = time.ParseDuration(env("AID_SYNC_FAIL_WINDOW", "15m")); err != nil {
		return s, fmt.Errorf("AID_SYNC_FAIL_WINDOW: %w", err)
	}
	if s.credentialTTL, err = time.ParseDuration(env("AID_SYNC_CREDENTIAL_TTL", "5m")); err != nil {
		return s, fmt.Errorf("AID_SYNC_CREDENTIAL_TTL: %w", err)
	}
	return s, nil
}

func env(name, fallback string) string {
	if value, ok := os.LookupEnv(name); ok {
		return value
	}
	return fallback
}

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "aid-sync:", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) == 0 {
		return errors.New("usage: aid-sync serve|adduser|passwd|quota|deluser|users")
	}
	s, err := load()
	if err != nil {
		return err
	}
	if err := os.MkdirAll(s.dataDir, 0o700); err != nil {
		return err
	}
	store, err := accounts.Open(filepath.Join(s.dataDir, "accounts.db"),
		accounts.DefaultHashing, s.minPassword)
	if err != nil {
		return err
	}
	defer store.Close()
	ctx := context.Background()
	name := ""
	if len(args) > 1 {
		name = args[1]
	}
	switch args[0] {
	case "serve":
		return serve(s, store)
	case "adduser":
		quota := s.defaultQuotaMB
		if len(args) > 2 {
			if quota, err = strconv.ParseInt(args[2], 10, 64); err != nil {
				return err
			}
		}
		password, err := readPassword()
		if err != nil {
			return err
		}
		user, err := store.Add(ctx, name, password, quota<<20)
		if err != nil {
			return err
		}
		fmt.Printf("added %s (id %d, quota %d MB)\n", user.Name, user.ID, quota)
	case "passwd":
		password, err := readPassword()
		if err != nil {
			return err
		}
		return store.SetPassword(ctx, name, password)
	case "quota":
		if len(args) < 3 {
			return errors.New("usage: aid-sync quota NAME QUOTA_MB")
		}
		quota, err := strconv.ParseInt(args[2], 10, 64)
		if err != nil {
			return err
		}
		return store.SetQuota(ctx, name, quota<<20)
	case "deluser":
		users, err := store.List(ctx)
		if err != nil {
			return err
		}
		for _, user := range users {
			if user.Name == strings.ToLower(name) {
				if err := store.Delete(ctx, name); err != nil {
					return err
				}
				return os.RemoveAll(filepath.Join(s.dataDir, "users", strconv.FormatInt(user.ID, 10)))
			}
		}
		return accounts.ErrNotFound
	case "users":
		users, err := store.List(ctx)
		if err != nil {
			return err
		}
		for _, user := range users {
			fmt.Printf("%s\t%d MB\t%s\n", user.Name, user.QuotaBytes>>20, user.Created.Format(time.DateOnly))
		}
	default:
		return fmt.Errorf("unknown command %q", args[0])
	}
	return nil
}

// readPassword takes the first line of standard input, so passwords never
// show in the shell history or process list.
func readPassword() (string, error) {
	fmt.Fprint(os.Stderr, "password: ")
	line, err := bufio.NewReader(os.Stdin).ReadString('\n')
	if err != nil && line == "" {
		return "", errors.New("no password on standard input")
	}
	return strings.TrimRight(line, "\r\n"), nil
}

func serve(s settings, store *accounts.Store) error {
	log := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	handler := server.New(server.Config{
		DataDir:        s.dataDir,
		MaxUploadBytes: s.maxUploadMB << 20,
		Media:          s.media,
		CredentialTTL:  s.credentialTTL,
		FailLimit:      s.failLimit,
		FailWindow:     s.failWindow,
		TrustProxy:     s.trustProxy,
	}, store, log).Handler()
	web := &http.Server{
		Addr:              s.addr,
		Handler:           handler,
		ReadHeaderTimeout: 10 * time.Second,
		IdleTimeout:       2 * time.Minute,
	}
	stop, cancel := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer cancel()
	go func() {
		<-stop.Done()
		shutdown, done := context.WithTimeout(context.Background(), 10*time.Second)
		defer done()
		web.Shutdown(shutdown)
	}()
	log.Info("listening", "addr", s.addr, "data", s.dataDir)
	if err := web.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
		return err
	}
	return nil
}
