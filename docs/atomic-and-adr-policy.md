---
metadata_version: 1
purpose: Define atomic work and automatic decision coverage for every repository change.
owner: unassigned
related_adrs: [ADR-0002, ADR-0003, ADR-0004, ADR-0008]
---

Executable fields, statuses, commit contracts, and limits are defined in the
[machine-readable policy](../config/engineering-policy.json). Read its referenced
registries before changing this standard or its validators.
# ATOMIC and automatic decision records

Read this policy before choosing or changing anything in the repository.
Use the [ADR index](adr/README.md) and [mandatory template](adr/adr-template.md).
This extends ADR practice to all decisions as an explicit project requirement;
it is broader than the usual focus on architecturally significant decisions.

## ATOMIC: one responsibility, one decision

- A unit must have one clear purpose that can be described, reviewed, and changed
  independently. Apply this to functions, modules, components, changes, and ADRs.
- Exactly **one ADR for one decision**. If two choices could be independently
  accepted, rejected, replaced, or reversed, give them separate ADRs and link them.
- Multiple implementation steps, affected files, tests, consequences, and rollout
  actions may belong to the same decision. They are not automatically new choices.
- One module does not have to contain one function. Reusable components may expose
  cohesive operations and serve many callers. Do not duplicate implementations or
  invent wrappers merely to reduce file size or increase the number of artifacts.
- Indexes, routers, schemas, and templates may organize related items under one
  explicit organizing purpose. They link decisions rather than bundle their rationale.
- A commit may contain several supporting ADRs if it delivers one coherent outcome.
  A commit boundary, file boundary, and decision boundary need not be identical.

## Automatic coverage: no undocumented change

Agents MUST create records without waiting for the user to request them:

1. Read relevant existing ADRs, the request, code/docs, and acceptance criteria.
2. Enumerate each independent choice or change: implementation, refactor, fix,
   naming, UI, documentation, configuration, tests, dependencies/downloads,
   security/privacy, tooling, policy, scope deferral, and size exceptions.
3. Search for an existing decision with the same scope, intent, and constraints.
   Reuse it when the work only applies that decision. Record that application in
   the work/commit coverage table. Reusable code does not remove this obligation.
4. Create a new ADR for each new choice or independently changed outcome, even
   if small. A purely mechanical repeat of an existing rule needs a coverage link,
   not a duplicate ADR. Do not invent alternatives or benefits for a trivial edit.
5. Draft the ADR before implementation where practical. For discoveries during
   work, create/update it immediately and finish it before the task closes.
6. Update the index and map every changed file to the decision(s) governing it.
   A change without a fitting ADR is incomplete. Record pending coverage as a gap.

Reading a file, running an already approved check, applying an existing formatter,
and maintaining an ADR/index under this policy do not recursively create decisions.
If those actions introduce a new choice, capture that choice. Recording an ADR,
its metadata, or its index row is covered by the governing decision/policy itself.
One adoption ADR can cover repeated application of a stable reusable convention.

Coverage record in the existing work log or commit's Decisions and ADRs section:

```text
Changed path | Decision ID(s) | New / reused / superseded | Why it applies
```

Use an ADR for rationale and a commit/work log for execution evidence. Neither
replaces the other. Do not copy the complete Git file/LOC ledger into every ADR.

## Template and identity

- Copy [adr-template.md](adr/adr-template.md); preserve all required sections and
  metadata keys. Replace placeholders with facts or explicit unknown/N/A reasons.
- Complete ADRs MUST have **at most 249 physical lines**, including YAML, blank
  lines, tables, comments, and references. No exception. Aim for 60–120 lines.
- Keep context, choice, why, tradeoffs, and confirmation in the ADR itself.
  Link long evidence or specifications; do not move essential rationale elsewhere
  or split one decision into numbered parts to evade the limit.
- Use `NNNN-short-decision.md` and matching `ADR-NNNN`. Allocate the next unused
  number after rereading the index and directory; never overwrite/reuse an ID.
  Existing IDs remain stable. Resolve concurrent collisions before finalizing.
- Use a precise decision title, such as "Keep browser sessions in memory."
  Avoid "Authentication decisions" or "Implement the whole app."
- Scope lists one responsibility, affected surfaces, and explicit exclusions.
  References distinguish current evidence from historical context.

## Status and authority

- Allowed statuses: `proposed`, `accepted`, `rejected`, `superseded`, `deprecated`.
- `accepted` means the choice is authorized, not that implementation/test passed.
  Keep `implementation` independently `planned`, `partial`, `implemented`, or
  `not-applicable`. Verification must state actual results or pending work.
- A direct user requirement can be recorded as accepted with that requirement as
  the basis. Routine delegated choices may be accepted within existing authority;
  record that basis accurately. Do not fabricate a named approver or consultation.
- Unresolved approval, product, spending, or deployment choices stay proposed.
  Writing an ADR neither grants authority nor silently expands task scope.
- Do not backdate records. Record today's date and distinguish retrospective
  reconstruction, source dates, and unknowns when documenting old work.
- Preserve accepted rationale. Clarify typos, links, and evidence without changing
  historical meaning. A changed decision gets a new ADR, reciprocal supersession
  links, and an updated index; never silently rewrite history or delete the old one.

## Metadata and lifecycle

Apply [file metadata](file-metadata.md). ADR front matter extends the shared keys
with ID, title, status, date, decision basis, implementation, and relationship lists.
Use `related_adrs` for contextual links, not approval or implicit supersession.
Empty lists mean none established; they must not hide known relationships.

Existing records need an honest adoption path. Do not declare the old corpus
compliant without review. Preserve historical records, list gaps in the index,
and normalize an affected record when its subject is next changed. Splitting a
historical bundle requires evidence for each extracted decision and truthful dates.
Do not invent historical approvals or disturb another task's active implementation.

## Required review before completion or commit

- One decision per ADR; every changed file has explicit coverage.
- All template fields/sections filled; statuses and authority are truthful.
- IDs unique; index, file paths, and related/supersession links resolve.
- All ADRs in the change are under 250 lines; no line-compression workaround.
- Metadata is present and safe; choices match actual behavior or clearly say planned.
- Alternatives are real, constraints are supported, and risks/reversal are usable.
- Verification describes actual checks and separates policy from automation.
- Report uncovered legacy records or files. No silent waivers or fake green gates.

## Research basis

Checked 2026-10-19. The template is an original project adaptation of established
ADR concepts; no external package or template source was installed/copied.

- [ADR community](https://adr.github.io/): a record captures one decision and
  rationale; this project explicitly extends coverage to every new choice/change.
- [MADR](https://adr.github.io/madr/): structured context, options, outcome,
  consequences, and confirmation support consistent review.
- [MADR metadata](https://adr.github.io/madr/decisions/0013-use-yaml-front-matter-for-meta-data.html):
  YAML front matter separates machine-readable fields from the explanatory body.
- [Michael Nygard's ADR guidance](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions):
  small records and retained superseded decisions preserve useful history.
