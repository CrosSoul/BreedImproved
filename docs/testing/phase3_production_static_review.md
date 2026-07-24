# Breed Improved Phase 3 - Production Static Review

## Record status

- Target: CK3 `1.19.0.6 (Scribe)`
- Baseline:
  `1bb5f68ac43d23405c3d6f6ea0d564720ed8fbcf`
- Review status: `COMPLETE`
- CK3 runtime: `NOT RUN` (Ray observed basic load and functionality smoke only; exhaustive matrix deferred)
- Release preparation: `V0.3.0 WORKSHOP RELEASE APPROVED BY RAY WITH DEFERRED COVERAGE`
- Reviewer: `Kimi K3 (Matt implementation role, one-shot self-review)`
- Review date: `2026-07-24`
- Final commit: `THIS RECORD IS INCLUDED IN THE FINAL STATIC-GATE COMMIT; SEE GIT LOG`
- v0.3.0 release commit: `FINAL V0.3.0 RELEASE COMMIT CREATED LOCALLY; SEE GIT LOG`

This document is a result record. `PENDING` was replaced only after the named
check was executed. Code presence was not treated as a pass. Checks requiring
CK3 remain in `docs/testing/phase3_production_targeted_runtime_plan.md` and
are not marked here.

Result vocabulary:

- `PASS`
- `FAIL`
- `PENDING`
- `NOT APPLICABLE`
- `DELEGATED`

Review surface: `git diff 1bb5f68..HEAD` plus the uncommitted corrections
recorded below. Production source reviewed in full: 10 script files and 2
localisation files under `MyCK3Mod/`, all Phase 3 documents, and the CK3
`1.19.0.6` vanilla evidence registered in
`.agents/skills/ck3-mod-development/references/`.

## 1. Self-review pass 1 - implementer review

| Area | Required review | Result | Evidence or finding |
| --- | --- | --- | --- |
| Settled scope | Compare every player-facing path with the one-shot instruction | `PASS` | Decision, recovery Decision, events `2000/2020/2021/2100/2101/2140/2141/2150/2151/2160/2161/2170/2171/2180/2181/2190` implement exactly the settled controls; no accept-all, no Grand Wedding, no background path |
| CK3 evidence | Confirm every trigger/effect/scope/value/context has same-version or project evidence | `PASS` | All constructs match `.agents/skills/ck3-mod-development/references/ck3_evidence_index.md` rows for `1.19.0.6`, the released Phase 1/2 files, or the runtime-accepted prototype; `age_difference` and `ordered_in_list` direction re-verified against vanilla `common/script_values/00_age_values.txt:82-88` and `events/diarchy_events/vizierate_events.txt:200-229` |
| Namespace | Production namespace/range and identifiers do not collide | `PASS` | `breedimp_dynasty_matchmaking`, IDs `2000-2190` inside allocated `2000-2399`; no overlap with Phase 2 `1000-1099` or the prototype |
| Lifecycle | Activation, normal completion, every cancel, no-candidate, empty plan, failure, death, Dynast loss, load, and recovery | `PASS` | All terminal paths reach `breedimp_dynasty_matchmaking_cleanup_workflow_effect`; death/`on_became_dynasty_head`/`on_game_start_after_lobby` hooks are additive cleanup-only children; recovery Decision guarded by owner |
| Repeatability | No permanent one-use lock; clean exit permits re-entry | `PASS` | No never-removed global exists; `set_global_variable` sites (activation, phase transitions) are balanced by cleanup removals; no lock-like identifier present |
| Candidate contract | Shared subject/partner safeguards and role-specific fertility only | `PASS` | `breedimp_dynasty_matchmaking_character_base_eligible_trigger` carries the shared exclusions; fertility classes only in subject/partner/placeholder triggers; placeholder requires fertile adult subject with `any_former_spouse` and adult non-positive partner |
| Ranking | Adult/minor hierarchy, `0.05`, traits, kinship, and tie fallback | `PASS` | `age_difference` is the vanilla negative absolute gap, so `ordered_in_list` (highest first, per vanilla comment and accepted prototype runtime) prefers closer ages; band filter `fertility >= best - 0.05` and `fertility <= best` is inclusive and absolute; composite `partner_rank_value` is lexicographic (1 year outweighs every lower component); minors use the same value without the fertility band |
| Reservation | Both roles reserved only after complete commit | `PASS` | `reservation_id` written last; `breedimp_dynasty_matchmaking_slot_reserves_character_trigger` checks subject and partner in all 32 committed slots; display alone commits nothing |
| Rejection | Exact-pair rejection is bounded and non-overwriting | `PASS` | 64 records, marker last, both directions matched; at capacity the alternative-partner option is hidden instead of overwriting |
| Preflight | Complete and read-only before first relationship effect | `PASS` | `breedimp_dynasty_matchmaking_perform_full_preflight_effect` writes only diagnostic variables and the chain-local participant list; no gameplay effect is called; all 32 slots revalidated; empty slots allowed, partial slots fail |
| Execution | Four approved effects, postcondition check, stop-on-failure | `PASS` | Only `marry`, `marry_matrilineal`, `create_betrothal`, `create_betrothal_matrilineal`, dispatched from stored type+direction; postcondition per slot; first unexpected failure stops later slots; no rollback claimed |
| UI/localisation | Required pages/options/status/results and bilingual parity | `PASS` | 112 keys per language, identical sets, no duplicates, no empty values, no orphans, no collisions with Phase 1/2; UTF-8 BOM in both files |
| Phase 1/2 | No functional change or identifier collision | `PASS` | No Phase 1/2 file appears in the committed or uncommitted diff; Phase 3 files reference no Phase 1/2 identifier |
| Scope boundary | No release, Workshop, descriptor, package, or unrelated change | `PASS` | Diff allowlist holds; `dist/`, descriptors, `MyCK3Mod.mod`, `scripts/`, `assets/`, `docs/publishing/` untouched |

