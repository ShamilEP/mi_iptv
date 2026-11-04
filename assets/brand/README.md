# Brand logo & icon kit (DSN-005)

Canonical Mi IPTV mark and lockups from the Logo brand sheet.

## Concept

Two arches spell **m**; the stem and live-dot spell **i**. The arches double as a broadcast signal; the Ember dot is the LIVE beacon.

## Rules

| Rule | Value |
|---|---|
| Clear space | Equal to the live-dot diameter (11 viewBox units) |
| Minimum mark size | 24 px |
| Wordmark | `iptv`, Bricolage Grotesque 700, lowercase, tracking −3% |
| App icon | `app_icon_512.png` — 512×512 on panel `#11161F` |
| Android TV banner | `tv_banner_320x180.png` — 320×180 on ink |

## Variants

| File | Use |
|---|---|
| `mark.svg` | Signal + Ember on transparent (TV / dark) |
| `mark_companion.svg` | Companion primary + live on transparent |
| `mark_monochrome.svg` | Ink mark on Signal plate |
| `lockup_*.svg` / `.png` | Mark + wordmark lockups |
| `adaptive/*` | Android adaptive FG / BG / monochrome masters |

## In-app

Prefer `BrandMark`, `BrandWordmark`, and `BrandLockup` in `lib/core/widgets`. Constants live in `BrandAssets`.

Re-export rasters (requires Pillow):

```bash
python tool/export_brand_assets.py
```
