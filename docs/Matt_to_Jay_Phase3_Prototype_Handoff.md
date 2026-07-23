# Breed Improved Phase 3 - Isolated Prototype Handoff

## Status

- Phase 3 isolated prototype:
  `STATIC IMPLEMENTATION COMPLETE — RUNTIME TEST REQUIRED`
- P0: `CORRECTED AND CLOSED`
- P1-P5: `STATIC COMPLETE`
- P6: `PRE-FIX BLOCKER OBSERVED; POST-FIX RETEST NOT RUN`
- Production implementation: `NOT APPROVED`
- CK3 runtime:
  `PRE-FIX BLOCKER OBSERVED; POST-FIX RESERVATION RETEST NOT RUN`
- Final handoff state: `AWAITING RAY RESERVATION-REGRESSION RETEST`
- Target: CK3 `1.19.0.6 (Scribe)`

This handoff covers only the isolated test Mod under
`tests/phase3_dynasty_matchmaking/`. It does not approve Phase 3 production
code or change the released Mod. Ray's first P6 pass established the pre-fix
observations recorded below; no post-fix CK3 result is claimed.

## 1. Run isolation

No exact CK3 `1.19.0.6` evidence was found for a generated numeric workflow
identity that can be saved, compared against current global state across the
event chain, serialized, and cleaned in the required context. The prototype
therefore uses the narrower approved fallback:

**one confirmed Phase 3 prototype activation per save.**

The permanent marker is:

`global_var:breedimp_p3_proto_used_in_save =
flag:breedimp_p3_proto_used`

Opening the Decision only opens event
`breedimp_p3_proto_matchmaking.1000`. Cancelling that entry event creates no
lock. Its explicit activation option writes the permanent marker before
coordinator, actor, Dynasty, candidate, or pair state. The marker is never
cleared. Completion, cancellation, failure, death, loss of Dynast status,
abnormal event closure, and cleanup therefore cannot authorize a second run
in the same save.

This is an isolation property of the prototype, not a proposed production
restriction.

## 2. Prototype structure

The standalone test Mod contains:

- one Dynast-only player Decision;
- one event namespace,
  `breedimp_p3_proto_matchmaking`, using IDs `1000-1199`;
- lifecycle, candidate, pair, and preflight scripted triggers;
- lifecycle, staged-candidate, pair-plan, preflight, and relationship scripted
  effects;
- fertility and age-gap script values;
- additive child on_actions for actor death, Dynast change, and load cleanup;
- matching English and Simplified Chinese localisation;
- a portable outer launcher template and an inner test-only descriptor.

All non-event prototype identifiers begin with `breedimp_p3_proto_`. The test
Mod has no Workshop ID, production metadata, or dependency on production Mod
files.

## 3. Authorization lifecycle

### Activation

Only a living, player-controlled current Dynast can open and confirm the
prototype. Explicit confirmation:

1. clears actor-owned residue;
2. permanently consumes the save-wide prototype run;
3. records the active actor;
4. records review phase;
5. stores the actor's current Dynasty;
6. initializes diagnostics and pair count; and
7. begins the player-initiated candidate pass.

### Guards

Every review or final state verifies the permanent lock, active actor identity,
expected phase, actor life, player control, current Dynast status, and equality
between the actor's current Dynasty and the recorded Dynasty. Pair guards also
verify both participants, same recorded Dynasty, marriage/betrothal
availability, mutual vanilla marriage legality, direct-ancestry exclusion,
age policy, and reservation state.

### Terminal paths

- Normal completion: execute only after whole-plan preflight, display the
  test-only completion result while its counts and slot details remain
  available, then centrally clear temporary state when that result is
  acknowledged.
- Review cancellation: clear temporary state; create no relationship.
- Final cancellation: clear temporary state; create no relationship.
- No eligible subject: clear temporary state and show the no-subject result.
- Empty accepted plan: clear temporary state and show the no-pair result.
- Preflight failure: create no relationship, retain diagnostic variables until
  the visible failure result is acknowledged, then centrally clear state.
- Actor death: additive `on_death` child checks active-actor identity and
  clears temporary state.
- Dynast loss: additive `on_became_dynasty_head` child rechecks the recorded
  actor and clears invalid authority.
- Save/load: additive `on_game_start_after_lobby` child clears any active
  temporary workflow while preserving the permanent lock.
- Stale or failing event: verified `on_trigger_fail` paths clear active
  temporary state.
