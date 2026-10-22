// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/models/tag_icon_type.dart';
import 'package:aid_diary/utils/color_utils.dart';

/// The color and icon of a tag or category.
typedef TagLook = ({int? color, String? icon, TagIconType iconType});

/// What the tag and category actions take for [look]: only the parts that
/// differ from [before], so that a look the actions cannot spell (an icon
/// key the app no longer has) survives a rename.
Map<String, Object?> tagLookArgs(TagLook look, {TagLook? before}) => {
      if (look.color != before?.color)
        'color': look.color == null ? 'none' : colorToHex(look.color!),
      if (look.icon != before?.icon || look.iconType != before?.iconType)
        'icon': look.icon == null || look.icon!.isEmpty ? 'none' : look.icon,
    };
