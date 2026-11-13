# TV-012 — Image pipeline with memory limits

**Refs:** NFR-003 · SRS §21 · Depends on **TV-002** · OEM budgets via **TV-011**  
**Skeletons:** DSN-016 ([ContentCardSkeleton](../../lib/core/widgets/content_card_skeleton.dart))

## Goal

Configure catalog / logo image loading so Android TV stays within a bounded
decoded-image budget: thumbnail decode, LRU memory ceilings, off-screen release,
and skeleton placeholders while bits arrive.

## Layout

| Piece | Location |
|---|---|
| Config | [`ImagePipelineConfig`](../../lib/core/images/image_pipeline_config.dart) |
| Thumbnail math | [`ImageThumbnailSizes`](../../lib/core/images/image_thumbnail_sizes.dart) |
| Cache port | [`ImageCacheController`](../../lib/core/images/image_cache_controller.dart) |
| Pipeline | [`ImagePipeline`](../../lib/core/images/image_pipeline.dart) |
| HTTPS sanitize | [`ArtworkUri`](../../lib/core/images/artwork_uri.dart) |
| Widget | [`ManagedNetworkImage`](../../lib/core/widgets/managed_network_image.dart) |
| Card hook | [`ContentCard.imageUrl`](../../lib/core/widgets/content_card.dart) |
| Route reclaim | [`ImagePipelineRouteObserver`](../../lib/core/images/image_pipeline_route_observer.dart) on [`MiIptvApp`](../../lib/app/app.dart) |
| DI | [`AppDependencies.imagePipeline`](../../lib/app/di/app_dependencies.dart) |

## Budgets

| Profile | Max images | Max bytes | When |
|---|---|---|---|
| `tvDefault` | 100 | 48 MiB | Mid / high OEM |
| `tvLowMemory` | 40 | 24 MiB | OEM `prefer1080pCeiling` |
| `companionDefault` | 80 | 32 MiB | Companion |

Decode size = logical [ContentCardMetrics] × capped device pixel ratio (not full poster resolution).

## Off-screen release

1. List / card dispose drops live image handles naturally.
2. `ImagePipeline.releaseOffscreenImages()` → `ImageCache.clearLiveImages()`.
3. Navigator pop/remove triggers the route observer for aggressive reclaim.

## Packages

**No new pubspec dependency.** Uses Flutter `ImageCache` + `ResizeImage` + `NetworkImage`.

**Proposed later (not installed):** `cached_network_image` / `flutter_cache_manager` for disk cache — wait for explicit approval.

## Security

Artwork URLs must be **HTTPS**; `ArtworkUri` strips userInfo and rejects other schemes.
