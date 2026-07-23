# Breed Improved Phase 3 - Isolated Prototype Handoff

## Status

- Phase 3 isolated prototype:
  `STATIC IMPLEMENTATION COMPLETE — RUNTIME TEST REQUIRED`
- P0: `CORRECTED AND CLOSED`
- P1-P5: `STATIC COMPLETE`
- P6: `AWAITING RAY RUNTIME APPROVAL`
- Production implementation: `NOT APPROVED`
- CK3 runtime: `NOT RUN`
- Final handoff state: `AWAITING RAY IN-GAME TESTING`
- Target: CK3 `1.19.0.6 (Scribe)`

This handoff covers only the isolated test Mod under
`tests/phase3_dynasty_matchmaking/`. It does not approve Phase 3 production
code, change the released Mod, or claim that CK3 has loaded or executed the
prototype.

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

- Normal completion: execute only after whole-plan preflight, then centrally
  clear temporary state.
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

## 7. Runtime gates and known risks

P6 must verify:

- descriptor loading, parsing, scopes, event flow, and localisation rendering;
- permanent-lock serialization and save/reload behavior;
- actor-owned character, flag, number, list, and Dynasty state across events;
- actor death and every relevant Dynast-transfer route;
- abnormal visible-event closure and orphaned-state isolation;
- fixed-slot persistence, incomplete writes, marker checks, and diagnostics;
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

All 140 manual cases remain `NOT RUN`.

## 8. Ray handoff

Use
`docs/testing/phase3_prototype_runtime_instructions.md` for installation,
fresh-save discipline, priority smoke gates, observation capture, and log
review. Use
`docs/testing/phase3_dynasty_matchmaking_manual.md` as the complete 140-case
matrix.

Do not begin runtime testing until Ray explicitly approves P6. A runtime pass
would validate only this isolated prototype; it would not approve production
implementation.
