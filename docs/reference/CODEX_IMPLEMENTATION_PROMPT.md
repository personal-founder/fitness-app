# CODEX TASK — Build Macro App's cross-platform foundation and approved authentication UI

You are the principal Flutter engineer and software architect implementing the first production-quality foundation of **Macro App**, a fitness/personal-progress tracking product. Do the work inside the current workspace. This is a request to **write runnable application code**, database migrations, tests, configuration examples and documentation — not to produce just a plan or screenshots.

## 0. REQUIRED READS / SOURCE OF TRUTH

Before modifying files, inspect the repository and read, in full:
1. `AGENTS.md` — always-on engineering constraints.
2. `Macro_App_Auth_UI_UX_Codex_Handoff.md` — the approved UX and auth semantics.
3. `Macro_App_Theme_Tokens.json` — color/geometry starting values.
4. `Macro_App_Light_Approved.png` and `Macro_App_Dark_Approved.png` — approved light/dark visual references.
5. `ARCHITECTURE_AND_DATA.md`, `FULL_STACK_REFERENCE.md`, `OPERATIONS_BUDGET_AND_RELEASE.md` — technical architecture, sources, cost/security.

The screenshot renders are **visual references only**; do not place them in the app as backgrounds. They depict smartphone hardware/status bar that must not be in the real app. The screenshots' temporary `Sign Out`+email/password inconsistency is overridden by the specified actual auth state rules. The concept images approve only welcome/login appearance, **not the dashboards or detailed feature screens**.

## 1. BUSINESS AND DELIVERY TARGET

- One shared Flutter/Dart application for **iOS, Android, web, Windows, macOS and Linux**. On unsupported host OS, scaffold all target folders and validate the build targets possible here; document limitations for the others.
- $0 mandatory software/hosting subscriptions while developing and production infrastructure targeted under **US $150 per month** at small launch scale. Use the Supabase free plan during development (or local Supabase if Docker is available). No paid service should be enabled without an explicit choice, cost note and billing safeguards.
- Primary objective of this assignment: **working account lifecycle + pixel-conscious approved light/dark welcome page + secure Supabase foundation + clean app module architecture**. Prepare data/domain scaffolding for nutrition, weight, exercise planning, body composition and an eventual optional medication log; don't pretend the unapproved module UI layouts are finalized.

## 2. LOCKED TECH STACK

- Flutter stable + Dart, adaptive responsive widgets; theme system based on Flutter `ThemeData`/`ThemeExtension`; vector backgrounds via `CustomPainter`/paths and tasteful gradients/opacity.
- `flutter_riverpod` for app state, dependency injection and asynchronous state; `go_router` for declarative typed/guarded routing and browser deep links.
- `supabase_flutter`: Supabase Auth, Postgres, private Supabase Storage, RLS; server-side functions in TypeScript/Deno using Supabase Edge Functions. Store SQL migrations/tests under `supabase/`.
- `drift` + `drift_flutter` (SQLite) for local user-scoped caching (and eventual offline write queue). For web, configure the required SQLite WASM/worker assets and test in a real browser, or defer the web local cache behind an explicit adapter while preserving a functional web build.
- `fl_chart` and `table_calendar` for future feature implementation, not necessarily dependencies in phase 1. Similar for `mobile_scanner` (Android/iOS/macOS/web; do NOT assume Windows/Linux support), `health` (Android/iOS only), `flutter_local_notifications` and `firebase_messaging` (later). For local security choose `flutter_secure_storage` and `local_auth` only where proven supported; keep platform adaptors and do not promise universal biometric/PIN features.
- Web distribution by **Cloudflare Pages** of `flutter build web` output; GitHub/GitHub Actions CI. Optional Resend for transactional email via Supabase custom SMTP; Sentry after PII scrubbing; RevenueCat/Stripe, Cloudflare R2 and other services only when required.
- Packages must be researched/locked to mutually compatible **currently stable versions** before adding. Avoid overinstalling future-only packages.

## 3. REQUIRED REPOSITORY / ARCHITECTURE

If an existing project is present, preserve valid work and migrate thoughtfully. Otherwise, create a Flutter project with all six platforms where host permits. Prefer clean feature-first organization:

```text
lib/
  app/{app.dart,router/,theme/,bootstrap/}
  core/{auth/,database/,sync/,networking/,security/,platform/,widgets/,utils/}
  features/
    welcome/
    auth/
    profile/
    settings/
    nutrition/
    weight/
    workouts/
    calendar/
    body_composition/
    medication_log/       # future only; no dosing engine
supabase/
  migrations/
  functions/
  tests/
test/
integration_test/
assets/
  artwork/                # editable waves/icons only; no screenshots baked in
web/
```

Each feature may contain `data/`, `domain/`, `presentation/` subfolders. Maintain models/entities separately from UI and external SDK implementations. Keep platform-specific integrations behind pure Dart interfaces that can be mocked. Use a consistent error/result model; instrument networking and auth errors without personal data in logs.

