# Breed Improved Phase 3 - Targeted Production Runtime Plan

## Status

- CK3 target: `1.19.0.6 (Scribe)`
- Build: `PRODUCTION SOURCE UNDER MyCK3Mod/`
- Tester: `Ray`
- Runtime status: `LIMITED RUNTIME ACCEPTANCE — V0.3.0 WORKSHOP RELEASE APPROVED BY RAY; EXHAUSTIVE MATRIX DEFERRED`
- Workshop status: `V0.3.0 UPLOAD PREPARATION — UPDATE EXISTING ITEM 3769010534`

This checklist is for the first integrated Phase 3 production pass. It does not
inherit prototype passes. Record `PASS`, `FAIL`, `BLOCKED`, or `NOT RUN` only
from the production build.

Ray has approved the v0.3.0 Workshop release based on observed Mod load,
Phase 1/2/3 visibility, and basic matchmaking/betrothal gameplay smoke. The
targeted functional, ranking, lifecycle, capacity, stress, and regression rows
below remain unexecuted and are deferred to a future patch. Do not convert
unexecuted rows to `PASS`.

## 0. Local installation and evidence discipline

1. Create or refresh a launcher-managed **local Mod** entry that points to the
   repository's `MyCK3Mod/` production Mod directory.
2. Do not point the entry to `tests/`, `dist/`, or Workshop staging.
3. Enable only Breed Improved for the first smoke pass.
4. Record the exact commit, CK3 version, DLC, game rules, language, load order,
   and save used.
5. Use a disposable save or verified backup. Preserve before-state evidence for
   every relationship test.
6. Before final confirmation, inspect both participants and verify that no
   marriage, betrothal, alliance, court, title, government, House, Dynasty,
   claim, inheritance, opinion, stress, hook, memory, or resource state changed.
7. After execution, save, reload, advance one day, then one month where safe,
   and inspect the same fields.
8. Preserve the CK3 `error.log` produced by the test session. Each game
   launch overwrites the previous session's logs, so capture them before
   launching any other configuration.

### 0.1 Playset pre-flight check (required once per Mod configuration)

A Mod entry that exists in the launcher library is not automatically inside
the active playset. Before every first launch of a new configuration:

1. Open the active playset in the launcher's playset editor, not the Mods
   library, and confirm the **Breed Improved - Local Runtime** entry is
   listed as a playset member and toggled on. Add it to the playset first if
   it is absent from the member list.
2. Launch through the launcher, then before loading a save verify on disk
   that `dlc_load.json` contains
   `mod/Breed Improved - Local Runtime.mod`. If it does not, the game never
   received the Mod; fix playset membership and relaunch.
3. Console checks once in game: `event breedimp_dynasty_cleanup.1001` must
   resolve (Phase 2 is Workshop-proven); `event breedimp_dynasty_matchmaking.2000`
   must not report `not a valid id`. If the Phase 2 event resolves but the
   Phase 3 event does not, report immediately as a Phase 3 registration
   defect instead of continuing.

Incident 2026-07-24: SMOKE-01 initially reported `FAIL` because the
production entry was never a member of the active playset; the game loaded
no Breed Improved content at all. Static diagnosis confirmed every
repository file, the descriptor, and the launcher entry were healthy, and
the prototype run proved the local-Mod pipeline. Re-run SMOKE-01 after the
pre-flight check. Benign `should be in utf8-bom encoding` lexer warnings for
`.txt` files are expected and non-blocking; the accepted prototype produced
the same warnings.

Do not edit the repository descriptor with a local absolute path. The outer
local `.mod` entry is launcher-managed and is not committed.

### Environment record

| Field | Observation |
| --- | --- |
| Test date | `NOT RUN` |
| Tester | `Ray` |
| Production commit | `NOT RUN` |
| CK3 exact build | `NOT RUN` |
| DLC | `NOT RUN` |
| Game rules | `NOT RUN` |
| Language | `NOT RUN` |
| Other Mods | `NOT RUN` |
| Playset/load order | `NOT RUN` |
| Save identifier | `NOT RUN` |
| Error-log path reviewed | `NOT RUN` |

## 1. Must-pass smoke before broader testing

