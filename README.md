---
metadata_version: 1
purpose: Explain Macro App setup, entry states, verification and remaining prerequisites.
owner: unassigned
related_adrs: [ADR-0001, ADR-0007, ADR-0008, ADR-0032, ADR-0033, ADR-0034, ADR-0035, ADR-0036, ADR-0037, ADR-0045, ADR-0046]
---
# Macro App

Flutter/Dart foundation for iOS, Android, Web, Windows, macOS and Linux. This
milestone contains sign-in, sign-up, the local lock and a blank dashboard. The light
blue and charcoal/burgundy views reuse the [approved handoff](README_START_HERE.md).
Registration arrangement is provisional. No tracking dashboard has been invented.

## Run locally

Use Flutter **3.47.7 / Dart 3.13.5**. The local SDK installed for this task is
outside the repo; add its `bin` to the current shell PATH if needed. Nothing here
requires a paid development subscription. Then run from the repository root:

```powershell
flutter pub get --enforce-lockfile
flutter run -d chrome --web-port 8080
```

Without configuration, views render and validation works, but account requests
show an explicit setup message. There is no simulated successful login.
To inspect King James without a backend:

```powershell
flutter run -d chrome --dart-define=PREVIEW_STATE=locked
```

The isolated demo starts at login. Use **demo@gmail.com** / **demo123** to reach
**King James #QF4821**, then enter PIN **1234**. Wrong credentials remain logged out;
4821 cannot unlock the account. This is a synthetic fixture, not a Gmail or Supabase
account. Production sign-up password rules remain unchanged.

Reopening a signed-in demo returns to the PIN screen. Sign Out clears its device
flag and visible identity; refresh stays logged out, and the same credentials can
sign in again. Only a namespaced boolean is persisted, never the password or PIN.
Failed persistence shows retry feedback before reporting success. Settings retains
its Demo account label; real builds never consume the demo flag or credentials.
See [demo workflow](docs/changes/2026-10-19-demo-sign-in.md) and the
[current commit boundary](docs/adr/0046-application-commit-native-waiver.md), which
supersedes the earlier five-commit recommendation.

## Connect real accounts

1. Use an existing/free Supabase development project; no project is auto-created.
2. Apply the three migrations in `supabase/migrations/` in filename order using
   your normal Supabase migration workflow. For a disposable local stack, install
   the official Supabase CLI and Docker, then `supabase start`, `supabase db reset`,
   and `supabase test db`. These tools are not installed by this milestone.
3. Enable email confirmation and a 12-character minimum password in Auth settings.
   Configure rate limits and development email delivery. Production SMTP remains
   a separate setup task; do not assume test-email quotas suit launch.
4. Copy `config/public.example.json` to the ignored `config/public.local.json`.
   Set your HTTPS project URL, **public publishable key**, and allowlisted callback.
   Never put a service-role/secret key in this file or send one in chat.
   Local Supabase may use HTTP on loopback in debug builds only; release uses HTTPS.
5. Set `AUTH_REDIRECT_URL` and Supabase's allowed redirects to the exact web origin
   (for example `http://localhost:8080/`) or `macroapp://auth-callback` on native.
   PKCE email links must return to the same browser/device that started the flow.
6. Run `flutter run -d chrome --web-port 8080 --dart-define-from-file=config/public.local.json`.
   Use `-d windows` for host-native validation once the build toolchain is ready.

Sign-in uses **email/password**, not an unimplemented username lookup. Supabase
verification/recovery callbacks drive the router. Recovery replaces the credential
card with new-password confirmation, then signs out for a fresh login.

On supported native targets, session material and the separate four-digit passcode
verifier use platform secure storage. Five unsuccessful attempts cause a persisted
five-minute cooldown. App backgrounding locks the UI; sign-out clears local account
state and returns to login. Device biometrics are an alternative on capable systems.
Web/Linux use memory-only sessions and no pretend PIN lock; reopening requires login.
The PIN must differ from the four digits in the account tag. It is chosen with
confirmation after verified first sign-in. Legacy six-digit records require account
credentials before replacement. Windows Hello and Apple/Android security integration
still need device verification. **Forgot Passcode?** is intentionally inactive;
use Sign Out and authenticate again for current recovery.

## Appearance and sharing

Open the sidebar, then **Settings**. Light/Dark overrides persist on this device,
including across sign-out. New installs follow System; **Reset to System Default**
restores live OS following. Native preferences use Drift/SQLite; browser appearance
uses SharedPreferencesAsync, never for secrets. Storage failures show a retry message.

Tap the signed-in profile circle, including while locked, to share a QR with only
the public tag. Friendship scanning/backend actions are deferred. Backgrounding,
sign-out or identity change dismisses the QR.

## Verify

```powershell
dart tool/verify.dart
```

Read [the verification guide](docs/verification.md) for pins, hooks, diagnostics,
reports and the strict six-target gate. Unavailable targets remain blocked.
Individual checks recorded in the authentication work log do not replace this gate.
The integration journey uses synthetic adapters; it is not live Supabase evidence.
`scripts/verify-web.cjs` reuses an installed Playwright module via
`MACRO_PLAYWRIGHT_MODULE`; run against `build/web` served on loopback port 8080.
Screenshots and ephemeral browser evidence go in ignored `output/playwright/`.
See [foundation evidence](docs/changes/2026-10-19-auth-foundation.md) and
[PIN/theme/QR evidence](docs/changes/2026-10-19-pin-theme-qr.md) for actual results.

## Boundaries and next milestone

- [Architecture](ARCHITECTURE_AND_DATA.md), [security](docs/security-and-privacy.md),
  [platform matrix](docs/platform-support.md), [dependencies](docs/dependencies.md).
- Drift/SQLite has an exercised preference adapter. It is not an offline tracking
  cache or sync implementation; web WASM/worker assets are deliberately deferred.
- Profile initialization, immutable random tags and private avatar storage policies
  are supplied; profile editing, avatar selection/upload and deletion/export UI are deferred.
- CI defines Linux/Windows/macOS verification shards and strict aggregation. No remote
  workflow/deployment result is asserted here; inspect actual matching evidence.
- Connect Supabase, execute two-user RLS/storage tests, and test passcode/biometrics
  on real supported devices before broadening scope. Review account deletion,
  native signing, app icons and privacy disclosures before any release.
- Cloudflare Pages is the eventual static host; no publication or paid service is
  enabled. Keep initial production planning under $150/month and recheck live quotas.
