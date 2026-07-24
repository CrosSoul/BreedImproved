# Breed Improved Phase 3 - Production Implementation Plan

## Status

- Authorization: `ONE-SHOT PRODUCTION IMPLEMENTATION AUTHORIZED`
- CK3 target: `1.19.0.6 (Scribe)`
- Accepted baseline:
  `1bb5f68ac43d23405c3d6f6ea0d564720ed8fbcf`
- Production source: `MyCK3Mod/`
- Runtime: `NOT RUN`
- Workshop/release: `OUT OF SCOPE`

This plan is an execution record, not an approval gate. Design choices are
closed in
`docs/Matt_to_Jay_Phase3_Production_Decision_Register.md`.

## 1. Invariants

Every stage must preserve these invariants:

1. Phase 1 and Phase 2 gameplay behavior is unchanged.
2. Phase 3 is player initiated and requires a living current Dynast.
3. Only AI-controlled members of the recorded current Dynasty participate.
4. Temporary authority exists only while the recorded workflow is valid.
5. Review and final cancellation create no relationship.
6. A committed participant appears in at most one accepted pair.
7. No relationship effect is reachable before complete final preflight.
8. Any failed preflight executes zero pairs.
9. Any unexpected post-effect failure stops later slots and attempts no
   rollback.
10. No automatic, scheduled, recurring, or background matchmaking exists.
11. Production and prototype namespaces never cross.
12. Release, Workshop, descriptor, version, and package files remain
    untouched.

## 2. Production file map

### Entry and lifecycle

- `MyCK3Mod/common/decisions/breedimp_dynasty_matchmaking_decisions.txt`
- `MyCK3Mod/common/on_action/breedimp_dynasty_matchmaking_on_actions.txt`
- `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_lifecycle_triggers.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_lifecycle_effects.txt`

### Candidate discovery and ranking

- `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_candidate_triggers.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_candidate_effects.txt`
- `MyCK3Mod/common/script_values/breedimp_dynasty_matchmaking_values.txt`

### Plan integrity and execution

- `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_plan_triggers.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_plan_effects.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_relationship_effects.txt`

### UI

- `MyCK3Mod/events/breedimp_dynasty_matchmaking_events.txt`
- `MyCK3Mod/localization/english/breedimp_dynasty_matchmaking_l_english.yml`
- `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_matchmaking_l_simp_chinese.yml`

### Records and tests

- `docs/Matt_to_Jay_Phase3_Production_Design_and_Gap_Closure.md`
- `docs/Matt_to_Jay_Phase3_Production_Decision_Register.md`
- this implementation plan
- `docs/testing/phase3_production_gap_matrix.md`
- `docs/testing/phase3_production_targeted_runtime_plan.md`
- `docs/Matt_to_Jay_Phase3_Production_Implementation_Handoff.md`
- `docs/testing/phase3_production_static_review.md`
- `docs/roadmap.md`

## 3. Execution stages

### Stage P3-PROD-0 - Baseline and evidence closure

Status: `COMPLETE`

- Confirm accepted prototype baseline and mapped runtime evidence.
- Recheck CK3 `1.19.0.6` evidence for every reused trigger, effect, scope,
  Decision, event, variable, list, value, and on-action form.
- Allocate production namespace `breedimp_dynasty_matchmaking`, event range
  `2000-2399`.
- Record every delegated product decision.
- Preserve runtime-only uncertainty explicitly.

Exit criterion: no guessed CK3 construct is required by the production design.

### Stage P3-PROD-1 - Repeatable lifecycle

Status: `IMPLEMENTED; STATIC GATE PASS`

- Add player-only Dynast Decision and pre-activation confirmation.
- Add one global active actor and one global phase.
- Add actor-owned managed Dynasty and alternating A/B token.
- Add centralized cleanup for 32 pair records, 64 rejection records, lists,
  counters, current proposal state, and diagnostics.
- Add review/final/result token guards.
- Add explicit interrupted-workflow recovery Decision.
- Add lifecycle cleanup children for actor death, Dynast change, and load.

Exit criterion: a clean terminal path removes authority and allows another
activation; an interrupted path has a visible cleanup route and no background
execution.

### Stage P3-PROD-2 - Candidate eligibility and deterministic ranking

Status: `IMPLEMENTED; STATIC GATE PASS`