| ID | Setup and action | Expected result | Evidence to return | Result |
| --- | --- | --- | --- | --- |
| P3-PROD-SMOKE-01 | Load production Breed Improved with Phase 1-3 together. Open Decisions and a valid Phase 1 target. | Mod loads; Phase 1 interaction, Phase 2 Decision, and Phase 3 Decision are all present where valid. | Screenshots and error-log excerpt. | `NOT RUN` |
| P3-PROD-SMOKE-02 | Execute one known-good Phase 1 exile case. | Existing Phase 1 behavior and consequences remain unchanged. | Before/after target state. | `NOT RUN` |
| P3-PROD-SMOKE-03 | Open Phase 2 cleanup and cancel before execution. | Existing Phase 2 flow opens and cancels without state change. | Screenshots and before/after Dynasty state. | `NOT RUN` |
| P3-PROD-SMOKE-04 | As a living player Dynast, open Phase 3, then choose the pre-activation cancel option. | No workflow state is created; Phase 3 can be opened again immediately. | Decision visibility before/after. | `NOT RUN` |
| P3-PROD-SMOKE-05 | Confirm Phase 3 activation with at least one eligible pair. | One proposal appears; authority/capacity warning and both characters render correctly; no relationship exists yet. | Proposal screenshot and before-state. | `NOT RUN` |
| P3-PROD-SMOKE-06 | From review, cancel the workflow. | All temporary state clears, no relationship is created, and a new run may start. | Before/after relationships and Decision visibility. | `NOT RUN` |
| P3-PROD-SMOKE-07 | Accept one pair, reach final confirmation, then cancel. | Accepted plan is discarded, no relationship is created, and a new run may start. | Final summary plus before/after relationships. | `NOT RUN` |
| P3-PROD-SMOKE-08 | Complete one ordinary adult pair through final confirmation. | Exactly one marriage is created; completion reports one pair/one marriage/zero betrothals. | Before/after, result event, save/reload. | `NOT RUN` |
| P3-PROD-SMOKE-09 | Start a second clean workflow in the same save after SMOKE-08. | Phase 3 activates normally; no prototype one-use lock remains. | Second-run proposal and Decision state. | `NOT RUN` |
| P3-PROD-SMOKE-10 | Review the session's CK3 error log after the smoke suite. | No blocking Phase 3 parse, scope, event, localisation, effect, or on-action error. | Full relevant log excerpt. | `NOT RUN` |

Stop broader testing if any smoke case fails.

## 2. Targeted functional tests

