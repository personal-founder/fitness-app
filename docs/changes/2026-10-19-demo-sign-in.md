---
metadata_version: 1
purpose: Record the credential-based demo workflow and five proposed application commits.
owner: unassigned
related_adrs: [ADR-0044, ADR-0042, ADR-0043, ADR-0025, ADR-0027]
---
# Demo credential workflow — 2026-10-19

## Implemented behavior

First use starts at login. demo@gmail.com / demo123 (email normalized, password
exact) leads to King James #QF4821 on the existing PIN screen. PIN 1234 unlocks;
4821 does not. Duplicate submissions are serialized by the existing controller.
Backgrounding locks; a remembered demo session restores locked after reopening.
Sign Out persists false before clearing identity; refresh stays logged out and
credentials can sign in again. A read failure defaults to login with feedback;
a failed write reports retry feedback without publishing a successful transition.
Only a namespaced synthetic boolean is stored with existing SharedPreferencesAsync.
No password, PIN, token, email or real auth session is persisted by this change.
Demo creation returns an explicit unavailable message rather than creating accounts.
The normal Supabase adapter and production sign-up rules are unchanged.

## Reuse and scope

Reused the existing AuthGateway, Riverpod serialization, router guards, field/button
components, approved designs, DemoLock and SharedPreferencesAsync. Added an injected
DemoSessionStore and a non-sensitive bootstrap notice provider. No new package,
download, paid service, deployment, staging or project commit. Preserved unrelated
work. Runtime browser validation uses the Browser skill and the existing local app.

Previously researched official guidance remains applicable:
[Supabase sign-in](https://supabase.com/docs/reference/dart/auth-signinwithpassword),
[sign-out](https://supabase.com/docs/reference/dart/auth-signout),
[Flutter tests](https://docs.flutter.dev/testing/overview), and
[logical Git changesets](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project).

## Commit recommendation: five application changesets

These are logical review boundaries, not ready-to-create/staged commits. Existing
application files are largely untracked. Each checkpoint must be independently
buildable; partial entry-point wiring needs careful preparation only when Git work
is authorized. Supporting tests/docs/ADRs stay with the behavior they establish.

| # | Proposed subject | Responsibility |
| --- | --- | --- |
| 1 | build(app): establish Flutter application foundation | Platform runners, dependencies, configuration, minimal app shell, shared contracts |
| 2 | feat(auth-ui): add approved authentication screens | Light/dark sign-in/up views, navigation, accessibility, appearance controls, profile QR |
| 3 | feat(auth): integrate Supabase account lifecycle | Sign-in/up/out, verification/recovery, profile/tag/private-storage migrations |
| 4 | feat(app-lock): add protected four-digit PIN unlocking | Enrollment, tag exclusion, secure verifier, migration, throttle, device integrations |
| 5 | feat(auth-demo): complete King James credential workflow | Demo credentials, persistent synthetic session, PIN transition, repeated sign-out/in |

Separate unrelated verifier/governance changes from these five app changesets.
The strict staged gate remains required; native prerequisite/platform evidence and
stale snapshot blockers prevent committing. This recommendation grants no Git action.

## Final validation

Implementation and test/doc authoring were batched before routine checks. Planned
order: format/document structure, analysis, affected controller/widget tests, one
serialized demo web rebuild and actual browser journey. Reuse prior theme/QR proof;
do not repeat native builds blocked by unchanged missing ATL/device prerequisites.
Actual outcomes so far:

- Formatting: PASS, 133 Dart files unchanged after final formatting.
- Scoped Flutter analysis: PASS, no issues across lib/test/integration_test/tool.
- Seven focused demo controller/persistence/widget tests: PASS (13 seconds).
- Structural metadata/ADR/link/length checks: PASS; one untouched example remains
  an adoption gap. Inventory covers 376 rules, all still visibly unverified.
- Git whitespace inspection: PASS; existing LF/CRLF notices only.
- Demo release web build: PASS, 47.5 seconds, using the existing preview output.
- In-app Browser journey: PASS, incorrect password denied, correct credentials to
  King James PIN, 1234 to unlocked confirmation, signed-in refresh restored locked,
  sign-out to login, signed-out refresh remained logged out, and subsequent sign-in
  returned to PIN. Final browser error log empty. Evidence screenshot:
  `output/demo-login/king-james-lock.png`. No storage inspection or real email used.
- A preliminary refresh during browser validation showed login unexpectedly. A
  subsequent controlled credential sign-in and reload verified the locked restore;
  sign-out/refresh/re-sign-in then passed. No unverified root cause is asserted.

Commands: `flutter analyze lib test integration_test tool --no-pub`;
`flutter test --no-pub test/demo_session_test.dart test/demo_persistence_test.dart test/demo_flow_widget_test.dart`;
`flutter build web --release --no-pub --no-wasm-dry-run --dart-define=PREVIEW_STATE=locked --output=output/preview`.
The existing policy inspectors checked current metadata/ADRs/links/lines and source
inventory; `git diff --check` checked whitespace. No full native/six-platform rerun
was attempted against unchanged prerequisites.

An initial widget test helper hung because it awaited a fake-clock timer before
pumping. Fixed it to settle microtasks and explicitly restore; added the missing
form pump before tapping Continue. Reran only the seven affected demo tests.
A concurrent ADR allocation used 0041; this task moved only its own entry decision
to 0044 and preserved the unrelated record. No implementation behavior was changed
by that metadata correction. The full six-platform gate is not claimed.

## Change-to-decision coverage

| Changed responsibility | Governing decision | Why |
| --- | --- | --- |
| design_preview.dart, entry_status.dart | ADR-0044 | Explicit credentials, profile denial and honest login status |
| demo_session_store.dart, main.dart, auth_gateway.dart, session_restore.dart | ADR-0042, ADR-0044 | Flag bootstrap, durable transitions and read-failure feedback |
| demo_session_test.dart, demo_persistence_test.dart, demo_flow_widget_test.dart, support/demo_harness.dart | ADR-0044, ADR-0042, ADR-0025 | Controller, failure and actual routed-widget regression cases |
| scripts/verify-demo-web.cjs | ADR-0044, ADR-0042, ADR-0025 | Repeatable credential-first browser flow |
| README.md, architecture/security docs, this work record | ADR-0044, ADR-0042, ADR-0043 | Current data boundaries and proposed commit grouping |
| ADR-0034, ADR index, ADR-0044/0042/0043 | Corresponding successors; ADR-0003/0004/0005 | Preserve rationale and record focused decisions |
| Cohesive source size extensions, if needed | ADR-0027, ADR-0008 reused | Existing <=150-line convention, not relaxed thresholds |

## Limits and next action

Public fixture credentials are not production authentication. No Supabase project,
real email delivery, native biometrics or other-platform builds are validated here.
Sign Up layout remains provisional. Fix Visual C++ ATL and provide supported runner
credentials/hardware before native/production claims or authorized commit creation.
