---
metadata_version: 1
purpose: Record actual tool and dependency acquisition for the authentication foundation.
owner: unassigned
related_adrs: [ADR-0001]
---
# Dependencies and downloads — 2026-10-19

No paid subscriptions, hosted projects or global tools were activated. Existing Git,
Python, Node and Playwright/Chromium were reused. SDK bootstrap source was inspected
before execution; no arbitrary remote installation script was executed.

## Manual tooling acquisition

Flutter stable was cloned from the official
[Flutter repository](https://github.com/flutter/flutter) into the user's local tools
directory outside this repo. Version 3.47.7, revision
`abaf9c523780a608bd46686fd5e53740a07077f8`, engine `deb287481e3ce9468f3434937ced4240a70539ca`,
Dart 3.13.5. Stable branch and release tag resolve to this revision. BSD-3-Clause
license was read. The official archive manifest/example ZIP returned 404, so the
official Git bootstrap obtained the matching Dart, engine, font and web artifacts.
No binary-signature attestation is claimed. Flutter analytics were disabled.
SDK update: review a new stable release and revalidate; removal: delete only its
verified local SDK directory when no longer needed. No machine PATH was changed.

`flutter create --project-name macro_app --org app.macro --platforms android,ios,web,windows,macos,linux --no-pub .`
generated platform source/assets. Those templates and icons remain identifiable;
shipping identifiers, icons, signing and platform provisioning need owner setup.
Windows build bootstrap also obtained host engine artifacts and attempted NuGet;
build output, rather than this dependency list, establishes its success or failure.

## Packages

Versions were checked through official pub.dev metadata and SDK constraints before
resolution with `flutter pub get`. `pubspec.yaml` pins direct versions and
`pubspec.lock` records all transitive versions/archive SHA-256 checksums. The native
SQLite package hook supplies its matching binary; SQLite persistence tests exercise it.
No sensitive user data is sent to package registries.

| Package | Version | Purpose | License / primary source |
| --- | --- | --- | --- |
| flutter_riverpod | 3.4.3 | State and injection | MIT; [pub.dev](https://pub.dev/packages/flutter_riverpod) |
| go_router | 18.1.0 | Guarded entry routing | BSD-3-Clause; [pub.dev](https://pub.dev/packages/go_router) |
| supabase_flutter | 2.18.3 | Actual account/backend SDK | MIT; [pub.dev](https://pub.dev/packages/supabase_flutter) |
| drift / drift_flutter | 2.35.2 / 0.3.1 | SQLite preferences foundation | MIT; [Drift](https://drift.simonbinder.eu/) |
| flutter_secure_storage | 11.2.0 | Native secret storage | BSD-3-Clause; [pub.dev](https://pub.dev/packages/flutter_secure_storage) |
| local_auth | 3.0.2 | OS biometric integration | BSD-3-Clause; [pub.dev](https://pub.dev/packages/local_auth) |
| cryptography | 2.9.0 | Established PIN derivation | Apache-2.0; [pub.dev](https://pub.dev/packages/cryptography) |
| cupertino_icons | 1.0.8 | Flutter adaptive icon font | MIT; [pub.dev](https://pub.dev/packages/cupertino_icons) |
| flutter_lints | 6.0.0 | Static checks | BSD-3-Clause; [pub.dev](https://pub.dev/packages/flutter_lints) |

Flutter test/integration_test come from the pinned SDK. The concurrently added
governance tooling owns `yaml` and its own dependency decision; this app task preserves it.
Drift's transitive native compatibility packages include deprecated compatibility
shims; review the dependency graph during upgrades, not by installing duplicate SQLite.
Do not treat successful resolution as a complete license/vulnerability audit.

Playwright 1.64.0 (Apache-2.0) and installed Chromium were reused from a neighboring
local project's existing installation, solely for loopback browser verification.
The checked-in script takes a configurable module path and creates no Node manifest.
No browser package was newly downloaded for those screenshots.

The supplied ZIP and two Markdown files were copied locally into `docs/reference/`;
they were not downloaded by this task. Keep user-provided design artifacts private;
redistribution rights are not established. Preserve the four original ZIP entries.

Update/removal: edit only current-scope manifests, resolve/review lock changes, rerun
analysis/tests and supported builds. Never install future services just because the
[full stack reference](reference/FULL_STACK_REFERENCE.md) lists them.

## PIN/theme/QR additions — 2026-10-19

- qr_flutter **4.1.0**, BSD-3-Clause, and transitive qr **3.0.2** supply the local
  QR encoder. Existing widgets had no encoder; decorative QR approximations were
  rejected. [Official API](https://pub.dev/packages/qr_flutter). No network, camera
  permission or image download is needed to render the tag.
- shared_preferences **2.5.6**, BSD-3-Clause, was already transitive and is now direct
  for browser appearance only. Its newer async API avoids cached preference reads.
  [Official API](https://pub.dev/packages/shared_preferences). Native appearance
  reuses existing Drift; no SQLite browser WASM setup was added for one preference.
- Acquired through `flutter pub get`; pinned manifest and lockfile archive SHA-256
  values own package integrity. Pub cache remains outside the repo. Removal/update
  follows the existing manifest/lock/retest workflow; no global package installed.
- jsQR **1.4.0**, Apache-2.0, obtained with
  `npm pack jsqr@1.4.0 --pack-destination output/qr-validator --ignore-scripts`.
  [Upstream](https://github.com/cozmo/jsQR) documents pixel decoding. No installed
  QR decoder was available; this independent encoder check stays under ignored
  output, outside application dependencies. npm reported SHA-512 integrity; the
  browser work record retains verification and removal instructions. Existing
  pngjs/Playwright/Chrome installations are reused, with no browser download.
  No application data leaves loopback; only synthetic screenshots are decoded.