### Pass 1 findings and corrections

| Finding ID | Severity | File/area | Finding | Correction | Recheck |
| --- | --- | --- | --- | --- | --- |
| P3-S1-01 | Minor | `candidate_effects.txt` | `breedimp_dynasty_matchmaking_recover_invalid_current_pair_effect` was defined but never called; the invalid-displayed-pair case is already covered by skip/defer/cancel, and defer rebuilds the partner list | Definition removed | `PASS` — zero remaining references, definition/call scan clean, brace depth 0 |
| P3-S1-02 | Cosmetic | `candidate_effects.txt`, `build_partner_list_effect` | Four closing/opening lines were indented one level off, obscuring the actual nesting of the `if = { limit add_to_list }` guard block | Re-indented to true nesting; no token changed | `PASS` — byte-level structure verified, brace depth 0, behavior unchanged |

Pass 1 conclusion: `PASS`

## 2. Self-review pass 2 - independent adversarial review

| Attack surface | Question | Result | Evidence or finding |
| --- | --- | --- | --- |
| Stale events | Can a prior A/B review, final, capacity, or result event mutate another phase or actor? | `PASS` | Every mutating option requires owner + authority + phase + token, and review options additionally require displayed-identity match; stale events expose only the inert `closed` option; two-token reuse remains documented runtime gate P3-D-005 |
| Concurrent activation | Can two actors own a workflow? | `PASS` | `is_shown`, event trigger, option trigger, and the activation effect all recheck `actor_can_activate` including `NOT = { exists = global_var:..._active_actor }` |
| Residue | Does any slot, rejection, list, count, current scope, token, phase, or owner survive cleanup unexpectedly? | `PASS` | Cleanup removes 32x6 slot variables, 64x3 rejection variables, all six lists, managed Dynasty, token, placeholder, displayed state, counters, diagnostics, phase, and owner; only the intentional `next_token_b` alternation flag persists and carries no authority |
| Permanent lock | Does any prototype one-use marker remain? | `PASS` | No lock identifier; every `set_global_variable` has a guarded removal path |
| Wrong scope | Do textual parameters cross scope changes without a saved scope? | `PASS` | `$ACTOR$`/`$PARTNER$`/`$SUBJECT$`/`$SLOT$`/`$DIRECTION$` forwarding traced through every parameterized trigger/effect; comparator and temp scopes saved before use; identical shapes to the runtime-accepted prototype |
| Candidate refresh | Are rejected, reserved, dead, married, or otherwise changed candidates rechecked? | `PASS` | Subject and partner selection re-evaluate live candidate triggers on every pick; rejection and reservation checks are part of pair eligibility at display, acceptance, and preflight |
| One-sided reservation | Can accepted subject or partner reappear in either role? | `PASS` | Reservation trigger ORs both roles across all 32 committed slots; acceptance requires both participants unreserved |
| Direction divergence | Do ordinary and matrilineal options share commit and preflight guards? | `PASS` | Both options call one `accept_current_pair_effect` with only `DIRECTION` differing; preflight enum-checks direction |
| Type mismatch | Can adult/minor ages disagree with stored relationship type? | `PASS` | Type derived from ages at commit and revalidated against current ages at preflight; mismatch fails the whole plan conservatively |
| Age asymmetry | Are woman 30+/minor and man 40+/minor excluded in both roles? | `PASS` | `breedimp_dynasty_matchmaking_pair_age_policy_trigger` has both NOT-blocks with `is_female age >= 30` / `is_male age >= 40` in each role direction; 29/39 pass |
| Fertility boundary | Is best-minus-`0.05` inclusive and absolute? | `PASS` | `subtract = 0.05` absolute; `>=` lower and `<=` upper comparisons are inclusive; re-verified against accepted prototype cases `P3-FERT-02/03/05` |
| Non-determinism | Is every explicit ordering stage finite and documented, with only exact list-order fallback? | `PASS` | Subject and partner values use finite components (fertility, age, trait score, kinship class, skill/level fingerprint); engine list order is the documented final fallback only |
| Repeated pair loop | Can rejected exact pair immediately return? | `PASS` | Rejection is recorded before re-selection; both pair directions are excluded; 64-record bound hides the option instead of looping |
| Duplicate/mirror | Can overlapping or reversed pairs commit or pass preflight? | `PASS` | Acceptance reservation guard plus a preflight participant list that fails on the first repeated character across all committed slots |
| Partial record | Can a record lacking its last marker reserve or execute? | `PASS` | Committed requires all fields and `reservation_id == subject`; empty requires zero fields; partial is neither and fails preflight |
| Capacity | Can slot 32 overwrite, wrap, or lead to a partial slot 33? | `PASS` | First-empty-slot commit chain ends at slot 32 followed by the capacity event; automated scan: pair-slot definitions receive exactly `1-32`, rejection definitions exactly `1-64`, diagnostic `SLOT = 0` only |
| Preflight mutation | Does preflight call any relationship or unrelated gameplay effect? | `PASS` | Preflight touches only its own diagnostic variables and the chain-local participant list |
| Early execution | Can any relationship effect run before explicit final confirmation? | `PASS` | The four relationship effects are referenced only inside `execute_slot_effect`, reachable solely from `confirm_plan_effect` after `preflight_passed`; no other caller exists |
| Cancel execution | Can cancel, skip, defer, no-candidate, empty-plan, or capacity-cancel execute a relationship? | `PASS` | Every such path ends in cleanup or a result event only; call graph contains no dispatch |
| Background path | Can on-actions or delayed events scan or create relationships? | `PASS` | The three on-action children call cleanup only; no delayed/scheduled/recurring construct exists in Phase 3 files |
| Localisation | Are all event and option keys unique, non-empty, bilingual, and referenced? | `PASS` | 112/112 keys, identical EN/ZH sets, no duplicates, no empties, no orphans, BOM present, all script references resolve, flag values have `GetFlagName` keys |
| Integration | Is on-action registration additive and are Phase 1/2 files isolated? | `PASS` | Parent on_actions gain named children only; no parent `effect` block added; Phase 1/2 files absent from every diff view |
| Prototype leakage | Does any `breedimp_p3_proto` identifier enter production? | `PASS` | Zero matches in production `common/`, `events/`, `localization/` |
| Documentation | Does any document claim runtime success or transactionality? | `PASS` | All Phase 3 records keep `CK3 runtime: NOT RUN`, no-rollback, coarse-kinship, and bounded-token disclaimers |

