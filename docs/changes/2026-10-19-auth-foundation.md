---
metadata_version: 1
purpose: Record implementation evidence and unresolved authentication milestone limits.
owner: unassigned
related_adrs: [ADR-0024, ADR-0025, ADR-0027]
---
# Macro App authentication foundation — 2026-10-19

## Scope and authority

The user's latest request limits implementation to login, registration, and the
signed-in local lock, with a minimal unlocked completion state. No dashboard,
tracking UI, profile editor, publication, payment, or Git commit is authorized.
The separate app passcode may have a device-biometric alternative (user reply).
The attached implementation prompt is reference material; it does not expand this scope.

## Inspection and plan

- Initial checkout has policy documents and three mockups, no application.
- Existing staged commit-policy files belong to the user and must be preserved.
- The supplied ZIP contains four files: original UX handoff, tokens, two PNGs.
- Preserved those files and the two supplied Markdown references in `docs/reference/`.
- `README_START_HERE.md`, `ARCHITECTURE_AND_DATA.md`, and operations documentation
  are absent from the supplied package. Local replacements will identify themselves.
- No Flutter/Dart SDK was found in PATH or the inspected local SDK/cache locations.
- Read root policy, detailed standards, full supplied prompt, stack and UX handoff;
  inspected both approved raster images. Existing `app_mockups/` remain untouched.
- This is direct application implementation, not a developer planning batch;
  the planning materializer workflow is not applied to background attachments.

Implementation sequence: obtain official free tooling; generate six Flutter targets;
build shared light/dark components and state routing; connect Supabase auth and native
lock adapters; add narrow profile/RLS schema and tests; run available checks and
compare rendered views. Keep unavailable service/native checks explicitly blocked.

## Tooling decision before acquisition

Flutter stable from `https://github.com/flutter/flutter.git` (BSD-3-Clause) will be
installed into a user-local tools directory outside the repo. Official archive
manifest and example ZIP requests returned HTTP 404; use the official stable Git
source, then its reviewed bootstrap to obtain matching Dart/engine artifacts.
Git already exists. No global PATH changes, paid services, or privileged installs.
Purpose: actual Flutter analysis, widget tests, and web compilation; Node/React
cannot satisfy the required stack. Record the resolved revision/version below.

Dependency choices will be limited to Riverpod, GoRouter, Supabase, Drift/SQLite,
protected storage, local_auth and established password derivation. Package manifests
and lockfiles own transitive versions and integrity. No future tracker plugins now.

## Verification and review

Implemented Flutter runners, Riverpod session orchestration, GoRouter guards,
approved shared light/dark entry components and vector artwork. Login, provisional
registration, verification messaging, recovery/password update, sign-out, native
passcode enrollment/verification, and device authentication have real adapters.
King James exists only in a labeled compile-time preview and synthetic tests.
No dashboard/profile editor/tracking module was added.

Supabase migrations create owner-scoped profiles, immutable CSPRNG tags, private
avatar bucket policies and two-user pgTAP tests. They have not been applied to a
database. Drift's preference adapter has real SQLite tests; runtime/offline tracker
integration and web WASM cache remain explicitly deferred.

Reused the supplied designs/tokens and Flutter's maintained platform templates.
Kept one reusable form/layout instead of parallel light/dark screens. Installed only
current-scope packages. See [dependency record](../dependencies.md) for exact versions,
SDK provenance and free tooling. No paid resource, publication, stage or commit
operation was performed by this task.

### Commands and limits

| Command/check | Actual result |
| --- | --- |
| `flutter --version` | Flutter 3.47.7 / Dart 3.13.5, pinned official revision |
| `flutter pub get` | PASS, exact current-scope direct versions resolved |
| `flutter analyze` | Initial pass; later runs caught and fixed app lint; concurrent tooling lint tracked separately |
| `flutter test` | Application tests exercise state/denials/races, KDF, SQLite, SDK HTTP and widgets; final count below |
| `flutter build web --release` | PASS; final rebuild below |
| `node scripts/verify-web.cjs` | PASS light/dark login, theme retention, registration/back and drawer; no page errors |
| `flutter build windows` | FAIL: secure-storage C++ compilation cannot find `atlstr.h` |
| `flutter test integration_test/entry_flow_test.dart -d windows` | BLOCKED by the same ATL compilation failure |
| `flutter doctor -v` | Visual Studio 18.5/Windows SDK present; Android SDK absent; SDK deliberately not added to machine PATH |
| Supabase/PostgreSQL/pgTAP | NOT RUN: no credentials, Docker, psql or Supabase CLI |
| iOS/macOS/Linux builds, real biometrics | NOT RUN: corresponding host/device prerequisites unavailable |

