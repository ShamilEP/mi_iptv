# Network security config & cleartext policy (SEC-023)

**Refs:** Security §3.1 · Depends on **TV-051** (stream playback)  
**Android NSC:** [`android/app/src/main/res/xml/network_security_config.xml`](../../android/app/src/main/res/xml/network_security_config.xml)  
**Manifest:** `android:networkSecurityConfig` + `usesCleartextTraffic` on `<application>`  
**Dart policy:** [`TransportSecurityPolicy`](../../lib/core/network/transport_security_policy.dart)  
**Tests:** [`test/core/network/transport_security_policy_test.dart`](../../test/core/network/transport_security_policy_test.dart), [`test/docs/sec_023_network_security_doc_test.dart`](../../test/docs/sec_023_network_security_doc_test.dart)

## Goal

Keep **Mi IPTV backend** traffic on **HTTPS only**, while allowing **user-supplied IPTV media** to use plain `http` when providers require it — and **warn** the user that HTTPS streams are preferred.

## Policy matrix

| Traffic | Cleartext HTTP | HTTPS | Enforcement |
|---|---|---|---|
| Backend API (`ApiClient` / auth / catalog / sync) | **Denied** | Required | `TransportSecurityPolicy.isBackendUriAllowed` |
| Artwork / posters | **Denied** | Required | Existing `ArtworkUri` (TV-012) |
| User IPTV / catalog media streams | Allowed | Preferred | `isMediaStreamUriAllowed` + `requiresCleartextMediaWarning` |
| Platform (Android 9+) | Permitted via NSC | System CAs | `network_security_config.xml` |

Android cannot scope cleartext to “Media3 only” when stream hosts are arbitrary user domains/IPs. NSC therefore permits cleartext at the process layer; **app code** refuses cleartext for backend and surfaces [cleartextMediaWarning](../../lib/core/network/transport_security_policy.dart) for `http` media.

## iOS / Companion

Companion MVP has **no video playback**. Default ATS (HTTPS) remains; no `NSAllowsArbitraryLoads`. If a future iOS player needs cleartext media, prefer `NSAllowsArbitraryLoadsInMedia` only — do not enable global arbitrary loads.

## Security checklist

Maps to **SEC-C05** (backend TLS) and **SEC-C08** (URL validation at the boundary). See [client_security_checklist.md](./client_security_checklist.md).

## Out of scope

- Pinning / custom trust stores (not in MVP)
- Inventing production API hostnames (Infra / Product)
- Logging stream URLs that embed credentials (harness ban)
