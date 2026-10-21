// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'dart:io';

import 'package:aid_cli/aid_cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runAid(arguments);
}
