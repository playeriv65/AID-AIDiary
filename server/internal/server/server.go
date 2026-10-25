// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

// Package server serves each user a private WebDAV folder, the store AID
// Diary syncs through. The app encrypts what it stores, so the server only
// ever holds ciphertext; it authenticates, keeps users apart, and enforces
// quotas and upload limits.
package server

import (
	"crypto/sha256"
	"errors"
	"io/fs"
	"log/slog"
	"net"
	"net/http"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"

	"aiddiary/syncserver/internal/accounts"

	"golang.org/x/net/webdav"
)

// Prefix is where the WebDAV folders are served.
const Prefix = "/dav"

// Config tunes the server; every value comes from the command line or
// environment.
type Config struct {
	// OperatorLimits opts into temporary cache retention and traffic allowances.
	// Personal installations keep durable storage and do not meter transfers.
	OperatorLimits bool
	// DataDir holds users' folders under users/<id>.
	DataDir string
	// MaxUploadBytes caps a single file.
	MaxUploadBytes int64
	// MonthlyMediaBytes combines cache and relay; control has its own daily cap.
	MonthlyMediaBytes int64
	// Media is a bounded, temporary cache, separate from durable metadata.
	Media      MediaLimits
	Network    NetworkLimits
	DeviceAuth DeviceAuthLimits
	Feedback   FeedbackLimits
	// CredentialTTL is how long a checked password is trusted before it is
	// checked again; a changed password takes effect within it.
	CredentialTTL time.Duration
	// FailLimit failed sign-ins from one address or for one name within
	// FailWindow block further tries until the window passes.
	FailLimit  int
	FailWindow time.Duration
	// TrustProxy takes the client address from X-Real-IP, for a server
	// behind a reverse proxy that sets it.
	TrustProxy bool
	// Now is the clock; tests replace it.
	Now func() time.Time
}

// Server answers sync requests.
type Server struct {
	cfg      Config
	accounts *accounts.Store
	log      *slog.Logger

	mu       sync.Mutex
	folders  map[int64]*folder
	trusted  map[[32]byte]trust
	failures map[string][]time.Time
	network  *networkHub

	// feedbackMu keeps appended feedback lines whole.
	feedbackMu sync.Mutex
}

type trust struct {
	user    accounts.User
	expires time.Time
}

// folder is one user's files, their WebDAV handler and how much they use.
type folder struct {
	root    string
	handler *webdav.Handler
	// mu serialises writes, so usage stays exact.
	mu   sync.Mutex
	used int64
}

// New makes a server over an accounts store.
func New(cfg Config, store *accounts.Store, log *slog.Logger) *Server {
	if cfg.Now == nil {
		cfg.Now = time.Now
	}
	if cfg.MonthlyMediaBytes <= 0 {
		cfg.MonthlyMediaBytes = 1000000000
	}
	cfg.Media = cfg.Media.defaults()
	cfg.Network = cfg.Network.defaults()
	cfg.DeviceAuth = cfg.DeviceAuth.defaults()
	cfg.Feedback = cfg.Feedback.defaults()
	return &Server{
		cfg:      cfg,
		accounts: store,
		log:      log,
		folders:  map[int64]*folder{},
		trusted:  map[[32]byte]trust{},
		failures: map[string][]time.Time{},
		network:  newNetworkHub(),
	}
}

// Handler routes /healthz and the WebDAV folders.
func (s *Server) Handler() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", s.health)
	mux.HandleFunc("GET /api/sync/policy", s.policy)
	mux.HandleFunc("GET /api/sync/network", s.networkSocket)
	mux.HandleFunc("GET /api/sync/devices/capabilities", s.deviceCapabilities)
	mux.HandleFunc("POST /api/sync/devices", s.enrollDevice)
	mux.HandleFunc("GET /api/sync/devices", s.listDevices)
	mux.HandleFunc("DELETE /api/sync/devices/{device}", s.revokeDevice)
	mux.HandleFunc("POST /api/sync/devices/rotate", s.rotateDevice)
	mux.HandleFunc("POST /api/sync/auth/challenge", s.deviceChallenge)
	mux.HandleFunc("POST /api/sync/auth/token", s.deviceToken)
	mux.HandleFunc("POST /api/feedback", s.feedback)
	mux.HandleFunc(Prefix+"/", s.dav)
	return s.logged(mux)
}

func (s *Server) health(w http.ResponseWriter, r *http.Request) {
	if _, err := s.accounts.List(r.Context()); err != nil {
		http.Error(w, "accounts unavailable", http.StatusServiceUnavailable)
		return
	}
	w.Write([]byte("ok\n"))
}