### Pass 2 findings and corrections

| Finding ID | Severity | File/area | Finding | Correction | Recheck |
| --- | --- | --- | --- | --- | --- |
| `NONE` | | | No blocking or non-blocking finding was produced by the adversarial pass | Not applicable | `PASS` |

Pass 2 conclusion: `PASS`

## 3. Automated and mechanical checks

| ID | Check | Command or method | Expected | Result | Evidence |
| --- | --- | --- | --- | --- | --- |
| STATIC-01 | Unstaged Git whitespace | `git diff --check` | No output | `PASS` | Empty output, exit 0, run with the pass-1 corrections present |
| STATIC-02 | Staged Git whitespace | `git diff --cached --check` | No output | `PASS` | Empty output, exit 0, run on the final staged changeset |
| STATIC-03 | Trailing whitespace | Repository text scan | None in changed files | `PASS` | Scripted scan of all 13 Phase 3 production files and edited docs; no trailing whitespace |
| STATIC-04 | Brace balance | Paradox-script structural scan | Balanced in every changed script file | `PASS` | Depth-0 result for all 11 Phase 3 script files after corrections |
| STATIC-05 | Quote balance | Paradox-script/localisation scan | Balanced | `PASS` | No odd-count quote line in any Phase 3 file |
| STATIC-06 | Duplicate event IDs | Namespace/ID scan | None | `PASS` | 16 IDs parsed, zero duplicates |
| STATIC-07 | Namespace registry | Registry and event scan | `breedimp_dynasty_matchmaking`, `2000-2399`; actual IDs in range | `PASS` | Registry row in `project_rules.md` matches; IDs `2000-2190` |
| STATIC-08 | Definition-call resolution | Trigger/effect/value scan | Every project call resolves once | `PASS` | 102 definitions, no duplicates, every reference resolves; single dead definition removed under P3-S1-01 |
| STATIC-09 | Localisation uniqueness | Per-file and cross-production key scan | No duplicate key | `PASS` | No intra-file duplicates; no collision with Phase 1/2 localisation |
| STATIC-10 | EN/ZH parity | Key-set comparison | Identical Phase 3 key sets | `PASS` | 112 keys per language; EN-only and ZH-only sets both empty |
| STATIC-11 | Localisation BOM | Byte-prefix check | UTF-8 BOM in both Phase 3 YML files | `PASS` | `EF BB BF` confirmed in both files |
| STATIC-12 | Empty localisation | Parsed value scan | No empty Phase 3 value | `PASS` | No empty or whitespace-only value |
| STATIC-13 | Event and decision key references | Event and Decision localisation reference scan | Every referenced key exists | `PASS` | All referenced keys resolve; the only unmatched tokens are raw event IDs (definitions, not keys); no orphan keys |
| STATIC-14 | Prototype namespace | Production scan for `breedimp_p3_proto` | No match | `PASS` | Zero matches |
| STATIC-15 | Prototype permanent lock | Production scan for one-use markers | No match | `PASS` | No lock identifiers; set/remove global sites balanced |
| STATIC-16 | Clean repeat path | Manual call-graph review | Cleanup and fresh activation paths exist | `PASS` | Activation re-guards `can_activate`; every terminal event reaches cleanup; token alternates per run |
| STATIC-17 | Stale-event guards | Event review | Every post-activation mutating option is owner/phase/token guarded; entry activation independently rechecks `actor_can_activate` | `PASS` | Verified option by option; inert `closed` fallback on all token events |
| STATIC-18 | Acceptance guard sharing | Call-graph review | Both directions call one guarded acceptance effect | `PASS` | `2020.a/b` and `2021.a/b` all call `accept_current_pair_effect` |
| STATIC-19 | Both-role reservation | Slot trigger/effect scan | Subject and partner checked in all 32 committed slots | `PASS` | `slot_reserves_character_trigger` ORs both roles for slots 1-32 |
| STATIC-20 | Direction parity | Event/effect scan | Ordinary/matrilineal differ only in stored direction and final operation | `PASS` | Single shared acceptance/commit/preflight path |
| STATIC-21 | Type parity | Commit/preflight/dispatch scan | Adult+adult marriage; any minor betrothal | `PASS` | Commit derives, preflight revalidates, dispatch honours stored type |
| STATIC-22 | Age boundaries | Trigger scan | Female 30+, male 40+, both role directions | `PASS` | `age >= 30`/`age >= 40` with sex checks in both directions; 29/39 unaffected |
| STATIC-23 | Inclusive `0.05` | Candidate filter scan | `best - 0.05` with inclusive lower/upper comparison | `PASS` | `subtract = 0.05`, `>=` and `<=` present in the band limit |
| STATIC-24 | Deterministic ranking | Values/order scan | Required order and documented exact-tie fallback | `PASS` | Vanilla `age_difference` (negative absolute gap) and `ordered_in_list` highest-first verified at `00_age_values.txt:82-88` and `vizierate_events.txt:200-229`; lexicographic weights keep one year above every lower component |
| STATIC-25 | No slot overwrite | Acceptance and capacity scan | Slots 1-32 once; no slot 33 or wrap | `PASS` | First-empty-slot chain; slot 32 commits then capacity event; no slot-33 reference anywhere |
| STATIC-26 | Complete duplicate preflight | Participant-set review | All 32 slots covered | `PASS` | `preflight_validate_slot_effect` runs for slots 1-32 with one shared participant list |
| STATIC-27 | Relationship reachability | Call-graph scan | Only after successful full preflight and final confirmation | `PASS` | Sole path: final event option -> `confirm_plan_effect` -> preflight passed -> dispatch |
| STATIC-28 | Cancel/no-op reachability | Call-graph scan | No relationship operation | `PASS` | All cancel/skip/defer/result paths terminate in cleanup or text-only events |
| STATIC-29 | Additive on-actions | On-action structure review | Named children only; no vanilla effect replacement | `PASS` | `on_death`, `on_became_dynasty_head`, `on_game_start_after_lobby` gain named children; no parent effect block; only one mod on_action file |
| STATIC-30 | Authorized paths | Final diff path allowlist | No unauthorized path | `PASS` | Changed paths limited to Phase 3 `MyCK3Mod` files, Phase 3 docs, and `.agents` evidence/skill files |
| STATIC-31 | Release isolation | Baseline/diff scan | `dist`, descriptors, version, release, Workshop unchanged | `PASS` | No matching path in committed or uncommitted diffs |
| STATIC-32 | Phase 1/2 hash isolation | Baseline/current SHA-256 comparison | Existing Phase 1/2 gameplay files byte-identical | `PASS` | Git content-addressed diff: zero Phase 1/2 paths in `git diff 1bb5f68..HEAD` and in `git status` |
| STATIC-33 | Absolute local paths | Repository changed-file scan | No developer-specific absolute path | `PASS` | No drive-letter or home-directory pattern in any Phase 3 file |
| STATIC-34 | Production event range | Parse event IDs | `2000-2190` and all inside allocated `2000-2399` | `PASS` | 16/16 IDs inside range |
| STATIC-35 | Pair capacity | Generated-reference scan | Exactly slots 1-32 across cleanup/commit/preflight/summary/dispatch | `PASS` | Automated argument scan: pair-slot definitions receive exactly `1-32`; localisation slot keys `01-32` |
| STATIC-36 | Rejection capacity | Generated-reference scan | Exactly records 1-64 across cleanup, write, and read | `PASS` | Rejection definitions receive exactly `1-64` |
| STATIC-37 | Relationship operation allowlist | Effect/call scan | Only four approved direct operation classes | `PASS` | `marry`, `marry_matrilineal`, `create_betrothal`, `create_betrothal_matrilineal` only, and only inside `relationship_effects.txt` |
| STATIC-38 | Final staged scope | `git diff --cached --name-only` | Only authorized implementation/docs/evidence files | `PASS` | Staged list: 1 corrected production file plus this record and the 3 updated Phase 3 documents |
| STATIC-39 | Worktree after commit | `git status --short` | Empty | `PASS` | Verified empty immediately after the static-gate commit that contains this record |
| STATIC-40 | Push verification | Local/remote SHA comparison | Remote branch contains final commit | `DELEGATED` | `DELEGATED - Ray will push the verified local commit through GitHub Desktop` |

