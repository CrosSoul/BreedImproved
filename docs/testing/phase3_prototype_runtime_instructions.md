# Breed Improved Phase 3 Prototype - Runtime Instructions

- Status: `NOT RUN`
- CK3 target: `1.19.0.6 (Scribe)`
- Prototype namespace: `breedimp_p3_proto_matchmaking`
- Production approval: `NOT APPROVED`
- Runtime authorization: required before launching CK3

This document is the gated runtime procedure for the completed static isolated
prototype. It does not authorize launching CK3 or changing production files;
Ray must explicitly approve P6 first. Record only observed results in the Phase
3 manual matrix, and do not convert an observation into a `PASS` without the
required reviewer decision.

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
6. Relationship-form smoke tests: only after Ray explicitly approves P6 and
   the preceding gates pass, test one fresh baseline each for ordinary
   adult marriage, matrilineal adult marriage, ordinary minor betrothal, and
   matrilineal minor betrothal.

## 4. Observation capture

For every executed test, capture:

- baseline save name, CK3 build, DLC, rules, language, load order, and date;
- actor, subject, partner, Dynasty, House, court, liege, title, government,
  spouse/betrothal, children, claims, succession, and relevant faith state;
- permanent-lock state before activation, after activation, and after the
  terminal action;
- chosen direction, relationship type, placeholder state, slot identity, and
  any visible candidate/failure text;
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

Only after the smoke gates are recorded for review, run the 140-case matrix in
`docs/testing/phase3_dynasty_matchmaking_manual.md`. Use a separate fresh
baseline for each activated workflow. Preserve `NOT RUN` for every case not
actually executed, and stop immediately for any blocker involving a stale
event, permanent-lock bypass, relationship change before final confirmation,
partial batch execution, or Phase 1/2 regression.