- Abnormal visible-event closure: no unverified close callback is assumed.
  The workflow may remain orphaned, but it has no delayed or background
  relationship path, cannot start a second run, and can be cleaned only by a
  later verified lifecycle entry. Exact behavior remains a P6 runtime gate.

Cleanup removes pair payload first, then review/list/diagnostic state, then
phase, and finally the active-actor pointer. It never removes the permanent
one-run marker.

## 4. Pair-plan storage and integrity

The active actor owns 16 explicit fixed slots. Each slot stores:

1. `subject`
2. `partner`
3. `direction`
4. `relationship_type`
5. `placeholder`
6. `reservation_id`

The first five fields are payload. `reservation_id` is written last as a second
character reference to the slot's `subject`. A slot is committed only when all
six fields exist, the marker equals the subject, both character references are
different, and every enum is in the approved set. The marker proves only that
the slot reached its final write; it is not a run identity and does not make
the six writes atomic.

Before committing a pair, both characters are checked against subject and
partner in every committed slot. This prevents one character from appearing
twice and also prevents mirrored `(A,B)` / `(B,A)` pairs. Final preflight repeats
all 120 unordered slot-pair comparisons, covering at most 480 role-to-role
identity comparisons.

The capacity is 16 pairs / 32 reserved characters. Slot 17 does not exist.
After slot 16 is committed, the prototype opens a capacity result that allows
the player to proceed to final confirmation or cancel. No existing slot is
overwritten, wrapped, reused, or truncated.

### P6 reservation blocker and static correction

Ray/Boss reported that the pre-correction build passed entry/cancel Smoke 1,
first activation/permanent-lock Smoke 2, and **View another partner for this
person** on retest. Pair-slot writing worked. These observations belong only
to that earlier build and do not mark the corrected build as runtime-verified.

The first P6 pass established a blocking pre-fix result: accepting a pair
wrote a committed slot, but one or both participants could still be proposed
and accepted again. The final cross-slot preflight detected the resulting
duplicate plan and aborted, but immediate subject/partner reservation had
failed. Reliable multi-pair execution was therefore blocked.

The exact cause was a scope-identity error in the shared unreserved-character
trigger. Callers evaluated it from the proposed character and passed
`CHARACTER = this`, but the trigger entered the actor scope before forwarding
that textual parameter to the slot checks. Scripted-trigger parameters are
textual substitutions, not automatically captured scopes; after entering the
actor block, `this` denoted the actor instead of the proposed subject or
partner. The slot integrity and final preflight logic remained sound because
those paths directly inspected actor-owned slot variables.

The CK3 `1.19.0.6` basis is the save-before-scope-transition pattern in
`common/scripted_triggers/00_marriage_triggers.txt:183-212`, plus
character-variable equality against a saved scope in
`events/board_game_events.txt:1173-1187`,
`events/relations_events/relation_upgrade_events.txt:190-210`, and
`events/siege_events.txt:1323-1351`. The corresponding project restrictions
are registered in
`.agents/skills/ck3-mod-development/references/ck3_syntax_reference.md:603-629`.

The static correction now:

1. saves the proposed character with `save_temporary_scope_as` before entering
   the actor-owned slot scope;
2. passes that explicit saved character to all 16 committed-slot reservation
   checks;
3. uses the same unreserved-character contract for subject selection and both
   roles in partner eligibility;
4. re-evaluates the current pair inside the shared acceptance effect before
   the first slot field is written; and
5. routes a rejected or stale pair to recovery without writing `subject`,
   `partner`, metadata, `reservation_id`, or incrementing
   `accepted_pair_count`.

Both visible direction options call this one acceptance effect, while
marriage versus betrothal remains derived from the participants' ages.
Consequently the static guard is shared by ordinary marriage, matrilineal
marriage, ordinary betrothal, and matrilineal betrothal. The complete final
preflight and all 120 unordered cross-slot comparisons remain unchanged as
defense in depth.

## 5. Candidate generation and ordering

Candidate work is player initiated and staged:

1. scan the recorded Dynasty for basic eligible subjects;
2. select one current subject;
3. scan the same Dynasty for that subject's possible partners;
4. exclude reserved or ineligible characters before ordering; and
5. retain only the current review lists, not a permanent all-pairs table.

Both roles require a living, AI-controlled, unmarried, unbetrothed member of
the recorded Dynasty. The conservative prototype also excludes imprisonment,
hostage, concubine, and pregnancy states. Mutual
`can_marry_character_trigger`, direct-ancestry exclusion, and the approved
adult-minor age limits remain mandatory.

