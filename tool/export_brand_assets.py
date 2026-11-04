#!/usr/bin/env python3
"""Export DSN-005 brand rasters from canonical mark geometry (Logo sheet)."""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
BRAND = ROOT / "assets" / "brand"
ADAPTIVE = BRAND / "adaptive"
FONT_PATH = ROOT / "assets" / "fonts" / "BricolageGrotesque-Bold.ttf"

INK = (0x0A, 0x0D, 0x14, 255)
PANEL = (0x11, 0x16, 0x1F, 255)
CLOUD = (0xF0, 0xEE, 0xE9, 255)
SIGNAL = (0x2B, 0xD9, 0xC8, 255)
EMBER = (0xFF, 0x7A, 0x4D, 255)
COMPANION_PRIMARY = (0x0A, 0x6F, 0x68, 255)
COMPANION_LIVE = (0xB8, 0x43, 0x1B, 255)

VB_W, VB_H = 72.0, 64.0
STROKE = 7.0
DOT_R = 5.5


def write_svg(path: Path, stroke: str, dot: str, bg: str | None = None) -> None:
    bg_rect = f'<rect width="72" height="64" fill="{bg}"/>' if bg else ""
    path.write_text(
        f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 72 64" fill="none">
  {bg_rect}
  <path d="M10 48V30a9 9 0 0 0 18 0V48M28 30a9 9 0 0 0 18 0V48M60 33v15"
        stroke="{stroke}" stroke-width="7" stroke-linecap="round"
        stroke-linejoin="round"/>
  <circle cx="60" cy="19" r="5.5" fill="{dot}"/>
</svg>
""",
        encoding="utf-8",
    )


def write_lockup_svg(
    path: Path,
    stroke: str,
    dot: str,
    word_fill: str,
    bg: str,
    width: int = 420,
    height: int = 120,
) -> None:
    path.write_text(
        f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {width} {height}" fill="none">
  <rect width="{width}" height="{height}" fill="{bg}"/>
  <g transform="translate(36,{(height - 89) / 2})">
    <svg viewBox="0 0 72 64" width="100" height="89">
      <path d="M10 48V30a9 9 0 0 0 18 0V48M28 30a9 9 0 0 0 18 0V48M60 33v15"
            stroke="{stroke}" stroke-width="7" stroke-linecap="round"
            stroke-linejoin="round" fill="none"/>
      <circle cx="60" cy="19" r="5.5" fill="{dot}"/>
    </svg>
  </g>
  <text x="154" y="{height * 0.68}" font-family="Bricolage Grotesque, sans-serif"
        font-weight="700" font-size="104" letter-spacing="-0.03em" fill="{word_fill}">iptv</text>
</svg>
""",
        encoding="utf-8",
    )


def _transform(
    x: float, y: float, scale: float, ox: float, oy: float
) -> tuple[float, float]:
    return ox + x * scale, oy + y * scale


def draw_mark(
    draw: ImageDraw.ImageDraw,
    *,
    scale: float,
    ox: float,
    oy: float,
    stroke: tuple[int, int, int, int],
    dot: tuple[int, int, int, int],
) -> None:
    """Paint canonical mark with upright arches (Logo sheet visual)."""
    sw = max(1, int(round(STROKE * scale)))

    def pt(x: float, y: float) -> tuple[float, float]:
        return _transform(x, y, scale, ox, oy)

    def arch(x0: float, x1: float) -> None:
        mid = (x0 + x1) / 2
        r = 9.0
        pts = []
        for i in range(33):
            t = i / 32
            ang = math.pi - (math.pi * t)
            px = mid + r * math.cos(ang)
            py = 30 - r * math.sin(ang)
            pts.append(pt(px, py))
        draw.line(pts, fill=stroke, width=sw, joint="curve")

    for x in (10.0, 28.0, 46.0):
        draw.line([pt(x, 48), pt(x, 30)], fill=stroke, width=sw)
    arch(10.0, 28.0)
    arch(28.0, 46.0)
    draw.line([pt(60, 33), pt(60, 48)], fill=stroke, width=sw)

    for x, y in (
        (10, 48),
        (10, 30),
        (28, 30),
        (28, 48),
        (46, 30),
        (46, 48),
        (60, 33),
        (60, 48),
    ):
        cx, cy = pt(x, y)
        r = sw / 2
        draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=stroke)

    cx, cy = pt(60, 19)
    r = DOT_R * scale
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=dot)