| ID | Setup and action | Expected result | Evidence to return | Result |
| --- | --- | --- | --- | --- |
| P3-PROD-FUNC-01 | Two eligible adults; accept ordinary. | Ordinary marriage is created only after final confirmation. | Relationship direction, spouse state, pre-confirmation comparison. | `NOT RUN` |
| P3-PROD-FUNC-02 | Two eligible adults; accept matrilineal. | Matrilineal marriage is created only after final confirmation. | Marriage direction and spouse state. | `NOT RUN` |
| P3-PROD-FUNC-03 | Pair containing a minor; accept ordinary. | Ordinary betrothal is created, not marriage. | Ages, stored type display, betrothed state. | `NOT RUN` |
| P3-PROD-FUNC-04 | Pair containing a minor; accept matrilineal. | Matrilineal betrothal is created, not marriage. | Ages, direction, betrothed state. | `NOT RUN` |
| P3-PROD-FUNC-05 | Accept A+B, then continue through many proposals. | Neither A nor B reappears as subject or partner. | Proposal log/screenshots and final plan. | `NOT RUN` |
| P3-PROD-FUNC-06 | Display A+B but choose another/skip without accepting; later permit A or B in a new legal pair. | Display alone reserves nobody; a later unaccepted-character pairing remains possible. | Proposal sequence. | `NOT RUN` |
| P3-PROD-FUNC-07 | On A+B choose **Show me another partner**. | The next proposal for A is not immediately A+B; no relationship or reservation is created. | Consecutive proposal screenshots. | `NOT RUN` |
| P3-PROD-FUNC-08 | Skip the current subject. | No plan record is created for that subject during the run; review proceeds. | Accepted count and later proposals. | `NOT RUN` |
| P3-PROD-FUNC-09 | Defer a subject while other unreviewed subjects exist. | Other subjects are reviewed first; the deferred subject may return later if still eligible. | Proposal order. | `NOT RUN` |
| P3-PROD-FUNC-10 | Accept at least one pair and finish early. | Existing accepted pairs remain; remaining subjects are not auto-accepted; final confirmation opens. | Final plan list. | `NOT RUN` |
| P3-PROD-FUNC-11 | Finish early with no accepted pairs. | Empty-plan result appears, no relationship is created, state clears, and re-entry is possible. | Result event and re-entry. | `NOT RUN` |
| P3-PROD-FUNC-12 | Use a Dynasty with no eligible subjects. | No-candidate result appears; state clears; later re-entry remains possible. | Result event and Decision state. | `NOT RUN` |
| P3-PROD-FUNC-13 | Create a plan with several pairs, including marriage and betrothal in both directions. | Final summary shows every accepted pair, direction, type, and placeholder state accurately. | Final summary screenshots. | `NOT RUN` |
| P3-PROD-FUNC-14 | Make one accepted pair invalid before final execution, for example by creating a marriage outside the workflow. | Full preflight fails before the first planned relationship; zero planned pairs execute. | Failure slot, all pair states before/after. | `NOT RUN` |
| P3-PROD-FUNC-15 | Accept overlapping or mirrored pairs if a controlled debug/save setup can attempt it. | Acceptance guard or final preflight rejects the plan; a character never executes in two pairs. | Plan and failure evidence. | `NOT RUN` |
| P3-PROD-FUNC-16 | Eligible landed same-Dynasty AI ruler. | Ruler can be proposed and related; titles, government, realm, liege, and succession are not directly changed by Mod script. | Full before/after political state. | `NOT RUN` |
| P3-PROD-FUNC-17 | Eligible same-Dynasty AI member in another court. | Character can be proposed and related without vanilla matchmaker permission; record all engine-owned court/realm effects. | Court/realm before/after. | `NOT RUN` |
| P3-PROD-FUNC-18 | Same-Dynasty cadet-House member. | House difference alone does not exclude the character. | House/Dynasty and proposal. | `NOT RUN` |
| P3-PROD-FUNC-19 | Another player-controlled same-Dynasty character in multiplayer or controlled test setup. | Character is never a subject or partner. | Candidate search evidence. | `NOT RUN` |
| P3-PROD-FUNC-20 | Test married, betrothed, dead, imprisoned, hostage, incapable, travelling, concubine, pregnant, pool-guest, and celibate characters. | Each listed state is excluded from both roles; existing state is untouched. | Candidate roster and state list. | `NOT RUN` |
| P3-PROD-FUNC-21 | Test faith/gender/kin/clergy/holy-order or government pair prohibited by vanilla legality. | Dynast override does not make the prohibited pair executable. | Faith/state and candidate absence. | `NOT RUN` |
| P3-PROD-FUNC-22 | Inspect alliances, Prestige, court, titles, government, inheritance, memories, and relationship history after each direct effect. | Record observed CK3-owned consequences without assuming parity with the native marriage interaction. | Full side-effect comparison. | `NOT RUN` |

## 3. Ranking, fertility, age, and placeholder tests