Windows next step: add the matching MSVC C++ ATL component using the existing
Visual Studio Installer, then rerun the build and native integration journey.
No system installer/elevation was launched. The secure-storage implementation was
not replaced or weakened to make the build pass.

Initial widget failures exposed registration ink hidden by a decorated surface and
drawer overflow at 200% text; both were fixed and regression checks passed. A test
lifecycle sequence was corrected to follow actual inactive/hidden/paused transitions.
Real SDK integration initially lacked PKCE storage in its fixture; the fixture now
exercises the protected PKCE adapter. No production assertion/check was suppressed.
Browser typing uses actual keyboard events rather than only changing DOM input values.

### Policy coordination and decision coverage

During application implementation, another task updated engineering policy and added
verification tooling. Those files, manifests, test dependencies and unrelated Git
changes were preserved. The new atomic/metadata policies were read and applied to
application artifacts. Concurrent ADR allocations collided at 0010–0012; this task's
three records and references were moved to unused IDs 0028–0030. ADR-0001 remains
historical; focused current records are indexed without rewriting its rationale.

| Changed paths/responsibility | Governing decisions | Application |
| --- | --- | --- |
| Generated runners, bootstrap, platform records | ADR-0028 | Six Flutter targets; generated-source provenance |
| Riverpod controller, actions, restoration, state | ADR-0029 | Serialized state and stale-unlock handling |
| Router | ADR-0030 | Session-derived guarded entry routes |
| Themes, waves, identity/avatar, shared widgets | ADR-0013 | Approved reference composition; registration remains provisional |
| Gateway, credential draft/forms, Supabase config | ADR-0014 | Genuine email account lifecycle |
| Profile model and first migration | ADR-0015 | Owner isolation and safe field grants |
| Profile initialization migration | ADR-0016 | Independent random immutable tags |
| Private avatars migration/tests | ADR-0017 | Owner-folder object access |
| PIN record/KDF/enrollment/lock view | ADR-0018 | Protected verifier and persistent retry policy |
| Biometric method and native runner setup | ADR-0019 | Device-mediated alternative |
| Native session/PKCE/vault | ADR-0020 | Protected local secrets |
| Unsupported session adapter behavior | ADR-0021 | Explicit memory-only fallback |
| Drift preference adapter/tests | ADR-0022 | Non-sensitive persistence foundation |
| Design fixture/config | ADR-0023 | Non-authenticating King James preview |
| README/start index/architecture/work records | ADR-0024 | Auth-only scope and supplied-artifact gaps |
| Tests, browser script, CI | ADR-0025 | Repeatable checks, honest platform limits |
| Dependency manifest/lock/download record | ADR-0026 | Scoped pinned acquisitions; preserve concurrent YAML dependency |
| Cohesive source extensions | ADR-0027 | Physical counts and reasons below |
| Metadata headers/sidecars and metadata script | ADR-0005 reused | Format-safe provenance; no recursive ADRs |
| Shared metadata reader and SQL regression | ADR-0007 reused, ADR-0015 | Accept valid SQL `--` headers required by native migration files |

Every generated runner file is covered by an adjacent sidecar. Imported original
references have sidecars and remain byte-identical to the supplied originals.
Existing untouched `app_mockups/` and other task's files remain their adoption scope.

### Remaining risks and next milestone

This is locally reviewable source, not production/cross-platform certification.
Live email callbacks, RLS/storage denial, native protected persistence, biometrics,
app-switcher snapshots and device accessibility still need verification. The six-digit
length and five-minute cooldown are reversible implementation choices. Browser/Linux
cannot retain a device-locked session in this milestone and require login on reopen.
No offline tracking, profile editor, photo upload, deletion/export, release signing,
privacy/legal assurance or hosted CI/deployment is claimed.

### Cohesive source-size exceptions

Physical counts after Dart formatting and metadata insertion; each is within the
allowed 150-line extension. ADR-0027 records the convention and revisit boundary.

