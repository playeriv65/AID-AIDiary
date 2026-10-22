// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package server

import (
	"context"
	"time"
)

type cloudTrafficPolicy struct {
	MonthlyLimitBytes     int64  `json:"monthlyLimitBytes"`
	MonthlyUsedBytes      int64  `json:"monthlyUsedBytes"`
	MonthlyRemainingBytes int64  `json:"monthlyRemainingBytes"`
	ResetsAt              string `json:"resetsAt"`
}

func nextMonth(now time.Time) time.Time {
	now = now.UTC()
	return time.Date(now.Year(), now.Month()+1, 1, 0, 0, 0, 0, time.UTC)
}

func (s *Server) cloudTrafficPolicy(ctx context.Context, user int64) (cloudTrafficPolicy, error) {
	now := s.cfg.Now().UTC()
	used, err := s.accounts.MonthlyMediaUsed(ctx, user, now.Format("2006-01"))
	return cloudTrafficPolicy{s.cfg.MonthlyMediaBytes, used, max(0, s.cfg.MonthlyMediaBytes-used), nextMonth(now).Format(time.RFC3339)}, err
}

func (s *Server) reserveNetwork(ctx context.Context, user int64, day, kind string, bytes int64) error {
	if !s.cfg.OperatorLimits {
		return nil
	}
	return s.accounts.ReserveCloudNetwork(ctx, user, day, kind, bytes, s.networkLimit(kind), s.cfg.MonthlyMediaBytes)
}