func (s *Server) dav(w http.ResponseWriter, r *http.Request) {
	if strings.ContainsAny(r.URL.Path, "\\:\x00") {
		http.Error(w, "invalid path separator", http.StatusBadRequest)
		return
	}
	for _, component := range strings.Split(r.URL.Path, "/") {
		if component != "." && component != ".." && strings.TrimRight(component, " .") != component {
			http.Error(w, "ambiguous path component", http.StatusBadRequest)
			return
		}
	}
	user, ok := s.authenticate(w, r)
	if !ok {
		return
	}
	f, err := s.folder(user)
	if err != nil {
		s.log.Error("open folder", "user", user.Name, "err", err)
		http.Error(w, "storage unavailable", http.StatusInternalServerError)
		return
	}
	f.mu.Lock()
	defer f.mu.Unlock()
	if err := s.expireMedia(f); err != nil {
		s.log.Error("expire media", "err", err)
		http.Error(w, "storage unavailable", http.StatusInternalServerError)
		return
	}
	if isMedia(r.URL.Path) {
		switch r.Method {
		case http.MethodPut:
			s.putMedia(w, r, user, f)
			return
		case http.MethodGet, http.MethodHead:
			s.getMedia(w, r, user, f)
			return
		}
	}
	control := &controlWriter{ResponseWriter: w, server: s, request: r, user: user}
	defer control.finish()
	w = control
	switch r.Method {
	case http.MethodPut:
		s.put(w, r, user, f)
	case http.MethodDelete:
		s.remove(w, r, f)
	case "COPY", "MOVE":
		// Moving or copying a parent directory could bypass media policy, too.
		http.Error(w, "copy and move are disabled; use put", http.StatusMethodNotAllowed)
	default:
		f.handler.ServeHTTP(w, r)
	}
}

// put writes a file within the user's quota and the upload limit.
func (s *Server) put(w http.ResponseWriter, r *http.Request, user accounts.User, f *folder) {
	if r.ContentLength > s.cfg.MaxUploadBytes {
		http.Error(w, "file too large", http.StatusRequestEntityTooLarge)
		return
	}
	if r.ContentLength < 0 {
		http.Error(w, "metadata upload requires Content-Length", http.StatusLengthRequired)
		return
	}
	day := s.transferDay()
	if !s.reserveControl(w, r, user, r.ContentLength) {
		return
	}
	reader := &mediaReader{Reader: r.Body}
	original := r.Body
	r.Body = readCloseBudget{Reader: reader, Closer: original}
	defer func() { s.refundNetwork(user.ID, day, "signal", r.ContentLength-min(r.ContentLength, reader.bytes)) }()
	target := f.path(r.URL.Path)
	var before int64
	if info, err := os.Stat(target); err == nil {
		before = info.Size()
	}
	if user.QuotaBytes > 0 && r.ContentLength >= 0 &&
		f.used-before+r.ContentLength > user.QuotaBytes {
		http.Error(w, "quota exceeded", http.StatusInsufficientStorage)
		return
	}
	r.Body = http.MaxBytesReader(w, r.Body, s.cfg.MaxUploadBytes)
	f.handler.ServeHTTP(w, r)
	var after int64
	if info, err := os.Stat(target); err == nil {
		after = info.Size()
	}
	f.used += after - before
}

// remove deletes a file or folder and gives its space back.
func (s *Server) remove(w http.ResponseWriter, r *http.Request, f *folder) {
	freed := usage(f.path(r.URL.Path))
	recorder := &statusRecorder{ResponseWriter: w, status: http.StatusOK}
	f.handler.ServeHTTP(recorder, r)
	if recorder.status >= 200 && recorder.status < 300 {
		f.used -= freed
	}
}

// folder returns the user's folder, made on first use.
func (s *Server) folder(user accounts.User) (*folder, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if f, ok := s.folders[user.ID]; ok {
		return f, nil
	}
	root := filepath.Join(s.cfg.DataDir, "users", strconv.FormatInt(user.ID, 10))
	if err := os.MkdirAll(root, 0o700); err != nil {
		return nil, err
	}
	f := &folder{
		root: root,
		handler: &webdav.Handler{
			Prefix:     Prefix,
			FileSystem: webdav.Dir(root),
			LockSystem: webdav.NewMemLS(),
			Logger: func(r *http.Request, err error) {
				if err != nil && !errors.Is(err, os.ErrNotExist) {
					s.log.Warn("webdav", "method", r.Method, "path", r.URL.Path, "err", err)
				}
			},
		},
		used: usage(root),
	}
	s.folders[user.ID] = f
	return f, nil
}

// path maps a request path to a file under the folder the way webdav.Dir
// does, so nothing outside it can be named.
func (f *folder) path(requestPath string) string {
	name := strings.TrimPrefix(requestPath, Prefix)
	return filepath.Join(f.root, filepath.FromSlash(path.Clean("/"+name)))
}

