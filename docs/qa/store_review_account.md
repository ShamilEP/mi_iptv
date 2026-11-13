# Store review / demo account (CMP-010)

**Scope:** Companion App Store & Play Console reviewers.  
**Security:** Never commit real passwords, JWTs, or staging secrets to git.

## Template (fill privately)

| Field | Value |
|---|---|
| Staging API base (HTTPS) | `https://<staging-host>/` — Infra / Backend |
| Reviewer email | `<provisioned by Backend>` |
| Reviewer password | `<provisioned by Backend; rotate after review>` |
| Account owner | |
| Expires (UTC) | |
| Linked demo TV | Optional — name only, no pairing secret in this doc |

## Reviewer path (non-secret)

Copy from [`CompanionStoreReadiness.reviewerNotes`](../../lib/core/store/companion_store_readiness.dart):

1. Install Companion (Android `companionProd` or iOS companion target).  
2. Sign in with the staging review account.  
3. Explore → open a title → **Play on TV** (no phone video player).  
4. Optional: Remote, Language, airplane-mode cached Explore.

UI placeholder email remains `you@example.com` (design hint only) — reviewers must use the provisioned account above.

## Rotation

After each store review window: rotate password, revoke refresh tokens, update the private ops channel. Do **not** paste credentials into PR descriptions or Excel notes.
