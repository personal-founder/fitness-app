---
metadata_version: 1
purpose: Describe auth data flows, threat controls and unverified security boundaries.
owner: unassigned
related_adrs: [ADR-0044, ADR-0042, ADR-0001, ADR-0032, ADR-0033, ADR-0034, ADR-0035, ADR-0036]
---
# Authentication security and privacy

## Data inventory and boundaries

Email/password go only to configured Supabase Auth over HTTPS; passwords remain
transient in form memory and clear after submission/background. Private profile
names, nickname, tag and optional avatar path live in owner-restricted PostgreSQL.
No health data is collected in this milestone. Profile avatar upload UI is deferred.

Supabase serializes sessions through a custom OS-vault adapter on supported native
targets. Native PKCE verifiers use that vault too. Web/Linux sessions are memory-only;
Supabase's browser PKCE storage can retain a transient code verifier for email return,
but not the access/refresh session. Browser XSS can still access in-memory secrets:
use reviewed hosting headers, trusted scripts and dependency updates before release.
The separate Drift preference database contains no passwords, tokens, PINs or profiles.

Passcodes are four digits with random 32-byte salt, PBKDF2-HMAC-SHA256 at 600,000
iterations and a 256-bit verifier. The verifier/retry record stays in the OS vault,
scoped to the account. An attempt is persisted before verification so a restart
cannot erase the attempt counter. Five failures trigger a five-minute cooldown.
KDF computation runs off the UI isolate. Device biometrics call `local_auth` rather
than using an invented biometric flag. Production unlock has no built-in secret. Only the compile-time demo adapter accepts
1234 for King James #QF4821; it never authenticates with Supabase or native vaults.

The app gate is additional visual/local protection. It does not encrypt future
health records and cannot stop a rooted device, modified application or extracted
OS secrets. Four-digit PINs have only 10,000 possible values and limited entropy; OS storage and retry controls are
necessary but are not hardware-enforced PIN verification. Device-clock tampering,
OS backups, accessibility exposure and hardware behavior require device review.

Account tags must load before enrollment; PINs equal to their numeric suffix are
rejected at the UI and native enrollment boundary. Old version-one records remain
intact until fresh account credentials authorize four-digit replacement. The record
key remains stable; version two records explicitly identify the four-digit format.

Appearance is non-sensitive device data retained across sign-out. The QR shares only
a public tag after an explicit tap, including while locked by user choice. It closes
on background/sign-out/account change, uses no camera permission, and performs no
friendship request. Recovery via **Forgot Passcode?** is intentionally unfinished.

## Threats and controls

| Abuse/failure | Control and evidence | Residual limit |
| --- | --- | --- |
| Client reads another profile | Ownership RLS; two-user SQL tests supplied | Not executed without PostgreSQL/Supabase |
| Client changes account tag/owner | Column grants; UNIQUE and format constraints | Live privilege tests pending |
| Public/cross-user photo access | Private bucket and folder ownership policies | Storage API tests and file-content inspection pending |
| User name drives tag | Independent server CSPRNG symbols with rejection sampling | Collision/namespace capacity needs future monitoring |
| Wrong PIN / repeated restart | Salted verifier, persisted throttle, denied-path tests | Native secure-store protection not device-tested |
| Background races with unlock | Epoch invalidation, lifecycle re-mask, regression tests | App-switcher snapshots need native validation |
| Missing credentials or storage | Explicit setup/fail-closed startup | No live backend success claim |
| Backend error exposes account existence | Generic credential errors, uniform recovery text | Configure backend rate limits/email policy |

Scope maps to OWASP MASVS AUTH/STORAGE/CRYPTO and ASVS authentication/access-control
areas; no full versioned certification/control audit has run. Reviewed primary sources
on 2026-10-19: [MASVS](https://mas.owasp.org/MASVS/),
[ASVS](https://owasp.org/www-project-application-security-verification-standard/),
[OWASP KDF guidance](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html).

## Retention, recovery and release blockers

Sign-out requests device-local Supabase session revocation, clears its persisted
session and lock record, and removes visible account identity. Already issued access
tokens may remain valid until expiry; sign-out is not immediate global token erasure.
Backend user deletion cascades the profile; storage cleanup and end-user deletion/
export workflows are not implemented. No retention duration has been selected.

Before collecting real users, define retention/deletion, processor regions, incident
ownership, secret rotation, backups/restoration and redacted diagnostics. No external
analytics/crash service or health processor was enabled. No secrets are requested in chat.

Account creation introduces release requirements. Current primary guidance reviewed
2026-10-19: [Apple account deletion](https://developer.apple.com/help/app-review/guideline-reference/5-1-1-account-deletion)
and [Google Play deletion paths](https://support.google.com/googleplay/android-developer/answer/13327111?hl=en).
Deletion UI/web requests, privacy disclosures, signing and actual-device tests remain
release blockers. This local foundation is not a production-readiness assertion.

## Credential-based demo

Only explicitly compiled preview mode accepts the public synthetic fixture
demo@gmail.com / demo123 before the King James PIN. No Gmail/Supabase account is
created, contacted, or recovered. Sign-up minimum length is unchanged. A namespaced
SharedPreferencesAsync boolean remembers demo sign-in, not a token or secret;
modifying it cannot grant access to a real account. Sign-out writes false before
clearing identity, and storage errors are surfaced. Password/PIN fields remain
transient. Native security and production sessions retain their existing boundaries.
