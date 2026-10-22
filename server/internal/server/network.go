// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"net/http"
	"regexp"
	"strings"
	"sync"
	"time"

	"aiddiary/syncserver/internal/accounts"
	"github.com/coder/websocket"
)

// NetworkLimits bound live networking independently of the asynchronous cache.
type NetworkLimits struct {
	SignalDailyBytes  int64
	RelayDailyBytes   int64
	SignalFrameBytes  int64
	RelayFrameBytes   int64
	MaxPeers          int
	MaxConnections    int
	QueueFrames       int
	ConnectsPerMinute int
	FramesPerSecond   int
	WriteTimeout      time.Duration
	SessionTTL        time.Duration
	HeartbeatInterval time.Duration
}

func (n NetworkLimits) defaults() NetworkLimits {
	if n.SignalDailyBytes <= 0 {
		n.SignalDailyBytes = 4 << 20
	}
	if n.RelayDailyBytes <= 0 {
		n.RelayDailyBytes = 32 << 20
	}
	if n.SignalFrameBytes <= 0 {
		n.SignalFrameBytes = 64 << 10
	}
	if n.RelayFrameBytes <= 0 {
		n.RelayFrameBytes = 32 << 10
	}
	if n.MaxPeers <= 0 {
		n.MaxPeers = 8
	}
	if n.MaxConnections <= 0 {
		n.MaxConnections = 16
	}
	if n.QueueFrames <= 0 {
		n.QueueFrames = 16
	}
	if n.ConnectsPerMinute <= 0 {
		n.ConnectsPerMinute = 30
	}
	if n.FramesPerSecond <= 0 {
		n.FramesPerSecond = 32
	}
	if n.WriteTimeout <= 0 {
		n.WriteTimeout = 10 * time.Second
	}
	if n.SessionTTL <= 0 {
		n.SessionTTL = time.Hour
	}
	if n.HeartbeatInterval <= 0 {
		n.HeartbeatInterval = 30 * time.Second
	}
	return n
}

type roomKey struct {
	user  int64
	space string
}
type connectWindow struct {
	at    time.Time
	count int
}
type networkHub struct {
	mu        sync.Mutex
	rooms     map[roomKey]map[string]*networkPeer
	counts    map[int64]int
	attempts  map[string]connectWindow
	admitting chan struct{}
	total     int
	closed    bool
	wg        sync.WaitGroup
}

func newNetworkHub() *networkHub {
	return &networkHub{rooms: map[roomKey]map[string]*networkPeer{}, counts: map[int64]int{},
		attempts: map[string]connectWindow{}, admitting: make(chan struct{}, 32)}
}

type peerInfo struct {
	Device  string `json:"device"`
	Session string `json:"session"`
}
type relayInfo struct {
	RemainingBytes int64 `json:"remainingBytes"`
	MaxFrameBytes  int64 `json:"maxFrameBytes"`
}
type networkMessage struct {
	Type    string      `json:"type"`
	To      string      `json:"to,omitempty"`
	From    string      `json:"from,omitempty"`
	Device  string      `json:"device,omitempty"`
	Session string      `json:"session,omitempty"`
	Payload string      `json:"payload,omitempty"`
	Code    string      `json:"code,omitempty"`
	Kind    string      `json:"kind,omitempty"`
	Peers   *[]peerInfo `json:"peers,omitempty"`
	Relay   *relayInfo  `json:"relay,omitempty"`
}
type networkFrame struct {
	bytes []byte
	kind  string
	day   string
}
type networkPeer struct {
	s             *Server
	key           roomKey
	device        string
	session       string
	authorization string
	conn          *websocket.Conn
	ctx           context.Context
	cancel        context.CancelFunc
	queue         chan networkFrame
	// sendMu serializes enqueue against shutdown and protects unused reserves.
	sendMu         sync.Mutex
	closed         bool
	emergencyDay   string
	emergencyBytes int64
}

