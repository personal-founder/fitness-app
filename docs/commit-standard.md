---
metadata_version: 1
purpose: Define detailed commit messages and evidence required before committing.
owner: unassigned
related_adrs: [ADR-0003, ADR-0004, ADR-0005]
---

# Commit standard

Status: policy adopted. Inspect local enforcement separately; policy prose alone
does not prove installed hooks, passing verification, or remote protection.
Last researched: 2026-10-19.

This standard applies to all commits in the Fitness App repository, including amendments, reverts, and final squash/merge messages. Follow [AGENTS.md](../AGENTS.md), [the ATOMIC/ADR policy](atomic-and-adr-policy.md), and [file metadata](file-metadata.md); use [the template](../.gitmessage) and [the illustrative message](examples/commit-message.txt). Changing this policy does not authorize staging, committing, initializing Git, or publishing.

## 1. Purpose and current enforcement status

Each commit must let a reviewer understand the problem, the solution, every changed file, the evidence that it works, important tradeoffs, and remaining work without reconstructing a chat. Detailed explanations supplement the diff; they must not contradict it or replace code review.

The initial commit-policy snapshot on 2026-10-19 contained only this standard, template, and example, with Git initialized and no app manifests. The workspace now also contains Flutter application files and `pubspec.yaml`; that historical documentation-only exemption no longer describes the live workspace. Inspect actual scripts, supported targets, hooks, and CI before committing. These policy files do not prove any gate is installed or passing; never create a fake always-green check.

