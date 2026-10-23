// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:convert';

import 'package:flutter/services.dart';

/// Public compatibility parameters from One Diary's v3 backup reader.
/// These are format constants shipped by the other app, not user secrets.
Future<Map<String, dynamic>> loadOneDiaryProtocol() async =>
    jsonDecode(await rootBundle.loadString('assets/config/one_diary_v3.json'))
        as Map<String, dynamic>;