// usage is the bytes of the files at or under p.
func usage(p string) int64 {
	var total int64
	filepath.WalkDir(p, func(_ string, entry fs.DirEntry, err error) error {
		if err != nil {
			return nil
		}
		if info, err := entry.Info(); err == nil && !entry.IsDir() {
			total += info.Size()
		}
		return nil
	})
	return total
}

// authenticate checks Basic credentials, trusting a recent check, and
// blocks an address or name after repeated failures.
func (s *Server) authenticate(w http.ResponseWriter, r *http.Request) (accounts.User, bool) {
	if strings.HasPrefix(r.Header.Get("Authorization"), "Bearer ") {
		user, _, ok := s.requireDevice(w, r)
		return user, ok
	}
	user, ok := s.authenticateBasic(w, r)
	if !ok {
		return user, false
	}
	has, err := s.accounts.HasDevices(r.Context(), user.ID)
	if err != nil {
		http.Error(w, "accounts unavailable", 503)
		return accounts.User{}, false
	}
	if has {
		s.challenge(w)
		return accounts.User{}, false
	}
	return user, true
}

func (s *Server) authenticateBasic(w http.ResponseWriter, r *http.Request) (accounts.User, bool) {
	name, password, ok := r.BasicAuth()
	address := s.clientAddress(r)
	now := s.cfg.Now()
	if s.blocked(now, "ip:"+address) || (ok && s.blocked(now, "user:"+strings.ToLower(name))) {
		w.Header().Set("Retry-After", strconv.Itoa(int(s.cfg.FailWindow.Seconds())))
		http.Error(w, "too many failed sign-ins", http.StatusTooManyRequests)
		return accounts.User{}, false
	}
	if !ok {
		s.challenge(w)
		return accounts.User{}, false
	}
	key := sha256.Sum256([]byte(strings.ToLower(name) + "\x00" + password))
	s.mu.Lock()
	cached, hit := s.trusted[key]
	s.mu.Unlock()
	if hit && now.Before(cached.expires) {
		return cached.user, true
	}
	user, err := s.accounts.Verify(r.Context(), name, password)
	if err != nil {
		if !errors.Is(err, accounts.ErrNotFound) {
			s.log.Error("verify", "err", err)
			http.Error(w, "accounts unavailable", http.StatusServiceUnavailable)
			return accounts.User{}, false
		}
		s.fail(now, "ip:"+address, "user:"+strings.ToLower(name))
		s.log.Warn("sign-in failed", "user", name, "address", address)
		s.challenge(w)
		return accounts.User{}, false
	}
	s.mu.Lock()
	s.trusted[key] = trust{user: user, expires: now.Add(s.cfg.CredentialTTL)}
	s.mu.Unlock()
	return user, true
}

func (s *Server) challenge(w http.ResponseWriter) {
	w.Header().Set("WWW-Authenticate", `Basic realm="AID Diary sync", charset="UTF-8"`)
	http.Error(w, "sign in required", http.StatusUnauthorized)
}

func (s *Server) clientAddress(r *http.Request) string {
	if s.cfg.TrustProxy {
		if real := r.Header.Get("X-Real-IP"); real != "" {
			return real
		}
	}
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		return r.RemoteAddr
	}
	return host
}

// recent drops failures older than the window; call with s.mu held.
func (s *Server) recent(now time.Time, key string) []time.Time {
	return s.recentWithin(now, key, s.cfg.FailWindow)
}

func (s *Server) blocked(now time.Time, key string) bool {
	s.mu.Lock()
	defer s.mu.Unlock()
	return len(s.recent(now, key)) >= s.cfg.FailLimit
}

func (s *Server) fail(now time.Time, keys ...string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	for _, key := range keys {
		s.failures[key] = append(s.recent(now, key), now)
	}
}

// logged records each request without credentials.
func (s *Server) logged(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := s.cfg.Now()
		recorder := &statusRecorder{ResponseWriter: w, status: http.StatusOK}
		next.ServeHTTP(recorder, r)
		name, _, _ := r.BasicAuth()
		s.log.Info("request", "method", r.Method, "path", r.URL.Path,
			"status", recorder.status, "user", name,
			"ms", s.cfg.Now().Sub(start).Milliseconds())
	})
}

type statusRecorder struct {
	http.ResponseWriter
	status int
}

// Unwrap preserves Hijacker and Flusher through http.ResponseController.
func (r *statusRecorder) Unwrap() http.ResponseWriter { return r.ResponseWriter }

func (r *statusRecorder) WriteHeader(status int) {
	r.status = status
	r.ResponseWriter.WriteHeader(status)
}
