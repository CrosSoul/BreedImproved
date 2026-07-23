# Breed Improved Phase 3 Prototype - Runtime Instructions

- Status: `POST-FIX RESERVATION REGRESSION NOT RUN`
- CK3 target: `1.19.0.6 (Scribe)`
- Prototype namespace: `breedimp_p3_proto_matchmaking`
- Production approval: `NOT APPROVED`
- Runtime gate: `AWAITING RAY RESERVATION-REGRESSION RETEST`

This document is the gated runtime procedure for the completed static isolated
prototype. It does not authorize launching CK3 or changing production files;
Ray must explicitly approve P6 first. Record only observed results in the Phase
3 manual matrix, and do not convert an observation into a `PASS` without the
required reviewer decision.

Ray/Boss reported that the pre-correction build passed entry/cancel Smoke 1,
first activation/permanent-lock Smoke 2, and **View another partner for this
person** on retest. That build wrote pair slots and retained the final
duplicate preflight, but failed immediate reservation, later candidate
exclusion, and the acceptance-time duplicate guard. These are historical
observations, not post-fix results. Every reservation-regression and completion
case for the corrected build remains `NOT RUN`.

## 1. Install and enable the isolated test Mod

1. Confirm the test-only content root is the current
   `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype/` directory.
2. Use the matching outer launcher template
   `BreedImprovedPhase3Prototype.mod` only for local testing. Replace its
   portable `<LOCAL_MOD_PATH>` placeholder in the local Launcher copy, never
   in a committed file.
3. Enable only the intended isolated Phase 3 prototype playset configuration.
   Do not place the test Mod in Workshop staging and do not change
   `MyCK3Mod/`, its descriptor, or the existing Workshop item.
4. Record CK3 version, enabled DLC, game rules, language, enabled Mods, and
   load order before testing.

## 2. Save discipline and permanent lock

The prototype permits one confirmed activation per save. A pre-activation
cancellation must not consume the save. Once confirmed activation occurs, the
permanent lock remains consumed after success, cancellation, no candidates,
preflight failure, actor death, Dynast loss, save/load, or an orphaned event.

- Create a fresh baseline save before every case that confirms activation.
- Restore or duplicate that baseline rather than attempting a second Phase 3
  workflow in an already activated save.
- Label every result with the baseline-save name and whether the permanent
  lock was observed before and after the action.

## 3. Priority smoke gates

Run these gates before attempting the complete matrix. Stop and report a
blocker if any gate fails or produces a CK3 error attributable to the
prototype.

1. Pre-activation cancel: open the Decision, cancel before confirmation, and
   verify that no lock, candidate state, reservation, or relationship change
   appears.
2. First activation: confirm as a living player Dynast and verify the lock is
   set only after confirmation; no marriage or betrothal may exist yet.
3. Second-entry rejection: after any confirmed activation, attempt another
   entry with the same actor and, where possible, another Dynast. It must be
   rejected without replacing state.
4. Terminal no-effect path: review-cancel or final-cancel and verify that no
   relationship changed while the permanent lock remains consumed.
5. Orphan and load path: close a visible event where possible, save/reload,
   advance one in-game day, and verify that no stale event can execute a
   relationship or begin background work.
6. Immediate-reservation blocker gate: from a fresh baseline, accept A-B and
   continue review. Before accepting another pair, verify that A and B appear
   neither as later subjects nor as later partners. Exhaust the available
   alternatives sufficiently to cover both roles.
7. Duplicate-rejection integrity: if a repeated-character or mirror proposal
   remains naturally reachable through the UI or an already approved test
   setup, record the next empty slot's six fields and accepted-pair count,
   attempt acceptance, and inspect them again. The attempt must write no field
   and increment no count. If no such proposal can be reached safely, record
   this acceptance-time portion as `BLOCKED`; do not invent a diagnostic
   invocation.
8. Four-path parity: using a separate fresh baseline for each, repeat the
   immediate-reservation and duplicate-rejection checks for ordinary adult
   marriage, matrilineal adult marriage, ordinary minor betrothal, and
   matrilineal minor betrothal.
9. Final defense-in-depth gate: where an already approved setup can provide a
   duplicated committed plan, verify that final preflight still aborts before
   every relationship mutation. Otherwise record this case as `BLOCKED`
   without fabricating an injection method.
10. Completion-result gate: execute a fully valid batch and verify that a
    visible completion result appears only after the relationship-execution
    path. Compare its total-pair, marriage, and betrothal counts with the
    relationships actually established. A duplicate rejection or preflight
    abort must not display success.

Stop the reservation-regression pass immediately if:

- either member of a committed pair appears again as a subject or partner;
- a duplicate or mirror attempt writes any slot field;
- the accepted-pair or displayed summary count increases after rejection;
- any of the four acceptance paths bypasses the shared reservation behavior;
- a completion result appears before execution or after a rejected/aborted
  plan;
- completion counts differ from actual relationships; or
- the final duplicate preflight no longer stops a duplicated plan before
  mutation.

## 4. Observation capture

For every executed test, capture:

- baseline save name, CK3 build, DLC, rules, language, load order, and date;
- actor, subject, partner, Dynasty, House, court, liege, title, government,
  spouse/betrothal, children, claims, succession, and relevant faith state;
- permanent-lock state before activation, after activation, and after the
  terminal action;
- chosen direction, relationship type, placeholder state, slot identity, and
  any visible candidate/failure text;
- every subject and partner proposed after a pair commits, including the first
  proposal selected after acceptance;
- the next empty slot's `subject`, `partner`, `direction`,
  `relationship_type`, `placeholder`, and `reservation_id` before and after
  any rejected duplicate attempt;
- accepted-pair, committed-slot, and displayed-summary counts before and after
  any rejected duplicate attempt;
- completion-result timing, total-pair count, marriage count, betrothal count,
  and the actual relationships used to verify those values;
- before/after screenshots or written observations sufficient to reproduce
  the result; and
- exact error-log lines, including timestamp/context when available.

Before final confirmation, verify that no marriage, betrothal, alliance, court,
title, government, Prestige, claim, succession, House, or Dynasty state has
changed. After every terminal action, save, reload, advance one day, and
inspect the same fields again.

## 5. Error log

After each smoke gate and each completed suite, inspect:

```text
Documents/Paradox Interactive/Crusader Kings III/logs/error.log
```

Record parser errors, unknown identifiers, scope errors, stale-event errors,
localisation errors, repeated messages, and any unexpected background activity.
Do not delete or edit the log as part of this procedure. A clean log is a
future observation, not a pre-recorded result.

## 6. Full matrix progression

Only after the smoke gates are recorded for review, run the 156-case matrix in
`docs/testing/phase3_dynasty_matchmaking_manual.md`. Use a separate fresh
baseline for each activated workflow. Preserve `NOT RUN` for every case not
actually executed, and stop immediately for any blocker involving a stale
event, permanent-lock bypass, relationship change before final confirmation,
repeated accepted character, partial slot write, rejected-duplicate count
increase, premature or inaccurate completion result, partial batch execution,
or Phase 1/2 regression.

Post-fix CK3 runtime remains `NOT RUN`. Stop after the requested reservation
regression with status `AWAITING RAY RESERVATION-REGRESSION RETEST` until Ray
records the new in-game observations.
