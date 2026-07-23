# Breed Improved Phase 3 - Production Implementation Handoff

## Status

- CK3 target: `1.19.0.6 (Scribe)`
- Accepted baseline:
  `1bb5f68ac43d23405c3d6f6ea0d564720ed8fbcf`
- Production implementation: `PRESENT IN SOURCE`
- Static validation: `SEE docs/testing/phase3_production_static_review.md`
- CK3 runtime: `NOT RUN`
- Release approval: `NOT GRANTED`
- Workshop/release files: `OUT OF SCOPE`

This handoff separates code presence, static evidence, and runtime evidence. It
must not be used to claim CK3 behavior before Ray completes the targeted
production pass.

## 1. Implemented in code

### Player workflow

- One **Manage Dynasty Matchmaking** Decision for a living player Dynast.
- One pre-activation confirmation that creates no state when cancelled.
- One explicit recovery Decision for an interrupted active workflow.
- Review options for ordinary accept, matrilineal accept, another partner,
  skip, defer, finish early, and complete cancellation.
- Final summary with execute or cancel/restart behavior.
- Visible no-candidate, empty-plan, capacity, preflight-failure, success,
  partial-execution, and recovery outcomes.

### Authority and lifecycle

- One global active workflow.
- Workflow-scoped Dynast override for current-Dynasty AI participants.
- Actor/Dynasty/phase/token guards.
- Alternating A/B token events.
- Central cleanup of plan, rejection, list, cursor, count, diagnostic, phase,
  and owner state.
- Additive cleanup children for actor death, Dynast change, and load.
- No recurring, delayed, or background candidate or relationship execution.

### Candidate contract

- Alive same-Dynasty AI characters only.
- Unmarried and unbetrothed.
- Available, not travelling, not incapable.
- Not imprisoned, hostage, concubine, pregnant, pool guest, or celibate.
- Mutual vanilla marriage legality and direct-ancestry exclusion.
- Accepted-character reservation in both roles.
- Eligible landed rulers, external-court members, and cadet-House members remain
  inside the supported class.

### Ranking

- Deterministic subject ordering with minors first.
- Adult best-fertility band through inclusive best-minus-`0.05`.
- Age, known-vanilla congenital score, coarse kinship, and finite tie
  fingerprint inside the adult band.
- Age, congenital, kinship, and finite tie fingerprint for minors.
- Both adult-minor age hard limits in both role directions.
- Known positive and negative congenital traits; unknown/modded traits ignored.
- Coarse legal-kin preference; no exact coefficient claim.

### Plan and execution

- 32 fixed six-field pair slots, reserving at most 64 characters.
- 64 fixed rejected-pair records.
- Commit markers written last.
- Acceptance-time overlap/mirror rejection.
- Final duplicate/mirror defense using the complete participant set.
- Marriage for adult+adult and betrothal for every pair containing a minor.
- Ordinary and matrilineal direct effects only after whole-plan preflight.
- Sequential postcondition checks and stop-on-first-unexpected-failure behavior.
- No rollback and no additional compensating gameplay effects.

### Localisation

- English and Simplified Chinese production localisation.
- Decision, authority warning, capacity, proposal, fertility, relationship
  type, placeholder, trait, kinship, review, final, result, and recovery text.

## 2. Production source files

Created for Phase 3:

- `MyCK3Mod/common/decisions/breedimp_dynasty_matchmaking_decisions.txt`
- `MyCK3Mod/common/on_action/breedimp_dynasty_matchmaking_on_actions.txt`
- `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_lifecycle_triggers.txt`
- `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_candidate_triggers.txt`
- `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_plan_triggers.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_lifecycle_effects.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_candidate_effects.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_plan_effects.txt`
- `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_relationship_effects.txt`
- `MyCK3Mod/common/script_values/breedimp_dynasty_matchmaking_values.txt`
- `MyCK3Mod/events/breedimp_dynasty_matchmaking_events.txt`
- `MyCK3Mod/localization/english/breedimp_dynasty_matchmaking_l_english.yml`
- `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_matchmaking_l_simp_chinese.yml`

The documentation and test records created or updated in the same pass are
listed by the final Git report.

## 3. Statically validated

Static validation is not inferred from this handoff. The source of truth is:

`docs/testing/phase3_production_static_review.md`

That record must contain the actual result of:

- both self-review passes;
- Paradox-script structure and reference checks;
- event and namespace collision checks;
- lifecycle, token, reservation, capacity, ranking, and reachability checks;
- bilingual localisation parity, uniqueness, non-empty values, and BOM;
- Phase 1/2 isolation;
- authorized-path and release-scope checks;
- `git diff --check`; and
- final staged-diff and clean-worktree checks.

Until that record is completed, the correct status is
`STATIC VALIDATION NOT YET RECORDED`.

## 4. Awaiting CK3 runtime

All production behavior remains runtime-unverified. Ray's ordered checklist is:

`docs/testing/phase3_production_targeted_runtime_plan.md`

The first must-pass gates are integrated load, Phase 1/2 regression smoke,
pre-activation cancel, review cancel, final cancel, one ordinary marriage,
clean repeat activation, and an error-log review. Broader testing covers all
four relationship forms, reservation, rejection, ranking, placeholders,
external-court and landed cases, invalidation, capacity, lifecycle recovery,
save/load, scale, side effects, and localisation.

## 5. Prototype-only behavior removed

The production implementation does not carry:

- namespace `breedimp_p3_proto_matchmaking`;
- any `breedimp_p3_proto_` identifier;
- the permanent one-workflow-per-save lock;
- the prototype 16-pair limit;
- test Mod descriptor or launcher metadata;
- test-only diagnostics or copy;
- prototype one-use lifecycle assumptions; or
- any dependency on `tests/phase3_dynasty_matchmaking/`.

The standalone prototype remains a historical test instrument and is not part
of production loading or release packaging.

## 6. Known production limitations

- Capacity is 32 accepted pairs per run and is intentionally visible.
- Rejected-pair history is bounded at 64 records per run.
- Only one Phase 3 workflow can be active globally.
- Alternating A/B tokens are a bounded stale-event defense, not an unbounded
  numeric run ID.
- No generic visible-event close callback is claimed; abnormal interruption
  uses explicit recovery and load cleanup.
- Final confirmation does not edit individual pairs; the player cancels and
  restarts.
- No external-Dynasty partner, other-player consent, Grand Wedding, accept-all,
  political scoring, or automated court movement exists.
- Known vanilla congenital traits are scored; unknown/modded trait groups are
  ignored safely.
- Kinship is a coarse preference category, not an exact relatedness value.
- Former-spouse history supports the fallback rule but does not reliably label
  every divorce versus widow case.
- CK3 direct effects are not transactional. A post-effect failure can leave
  earlier relationships valid.

## 7. Release blockers

Phase 3 may not be released until:

1. the final static record has no unresolved blocking finding;
2. Ray completes the must-pass production smoke;
3. repeatability, stale-event recovery, all four relationship forms, 32-pair
   capacity, eligibility, ranking, placeholder, preflight, save/load, and
   direct-effect side effects are reviewed;
4. Phase 1 and Phase 2 production regression passes;
5. English and Simplified Chinese UI passes;
6. CK3 `error.log` has no blocking Phase 3 error; and
7. Jay/Boss explicitly approves release work.

No Workshop upload, package rebuild, version change, tag, or GitHub Release is
authorized by this handoff.

## 8. Handoff state

When the static review record is complete and the implementation commit is
pushed, the required engineering stop state is:

`AWAITING RAY PHASE 3 PRODUCTION RUNTIME TEST`