## 4. IMPLEMENT THE EXACT APPROVED VISUAL DESIGN

A. Recreate the approved **light** page: white/ice-blue background, conspicuous but elegant pale/medium blue flowing curves at sides/bottom, dark-navy heading, very light rounded glass form panel, blue accents. The background graphics must not be invisible.

B. Recreate the approved **dark** page: charcoal neutral background, subdued burgundy/wine waves, off-white heading, restrained muted-red details only. **No glowing red HUD/Tron look, bright neon outlines, or harsh saturation**. The right header control in dark mode is neutral charcoal/silver, not fire-red.

C. One shared layout: native safe-area/system status UI; approximately 390x844 logical-point mobile design reference, 16-20 pt gutters, centered name and account tag, short accent line, circular ~160-pt avatar with neutral fallback, large translucent card, full-width rounded Continue button, reserved open decorative zone at bottom. Follow the detailed handoff geometry. Header hamburger at upper left; auth action at upper right. Keep responsive on narrow phones, landscape, tablet, web and wide desktop without merely stretching mobile pixels across the screen. On desktop, use an aesthetically consistent centered max-width auth region and an accessible shell.

D. Render actual widgets, not screenshots. Use theme tokens and layered `CustomPainter` waves; add an independent `BackgroundLayer` component for future custom image substitution. Support system theme default and optional persisted theme override only if feasible, otherwise mark toggle as deferred (the UI override is not approved). Live theme switching must not reset typed form data.

E. Forms must support keyboard access, focus, semantic labels, 44+ pt targets, readable contrast, screenreader access, responsive layout under keyboard, secure password input, disabled/enabled Continue state, loading, retry and errors.

## 5. AUTHENTICATION AND PROFILE STATE MACHINE (REAL LOGIC)

Explicit states: `signedOutLogin`, `signedOutRegister`, `signedInLocked`, `signedInUnlocked`, `submitting`, and `error`/`recovering`. Derive header text from authenticated SESSION, not the form widget.

- **Signed out:** top right button text is exactly `Sign Up`; card is email/password and disabled gray `Continue →` until plausibly valid email + nonempty password. Real login via Supabase, error without user enumeration, password reset flow. Do not show another person's name/image/tag on a shared signed-out device.
- **Registration:** forms for first name, last name, email, password; optional nickname and display-name choice. Include email verification as configured. Clear `Back to Log In` action. The exact registration visual layout is not approved: use shared components conservatively and label unapproved decisions in code/docs.
- **Signed in + optional local lock on supported device:** top right `Sign Out`; show user identity/avatar with masked tag and a local passcode/unlock challenge, **not email/password**. Only permit Continue after enough input; secure local verifier, retry throttling, credential recovery via full login. OS biometric/device-auth can be an optional alternative on platforms supported by `local_auth`; do not silently conflate biometric OS unlock with custom app PIN.
- **Signed in + lock OFF:** top right `Sign Out`; go straight into protected shell (no fabricated passcode).
- **Signed in + unlocked:** render protected app shell, settings/profile actions. Only feature-specific route placeholders for unapproved screens, clearly marked as placeholders.
- **Sign Out:** clear Supabase auth session and sensitive caches; reset local unlock state and tag reveal; route to signed-out login with `Sign Up` and email/password. Never call a mere app lock “sign out.”
- On app background, account switch, or sign out, immediately re-mask the tag, hide sensitive input and apply the chosen device-local lock policy.

### Identity profile data
- Persistent `first_name`, `last_name`, nullable `nickname`, `display_name_mode` enum/string `full_name|nickname`, `avatar_path`, audit timestamps; a stable *internal* UUID `auth.users.id` primary key. Do not expose private email/public names inadvertently.
- A server-assigned unique short tag matching `#[A-Z]{2}[0-9]{4}`, with two independent random uppercase letters and 4 digits, including leading zeros. Generate using a cryptographically secure server/database RNG (not `Math.random()` in client); insert with a UNIQUE constraint and safe collision retry under transaction. Never derive from initials/nickname/ID; never let clients update tags, and never use tags as authentication tokens.
- UI tag defaults to `#••••••`; **tap the tag itself** to show/hide complete tag. **No eye icon**. Keep geometry stable; re-mask on background and sign-out. The demo profile in screenshot is `King James`, not a hard-coded user identity in production.
- Private user-owned profile photos in Supabase Storage. Image selection, crop to circle, neutral silhouette fallback, permissions, upload validation, lifecycle cleanup, authenticated access only.
- Keep device-local passcode setting and secret **device scoped** where possible; do not synchronize a naked passcode through PostgreSQL. Unsupported platforms must have documented graceful behavior; never describe an insecure PIN dialog as production authentication.

## 6. POSTGRES SECURITY AND DATA ACCESS