def paint_mark_image(
    size: int,
    stroke: tuple[int, int, int, int],
    dot: tuple[int, int, int, int],
    bg: tuple[int, int, int, int] | None,
    *,
    mark_scale_of_min: float = 0.58,
) -> Image.Image:
    img = Image.new("RGBA", (size, size), bg if bg else (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    usable = size * mark_scale_of_min
    scale = usable / max(VB_W, VB_H)
    drawn_w, drawn_h = VB_W * scale, VB_H * scale
    ox = (size - drawn_w) / 2
    oy = (size - drawn_h) / 2
    draw_mark(draw, scale=scale, ox=ox, oy=oy, stroke=stroke, dot=dot)
    return img


def paint_lockup(
    width: int,
    height: int,
    stroke: tuple[int, int, int, int],
    dot: tuple[int, int, int, int],
    word_fill: tuple[int, int, int, int],
    bg: tuple[int, int, int, int],
    *,
    mark_h: int,
    word_size: int,
) -> Image.Image:
    img = Image.new("RGBA", (width, height), bg)
    draw = ImageDraw.Draw(img)
    scale = mark_h / VB_H
    mark_w = VB_W * scale
    gap = DOT_R * 2 * scale
    font = ImageFont.truetype(str(FONT_PATH), word_size)
    text = "iptv"
    bbox = font.getbbox(text)
    natural_w = bbox[2] - bbox[0]
    tracking = -0.03 * word_size
    tracked_w = natural_w + tracking * (len(text) - 1)
    total_w = mark_w + gap + tracked_w
    ox = (width - total_w) / 2
    oy = (height - mark_h) / 2
    draw_mark(draw, scale=scale, ox=ox, oy=oy, stroke=stroke, dot=dot)

    text_x = ox + mark_w + gap
    ascent, descent = font.getmetrics()
    text_y = (height - (ascent + descent)) / 2
    x = text_x
    for ch in text:
        draw.text((x, text_y), ch, font=font, fill=word_fill)
        x += font.getlength(ch) + tracking
    return img


def main() -> None:
    BRAND.mkdir(parents=True, exist_ok=True)
    ADAPTIVE.mkdir(parents=True, exist_ok=True)

    write_svg(BRAND / "mark.svg", "#2BD9C8", "#FF7A4D")
    write_svg(BRAND / "mark_companion.svg", "#0A6F68", "#B8431B")
    write_svg(BRAND / "mark_monochrome.svg", "#0A0D14", "#0A0D14", bg="#2BD9C8")
    write_lockup_svg(
        BRAND / "lockup_dark.svg", "#2BD9C8", "#FF7A4D", "#F0EEE9", "#11161F"
    )
    write_lockup_svg(
        BRAND / "lockup_companion.svg", "#0A6F68", "#B8431B", "#0A0D14", "#F0EEE9"
    )
    write_lockup_svg(
        BRAND / "lockup_monochrome.svg", "#0A0D14", "#0A0D14", "#0A0D14", "#2BD9C8"
    )

    paint_mark_image(512, SIGNAL, EMBER, PANEL, mark_scale_of_min=236 / 360).save(
        BRAND / "app_icon_512.png"
    )

    paint_lockup(
        320, 180, SIGNAL, EMBER, CLOUD, INK, mark_h=57, word_size=62
    ).save(BRAND / "tv_banner_320x180.png")

    adaptive_size = 432
    fg = paint_mark_image(
        adaptive_size, SIGNAL, EMBER, None, mark_scale_of_min=0.52
    )
    fg.save(ADAPTIVE / "ic_launcher_foreground.png")
    Image.new("RGBA", (adaptive_size, adaptive_size), PANEL).save(
        ADAPTIVE / "ic_launcher_background.png"
    )
    mono = paint_mark_image(
        adaptive_size, CLOUD, CLOUD, None, mark_scale_of_min=0.52
    )
    mono.save(ADAPTIVE / "ic_launcher_monochrome.png")

    res = ROOT / "android" / "app" / "src" / "main" / "res"
    densities = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, px in densities.items():
        out = res / folder
        out.mkdir(parents=True, exist_ok=True)
        paint_mark_image(px, SIGNAL, EMBER, PANEL, mark_scale_of_min=236 / 360).save(
            out / "ic_launcher.png"
        )

    drawable = res / "drawable"
    drawable.mkdir(parents=True, exist_ok=True)
    fg.save(drawable / "ic_launcher_foreground.png")
    Image.new("RGBA", (adaptive_size, adaptive_size), PANEL).save(
        drawable / "ic_launcher_background.png"
    )
    mono.save(drawable / "ic_launcher_monochrome.png")
    paint_lockup(
        320, 180, SIGNAL, EMBER, CLOUD, INK, mark_h=57, word_size=62
    ).save(drawable / "tv_banner.png")

    paint_lockup(840, 240, SIGNAL, EMBER, CLOUD, PANEL, mark_h=89, word_size=104).save(
        BRAND / "lockup_dark.png"
    )
    paint_lockup(
        840,
        240,
        COMPANION_PRIMARY,
        COMPANION_LIVE,
        INK,
        CLOUD,
        mark_h=89,
        word_size=104,
    ).save(BRAND / "lockup_companion.png")
    paint_lockup(840, 240, INK, INK, INK, SIGNAL, mark_h=89, word_size=104).save(
        BRAND / "lockup_monochrome.png"
    )

    print("DSN-005 assets exported to", BRAND)


if __name__ == "__main__":
    main()
