# Copyright (C) 2026 Demizo and contributors
# SPDX-License-Identifier: GPL-3.0-only
# Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.
"""Export the app icon (a blue spiral notebook, black rings on the left, two
white lines and a small white sparkle) as every asset icons_launcher reads,
plus assets/logo.svg. Flat shapes only, in the style of Google's app icons.

Usage, from the app folder:
  uv run --no-project --with resvg-py --with pillow python tool/icon/export_icon.py assets
  dart run icons_launcher:create
"""
import io
import sys
from pathlib import Path

import resvg_py
from PIL import Image

ASSETS = Path(sys.argv[1])

BLUE, BLACK, WHITE = "#1A73E8", "#202124", "#FFFFFF"

# How large the notebook is drawn, relative to its base layout below.
LAUNCHER_SCALE = 1.14
# Adaptive layers are 108 dp of which 72 dp show: the same look needs the
# glyph 72/108 as large; it stays well inside the 66 dp safe circle.
ADAPTIVE_SCALE = LAUNCHER_SCALE * 72 / 108
# Notification icons fill their square.
NOTIFY_SCALE = 1.9
# Windows shows the icon unmasked: a fuller glyph on a white plate.
WINDOWS_SCALE = 1.45


def rect(x, y, w, h, r, fill):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}"/>'


def sparkle(cx, cy, r, fill, fullness=0.22):
    k = r * fullness
    return (f'<path d="M{cx} {cy - r} Q{cx + k} {cy - k} {cx + r} {cy} '
            f'Q{cx + k} {cy + k} {cx} {cy + r} Q{cx - k} {cy + k} {cx - r} {cy} '
            f'Q{cx - k} {cy - k} {cx} {cy - r}Z" fill="{fill}"/>')


def notebook(page, rings, marks):
    """400 x 500 page centred on the 1024 canvas (shifted right so the rings
    balance it), four rings on the left, two lines, a sparkle at the bottom
    right."""
    left, width, height = 340, 400, 500
    top = 512 - height // 2
    gap = (height - 160) / 3
    out = rect(left, top, width, height, 56, page)
    out += "".join(rect(left - 58, top + 80 + i * gap - 22, 116, 44, 22, rings)
                   for i in range(4))
    out += "".join(rect(left + 100, top + 96 + i * 88, w, 40, 20, marks)
                   for i, w in enumerate((220, 160)))
    out += sparkle(left + width - 104, top + height - 104, 60, marks)
    return out


def grown(body, scale):
    shift = 512 * (1 - scale)
    return f'<g transform="translate({shift:.1f} {shift:.1f}) scale({scale:.4f})">{body}</g>'


def svg(inner):
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">{inner}</svg>'


GLYPH = notebook(BLUE, BLACK, WHITE)


def silhouette(scale):
    """White, with the lines and the sparkle cut out: only alpha counts."""
    mask = ('<mask id="m"><rect width="1024" height="1024" fill="black"/>'
            + notebook("white", "white", "black") + "</mask>")
    return svg(f"<defs>{mask}</defs>"
               + grown('<rect width="1024" height="1024" fill="#FFFFFF" mask="url(#m)"/>',
                       scale))


CIRCLE = f'<circle cx="512" cy="512" r="512" fill="{WHITE}"/>'
ROUNDED = f'<rect width="1024" height="1024" rx="200" fill="{WHITE}"/>'
SQUARE = f'<rect width="1024" height="1024" fill="{WHITE}"/>'

LAUNCHER = svg(ROUNDED + grown(GLYPH, LAUNCHER_SCALE))
FILES = {
    # Windows .ico (icons_launcher's image_path).
    "logo.png": svg(ROUNDED + grown(GLYPH, WINDOWS_SCALE)),
    # Legacy Android launcher icons, and macOS (not built).
    "logo_rectangle.png": LAUNCHER,
    "logo_border.png": LAUNCHER,
    "logo_round.png": svg(CIRCLE + grown(GLYPH, LAUNCHER_SCALE)),
    # Adaptive icon layers.
    "logo_background.png": svg(SQUARE),
    "logo_foreground.png": svg(grown(GLYPH, ADAPTIVE_SCALE)),
    "logo_monochrome.png": silhouette(ADAPTIVE_SCALE),
    "logo_notification.png": silhouette(NOTIFY_SCALE),
}

for name, markup in FILES.items():
    png = resvg_py.svg_to_bytes(svg_string=markup, width=1024, height=1024)
    Image.open(io.BytesIO(bytes(png))).convert("RGBA").save(ASSETS / name)
    print("wrote", name)
(ASSETS / "logo.svg").write_text(svg(CIRCLE + grown(GLYPH, LAUNCHER_SCALE)),
                                 encoding="utf-8")
print("wrote logo.svg")
