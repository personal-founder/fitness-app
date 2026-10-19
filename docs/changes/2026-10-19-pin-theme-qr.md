---
metadata_version: 1
purpose: Record the implemented PIN appearance and public QR milestone with scoped evidence.
owner: unassigned
related_adrs: [ADR-0032, ADR-0033, ADR-0034, ADR-0035, ADR-0036, ADR-0037, ADR-0038, ADR-0025, ADR-0027]
---
# PIN, appearance and profile QR — 2026-10-19

## Outcome and authority

The user approved the complete implementation plan. Device-local PIN setup happens
following verified first sign-in; QR sharing is allowed while locked; manual theme
choices persist across reopening until reset. No dashboards, commits, deployment,
paid services or real friend operations were authorized or performed.

- King James #QF4821 unlocks with 1234 only in the compile-time demo. Wrong PINs
  stay locked, background/reload relocks, sign-out removes the visible identity.
  Demo adapters make no backend calls and never simulate successful biometrics.
- Real PINs contain exactly four numeric characters, retaining leading zeros.
  Enrollment requires a loaded valid account tag and confirmation. Its last four
  digits cannot equal the PIN; #QF4821 rejects 4821 and permits 1234.
- Native salt, PBKDF2-HMAC-SHA256/600,000 iterations, OS-vault verifier, account
  isolation and persisted five-failure/five-minute throttle are retained.
  Version-one records fail closed and require account credentials before version-two
  replacement. Unknown/corrupt versions do not unlock. No PIN enters Supabase.
- The sidebar Settings switch chooses Light/Dark; new installs follow System.
  Reset resumes live OS following. Native appearance reuses Drift/SQLite; browser
  appearance uses SharedPreferencesAsync. Errors remain usable and expose retry.
- The loaded signed-in avatar opens a QR with display identity and public tag only.
  The versioned payload is `macroapp://friend?v=1&tag=%23QF4821` for the demo.
  Background, sign-out or account/profile changes dismiss the modal. No camera
  permission, scanner, friendship write, private UUID, email or credential is added.
- Labels are Enter Passcode, Use Device Biometrics, Forgot Passcode?, and the dynamic
  Signed in as selected display name. Forgot Passcode is deliberately inactive under
  the user's explicit instruction; actual PIN recovery remains unfinished.
- Narrow 320px/200% signed-in testing exposed a 17px header overflow. Flexible button
  sizing now allows Sign Out to wrap while preserving the menu gap and text scaling.

## Reuse, research and complexity

Reused approved entry composition, palettes, silhouette, field/button components,
Riverpod, GoRouter, auth adapters, protected storage and SQLite schema. The only new
application packages are qr_flutter (with qr transitively) and a direct declaration
of already-transitive shared_preferences. No schema migration or new service needed.
Kept local-lock behavior in a focused controller part, sharing in a lifecycle widget,
and entry status in its own presentation widget to stay within source limits.

