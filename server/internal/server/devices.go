// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"aiddiary/syncserver/internal/accounts"
	"context"
	"encoding/base64"
	"encoding/json"
	"io"
	"net/http"
	"strings"
	"time"
)

type DeviceAuthLimits struct {
	ChallengeTTL, TokenTTL time.Duration
	MaxDevices             int
}

func (d DeviceAuthLimits) defaults() DeviceAuthLimits {
	if d.ChallengeTTL <= 0 {
		d.ChallengeTTL = 2 * time.Minute
	}
	if d.TokenTTL <= 0 {
		d.TokenTTL = 15 * time.Minute
	}
	if d.MaxDevices <= 0 {
		d.MaxDevices = 16
	}
	return d
}

type enrollment struct {
	ID        string `json:"id"`
	Label     string `json:"label"`
	PublicKey string `json:"publicKeySpki"`
	Signature string `json:"signature"`
}

func readDeviceJSON(w http.ResponseWriter, r *http.Request, value any) bool {
	r.Body = http.MaxBytesReader(w, r.Body, 8192)
	decoder := json.NewDecoder(r.Body)
	decoder.DisallowUnknownFields()
	if decoder.Decode(value) != nil {
		http.Error(w, "invalid device request", 400)
		return false
	}
	var tail any
	if decoder.Decode(&tail) != io.EOF {
		http.Error(w, "invalid device request", 400)
		return false
	}
	return true
}
func deviceJSON(w http.ResponseWriter, value any) {
	w.Header().Set("Cache-Control", "no-store")
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(value)
}

func (s *Server) deviceCapabilities(w http.ResponseWriter, r *http.Request) {
	deviceJSON(w, map[string]any{"protocol": "aid-device-auth-v1", "challengeTtlSeconds": int64(s.cfg.DeviceAuth.ChallengeTTL.Seconds()), "tokenTtlSeconds": int64(s.cfg.DeviceAuth.TokenTTL.Seconds())})
}

func (s *Server) enrollDevice(w http.ResponseWriter, r *http.Request) {
	bootstrap := !strings.HasPrefix(r.Header.Get("Authorization"), "Bearer ")
	var user accounts.User
	var ok bool
	if bootstrap {
		user, ok = s.authenticateBasic(w, r)
	} else {
		user, ok = s.authenticate(w, r)
	}
	if !ok {
		return
	}
	var request enrollment
	if !readDeviceJSON(w, r, &request) {
		return
	}
	key, err := base64.StdEncoding.DecodeString(request.PublicKey)
	signature, decodeErr := base64.StdEncoding.DecodeString(request.Signature)
	if err != nil || decodeErr != nil || len(request.Label) > 128 || !devicePattern.MatchString(request.ID) ||
		!accounts.VerifyDeviceProof(key, accounts.DeviceEnrollmentMessage(user.Name, request.ID, key), signature) {
		http.Error(w, "invalid device proof", 403)
		return
	}
	if err = s.accounts.RegisterDevice(r.Context(), user.ID, request.ID, request.Label, key, bootstrap, s.cfg.DeviceAuth.MaxDevices, s.cfg.Now()); err != nil {
		http.Error(w, "device authorization required", 403)
		return
	}
	if bootstrap {
		s.closeAccountSockets(user.ID)
	}
	deviceJSON(w, map[string]bool{"authorized": true})
}

