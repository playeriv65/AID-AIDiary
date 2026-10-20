# Copyright (C) 2026 Demizo and contributors
# SPDX-License-Identifier: GPL-3.0-only
# Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.
"""Export the app icon (kraft diary, blue sparkle with a highlight line) as
every asset icons_launcher reads, plus assets/logo.svg.

Usage, from the app folder:
  uv run --no-project --with resvg-py --with pillow python tool/icon/export_icon.py assets
  dart run icons_launcher:create

The book outline is Lucide's "book" icon (ISC licence); the rest is drawn here.
"""
import io
import sys
from pathlib import Path

import resvg_py
from PIL import Image

ASSETS = Path(sys.argv[1])

BOOK = "M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20"
COVER = "M6.5 2H19a1 1 0 0 1 1 1v14H6.5A2.5 2.5 0 0 0 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"
PAGES = "M20 17H6.5a2.5 2.5 0 0 0 0 5H19a1 1 0 0 0 1-1z"

FIELD = "#FFFFFF"
COVER_COLOR = "#E2BE8E"  # Kraft.
OUTLINE = "#7A4E2A"
PAGE_COLOR = "#FFF7E8"
STAR = "#1E6FE6"

STAR_X, STAR_Y, STAR_R, FULLNESS = 12.6, 9.4, 4.4, 0.26


def sparkle(cx, cy, r, fullness):
    k = r * fullness
    return (f"M{cx} {cy - r} Q{cx + k} {cy - k} {cx + r} {cy} "
            f"Q{cx + k} {cy + k} {cx} {cy + r} Q{cx - k} {cy + k} {cx - r} {cy} "
            f"Q{cx - k} {cy - k} {cx} {cy - r}Z")


def _point(p0, c, p2, t):
    return ((1 - t) ** 2 * p0[0] + 2 * t * (1 - t) * c[0] + t * t * p2[0],
            (1 - t) ** 2 * p0[1] + 2 * t * (1 - t) * c[1] + t * t * p2[1])


def edge_shift(t0, t1, d, n=16):
    """The star's upper-left edge from t0 to t1, shifted d toward the centre
    so the highlight keeps the edge's curve."""
    cx, cy, r = STAR_X, STAR_Y, STAR_R
    k = r * FULLNESS
    p0, c, p2 = (cx, cy - r), (cx - k, cy - k), (cx - r, cy)
    step = d / 2 ** 0.5
    return [(x + step, y + step) for x, y in
            (_point(p0, c, p2, t0 + (t1 - t0) * i / n) for i in range(n + 1))]


def highlight(color):
    line = edge_shift(0.3, 0.78, 0.6)
    dot = edge_shift(0.17, 0.17, 0.6, n=1)[0]
    path = "M" + " L".join(f"{x:.3f} {y:.3f}" for x, y in line)
    return (f'<path d="{path}" fill="none" stroke="{color}" stroke-width="0.3" '
            f'stroke-linecap="round" stroke-linejoin="round"/>'
            f'<circle cx="{dot[0]:.3f}" cy="{dot[1]:.3f}" r="0.17" fill="{color}"/>')


def placed(body, scale):
    """[body] on the 24-unit grid, centred on a 1024 canvas at [scale]."""
    offset = 512 - 12 * scale
    return f'<g transform="translate({offset} {offset}) scale({scale})">{body}</g>'


def outline(color):
    return (f'<path d="{BOOK}" fill="none" stroke="{color}" stroke-width="1.8" '
            f'stroke-linecap="round" stroke-linejoin="round"/>')


def colour_book():
    return (f'<path d="{COVER}" fill="{COVER_COLOR}"/>'
            f'<path d="{PAGES}" fill="{PAGE_COLOR}"/>' + outline(OUTLINE)
            + f'<path d="{sparkle(STAR_X, STAR_Y, STAR_R, FULLNESS)}" fill="{STAR}"/>'
            + highlight("#FFFFFF"))


def silhouette(color):
    """One colour on transparency: the outline and the star, for monochrome
    and notification icons, which only use alpha."""
    return outline(color) + f'<path d="{sparkle(STAR_X, STAR_Y, STAR_R, FULLNESS)}" fill="{color}"/>'


def svg(inner):
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">{inner}</svg>'


ROUNDED = f'<rect width="1024" height="1024" rx="224" fill="{FIELD}"/>'
CIRCLE = f'<circle cx="512" cy="512" r="512" fill="{FIELD}"/>'
SQUARE = f'<rect width="1024" height="1024" fill="{FIELD}"/>'

# Full icon: the book at 35 px per unit, as approved.
FULL = svg(ROUNDED + placed(colour_book(), 35))
FILES = {
    "logo.png": FULL,
    "logo_border.png": FULL,
    "logo_rectangle.png": FULL,
    # In a circle the book's corners must stay inside: smaller.
    "logo_round.png": svg(CIRCLE + placed(colour_book(), 30)),
    "logo_background.png": svg(SQUARE),
    # Adaptive layers are 108 dp with a 66 dp safe circle (313 px of 1024):
    # the book's half-diagonal of about 14 units fits at 21 px per unit.
    "logo_foreground.png": svg(placed(colour_book(), 21)),
    "logo_monochrome.png": svg(placed(silhouette("#FFFFFF"), 21)),
    "logo_notification.png": svg(placed(silhouette("#FFFFFF"), 40)),
}

for name, markup in FILES.items():
    png = resvg_py.svg_to_bytes(svg_string=markup, width=1024, height=1024)
    Image.open(io.BytesIO(bytes(png))).convert("RGBA").save(ASSETS / name)
    print("wrote", name)
(ASSETS / "logo.svg").write_text(FULL, encoding="utf-8")
print("wrote logo.svg")