Official APIs researched during planning: [qr_flutter](https://pub.dev/packages/qr_flutter)
and [shared_preferences](https://pub.dev/packages/shared_preferences). Independent
pixel validation uses [jsQR](https://github.com/cozmo/jsQR), Apache-2.0, from npm.
Acquisition and removal are recorded in [dependencies](../dependencies.md).
The tarball SHA-512 matched the npm integrity output:
`sha512-dxLob7q65Xg2DvstYkRpkYtmKm2sPJ9oFhrhmudT1dZvNFFTlroai3AWSpLey/w5vMcLBXRgOJsbXpdN9HzU/A==`.
It remains in ignored `output/qr-validator/`; remove that exact directory when no
longer needed. Existing Playwright 1.64.0/Chromium and pngjs installations were reused.
An initial bundled Playwright/browser-version mismatch and Chrome-channel timeouts
were resolved by using the already-installed matching Chromium, without downloads.

## Verification evidence

| Command / scenario | Actual result |
| --- | --- |
| `dart format --output=none --set-exit-if-changed lib test integration_test tool` | PASS, 129 files unchanged |
| `flutter analyze lib test integration_test tool --no-pub` | PASS, no issues |
| `flutter test --no-pub --reporter expanded` | PASS, 84 tests before the added header regression; log in ignored output |
| `flutter test test/entry_accessibility_test.dart --no-pub` | PASS, additional signed-in 320px/200% regression |
| `flutter build web --release --no-pub` | PASS, normal build including WASM dry run |
| `flutter build web --release --no-pub --dart-define=PREVIEW_STATE=locked --output=output/preview` | PASS, demo build including WASM dry run |
| Final normal/demo rebuilds with `--no-wasm-dry-run` | PASS, 91.8s / 83.3s after the header correction |
| `node scripts/verify-web.cjs` | PASS, light/dark login, form retention, registration/back and drawer; no page errors |
| `node scripts/verify-demo-web.cjs` | PASS, all four 390px/1440px light/dark journeys: PIN denial/unlock/relock/sign-out, theme persistence/reset, independently decoded QR, no page errors |
| `dart tool/refresh_requirements.dart` | Updated the requirement register after AGENTS changes; records remain unverified where evidence is absent |
| Shared `dart tool/verify.dart` | FAIL, gate exit 1: snapshot changed during concurrent policy-document work. Its 48 application tests, 38 tooling tests, static/policy checks and web release build passed; native integration/build blocked by missing ATL, foreign targets lack runner evidence. Report: `output/verification/pin-theme-qr.json` |
| Structural metadata/ADR/links/lines/requirement inspection | PASS; one untouched example lacks metadata. Requirement records remain visibly unverified; inventory validation does not establish compliance |
| `git diff --check` | PASS; only existing CRLF notices, no whitespace errors |

Focused tests cover invalid PINs, leading zeros, tag exclusion, confirmation,
missing profiles/retry, legacy reauthentication/replacement, account isolation,
real KDF/throttle, demo denial/unlock/relock/sign-out, SQLite preference writes,
System/manual/reset behavior, write failures/retry, retained credentials/PIN,
public QR payload and dismissal boundaries, selected full name, exact copy/no-op,
and narrow layouts with large text. Synthetic gateways do not prove live RLS.

Browser automation uses the existing Playwright workflow (skill), actual DOM
semantics and local Chromium. No fixed sleep is needed. Screenshots reside in
ignored `output/playwright/`; jsQR reads their real RGBA pixels independently.
Set MACRO_PLAYWRIGHT_MODULE, MACRO_PNG_MODULE and MACRO_QR_MODULE to existing local
modules; serve normal build on loopback 8080 and demo output on 8081. The optional
MACRO_BROWSER_CHANNEL chooses an installed browser; default uses matching Chromium.

The final full verifier detected concurrent changes at 11:14–11:15 to AGENTS,
core principles, verification guidance, ADRs 0039/0040, their work record and the
requirement inventory. Its application source remained unchanged; its complete
snapshot receipt is stale and cannot authorize a commit/release. These unrelated
changes were preserved and the new instructions reread. Final document-only checks
apply to the current documents; unchanged application suites/builds were not repeated
merely to retry the same missing native prerequisites. The final review also added
a regression proving fresh legacy authentication survives a profile-load retry.

## Limits, risks and next milestone

- Web/Linux real sessions remain memory-only with no simulated secure PIN gate.
  The browser demo is UI evidence, not native security evidence.
- Four-digit PINs have low entropy; software throttling and OS-vault storage are
  retained controls, not hardware-enforced offline-attack resistance.
- No credentials/test Supabase project are available: live verification/email,
  RLS/storage isolation, recovery and remote session behavior are not tested here.
- Native secure store, biometrics/Face ID/fingerprint/Windows Hello and app-switcher
  behavior require real platform testing. Both current Windows integration and
  release builds stop at flutter_secure_storage_windows because Visual C++ ATL's
  `atlstr.h` is missing. This is BLOCKED, not a passing native result.
- Android/iOS/macOS/Linux build/device results cannot be inferred from Windows/web.
- QR receiving/friendship actions, PIN recovery UI, profile editor, account deletion,
  signing and release disclosures remain future work. Next milestone: provision a
  free Supabase test environment and validate native account/PIN/biometric journeys.
- Root analysis initially reported unrelated ignored diagnostic scripts under output;
  scoped analysis and isolated verifier source exclude those temporary artifacts.
  No unrelated tool source was changed to hide findings.

## Change-to-decision coverage

| Changed path / responsibility | ADRs | Application |
| --- | --- | --- |
| `lib/core/security/pin_policy.dart`, `app_lock.dart`, `pin_record.dart` | 0032, 0033; 0019 retained | Four-digit boundary, v2 secure records and legacy denial |
| `lib/features/auth/session_controller.dart`, `session_actions.dart`, `session_restore.dart`, `session_lock.dart`, `session_state.dart` | 0032, 0033, 0034; 0029 retained | Serialized enrollment and credential-bound legacy replacement |
| `lib/features/auth/design_preview.dart`, `demo_lock.dart`, `lib/main.dart` | 0034, 0035 | Explicit adapters and appearance bootstrap |
| `lib/features/auth/entry_field.dart`, `lock_card.dart` | 0032, 0034, 0037 | Length, confirmation, errors and requested labels |
| `lib/app/app.dart`, `lib/app/theme/theme_controller.dart`, `theme_store.dart` | 0035; 0022 retained | Device preference and failure handling |
| `lib/features/welcome/appearance_settings.dart`, `entry_drawer.dart` | 0035 | Existing sidebar appearance controls |
| `lib/features/profile/friend_code.dart`, `profile_qr_dialog.dart`, `lib/features/welcome/profile_share.dart` | 0036 | Public URI, real QR and lifecycle |
| `lib/features/welcome/welcome_page.dart`, `entry_status.dart` | 0036, 0037; 0013 retained | Existing composition and active identity |
| `lib/features/welcome/entry_header.dart` | 0038 | Large-text overflow correction |
| `test/pin_policy_test.dart`, `pin_security_test.dart`, `pin_entry_widget_test.dart`, `legacy_pin_test.dart`, `session_test.dart` | 0032, 0033, 0025 | Validation, denial and migration regression coverage |
| `test/demo_session_test.dart`, `theme_preference_test.dart`, `appearance_widget_test.dart`, `profile_qr_test.dart`, `entry_accessibility_test.dart` | 0034–0038, 0025 | New observable behavior checks |
| `test/support/fakes.dart`, `memory_theme_store.dart`, `render_entry.dart`, `test/entry_widget_test.dart`, `integration_test/entry_flow_test.dart` | 0032, 0033, 0035, 0025 | Existing harnesses and contract updates |
| `scripts/verify-web.cjs`, `verify-demo-web.cjs` | 0025, 0034–0036 | Repeatable browser and pixel evidence |
| `pubspec.yaml`, `pubspec.lock`, lock sidecar, `docs/dependencies.md` | 0026, 0035, 0036 | Pinned packages and actual acquisition |
| `AGENTS.md`, `README.md`, `ARCHITECTURE_AND_DATA.md`, `docs/security-and-privacy.md`, this work record | 0032–0037, 0025 | Current scope, setup and honest limitations |
| ADR-0018/0023, ADR index, ADR-0032 through ADR-0038 | Corresponding successor; 0003/0004/0005 retained | Preserve superseded rationale and focused decisions |
| `config/policy/exceptions.json`, `exceptions/application-03.json`, `application-05.json` and sidecar | 0027, 0008 | Cohesive <=150-line units; generated lockfile count |
| `config/policy/requirements/*.jsonl` | 0006, 0008 | Explicit regenerated source inventory, no invented verification |

Extensions retain lifecycle/security responsibilities and their tests together.
Final physical counts and structural/link checks are recorded by the verifier.
Imported originals and unrelated concurrent tooling/governance changes were preserved.