var roomPattern = regexp.MustCompile(`^[a-fA-F0-9]{32,64}$`)
var devicePattern = regexp.MustCompile(`^[A-Za-z0-9_-]{1,128}$`)
var sessionPattern = regexp.MustCompile(`^[a-f0-9]{32}$`)

func (s *Server) networkSocket(w http.ResponseWriter, r *http.Request) {
	h := s.network
	select {
	case h.admitting <- struct{}{}:
	default:
		http.Error(w, "network busy", 503)
		return
	}
	release := func() { <-h.admitting }
	if !s.allowNetworkConnect(s.clientAddress(r)) {
		release()
		w.Header().Set("Retry-After", "60")
		http.Error(w, "network connection rate exceeded", 429)
		return
	}
	user, ok := s.authenticate(w, r)
	if !ok {
		release()
		return
	}
	space, device := r.URL.Query().Get("space"), r.URL.Query().Get("device")
	if strings.HasPrefix(r.Header.Get("Authorization"), "Bearer ") {
		_, authenticated, valid := s.requireDevice(w, r)
		if !valid {
			release()
			return
		}
		if authenticated != device {
			release()
			http.Error(w, "device identity mismatch", 403)
			return
		}
	}
	if !roomPattern.MatchString(space) || !devicePattern.MatchString(device) {
		release()
		http.Error(w, "invalid network identity", 400)
		return
	}
	key := roomKey{user.ID, space}
	// Admission holds the room lock through upgrade and welcome enqueue, so a
	// concurrent join cannot overtake welcome or exceed room/account limits.
	h.mu.Lock()
	if h.closed {
		h.mu.Unlock()
		release()
		http.Error(w, "network shutting down", 503)
		return
	}
	room := h.rooms[key]
	old := room[device]
	if old == nil && (len(room) >= s.cfg.Network.MaxPeers || h.counts[user.ID] >= s.cfg.Network.MaxConnections || h.total >= 1024) {
		h.mu.Unlock()
		release()
		http.Error(w, "network peer limit reached", 429)
		return
	}
	day := s.transferDay()
	const emergencyBytes int64 = 256
	if err := s.reserveNetwork(r.Context(), user.ID, day, "signal", emergencyBytes); err != nil {
		h.mu.Unlock()
		release()
		http.Error(w, "network signal budget exhausted", 429)
		return
	}
	conn, err := websocket.Accept(w, r, &websocket.AcceptOptions{CompressionMode: websocket.CompressionDisabled})
	if err != nil {
		h.mu.Unlock()
		release()
		s.refundNetwork(user.ID, day, "signal", emergencyBytes)
		return
	}
	release()
	ctx, cancel := context.WithTimeout(context.Background(), s.cfg.Network.SessionTTL)
	h.wg.Add(1)
	defer h.wg.Done()
	var random [16]byte
	if _, err := rand.Read(random[:]); err != nil {
		h.mu.Unlock()
		cancel()
		conn.CloseNow()
		s.refundNetwork(user.ID, day, "signal", emergencyBytes)
		return
	}
	p := &networkPeer{s: s, key: key, device: device, session: hex.EncodeToString(random[:]), conn: conn,
		authorization: r.Header.Get("Authorization"),
		ctx:           ctx, cancel: cancel, queue: make(chan networkFrame, s.cfg.Network.QueueFrames), emergencyDay: day, emergencyBytes: emergencyBytes}
	conn.SetReadLimit(max(s.cfg.Network.SignalFrameBytes, s.cfg.Network.RelayFrameBytes))
	var peers = []peerInfo{}
	for id, peer := range room {
		if id != device {
			peers = append(peers, peerInfo{id, peer.session})
		}
	}
	if room == nil {
		room = map[string]*networkPeer{}
		h.rooms[key] = room
	}
	room[device] = p
	if old == nil {
		h.counts[user.ID]++
		h.total++
	}
	remaining, err := s.networkRemaining(p.ctx, user.ID, "relay")
	if err == nil {
		err = p.enqueue("signal", networkMessage{Type: "welcome", Session: p.session, Peers: &peers, Relay: &relayInfo{remaining, s.cfg.Network.RelayFrameBytes}})
	}
	if err != nil {
		delete(room, device)
		if old != nil {
			room[device] = old
		} else {
			h.counts[user.ID]--
			h.total--
			if len(room) == 0 {
				delete(h.rooms, key)
			}
			if h.counts[user.ID] == 0 {
				delete(h.counts, user.ID)
			}
		}
		h.mu.Unlock()
		p.stop()
		return
	}
	for id, peer := range room {
		if id != device {
			if err := peer.enqueue("signal", networkMessage{Type: "join", Device: device, Session: p.session}); err != nil {
				peer.cancel()
			}
		}
	}
	h.mu.Unlock()
	if old != nil {
		old.cancel()
		old.conn.CloseNow()
	}
	authorization := r.Header.Get("Authorization")
	writerDone := make(chan struct{})
	go func() { defer close(writerDone); p.writer(authorization) }()
	p.readLoop()
	p.cancel()
	conn.CloseNow()
	<-writerDone
	s.removeNetworkPeer(p)
	p.stop()
}

