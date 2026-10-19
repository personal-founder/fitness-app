# ADR 0001 — Flutter authentication foundation

Status: accepted for local implementation, 2026-10-19.

## Context and decision

User selected Flutter/Dart, Riverpod, GoRouter, Supabase/Postgres/RLS, Drift/SQLite,
and eventual Cloudflare Pages. Preserve those choices rather than reuse the separate
React Macro Tracker application. No executable code exists in this checkout.
Use one modular Flutter app and a narrow backend profile schema. No extra server.

Only entry views are approved. King James is preview data. A compile-time design
preview can render the locked identity without a backend, but must announce itself
and cannot unlock or become a real session. Production never falls back to demo auth.

Native session storage uses the platform secure-store plugin. Separate app PINs use
a maintained KDF and protected verifier with account-scoped persisted retry state;
OS biometrics are an alternative. Browser sessions are memory-only because this
milestone has no reviewed WebAuthn/encrypted browser-unlock design. Linux native
locking remains disabled until its secret-store and unlock behavior are validated.

## Alternatives and consequences

A hard-coded PIN, shared-preferences token store, or client-generated account tags
would simplify demos but fail the security boundary. Native-only development would
miss required Web support. Installing every future plugin adds unneeded surface.
Drift stores only non-sensitive preferences now; web cache is explicitly deferred.

Device testing, Supabase service configuration, live RLS testing and platform signing
remain separate evidence requirements. A UI gate cannot stop a compromised client.
Switching backend requires replacing adapters and migrating profiles; never migrate
raw credentials through application storage. Remove this decision only with an
explicit replacement ADR and migration/revalidation plan.