| ID | Setup and action | Expected result | Evidence to return | Result |
| --- | --- | --- | --- | --- |
| P3-PROD-RANK-01 | Adult subject with candidates at 100%, 95%, and 94% fertility; make 95% closer in age. | 100% and 95% share the inclusive top band; age may put 95% first; 94% cannot outrank either while one remains. | Raw/evaluated fertility and order. | `NOT RUN` |
| P3-PROD-RANK-02 | Repeat with 80%, 75%, and 74%. | 75% is included; 74% is excluded from that band. | Values and order. | `NOT RUN` |
| P3-PROD-RANK-03 | Use eligible values above 1.0, at zero, and below zero where a controlled setup permits. | Ordering remains numeric and stable; no clamping or overflow is claimed by the Mod. | Raw values, order, logs. | `NOT RUN` |
| P3-PROD-RANK-04 | Reject every member of an adult top band one by one. | Exact rejected pairs do not immediately repeat; a new best band is recomputed from remaining legal candidates. | Full proposal sequence. | `NOT RUN` |
| P3-PROD-RANK-05 | Adult candidates tied in fertility band but with different age gaps and congenital scores. | Smaller age gap wins even if its congenital score is lower. | Ages, traits, order. | `NOT RUN` |
| P3-PROD-RANK-06 | Adult candidates tied in fertility band and age, with good traits at tiers 1, 2, and 3. | Higher supported positive tier wins. | Trait keys and order. | `NOT RUN` |
| P3-PROD-RANK-07 | Otherwise tied candidates where one repeats a known negative trait carried by the subject. | Matching known negative reinforcement lowers that candidate. | Traits and order. | `NOT RUN` |
| P3-PROD-RANK-08 | Otherwise tied legal candidates from close, avuncular/nibling, cousin, extended, and no-detected-family categories. | More distant coarse category ranks higher after prior criteria. | Relation category and order. | `NOT RUN` |
| P3-PROD-RANK-09 | Minor subject with varying age gaps, traits, and kin categories. | Age gap wins first, then congenital score, then kinship category. | Ages, traits, relations, order. | `NOT RUN` |
| P3-PROD-RANK-10 | Woman 29 with a minor, then otherwise identical woman 30 with a minor; test adult as subject and partner. | Age 29 is not excluded by the project limit; age 30 is excluded in both role directions. | Ages and candidate presence. | `NOT RUN` |
| P3-PROD-RANK-11 | Man 39 with a minor, then otherwise identical man 40 with a minor; test adult as subject and partner. | Age 39 is not excluded by the project limit; age 40 is excluded in both role directions. | Ages and candidate presence. | `NOT RUN` |
| P3-PROD-RANK-12 | Fertile divorced adult and fertile widowed adult, both currently single. | Both can be proactive subjects and normal partners. | Former-spouse history and proposals. | `NOT RUN` |
| P3-PROD-RANK-13 | Zero-fertility never-married adult and zero-fertility previously married adult. | Neither becomes a proactive subject. | Candidate roster. | `NOT RUN` |
| P3-PROD-RANK-14 | Fertile previously married adult with at least one normal positive-fertility partner and one zero-fertility fallback. | Normal candidate appears first; fallback is not used while a normal candidate remains. | Proposal sequence and fertility. | `NOT RUN` |
| P3-PROD-RANK-15 | Same subject after all normal partners are exhausted; one legal zero-fertility adult remains. | Clearly marked placeholder appears; both ordinary and matrilineal choices remain explicit. | Placeholder warning and options. | `NOT RUN` |
| P3-PROD-RANK-16 | Minor plus only zero-fertility adults, or two zero-fertility adults. | No minor placeholder and no proactive zero+zero match occurs. | No-candidate/proposal evidence. | `NOT RUN` |
| P3-PROD-RANK-17 | Repeat an unchanged controlled candidate pool after save/reload and in a clean later workflow. | Order is stable for exposed ranking components; document any exact-tie list-order difference. | Before/after proposal sequence. | `NOT RUN` |

## 4. Lifecycle, capacity, stress, and special-state tests