| File | Lines | Why kept together |
| --- | --- | --- |
| `lib/core/security/app_lock.dart` | 106 | One native lock adapter with atomic retry reservation and verification |
| `lib/features/auth/credential_form.dart` | 134 | One form lifecycle, validation and dispatch composition |
| `lib/features/auth/lock_card.dart` | 118 | Shared enrollment/unlock input disposal and device-auth action |
| `lib/features/auth/session_controller.dart` | 140 | One serialized state owner with cancellation/lifecycle invariants |
| `lib/features/welcome/account_identity.dart` | 92 | Tag reveal/masking lifecycle and its accessible rendering |
| `lib/features/welcome/background_layer.dart` | 91 | One coordinated vector composition and repaint contract |
| `lib/features/welcome/profile_avatar.dart` | 78 | Fallback silhouette painter and its circular framing |
| `lib/features/welcome/welcome_page.dart` | 147 | One responsive approved entry composition and lifecycle observer |
| `test/entry_widget_test.dart` | 133 | Shared widget harness and related entry/viewport regressions |
| `test/session_test.dart` | 115 | Shared session fixture and linked state-transition regressions |
| `test/supabase_adapter_test.dart` | 109 | One loopback HTTP server fixture and actual SDK request journey |
| `test/support/fakes.dart` | 108 | Cohesive synthetic auth/lock/vault adapter fixtures |

The larger state restoration and recovery tests were split at responsibility
boundaries before closeout. No source was compressed to evade limits.
Flutter-generated platform templates, lockfiles, Xcode project XML and imported
reference originals preserve their generator/external format; hand-splitting would
break regeneration, tooling or source fidelity. Sidecars identify their source.
Revisit generated templates through their generator or a justified platform change.
The imported UX handoff's larger document remains intact as required design evidence.

Generated/external exceptions with measured counts: UX handoff 555; iOS Xcode
project 651, scheme 119, icon manifest 122, Info.plist 77; Linux CMake 128, Flutter
CMake 88, generated application 148; macOS Xcode project 729, scheme 117, MainMenu
XIB 343; pubspec lockfile 1030; Windows CMake 108, Flutter CMake 109, Runner.rc 121,
win32_window.cpp 288, win32_window.h 102. Exact paths and rationale are registered
in `config/policy/exceptions.json` under ADR-0027. No broad exclusion was added.

The concurrently authored shared CI workflow supersedes the earlier direct-check
workflow in the same file. Its canonical verifier is reused; duplicate metadata
introduced by concurrent writes was reconciled. No second workflow was retained.

Next: configure a free/local Supabase environment and run the supplied two-user
database/storage tests, then resolve Windows ATL and test native locking. Keep tracker
screens deferred until their designs are approved.

## Final validation and definition of done

- PASS: 29 application/domain/widget/security/SDK tests in one targeted run; the
  additional real-file SQLite close/reopen test passed separately (30 app tests total).
- PASS: `flutter analyze --no-pub` after final source/lint corrections, no issues.
- PASS: release `build/web` compilation after configuration validation was added;
  the labeled preview also compiled. WASM dry-run success is not WASM runtime proof.
- PASS: light/dark browser entry checks and screenshots, no page errors; native
  device authentication remains outside that browser evidence.
- PASS: four original ZIP entries hash-identical; 314 application/generated metadata
  associations checked before final small additions, no problems. Apple property
  lists/entitlements (five) and Android manifest parse successfully.
- PASS: app-source formatting and Git whitespace review; no source exceeds its
  documented application size exception. No server key or real account fixture added.
- FAIL/BLOCKED: full shared project verifier is not green. Its recorded run had
  in-progress tooling/test/format failures, incomplete requirement records, a snapshot
  changed by concurrent work, an integration device-selection error and the Windows
  ATL failure. Auth application tests and web build passed within that run.
  Later scoped policy inspection cleared application metadata/size findings; remaining
  concurrent policy/tooling work is not claimed complete by this application task.
- Current broad format inspection still reports changes in 14 concurrently authored
  `tool/` files; application formatting is separate and passes. Do not use an earlier
  successful root analysis or test run as a claim that the entire shared gate passed.
- The mandatory-rule register was refreshed explicitly; 335 source statements were
  recorded with unknown evidence retained as unverified. Concurrent policy updates
  can stale that snapshot; this is not a compliance claim.
- Native Windows build/integration require MSVC ATL (`atlstr.h`). Android SDK,
  Apple/Linux hosts, live Supabase configuration and physical biometric devices
  remain unavailable. No integration success is inferred from synthetic adapters.

Supplied-artifact gaps were documented, the full stack was added to AGENTS.md,
focused decisions/metadata and this work record were updated, and unrelated work
was preserved. No staged-tree/commit/release readiness is claimed. The auth source
milestone is reviewable; service/device integration and the shared governance gate
remain the next required checks before release or commit.
