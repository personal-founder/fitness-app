---
metadata_version: 1
purpose: Document the current application architecture and data boundaries.
owner: unassigned
related_adrs: [ADR-0045, ADR-0044, ADR-0042, ADR-0028, ADR-0024, ADR-0032, ADR-0033, ADR-0035, ADR-0036]
---
# Macro App architecture and data

Locally authored on 2026-10-19. No architecture document was present in the ZIP.
Decision: [ADR 0001](docs/adr/0001-auth-foundation.md).

## Boundaries

Flutter renders six platform targets. `lib/app/` owns themes, configuration and
GoRouter. Riverpod injects authentication and lock adapters. Features own reusable
entry views. Supabase owns account credentials, email verification and profile rows.
Native secure storage owns session serialization and device-local lock records;
neither secrets nor profiles belong in the non-sensitive Drift preferences database.
Web sessions remain memory-only; refresh requires credentials. Browser storage is
not presented as equivalent to a native protected store.

Entry views cover login, registration and signed-in local lock.
Successful unlock opens `/dashboard`: an intentionally empty page retaining the
existing background, theme, menu and Sign Out. No tracker content is implemented.
The entry lifecycle observer remains mounted to lock the dashboard on background.
Registration layout reuses the approved components but is provisional.

## Account lifecycle

Supabase signs up with first/last name and optional nickname metadata. A database
trigger initializes a private profile and independently random `#[A-Z]{2}[0-9]{4}`
tag under a UNIQUE constraint with bounded retry. Clients cannot insert profiles or
change account ID/tag. RLS restricts personal rows to `auth.uid()`.
Login uses email/password (no username backend was specified). Verification follows
Supabase configuration. Recovery stays inside the credential card.

Restored native sessions begin locked. First native login requires a separate four-digit
passcode with confirmation after verified authentication. The account tag must load
first, and its numeric suffix cannot be the PIN. Version-one records require fresh
account authentication before replacement with version two; no silent conversion.
Use a salted PBKDF2-HMAC-SHA256 verifier, protected storage and persistent throttling;
biometric unlock uses the operating system on capable devices. Never store raw PIN.
Signing out removes local session/lock state and clears reveal state. On background
the local UI locks and tag re-masks. This gate does not encrypt future tracking data
and is not protection from a compromised OS or a modified client.

## Appearance and public-tag sharing

Riverpod owns a device theme preference loaded before the first frame. Native Drift
stores its non-sensitive value; SharedPreferencesAsync stores browser appearance.
System follows OS changes; explicit overrides persist until reset, including sign-out.
A failed write keeps the selected session appearance and exposes retry status.

The profile-circle modal uses qr_flutter locally. Its versioned payload is
`macroapp://friend?v=1&tag=%23QF4821` for the synthetic example. It shares no account
UUID, email, credential or session. It is available while locked by explicit product
choice and dismisses at lifecycle/account boundaries. Receiving/friending is deferred.

## Deferred data

Nutrition, weight, workouts, calendars, body composition and user-entered medication
logs remain future domain work. No premature tables or UI are created. Future local
records must include account ownership, units, provenance, revision and timestamps;
sync needs idempotency, conflict handling and deletion propagation before shipping.
Private avatar storage policies are prepared; image editing/upload UI is out of scope.

Cloudflare Pages eventually serves `build/web`. No services are deployed here.

## Isolated demo lifecycle

Explicit preview mode restores a synthetic flag before the Riverpod scope starts.
First use requires demo@gmail.com / demo123; successful sign-in loads King James
#QF4821 and the existing 1234 local demo lock. Sign-out persists false before
clearing identity. Restored true flags always enter locked, never unlocked.
The SharedPreferencesAsync flag is a demo preference, not real authorization.
Read errors default to login with retry feedback; failed writes retain the prior
auth state and report failure. Production adapters ignore this fixture entirely.