func (s *Server) allowNetworkConnect(address string) bool {
	h := s.network
	h.mu.Lock()
	defer h.mu.Unlock()
	now := s.cfg.Now()
	for key, entry := range h.attempts {
		if now.Sub(entry.at) >= time.Minute {
			delete(h.attempts, key)
		}
	}
	entry, exists := h.attempts[address]
	if !exists && len(h.attempts) >= 4096 {
		return false
	}
	if !exists {
		entry.at = now
	}
	entry.count++
	h.attempts[address] = entry
	return entry.count <= s.cfg.Network.ConnectsPerMinute
}

func (s *Server) networkLimit(kind string) int64 {
	if kind == "relay" {
		return s.cfg.Network.RelayDailyBytes
	}
	return s.cfg.Network.SignalDailyBytes
}
func (s *Server) networkRemaining(ctx context.Context, user int64, kind string) (int64, error) {
	if !s.cfg.OperatorLimits {
		// A protocol capability ceiling, not a metered allowance. Exact integers
		// remain representable by clients that decode JSON through JavaScript.
		return 1<<53 - 1, nil
	}
	used, err := s.accounts.NetworkUsed(ctx, user, s.transferDay(), kind)
	remaining := max(0, s.networkLimit(kind)-used)
	if err == nil && kind == "relay" {
		traffic, failure := s.cloudTrafficPolicy(ctx, user)
		return min(remaining, traffic.MonthlyRemainingBytes), failure
	}
	return remaining, err
}
func (s *Server) refundNetwork(user int64, day, kind string, bytes int64) {
	if !s.cfg.OperatorLimits || bytes <= 0 {
		return
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := s.accounts.RefundNetwork(ctx, user, day, kind, bytes); err != nil {
		s.log.Error("refund network transfer", "user", user, "err", err)
	}
}

// enqueue reserves the encoded outbound length before putting it on the queue.
// Cancelled, unattempted frames are refunded; failed/partial writes keep their
// full reservation because WebSocket Write does not expose a byte count.
func (p *networkPeer) enqueue(kind string, message networkMessage) error {
	data, err := json.Marshal(message)
	if err != nil {
		return err
	}
	limit := p.s.cfg.Network.SignalFrameBytes
	if kind == "relay" {
		limit = p.s.cfg.Network.RelayFrameBytes
	}
	if int64(len(data)) > limit {
		return errors.New("network output frame too large")
	}
	p.sendMu.Lock()
	defer p.sendMu.Unlock()
	if p.closed || p.ctx.Err() != nil {
		return context.Canceled
	}
	day := p.s.transferDay()
	if err = p.s.reserveNetwork(p.ctx, p.key.user, day, kind, int64(len(data))); err != nil {
		return err
	}
	select {
	case p.queue <- networkFrame{data, kind, day}:
		return nil
	default:
		p.s.refundNetwork(p.key.user, day, kind, int64(len(data)))
		p.cancel()
		return errors.New("network output queue full")
	}
}

func (p *networkPeer) writer(authorization string) {
	ticker := time.NewTicker(p.s.cfg.Network.HeartbeatInterval)
	defer ticker.Stop()
	checked := time.Now()
	for {
		select {
		case <-p.ctx.Done():
			return
		case frame := <-p.queue:
			if p.ctx.Err() != nil {
				p.s.refundNetwork(p.key.user, frame.day, frame.kind, int64(len(frame.bytes)))
				return
			}
			ctx, cancel := context.WithTimeout(p.ctx, p.s.cfg.Network.WriteTimeout)
			err := p.conn.Write(ctx, websocket.MessageText, frame.bytes)
			cancel()
			if err != nil {
				p.cancel()
				p.conn.CloseNow()
				return
			}
		case <-ticker.C:
			ctx, cancel := context.WithTimeout(p.ctx, p.s.cfg.Network.WriteTimeout)
			err := p.conn.Ping(ctx)
			cancel()
			if err != nil {
				p.cancel()
				p.conn.CloseNow()
				return
			}
			if strings.HasPrefix(authorization, "Bearer ") || time.Since(checked) >= p.s.cfg.CredentialTTL {
				ctx, cancel := context.WithTimeout(p.ctx, p.s.cfg.Network.WriteTimeout)
				valid := p.s.validNetworkCredential(ctx, authorization, p.key.user)
				cancel()
				if !valid {
					p.cancel()
					p.conn.CloseNow()
					return
				}
				checked = time.Now()
			}
		}
	}
}

func (p *networkPeer) readLoop() {
	window := time.Now()
	frames := 0
	for {
		typeID, data, err := p.conn.Read(p.ctx)
		if err != nil {
			return
		}
		if p.ctx.Err() != nil || (strings.HasPrefix(p.authorization, "Bearer ") &&
			!p.s.validNetworkCredential(p.ctx, p.authorization, p.key.user)) {
			return
		}
		if time.Since(window) >= time.Second {
			window = time.Now()
			frames = 0
		}
		frames++
		if frames > p.s.cfg.Network.FramesPerSecond || typeID != websocket.MessageText {
			return
		}
		var message networkMessage
		if json.Unmarshal(data, &message) != nil || (message.Type != "signal" && message.Type != "relay") {
			return
		}
		kind := message.Type
		if err := p.s.reserveNetwork(p.ctx, p.key.user, p.s.transferDay(), kind, int64(len(data))); err != nil {
			p.terminalBudget(kind)
			return
		}
		limit := p.s.cfg.Network.SignalFrameBytes
		if kind == "relay" {
			limit = p.s.cfg.Network.RelayFrameBytes
		}
		if int64(len(data)) > limit {
			p.sendError("too_large", kind)
			continue
		}
		if !devicePattern.MatchString(message.To) || !sessionPattern.MatchString(message.Session) {
			p.sendError("offline", kind)
			continue
		}
		if _, err := base64.StdEncoding.Strict().DecodeString(message.Payload); err != nil {
			return
		}
		forward := networkMessage{Type: kind, From: p.device, Session: p.session, Payload: message.Payload}
		encoded, _ := json.Marshal(forward)
		if int64(len(encoded)) > limit {
			p.sendError("too_large", kind)
			continue
		}
		h := p.s.network
		h.mu.Lock()
		target := h.rooms[p.key][message.To]
		if target == nil || target == p || target.session != message.Session {
			h.mu.Unlock()
			p.sendError("offline", kind)
			continue
		}
		err = target.enqueue(kind, forward)
		h.mu.Unlock()
		if errors.Is(err, accounts.ErrTransferLimit) {
			p.sendError("budget", kind)
		} else if err != nil {
			p.sendError("offline", kind)
		}
		if kind == "relay" {
			p.sendBudget()
		}
	}
}

func (p *networkPeer) sendError(code, kind string) {
	if err := p.enqueue("signal", networkMessage{Type: "error", Code: code, Kind: kind}); err != nil {
		p.cancel()
	}
}
func (p *networkPeer) sendBudget() {
	remaining, err := p.s.networkRemaining(p.ctx, p.key.user, "relay")
	if err != nil {
		p.cancel()
		return
	}
	if err = p.enqueue("signal", networkMessage{Type: "budget", Relay: &relayInfo{remaining, p.s.cfg.Network.RelayFrameBytes}}); err != nil {
		p.cancel()
	}
}

// The last budget error uses a small signal reserve taken at admission, so
// reporting exhaustion itself cannot exceed the signal allowance.
func (p *networkPeer) terminalBudget(kind string) {
	data, _ := json.Marshal(networkMessage{Type: "error", Code: "budget", Kind: kind})
	p.sendMu.Lock()
	if int64(len(data)) > p.emergencyBytes || int64(len(data)) > p.s.cfg.Network.SignalFrameBytes {
		p.sendMu.Unlock()
		return
	}
	p.emergencyBytes -= int64(len(data))
	p.sendMu.Unlock()
	ctx, cancel := context.WithTimeout(p.ctx, p.s.cfg.Network.WriteTimeout)
	defer cancel()
	p.conn.Write(ctx, websocket.MessageText, data)
}

func (s *Server) removeNetworkPeer(p *networkPeer) {
	h := s.network
	h.mu.Lock()
	defer h.mu.Unlock()
	room := h.rooms[p.key]
	if room[p.device] != p {
		return
	}
	delete(room, p.device)
	h.counts[p.key.user]--
	h.total--
	if h.counts[p.key.user] == 0 {
		delete(h.counts, p.key.user)
	}
	if len(room) == 0 {
		delete(h.rooms, p.key)
		return
	}
	for _, peer := range room {
		if err := peer.enqueue("signal", networkMessage{Type: "leave", Device: p.device, Session: p.session}); err != nil {
			peer.cancel()
		}
	}
}
func (p *networkPeer) stop() {
	p.cancel()
	p.conn.CloseNow()
	p.sendMu.Lock()
	defer p.sendMu.Unlock()
	p.closed = true
	for {
		select {
		case frame := <-p.queue:
			p.s.refundNetwork(p.key.user, frame.day, frame.kind, int64(len(frame.bytes)))
		default:
			p.s.refundNetwork(p.key.user, p.emergencyDay, "signal", p.emergencyBytes)
			p.emergencyBytes = 0
			return
		}
	}
}

// Close terminates upgraded connections, which http.Server.Shutdown does not own.
func (s *Server) Close() {
	h := s.network
	h.mu.Lock()
	h.closed = true
	var peers []*networkPeer
	for _, room := range h.rooms {
		for _, peer := range room {
			peers = append(peers, peer)
		}
	}
	h.mu.Unlock()
	for _, peer := range peers {
		peer.cancel()
		peer.conn.CloseNow()
	}
	h.wg.Wait()
}

func (s *Server) networkPolicy(ctx context.Context, user int64) (map[string]any, error) {
	if !s.cfg.OperatorLimits {
		return map[string]any{"endpoint": "/api/sync/network",
			"relay":  map[string]int64{"maxFrameBytes": s.cfg.Network.RelayFrameBytes},
			"signal": map[string]int64{"maxFrameBytes": s.cfg.Network.SignalFrameBytes}}, nil
	}
	relay, err := s.networkRemaining(ctx, user, "relay")
	if err != nil {
		return nil, err
	}
	signal, err := s.networkRemaining(ctx, user, "signal")
	if err != nil {
		return nil, err
	}
	return map[string]any{"endpoint": "/api/sync/network", "relay": relayInfo{relay, s.cfg.Network.RelayFrameBytes},
		"signal": map[string]int64{"remainingBytes": signal, "maxFrameBytes": s.cfg.Network.SignalFrameBytes}}, nil
}