- Migrations for profiles, display preferences, and necessary private avatar ownership metadata; retain minimal future schema planning in `ARCHITECTURE_AND_DATA.md` rather than eagerly building unapproved feature DB if not required for this milestone.
- Server-side profile initialization upon verified/auth creation, including random tag. If using `SECURITY DEFINER` functions/triggers, lock down `search_path`, execution grants, inputs and ownership; never allow arbitrary unauthenticated calls or tag reassignment.
- Enable RLS, revoke permissive default grants as necessary, and add `auth.uid()` ownership policies for each personal table. Test user A cannot SELECT/UPDATE/DELETE user B's profile or fetch photos. Give client read/write permission only to safe profile fields; account ID and assigned tag are immutable to clients.
- Store service credentials/API tokens only on server. Client uses `SUPABASE_URL` and publishable key from environment/dart-define (these are public identifiers, not secrets). Do not print tokens or embed server credentials in JS/mobile bundles.
- Track migrations in git, make startup idempotent, document database setup. Provide negative authorization tests with two independent test users; don't mark RLS tested if the actual environment can't execute tests.

## 7. FOUNDATION FOR TRACKER MODULES (DESIGN NOT YET APPROVED)

Provide organized route/domain abstractions and clear unstyled/neutral placeholders only, without asserting invented designs are approved:
1. Nutrition / macros: daily calorie/protein/carbs/fat goals, food items/servings/log entries; future barcode and USDA provider API via Edge Function with server-side key, cache/rate limit; user-entered custom foods. Open Food Facts is optional pending data-license review.
2. Bodyweight: timestamped weight records with units, trends and charts via `fl_chart` later.
3. Workouts: exercise catalog, templates, schedules, session/set logs; later `table_calendar` monthly/weekly view.
4. Body composition: measurement points and private progress photos with capture time; zero public access by default.
5. Medication/peptide log (optional/future): **user-entered records and reminders only**, not automated medical prescription/dosing guidance.

Plan eventual offline cache in Drift and an idempotent outbound queue (UUIDs, update timestamps/revisions, dedupe, soft deletions and conflict handling) for editable logs; don't claim completed offline write/sync before implementing/tests. On web, use the correct WASM/worker setup or a documented safe adapter fallback.

## 8. QA, CI, DEPLOYMENT, DOCUMENTATION

Add automated tests for:
- Theme tokens and signed-out/signed-in visual state logic;
- `Sign Up` vs `Sign Out` exact copy and matching credential form;
- Form validity/loading/errors, system theme changes without losing form inputs;
- Display mode nickname/full-name rules;
- Tag pattern, independence from initials, collisions, immutability, mask-toggle and re-hide on lifecycle events;
- Login/register/log out flow using mock adapter plus live/local integration instructions;
- RLS between two distinct users and storage privacy;
- Small/large viewport layout, keyboard and accessibility where testable.

Set up GitHub Actions to run `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, `flutter test`, `flutter build web` on a supported host. Build web assets to `build/web`; document optional Cloudflare Pages static deploy (CLI or build artifact upload), SPA routing/fallback and caching. Document Android release and macOS/Xcode prerequisites for iOS releases, instead of presenting impossible cross-OS builds as completed.

Supply `.env.example` or `--dart-define` README instructions with placeholders; a `.gitignore` to exclude real secret config; README for Flutter install, local run for web and host-supported native targets, database migration application, email integration, testing, build and deploy; simple platform capability matrix. Document cost monitoring, free tiers, reserved budget, the $99/year Apple developer cost and $25 Google Play registration.

## 9. IMPLEMENTATION ORDER (EXECUTE, DON'T JUST PLAN)

**Milestone A:** inspect environment/repository + establish compilable Flutter multi-platform scaffold; shared themes; reusable authenticated/unauthenticated shell; navigation; initial tests. **Milestone B:** implement faithful light/dark responsive welcome UI with live real form states; compare with approved reference images. **Milestone C:** Supabase schema, RLS, profile/tag issuance, real auth, private avatars + negative tests. **Milestone D:** local lock where securely supported, app shell and explicit future modules placeholders; local database adapter, browser build. **Milestone E:** tests, CI and deployment/docs, show clear test results.

If platform/tool limitations or missing credentials prevent a piece, complete every other possible piece and document the blocker exactly. Ask only for truly missing secrets/approval for unsafe paid deployment; do not silently activate paid resources. **Do not create expensive subscriptions or submit app-store releases without permission.**

## 10. DEFINITION OF DONE / CODEx REPORT FORMAT

At the end, report:
1. **Implemented** — precise completed screens, flows, files/migrations.
2. **Validated** — commands actually run with pass/fail; screenshots or manually checked viewports if feasible.
3. **Deferred** — not-approved tracking screen designs and any unavailable native integrations.
4. **Setup required by owner** — exact environment variables and service configuration steps, never requesting server secrets in chat.
5. **Cost status** — software/services activated, and whether any paid resource was enabled.
6. **Next task** — smallest coherent next milestone.

Do not declare cross-platform, security or offline readiness where it has not been tested. Prioritize secure real behavior and approved UI fidelity over scope inflation.