For an adult subject, the prototype finds the current maximum fertility,
includes candidates from `best - 0.05` through `best`, inclusive, and selects
the smallest age gap within that tier. For a minor subject, smallest age gap is
the first ordering criterion. The implementation uses staged list filtering
and does not construct a persistent full-Dynasty binary-pair table.

The complete fertility composition, inclusive boundaries, values outside
`0-1`, ties, save/reload ordering, and large-Dynasty responsiveness remain P6
runtime gates.

## 6. Review, preflight, and execution

Review provides ordinary accept, matrilineal accept, next partner, skip,
defer, finish early, and cancel. Accepting a pair writes only temporary plan
state. No relationship or compensating gameplay effect occurs before final
confirmation.

Final confirmation performs a complete read-only pass over:

- workflow authority and phase;
- every slot's completeness and marker;
- participant life, Dynasty, availability, legality, ancestry, and age policy;
- relationship type versus current ages; and
- all cross-slot duplicate and mirror comparisons.

The first failure records a diagnostic slot and reason. Any failure stops the
whole batch before a relationship operation. No invalid pair is skipped or
replaced.

Only after the complete pass succeeds can the plan dispatch:

- `marry`
- `marry_matrilineal`
- `create_betrothal`
- `create_betrothal_matrilineal`

No alliance, Prestige, court movement, title, government, House, Dynasty,
claim, succession, inheritance, memory, opinion, stress, or AI-acceptance
effect was added. Engine-produced side effects and parity with native
arrange-marriage behavior must be observed in P6. CK3 provides no verified
transaction rollback for this batch: if a direct relationship operation fails
despite the completed preflight, an earlier operation could already have
executed. That residual partial-execution risk is a mandatory runtime gate, not
a statically solved guarantee.

### Test-only completion feedback

After the execution path is reached, event
`breedimp_p3_proto_matchmaking.1144` now provides a visible test result before
temporary state is cleared. It reports:

- accepted-pair count;
- relationship-operation count reached by the execution dispatcher;
- marriage-operation count;
- betrothal-operation count; and
- each committed slot's two characters, relationship type, and ordinary or
  matrilineal direction.

These are prototype diagnostics, not proof that CK3 completed every requested
relationship. The counters advance only in the corresponding committed-slot
execution branch, and no success result is dispatched before the validated
execution path. Cleanup now occurs when the player acknowledges this
completion page. The event rendering, counter agreement, relationship
postconditions, cleanup timing, and abnormal-close behavior remain runtime
retest requirements.

The conditional description pattern is evidenced by
`events/court_position_management_events.txt:5-41`; numeric counter
initialization and increments are evidenced by
`events/court_events/introduce_court_fashion_events.txt:84-109,157-175`.

## 7. Runtime gates and known risks

P6 must verify:

- descriptor loading, parsing, scopes, event flow, and localisation rendering;
- permanent-lock serialization and save/reload behavior;
- actor-owned character, flag, number, list, and Dynasty state across events;
- actor death and every relevant Dynast-transfer route;
- abnormal visible-event closure and orphaned-state isolation;
- fixed-slot persistence, incomplete writes, marker checks, and diagnostics;
- immediate exclusion of an accepted subject and partner from both later
  roles;
- effect-time duplicate rejection with no partial slot or count change;
- ordinary/matrilineal marriage and betrothal parity through the shared
  reservation guard;
- completion-event counts, slot details, and acknowledgement-time cleanup;
- maximum-minus-`0.05` fertility boundaries and age-gap ordering;
- ordinary and matrilineal adult marriage;
- ordinary and matrilineal minor betrothal;
- direct-effect alliance, Prestige, court, succession, memory, and other side
  effects compared with native behavior;
- external-court and landed Dynasty members;
- 16-pair capacity, collision protection, and whole-plan failure behavior;
- large-Dynasty responsiveness;
- Phase 1 and Phase 2 regression safety; and
- CK3 `error.log`.

All 156 manual cases remain `NOT RUN`.

## 8. Ray handoff

Use
`docs/testing/phase3_prototype_runtime_instructions.md` for installation,
fresh-save discipline, priority smoke gates, observation capture, and log
review. Use
`docs/testing/phase3_dynasty_matchmaking_manual.md` as the complete 156-case
matrix.

Ray should now perform the reservation-regression retest before continuing
the broader P6 matrix. A post-fix runtime pass would validate only this
isolated prototype; it would not approve production implementation.