- Implement shared base eligibility.
- Preserve mutual `can_marry_character_trigger` and direct-ancestry checks.
- Apply both adult-minor age limits in both roles.
- Allow landed/external-court same-Dynasty AI participants.
- Implement subject order.
- Implement adult best-minus-`0.05` band and strict within-band ranking.
- Implement minor ranking.
- Implement finite known-vanilla congenital score and coarse kinship score.
- Implement normal and zero-fertility fallback candidate classes.

Exit criterion: candidate generation mutates no gameplay relationship and has
no unbounded all-pairs persistent table.

### Stage P3-PROD-3 - Review and bounded plan

Status: `IMPLEMENTED; STATIC GATE PASS`

- Store up to 32 complete six-field pair records.
- Write reservation marker last.
- Reserve subject and partner only after complete commit.
- Reject duplicate and mirror participation at acceptance.
- Store up to 64 complete rejected-pair records.
- Implement ordinary/matrilineal accept, another partner, skip, defer, finish
  early, and cancel.
- Stop safely at capacity without overwrite or partial record.

Exit criterion: every pre-confirmation path creates zero marriages and zero
betrothals.

### Stage P3-PROD-4 - Full preflight and guarded execution

Status: `IMPLEMENTED; STATIC GATE PASS`

- Revalidate active authority and token.
- Validate all 32 slots as committed-and-currently-valid or completely empty.
- Validate enum values, relationship type, placeholder policy, and count.
- Use one participant list to detect duplicate or mirrored use.
- Fail the complete batch before mutation when any check fails.
- Dispatch only the four approved relationship effects after a successful
  preflight.
- Verify each postcondition and stop after the first unexpected failure.
- Record success or partial-result counts before final cleanup.

Exit criterion: no relationship effect can be reached from review, skip,
defer, cancel, no-candidate, empty-plan, capacity-cancel, or failed-preflight
paths.

### Stage P3-PROD-5 - Events and localisation

Status: `IMPLEMENTED; STATIC GATE PASS`

- Add A/B review, final confirmation, capacity, failed-preflight, success, and
  partial-failure events.
- Add no-candidate, empty-plan, and recovery results.
- Display authority warning, 32-pair capacity, current proposal, type,
  placeholder state, congenital warnings, kinship category, accepted count,
  final plan, and result counts.
- Add matching English and Simplified Chinese keys and UTF-8 BOM.

Exit criterion: every referenced key is present, unique, non-empty, and
bilingual.

### Stage P3-PROD-6 - Two-pass self-review

Status: `COMPLETE — BOTH PASSES RECORDED`

Pass 1 reviewed each changed file against the settled requirements and
evidence. Pass 2 started from the corrected diff and challenged lifecycle,
scope, token, reservation, ranking, preflight, execution, localisation, and
integration. Pass 1 produced and closed two findings (one dead definition,
one indentation correction). Pass 2 produced no findings.

The results are recorded in
`docs/testing/phase3_production_static_review.md`.

### Stage P3-PROD-7 - Static and repository validation

Status: `COMPLETE — STATIC-01..39 PASS, STATIC-40 DELEGATED`

Run all checks listed in Section 16 of the one-shot instruction, including:

- Git whitespace checks;
- structure and reference resolution;
- event/namespace collisions;
- bilingual localisation parity, uniqueness, non-empty values, and BOM;
- capacity, rejection, reservation, relationship-type, age, and ranking
  invariants;
- stale-event and lifecycle path review;
- relationship reachability review;
- additive on-action integration;
- Phase 1/2 isolation;
- prototype identifier leakage;
- absolute-path and release-scope checks; and
- final clean-worktree verification after commit.

Exit criterion: the static review record contains no unresolved blocking
finding.

### Stage P3-PROD-8 - Ray runtime gate

Status: `NOT RUN`

Ray follows
`docs/testing/phase3_production_targeted_runtime_plan.md`, records exact CK3
observations, and returns logs and screenshots or save evidence where useful.
No static inference may be converted into a runtime pass.

Exit criterion: Jay/Boss reviews Ray's evidence and separately approves any
release work.

## 4. Commit and handoff gate

After Stage P3-PROD-7 passed:

1. the complete authorized diff was reviewed;
2. the production corrections and records were committed locally;
3. the push is delegated to Ray through GitHub Desktop because this
   environment has no GitHub network access;
4. no packaging, tagging, release, or Workshop upload was performed; and
5. the pushed commit must be verified by Ray after the push.

Current stop state:

`AWAITING RAY MANUAL GITHUB DESKTOP PUSH`

After the push, the required stop state is:

`AWAITING RAY PHASE 3 PRODUCTION RUNTIME TEST`