| ID | Setup and action | Expected result | Evidence to return | Result |
| --- | --- | --- | --- | --- |
| P3-PROD-LIFE-01 | Complete a clean workflow, then complete a second in the same save. | Both run; no permanent prototype lock or residue remains. | Two completion events and plans. | `NOT RUN` |
| P3-PROD-LIFE-02 | Cancel from review, reopen, cancel from final, reopen. | Every clean cancellation permits a new run. | Decision/proposal sequence. | `NOT RUN` |
| P3-PROD-LIFE-03 | Save/reload while no Phase 3 workflow is active. | Normal inactive state and Decision visibility persist. | Before/after Decision state. | `NOT RUN` |
| P3-PROD-LIFE-04 | Save/reload during active review. | Active temporary workflow is cleaned at the supported load hook; no relationship executes; a fresh run can begin. | Before/after state and log. | `NOT RUN` |
| P3-PROD-LIFE-05 | Close or dismiss a review event abnormally where the UI permits. | No relationship executes in the background; recovery Decision appears and clears residue. | Event/Decision sequence. | `NOT RUN` |
| P3-PROD-LIFE-06 | During active workflow, kill the actor in a controlled save/debug setup. | Authority and temporary state become unusable and are cleaned; no relationship executes. | Actor/death state and coordinator behavior. | `NOT RUN` |
| P3-PROD-LIFE-07 | During active workflow, transfer Dynast status away from the actor. | Old workflow cannot advance; cleanup/recovery makes a new valid run possible for the new Dynast. | Dynast and Decision state. | `NOT RUN` |
| P3-PROD-LIFE-08 | Keep an old A-token event visible, clean the run, start a B-token run, then interact with the old event if possible. | Old event cannot mutate the B-token run. | Event outcomes and accepted count. | `NOT RUN` |
| P3-PROD-LIFE-09 | Repeat the prior experiment across enough clean runs to reuse token A, if the UI/save allows an ancient event to remain. | Record whether the complete owner/phase/token guard prevents mutation. Treat any mutation as release-blocking. | Exact reproduction and save. | `NOT RUN` |
| P3-PROD-LIFE-10 | Fill accepted slots 1 through 31. | All remain distinct and visible; performance remains acceptable. | Plan summary and timing. | `NOT RUN` |
| P3-PROD-LIFE-11 | Accept slot 32. | Capacity result appears; 32 records remain intact; player may finalize or cancel. | Result and plan summary. | `NOT RUN` |
| P3-PROD-LIFE-12 | Attempt a 33rd pair through normal UI. | No overwrite, wrap, partial slot, or count above 32; remaining members require another run. | Count and slot comparison. | `NOT RUN` |
| P3-PROD-LIFE-13 | Cycle alternatives until rejection record 64, then attempt another alternative. | Earlier rejection records remain intact; no overwrite; alternative option safely becomes unavailable or review advances under implemented UI. | Proposal count and UI. | `NOT RUN` |
| P3-PROD-LIFE-14 | Large Dynasty with hundreds of members; record activation, proposal, alternative, and final-preflight times. | No unacceptable freeze, runaway event chain, or background continuation. | Timings, hardware summary, log. | `NOT RUN` |
| P3-PROD-LIFE-15 | Execute a mixed 32-pair plan if practical. | Relationships execute in slot order, counts equal 32, and save/reload remains stable. | Timing, result counts, relationship audit. | `NOT RUN` |
| P3-PROD-LIFE-16 | If a safe reproducible post-effect failure can be created after successful preflight, trigger it after at least one valid slot. | Execution stops at first absent postcondition, earlier relationships remain, later slots do not execute, no rollback occurs, partial counts are exact. | Save, failing slot, all relationships. | `NOT RUN` |

## 5. Regression and log collection

| ID | Action | Expected result | Evidence to return | Result |
| --- | --- | --- | --- | --- |
| P3-PROD-REG-01 | Repeat a representative Phase 1 minor/adult/ruler exile case after Phase 3 use. | Phase 1 remains unchanged. | Before/after and error log. | `NOT RUN` |
| P3-PROD-REG-02 | Run both Phase 2 cleanup modes after Phase 3 use, including cancel and one confirmed branch. | Phase 2 candidate, protection, fold, confirm, and execution behavior remains unchanged. | Flow screenshots and before/after. | `NOT RUN` |
| P3-PROD-REG-03 | Change UI language between English and Simplified Chinese and open every Phase 3 result type available. | No missing key, wrong-language value, raw enum key, truncation blocker, or broken character expression. | Screenshots for both languages. | `NOT RUN` |
| P3-PROD-REG-04 | Search the final CK3 error log for `breedimp`, Phase 3 files, unknown effects/triggers/scopes, invalid localisation, missing events, and on-action errors. | No blocking error. Warnings are copied verbatim and assessed, not silently ignored. | Complete relevant log excerpt. | `NOT RUN` |
| P3-PROD-REG-05 | Save, reload, advance one day and one month after ordinary marriage, matrilineal marriage, ordinary betrothal, and matrilineal betrothal. | Every relationship persists; no workflow state or delayed relationship appears. | Four before/after records and log. | `NOT RUN` |

## 6. Ray return package

Return:

- the exact production commit tested;
- completed result cells for every executed case;
- screenshots of entry, review, final summary, capacity, success, failure, and
  recovery pages encountered;
- before/after state for all relationship participants;
- observed engine-owned side effects;
- save/reload observations;
- approximate large-Dynasty timings and hardware summary;
- the relevant `error.log`; and
- a list of every unexpected behavior, even if non-blocking.

Do not report unexecuted rows as passed. Phase 3 remains unreleased until
Jay/Boss reviews the production-runtime evidence.
