# Macro App — Complete full stack reference

**Checked against official project/vendor docs on October 19, 2026.** This is an architecture decision list, not a commitment to install every optional plugin immediately.

Column format: **What it is | What it is for | Source / Link | Why we are using it**. Adoption timing in the final column.

| What it is | What it is for | Source / Link | Why we are using it | Adoption |
|---|---|---|---|---|
| **Flutter** — Free, open-source cross-platform UI framework | App interface for iOS/Android/web/Windows/macOS/Linux | [Official source](https://flutter.dev) | One branded widget/layout system for all six targets | Now |
| **Dart** — Programming language used by Flutter | Frontend logic, models, tests | [Official source](https://dart.dev) | Single typed language for all app clients | Now |
| **ThemeData / ThemeExtension / CustomPainter** — Built-in Flutter visual and painting APIs | Shared theme tokens; responsive custom wave graphics | [Official source](https://docs.flutter.dev/cookbook/design/themes) | Faithfully reproduce approved blue/burgundy screens; future custom backgrounds | Now |
| **flutter_riverpod (Riverpod)** — Flutter state-management and dependency injection library | Auth/session state, async data, shared business state | [Official source](https://pub.dev/packages/flutter_riverpod) | Separation of UI and testable behavior | Now |
| **go_router (GoRouter)** — Declarative navigation package | Login redirects, deep links, protected routes | [Official source](https://pub.dev/packages/go_router) | Same route semantics on apps and browser | Now |
| **Supabase** — Managed backend platform | Accounts, database, user files, server-side logic | [Official source](https://supabase.com/docs) | One backend across all six clients with free prototyping tier | Now |
| **supabase_flutter** — Flutter SDK for Supabase | App-to-backend API and auth integration | [Official source](https://supabase.com/docs/guides/getting-started/quickstarts/flutter) | Official integration avoids a separate application backend at launch | Now |
| **PostgreSQL** — Relational SQL database (managed by Supabase) | Profiles, food logs, weight, workouts, settings | [Official source](https://supabase.com/docs/guides/database/overview) | Strong constraints, joins, migrations and scalability | Now |
| **Postgres Row Level Security (RLS)** — Database-enforced record authorization | Restrict private data to its authenticated owner | [Official source](https://supabase.com/docs/guides/database/postgres/row-level-security) | Protection is enforced even if client UI/requests are manipulated | Now |
| **Supabase Auth** — Managed authentication service | Sign in/up/out, verification, password reset, sessions | [Official source](https://supabase.com/docs/guides/auth) | Mature account lifecycle without a custom password server | Now |
| **Supabase Storage** — Object/file storage | Private profile photos and body progress photos | [Official source](https://supabase.com/docs/guides/storage) | Direct integration with Supabase auth, access policies | Now |
| **Supabase Edge Functions (Deno/TypeScript)** — Serverless backend functions | Private nutrition API keys, webhooks, privileged operations | [Official source](https://supabase.com/docs/guides/functions) | No separate always-on server subscription initially | Now/when needed |
| **Drift + drift_flutter + SQLite** — Type-safe local relational persistence | Offline reads/cache and later sync queue | [Official source](https://pub.dev/packages/drift_flutter) | Responsive access and user-scoped offline tracking; web WASM needs setup | Foundation, then logs |
| **Cloudflare Pages** — Static web hosting and CDN | Deploy Flutter `build/web` assets | [Official source](https://developers.cloudflare.com/pages/) | Free-tier web distribution; no always-on web server | At web release |
| **fl_chart** — Cross-platform Flutter chart library | Weight trends, calories/macros charts, body measurements | [Official source](https://pub.dev/packages/fl_chart) | Customizable charts aligned with both themes | When tracker UI approved |
| **table_calendar** — Cross-platform calendar UI package | Workout split and scheduled workouts | [Official source](https://pub.dev/packages/table_calendar) | Avoid building complex calendar controls from scratch | When planner UI approved |
| **USDA FoodData Central** — Public US nutrition food dataset and API | Food search, nutrients, portion metadata | [Official source](https://fdc.nal.usda.gov/api-guide/) | Free CC0 source to seed nutrition functionality; API rate limits/key apply | When nutrition module built |
| **Open Food Facts** — Community packaged-food data/API | Barcode and branded product lookup | [Official source](https://openfoodfacts.github.io/openfoodfacts-server/api/) | Expanded barcode coverage; must comply with ODbL/data and image licensing | After licensing review |
| **mobile_scanner** — Flutter barcode/QR scanning plugin | Scan packaged food barcodes | [Official source](https://pub.dev/packages/mobile_scanner) | Built-in camera UX on Android/iOS/macOS/web; manual input elsewhere | When barcode enabled |
| **flutter_secure_storage** — Platform-aware protected key/value storage | Native device lock material and sensitive local values | [Official source](https://pub.dev/packages/flutter_secure_storage) | Avoid plaintext app-level credential storage; web security differs | When lock built |
| **local_auth** — Native device authentication plugin | Biometric/device credential unlock as optional local gate | [Official source](https://pub.dev/packages/local_auth) | Uses supported OS auth mechanisms; not a custom PIN implementation | Optional device lock |
| **flutter_local_notifications** — Flutter local notification scheduling/display | Workout reminders and user-selected reminders | [Official source](https://pub.dev/packages/flutter_local_notifications) | Does not require a backend push service for purely local schedules | Later |
| **Firebase Cloud Messaging / firebase_messaging** — Free push messaging transport | Remote reminder notifications on supported platforms | [Official source](https://firebase.google.com/docs/cloud-messaging/flutter/get-started) | Broad Android/iOS/web push support; separate platform setups needed | After local reminders |
| **Resend** — Transactional email service / SMTP | Reliable verification and password recovery via Supabase custom SMTP | [Official source](https://resend.com/pricing) | A clearer email quota and deliverability path than testing defaults | When production email configured |
| **Sentry / sentry_flutter** — Crash and error reporting service | Track runtime exceptions and failed launches | [Official source](https://pub.dev/packages/sentry_flutter) | Understand production failures across supported clients; scrub private data | Production |
| **GitHub** — Git source hosting and collaboration | Version history, issues, branches, code review | [Official source](https://github.com) | Standard place to maintain one cross-platform codebase | Now |
| **GitHub Actions** — Hosted CI/CD automation | Analyze/test/build/deploy artifacts | [Official source](https://github.com/features/actions) | Catch regressions, automate repeatable releases | Now |
| **health** — Flutter wrapper for Apple HealthKit / Health Connect | Read permitted device health/fitness data on mobile | [Official source](https://pub.dev/packages/health) | Avoid reinventing OS-level integrations; Android/iOS only | Later |
| **Cloudflare R2** — Object storage service | Expand body/photo storage if bandwidth economics warrant | [Official source](https://developers.cloudflare.com/r2/pricing/) | Low-cost storage with no internet egress charges; extra integration work | Only as needed |
| **RevenueCat** — Subscription and in-app purchase management | Entitlements and store purchase lifecycle | [Official source](https://www.revenuecat.com/pricing) | Avoid manual App Store/Play billing complexity | Only when subscriptions exist |
| **Stripe** — Web payment processor | Paid browser/desktop subscriptions/payments | [Official source](https://stripe.com/pricing) | Mature billing on supported web flows; check platform store policies | Only when charging |
| **Astro** — Static site framework | SEO-friendly marketing and support/privacy website | [Official source](https://astro.build) | Separate indexable landing pages from complex Flutter web app | If marketing requires |
| **Flutter SDK / VS Code / Android Studio** — SDK and free development tools | Code editing, SDK management, debugging, Android build | [Official source](https://docs.flutter.dev/get-started/install) | Zero subscription tooling to develop locally | Now |
| **Apple Developer Program / Xcode** — Apple build/signing and distribution tooling | Test/sign/release iOS and macOS apps | [Official source](https://developer.apple.com/help/account/membership/program-enrollment/) | Required Apple ecosystem workflow; 99 USD/yr account fee | Before Apple release |
| **Google Play Console** — Android app publishing portal | Publish/sign Android app to Play Store | [Official source](https://support.google.com/googleplay/android-developer/answer/6112435/) | Official distribution; 25 USD registration one-time | Before Play release |

## High-priority compatibility caveats

- All **six Flutter targets** are supported by Flutter itself, **not every third-party plugin**. Guard native-only code behind interfaces and implement a fallback.
- `mobile_scanner` currently lists Android, iOS, macOS, and web, not native Windows/Linux.
- `health` currently supports iOS and Android only; `local_auth` supports Android/iOS/macOS/Windows, not Linux/web.
- `drift_flutter` web mode requires SQLite WASM and worker JavaScript assets.
- Free-plan quotas and fair use do not imply unlimited free production traffic.
- USDA requests require an API key that is **server-side secret**; default API rate limit is 1,000 requests/hour/IP. Credit USDA as source. Do not treat `DEMO_KEY` as production.
- Open Food Facts has ODbL database licensing and CC BY-SA product image licensing; require compliance review before combining or redistributing data.
- Google Play developer registration and Apple membership are distribution costs, not monthly infrastructure subscriptions.
- Supabase and other service quotas/pricing may change; set budget alerts and revisit official links before publishing.