The project policy is **no commit with a failed, blocked, missing, stale, or skipped required check**. This is stronger than merely requiring green checks before merging. Local hooks can be bypassed by Git options or configuration; they are useful controls, not an absolute security boundary. Remote CI and protected branches provide a second enforcement layer once hosting exists. Their existence alone does not validate local commits before creation. [Git hooks](https://git-scm.com/docs/githooks), [GitHub branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches).

## 2. Commit boundary and writing style

- Commit one coherent, complete purpose at a time. Keep supporting tests, docs, migrations, and dependency changes with the behavior they support. Split unrelated cleanup or features into independently valid commits.
- Explain the concrete before/after behavior and why it matters. Describe mechanisms and tradeoffs precisely; avoid vague statements such as "improve code," "various fixes," or "production-ready."
- Write direct, natural engineering prose. No mentions of AI, models, assistants, prompting, generated-by signatures, or tool-credit boilerplate in commit messages. Do not invent a human author, reviewer, sign-off, or test execution. Preserve legally required attribution in source and truthful Git identity.
- No email address is required in the commit subject, body, or trailers. Keep personal email addresses out of commit messages. Git author/committer metadata is separate: use the authorized public author name and a GitHub-provided noreply address, configured per repository, to avoid publishing a personal address. Do not invent attribution or sign-off trailers.
- Keep the subject short enough to scan; target 50–72 characters and use imperative wording. Wrap body prose around 80–100 columns when practical. Keep paths, URLs, commands, and file-ledger rows intact even when longer.
- Depth means useful evidence and reasoning, not repeated claims. Every section below is required; `None — <reason>` or `N/A — <reason>` is acceptable where true. Do not invent decisions or downloads to fill space.
- Keep secrets, sensitive user data, proprietary credentials, internal access tokens, and embargoed exploit instructions out of permanent Git history. Cite appropriately restricted sanitized evidence instead.
- No unresolved placeholders, fabricated issue IDs, copied PR discussion, chronological tool transcripts, or claims that pending work is already finished.

## 3. Subject format

```text
type(scope)!: specific change
```

Use `!` only for a breaking change; otherwise omit it. Use a stable scope naming the affected feature or subsystem, such as `auth`, `workouts`, `sync`, `billing`, `docs`, or `tooling`. Scope can be omitted when the change genuinely spans the whole repository.

| Type | Use |
| --- | --- |
| `feat` | New user or developer capability |
| `fix` | Correct incorrect behavior |
| `refactor` | Internal restructuring with preserved intended behavior |
| `perf` | Measured performance improvement |
| `test` | Test-only behavior or coverage changes |
| `docs` | Documentation-only changes |
| `build` | Build tooling, packaging, or dependency configuration |
| `ci` | Continuous integration and automation configuration |
| `style` | Formatting-only changes with no behavior change |
| `chore` | Necessary maintenance not covered above; explain it specifically |
| `revert` | Reversal of an earlier change; identify the original commit |

Use the type that reflects the primary outcome: a security bug fix is normally `fix(auth)`, not an undocumented new category. Breaking changes also need a final `BREAKING CHANGE:` trailer describing affected consumers and migration. These subject/trailer conventions build on [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/); the detailed body is this project's additional contract.

## 4. Required message sections

Use these headings and this order, exactly as in the template:

| Section | Required explanation |
| --- | --- |
| Summary | What the commit accomplishes and who benefits |
| Problem and rationale | Prior behavior, trigger/reproduction or need, why this approach |
| Changes | Added, changed, removed, and reused/simplified behavior; major failure paths |
| File ledger | Every changed path, action, purpose/reason, added/deleted line counts and totals |
| Verification | Exact snapshot/base, commands, targets, environment, outcomes, functional checks, evidence and gate result |
| Decisions and ADRs | Choices, alternatives, tradeoffs; created/updated/superseded ADR paths and status |
| Dependencies and downloads | Added/updated/removed dependencies and deliberately downloaded tools/assets, including temporary ones; purpose and provenance |
| Compatibility, security, and operations | API/data/client compatibility, sensitive data, permissions, migrations, rollout/configuration, measurements or limits |
| Not included and remaining risks | Deliberately deferred work, reasons, impact, tracking and non-blocking residual risk |
| Next steps | Ordered, actionable work with acceptance criteria, dependencies and owner if known; no invented commitments |
| Rollback | Reversal procedure, data consequences, follow-on dependencies and verification |
| References | Real issue/specification/ADR/report references; None with reason if absent |

Every changed file MUST map to a new or reused ADR in Decisions and ADRs. Record
each independent choice automatically, including small changes; one ADR contains
one decision. Verify the mandatory template, 249-line maximum, metadata, index,
and references. Reusing a governing decision is explicit coverage, not "no ADR."
Do not invent new decisions for repeated implementation of an existing rule.

Final Git trailers, if any, go after a blank line below References. Do not repeat every detail in multiple sections. Use repository-relative paths and durable links. A commit body can be the canonical work record for the committed change; use a separate change document only when it adds persistent operational value. Keep ADRs and dependency records as canonical detailed records and summarize their relevant changes here.

## 5. Complete file and LOC ledger

Required row format:

```text
Path | Action | Purpose and reason | LOC
src/auth/authenticate.ts | Added | Delegate login to the existing provider; replace legacy-login.ts. | +35 -0 LOC
src/auth/legacy-login.ts | Removed | Duplicated authentication; replaced by authenticate.ts. | +0 -170 LOC
src/auth/sign-out.ts | Edited | Clear cached session state when signing out. | +38 -170 LOC
```

The rows above are fictional format examples. Never reuse their counts for real work.

- Use the complete repository-relative path, not a basename that could be ambiguous. Sort by path. For a rename, show `old/path -> new/path` once, with action `Renamed`; explain any simultaneous behavior change.
- List **every** changed path, including tests, docs, configuration, lockfiles, generated content, binaries, removals, modes, symlinks, and submodule references. No omitted "miscellaneous files." Quote/escape unusual paths and literal pipes unambiguously.
- Use Git's added/deleted line counts from the final staged diff. Here `LOC` means changed text lines as Git reports them, including comments/blank lines/docs; it is not a language-aware code metric or a measure of productivity.
- Report additions and deletions separately, even for edited files. Always use `+A -D LOC`. Also report net `A-D` and overall totals. Never present the net alone as the amount of work.
- For pure renames, report `+0 -0 LOC` if that is the diff result; do not count the entire file as newly authored. Record the rename detection mode so counts can be reproduced. For copies, identify origin and do not imply original authorship.
- Binary files have `LOC: N/A (binary)`; record old/new byte size and purpose when available. Git's `- -` numstat values are not zeros. For LFS objects identify the object/size; pointer text counts are not asset size. For submodules record old/new commit IDs; do not label a gitlink line as implementation LOC. For mode-only changes record old/new modes and `+0 -0 LOC`.
- Include lockfile/generated text in totals but identify their subtotal separately from hand-maintained source/tests/docs. Totals must reconcile with the file rows; list non-text changes separately.
- Generate factual counts mechanically; write the explanation after reviewing the actual diff. Do not estimate counts or count unstaged/untracked files outside the proposed commit.

Once Git exists, the normal comparison for a new single-parent commit is the index against `HEAD`; for the first commit, `--cached` without `HEAD` compares staged files against the empty tree. These commands inspect rather than stage:

```powershell
git diff --cached --no-ext-diff --no-textconv --diff-algorithm=myers --find-renames=50% --name-status
git diff --cached --no-ext-diff --no-textconv --diff-algorithm=myers --find-renames=50% --numstat
git diff --cached --no-ext-diff --no-textconv --diff-algorithm=myers --find-renames=50% --summary
git diff --cached --check
```

For automation, use `-z` on name-status/numstat, parse NUL-delimited records including the special rename layout, and preserve Unicode/spaces in paths. Never split paths on whitespace. Record diff settings including rename detection and algorithm; normalize the future ledger tool to `--diff-algorithm=myers` for both generation and validation. These counts reflect the chosen diff, not an intrinsic property of a file. [Git diff documentation](https://git-scm.com/docs/git-diff).

For an amend, compare the final candidate tree against the original commit's first parent, not against the commit being amended; regenerate the **entire replacement message**, not only the new delta. An amended root commit uses the empty tree. For a merge commit, declare first-parent comparison and distinguish incoming changes from conflict resolutions; retain other parent IDs in evidence. A squash commit gets a fresh ledger against its actual target parent. Do not concatenate obsolete messages/counts. After rebase/cherry-pick/conflict resolution, regenerate evidence for the new candidate tree and parent.

## 6. Mandatory build, test, and functional gate

### Required result

A commit is allowed only when the exact proposed contents pass the complete registered commit gate. Existing failures still block; being unrelated to the task does not turn a red build green. Failed/flaky tests must be investigated and fixed; repeated reruns until green are not a substitute. Missing tools/devices/credentials or unavailable runners are `BLOCKED`, not `PASS`.

Once an app exists, documentation-only commits still run the required app build/test gate under this policy. They do not need artificial new unit tests for prose. Before any executable app exists, a genuinely documentation/asset-only initial snapshot may record app build/tests as `N/A — no executable app exists`, with real documentation/asset validation. This exception ends with application scaffolding; an app with no configured tests/build commands is blocked, not exempt.

### What the registered gate must include

Define verified commands, expected suite discovery/count rules, supported target matrix, toolchain/environment requirements, and evidence locations during application bootstrap. Until then, commands are unconfigured; do not select a framework just to implement this policy.

1. Reproducible dependency resolution using pinned tools and lockfiles.
2. Formatting/lint/type/static checks required by the selected stack.
3. The full required automated suite, including domain, integration, critical user flows, and relevant negative/security cases. Fail on unexpectedly zero tests or missing suites. Required tests may not be silently skipped/quarantined.
4. Builds for every currently supported application target and required configuration, plus backend/services where present. Future unimplemented platforms must be explicitly labeled planned, never claimed supported or tested.
5. Applicable functional smoke checks proving the built app starts and critical touched journeys work. For behavior that depends on native permissions, hardware, accessibility, or sensors, include the required device/manual checks and name their actual coverage.
6. Secret/dependency/security checks and migration/configuration validation required for the change. Verify generated files are current without quietly modifying the candidate.
7. Final diff/message/ledger verification, with no conflict markers, accidental secrets, or unrelated content.

Native builds may require macOS or another platform-specific runner. Use a trusted pre-commit runner that can validate the same candidate tree before commit creation; otherwise wait until such validation is available. Do not claim a Windows check validates an iOS build. Ordinary CI triggered only after committing cannot satisfy this pre-commit requirement retroactively.

### Match the evidence to the actual commit

- Stage only when authorized. Identify the staged tree and intended parent/base. `git write-tree` writes a tree object representing the index; it does not create a commit. Capture its full object ID for validation evidence. [Git write-tree](https://git-scm.com/docs/git-write-tree).
- Validate in a clean isolated checkout/export of that tree, or prove the validation workspace matches it and contains no untracked/ignored inputs that affect the result. Do not rely only on `git status`; ignored files and local dependencies can change outcomes. Recreate dependencies from the declared inputs.
- Handle partial staging correctly: an unstaged fix must not make a broken staged file pass. Do not automatically stash, overwrite, or stage unrelated work to work around this problem. An isolated candidate workspace is preferable when the user's tree is dirty.
- Record tree ID, base/parent ID, tool versions, OS/architecture, relevant sanitized configuration, dependency/lockfile identity, commands/results, timestamp/time zone, and report/run references. Store bulky logs outside committed source with appropriate retention/access.
- Recheck tree ID and parent immediately before committing. Any change to code, tests, config, lockfiles, generated content, or other staged files invalidates the earlier full gate evidence; rerun for the new snapshot. Parent changes also require renewed evidence. A message-only edit needs message validation again but does not alter the tree.
- Do not place a report containing its own final tree ID inside that tree: this creates a self-reference. Keep the gate report external and place its identifier/tree ID in the commit message. A commit's own hash cannot be known in advance; do not invent one. Attach later CI links to the PR/status rather than amending history merely to insert them.
- Do not change the staged snapshot in hooks. If formatters fix files, stop, review/restage deliberately, and rerun the gate. Optimize with safe build caches keyed to inputs, not by reusing stale verdicts.

## 7. Enforcement setup when Git and the app exist

This section is an implementation contract, not an installed capability. Before the first application commit, implement and test it using the selected toolchain and existing repository mechanisms.

- A tracked `pre-commit` hook runs or verifies the complete gate for the final candidate and fails closed. A tracked `commit-msg` hook validates the subject, required sections, absence of placeholders, all paths/actions/counts/totals, and matching gate evidence. Message text saying `PASS` is never evidence by itself.
- Use one canonical gate implementation from local hooks and CI. Install hooks explicitly per clone/worktree and document activation. Inspect existing `core.hooksPath`, hooks, and tooling before configuring; integrate rather than replacing somebody's existing hooks.
- Add automated checks that a broken build, failing test, missing command, zero-test suite, wrong file count, stale tree evidence, and unstaged-fix/partial-staging case each prevent a commit. Also prove a valid candidate commits successfully in an isolated test repository. Test merge/amend workflows if supported.
- Policy forbids `--no-verify`, disabling hooks/checks, environment skip switches, lower-level commit creation, or alternate workflows to evade validation. New clones and GUI clients must be checked for hook activation. Do not claim local controls are tamper-proof.
- Require trusted CI checks and reviewed changes on protected shared branches once hosting exists. Validate the latest candidate and integration with the target branch; block stale results and bypass paths. Do not accept a skipped/neutral wrapper job as proof that required builds/tests ran. Configure platform-specific jobs explicitly. [Required status checks](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks).
- Account for squash/merge automation: it must preserve/rebuild the complete message and validate the final tree; a default one-line squash message is insufficient. If strict pre-creation validation cannot be provided by a hosted merge flow, use a compatible validated workflow rather than silently weakening this rule.

After authorized Git initialization, configure the template **locally**, preserving existing settings as appropriate:

```powershell
git config --local commit.template .gitmessage
```

The template aids interactive editing; it does not enforce anything and can be bypassed by `-m`/`-F`. For a prepared multiline message, save the exact text to a temporary UTF-8 file and use `git commit --file <message-file>` only after authorization and gate success. Do not interpolate multiline prose into a shell command. [Git commit documentation](https://git-scm.com/docs/git-commit).

## 8. Review checklist

- [ ] The commit is authorized, coherent, and complete.
- [ ] Subject and all twelve body sections follow the standard; no placeholders remain.
- [ ] Every changed path and LOC total reconciles with the declared base/candidate diff.
- [ ] All required builds/tests/functional checks passed for that exact candidate and environment.
- [ ] No failures, skips, unavailable platforms, or unrun checks are disguised as success.
- [ ] Decisions, ADRs, downloads, compatibility, data handling, and rollback are explicit.
- [ ] Deferred work is separate from completed work, actionable, and not required for this commit to function.
- [ ] Prose is direct and natural; no tool attribution, fake authorship, or sensitive information.
- [ ] Gate evidence is still valid immediately before commit; final message validation passed.

If any mandatory item fails, leave the changes uncommitted, report the blocker, and fix it. Do not create a broken checkpoint commit or weaken this policy as a shortcut.

## 9. Research and design rationale

Primary sources checked on 2026-10-19:

- [GitHub commit email privacy](https://docs.github.com/en/account-and-profile/how-tos/email-preferences/setting-your-commit-email-address): a noreply address can protect a personal email address in Git metadata; email addresses are not required in message prose.
- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/): predictable subjects and breaking-change trailers support scanning and tooling. The expanded body remains a project-specific choice.
- [Git commit](https://git-scm.com/docs/git-commit): separate subject/body and template/file support make detailed messages practical.
- [Git diff](https://git-scm.com/docs/git-diff): staged diffs, numerical statistics, rename handling and machine-safe path output support reproducible ledgers.
- [Git write-tree](https://git-scm.com/docs/git-write-tree): identify the indexed file snapshot before creating a commit.
- [Git hooks](https://git-scm.com/docs/githooks): local pre-commit/message checks can reject normal commit attempts, but have bypass limitations.
- [GitHub branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) and [status-check troubleshooting](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks): protected shared history needs correctly configured checks on current changes.

The example is fictional; its paths, test counts, commands, durations, and changes are not evidence about this workspace. The files created for this standard are documentation/template artifacts. No packages, SDKs, binaries, or other third-party artifacts were downloaded or installed for this work; web sources were read for research.