func (s *Server) deviceChallenge(w http.ResponseWriter, r *http.Request) {
	if !s.allowNetworkConnect("auth:" + s.clientAddress(r)) {
		http.Error(w, "too many device requests", 429)
		return
	}
	var request struct {
		Username string `json:"username"`
		Device   string `json:"device"`
	}
	if !readDeviceJSON(w, r, &request) {
		return
	}
	if !devicePattern.MatchString(request.Device) || len(request.Username) > 32 {
		http.Error(w, "device authorization required", 403)
		return
	}
	id, message, err := s.accounts.NewDeviceChallenge(r.Context(), strings.ToLower(request.Username), request.Device, s.cfg.Now(), s.cfg.DeviceAuth.ChallengeTTL)
	if err != nil {
		http.Error(w, "device authorization required", 403)
		return
	}
	deviceJSON(w, map[string]any{"challenge": id, "message": base64.StdEncoding.EncodeToString(message), "expires": s.cfg.Now().Add(s.cfg.DeviceAuth.ChallengeTTL).Unix()})
}
func (s *Server) deviceToken(w http.ResponseWriter, r *http.Request) {
	if !s.allowNetworkConnect("auth:" + s.clientAddress(r)) {
		http.Error(w, "too many device requests", 429)
		return
	}
	var request struct {
		Challenge string `json:"challenge"`
		Signature string `json:"signature"`
	}
	if !readDeviceJSON(w, r, &request) {
		return
	}
	signature, err := base64.StdEncoding.DecodeString(request.Signature)
	if err != nil || len(request.Challenge) != 43 || len(signature) > 80 {
		http.Error(w, "invalid device proof", 403)
		return
	}
	token, err := s.accounts.DeviceToken(r.Context(), request.Challenge, signature, s.cfg.Now(), s.cfg.DeviceAuth.TokenTTL)
	if err != nil {
		http.Error(w, "invalid device proof", 403)
		return
	}
	deviceJSON(w, map[string]any{"token": token, "expires": s.cfg.Now().Add(s.cfg.DeviceAuth.TokenTTL).Unix()})
}
func (s *Server) requireDevice(w http.ResponseWriter, r *http.Request) (accounts.User, string, bool) {
	value := r.Header.Get("Authorization")
	if !strings.HasPrefix(value, "Bearer ") {
		s.challenge(w)
		return accounts.User{}, "", false
	}
	user, id, err := s.accounts.VerifyDeviceToken(r.Context(), strings.TrimPrefix(value, "Bearer "), s.cfg.Now())
	if err != nil {
		s.challenge(w)
		return accounts.User{}, "", false
	}
	return user, id, true
}
func (s *Server) listDevices(w http.ResponseWriter, r *http.Request) {
	user, _, ok := s.requireDevice(w, r)
	if !ok {
		return
	}
	devices, err := s.accounts.Devices(r.Context(), user.ID)
	if err != nil {
		http.Error(w, "devices unavailable", 503)
		return
	}
	deviceJSON(w, map[string]any{"devices": devices})
}
func (s *Server) revokeDevice(w http.ResponseWriter, r *http.Request) {
	user, _, ok := s.requireDevice(w, r)
	if !ok {
		return
	}
	id := r.PathValue("device")
	if !devicePattern.MatchString(id) {
		http.Error(w, "invalid device", 400)
		return
	}
	if err := s.accounts.RevokeDevice(r.Context(), user.ID, id); err != nil {
		http.Error(w, "device unavailable", 404)
		return
	}
	s.closeDeviceSockets(user.ID, id)
	deviceJSON(w, map[string]bool{"revoked": true})
}
func (s *Server) rotateDevice(w http.ResponseWriter, r *http.Request) {
	user, id, ok := s.requireDevice(w, r)
	if !ok {
		return
	}
	var request enrollment
	if !readDeviceJSON(w, r, &request) {
		return
	}
	key, err := base64.StdEncoding.DecodeString(request.PublicKey)
	signature, decodeErr := base64.StdEncoding.DecodeString(request.Signature)
	if request.ID != id || err != nil || decodeErr != nil || !accounts.VerifyDeviceProof(key,
		append([]byte("aid-device-rotate-v1\n"), accounts.DeviceEnrollmentMessage(user.Name, id, key)...), signature) {
		http.Error(w, "invalid rotation proof", 403)
		return
	}
	if err = s.accounts.RotateDevice(r.Context(), user.ID, id, key); err != nil {
		http.Error(w, "device unavailable", 403)
		return
	}
	s.closeDeviceSockets(user.ID, id)
	deviceJSON(w, map[string]bool{"rotated": true})
}
func (s *Server) closeDeviceSockets(user int64, id string) {
	h := s.network
	h.mu.Lock()
	var peers []*networkPeer
	for room, devices := range h.rooms {
		if room.user == user {
			if p := devices[id]; p != nil {
				peers = append(peers, p)
			}
		}
	}
	h.mu.Unlock()
	for _, p := range peers {
		p.cancel()
		p.conn.CloseNow()
	}
}

func (s *Server) closeAccountSockets(user int64) {
	h := s.network
	h.mu.Lock()
	var peers []*networkPeer
	for room, devices := range h.rooms {
		if room.user == user {
			for _, p := range devices {
				peers = append(peers, p)
			}
		}
	}
	h.mu.Unlock()
	for _, p := range peers {
		p.cancel()
		p.conn.CloseNow()
	}
}
func (s *Server) validNetworkCredential(ctx context.Context, authorization string, userID int64) bool {
	if strings.HasPrefix(authorization, "Bearer ") {
		user, _, err := s.accounts.VerifyDeviceToken(ctx, strings.TrimPrefix(authorization, "Bearer "), s.cfg.Now())
		return err == nil && user.ID == userID
	}
	request := &http.Request{Header: http.Header{"Authorization": []string{authorization}}}
	name, password, ok := request.BasicAuth()
	if !ok {
		return false
	}
	user, err := s.accounts.Verify(ctx, name, password)
	if err != nil || user.ID != userID {
		return false
	}
	has, err := s.accounts.HasDevices(ctx, user.ID)
	return err == nil && !has
}
