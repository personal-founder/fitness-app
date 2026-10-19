---
metadata_version: 1
purpose: Record the blank dashboard implementation and validation evidence.
owner: unassigned
related_adrs: [ADR-0045, ADR-0030, ADR-0013, ADR-0025]
---
# Blank post-passcode dashboard

The user authorized an empty King James dashboard after successful unlock.
The dashboard retains the existing background, appearance, menu and Sign Out;
its content area is intentionally empty. No dependencies or downloads were added.
Existing lifecycle locking stays mounted around both entry and dashboard views.
The session guard redirects old `/ready` requests to the current phase destination.

## Change coverage

| Changed path | Decision | Application |
| --- | --- | --- |
| `lib/features/dashboard/dashboard_page.dart` | ADR-0045, ADR-0013 | Empty themed destination using shell widgets |
| `lib/features/welcome/welcome_page.dart` | ADR-0045 | Render destination and retain lifecycle observer |
| `lib/app/router.dart` | ADR-0045, ADR-0030 | Guard dashboard by unlocked session phase |
| `test/demo_flow_widget_test.dart` | ADR-0045, ADR-0025 | Guard, unlock, background and sign-out regressions |
| `integration_test/entry_flow_test.dart` | ADR-0045, ADR-0025 | Update synthetic unlock destination assertion |
| `scripts/verify-demo-web.cjs` | ADR-0045, ADR-0025 | Expect the current dashboard route after unlock |
| `ARCHITECTURE_AND_DATA.md` | ADR-0045 | Current destination and boundaries |
| `docs/adr/0024-auth-only-milestone.md` | ADR-0045 | Preserve historical decision and mark successor |
| `docs/adr/0045-blank-dashboard.md`, `docs/adr/README.md`, this record | ADR-0045 | Rationale, index and evidence |

## Validation

Final staged checks and actual outcomes are recorded in the application commit
message and its external verification report. Physical-device and live Supabase
testing remain outside this local synthetic journey; platform limitations remain
explicit. See [the bounded commit decision](../adr/0046-application-commit-native-waiver.md).