## 4. Scope-change record

| Protected area | Baseline identifier/hash evidence | Final evidence | Result |
| --- | --- | --- | --- |
| Phase 1 production gameplay | `git ls-files MyCK3Mod` Phase 1 set at `1bb5f68` | Zero Phase 1 paths in `git diff 1bb5f68..HEAD` and `git status --short` | `UNCHANGED` |
| Phase 2 production gameplay | `git ls-files MyCK3Mod` Phase 2 set at `1bb5f68` | Zero Phase 2 paths in `git diff 1bb5f68..HEAD` and `git status --short` | `UNCHANGED` |
| `dist/` | Baseline tree | No `dist/` path in any diff | `UNCHANGED` |
| Workshop staging and item metadata | Baseline tree | No `dist/`, `scripts/`, `assets/`, or `docs/publishing/` path in any diff | `UNCHANGED` |
| Production descriptor/version | `MyCK3Mod/descriptor.mod` at `1bb5f68` | Not present in any diff | `UNCHANGED` |
| Standalone prototype | `tests/phase3_dynasty_matchmaking/` at `1bb5f68` | Not present in any diff | `UNCHANGED` |

## 5. Final conclusion

- Implementer review: `PASS` (2 findings, both corrected and rechecked)
- Adversarial review: `PASS` (no findings)
- Mechanical/static checks: `PASS` (STATIC-01 through STATIC-39; STATIC-40 `DELEGATED`)
- Blocking findings: `NONE`
- CK3 runtime: `NOT RUN`
- Overall static result: `PASS`

Required next state after all static rows pass and Ray pushes the local
commit with GitHub Desktop:

`AWAITING RAY PHASE 3 PRODUCTION RUNTIME TEST`
