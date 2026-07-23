# Breed Improved Phase 3 - Production Design and Gap Closure

## Status

- CK3 target: `1.19.0.6 (Scribe)`
- Accepted baseline: commit
  `1bb5f68ac43d23405c3d6f6ea0d564720ed8fbcf`
- Isolated prototype: `ACCEPTED FOR PRODUCTION DESIGN`
- Production candidate: `IMPLEMENTED IN SOURCE`
- CK3 runtime: `NOT RUN`
- Release and Workshop scope: `NOT AUTHORIZED`

This document closes the delegated product and technical gaps for the first
Phase 3 production candidate. It records the design implemented under
`MyCK3Mod/`; it does not turn a static implementation into a runtime result.
The final static result is recorded separately in
`docs/testing/phase3_production_static_review.md`.

## 1. Product boundary

Phase 3 adds one explicitly player-initiated **Manage Dynasty Matchmaking**
Decision. The player must be a living current Dynast. After the player confirms
entry, Breed Improved grants a workflow-scoped authority override over
eligible AI-controlled members of the player's current Dynasty.

The override changes only who may arrange a proposed relationship. It does not
waive CK3 marriage legality, current marital state, faith restrictions,
consanguinity rules, or the additional project safeguards described below.
It does not persist after the workflow ends and never runs for AI.

The production candidate supports:

- ordinary and matrilineal relationships;
- direct marriage when both participants are adults;
- betrothal when either participant is a minor;
- one-pair-at-a-time review;
- alternative-partner rejection, skip, defer, finish-early, and cancel;
- a read-only final summary and explicit final confirmation;
- a bounded 32-pair plan; and
- visible no-candidate, empty-plan, capacity, validation-failure, success,
  partial-failure, and recovery outcomes.

It does not support Grand Weddings, external-Dynasty partners, other
player-controlled participants, political scoring, automatic acceptance,
automatic divorce, automatic court movement, background scanning, or recurring
matchmaking.

## 2. Prototype findings carried forward

The production architecture reuses only prototype behavior that has exact CK3
evidence or mapped prototype runtime evidence:

- a player-confirmed Dynast override limited to one active workflow;
- current-Dynasty candidate discovery;
- actor-owned fixed records with the commit marker written last;
- immediate reservation of both participants after a complete commit;
- direct ordinary/matrilineal marriage and betrothal effects;
- a complete preflight before the first relationship effect; and
- player-visible result events before state cleanup.

The following prototype restrictions were deliberately removed:

- the permanent one-workflow-per-save lock;
- the test namespace and test-only identifiers;
- the fixed 16-pair limit;
- prototype-only metadata, UI wording, and diagnostics; and
- the absence of congenital and kinship ranking.

The production candidate remains conservative where the prototype did not
establish a safe general policy.

## 3. Repeatable workflow and stale-event isolation

### 3.1 Coordinator

At most one Phase 3 workflow may be active globally. The coordinator stores:

- `global_var:breedimp_dynasty_matchmaking_active_actor`; and
- `global_var:breedimp_dynasty_matchmaking_phase`.

The actor stores the managed Dynasty, current token, plan slots, rejection
records, lists, counters, current proposal state, and failure diagnostics.
Every mutating review or result event is split into a token-A or token-B event
and checks actor ownership, authority, phase, and token before exposing a
mutating option.

### 3.2 Alternating token

Each confirmed activation alternates between:

- `breedimp_dynasty_matchmaking_token_a`; and
- `breedimp_dynasty_matchmaking_token_b`.

The persistent actor flag `breedimp_dynasty_matchmaking_next_token_b` chooses
the next token. It is not an authority flag and does not by itself authorize
an event. A valid event also requires the same active actor, current Dynasty,
Dynast status, expected phase, and matching current token.

This model rejects an immediately stale event from the prior run and prevents
an event owned by another actor or phase from mutating current state. CK3 has
no verified generic callback for closing every visible event abnormally.
Therefore a visible interrupted workflow is handled by a separate player
recovery Decision that discards all temporary state. Very old visible events
surviving two token alternations and exact save/load ordering remain runtime
gates; the model is not described as a cryptographic or unbounded run ID.

### 3.3 Cleanup

Central cleanup removes:

1. all 32 pair records;
2. all 64 rejected-pair records;
3. temporary lists, current proposal state, counters, and diagnostics;
4. the actor's managed Dynasty and current token;
5. the global phase; and
6. the global active-actor pointer, last.

Cleanup is reachable from normal completion, review cancellation, final
confirmation cancellation, no candidates, an empty plan, preflight failure,
partial execution acknowledgement, actor death, Dynast invalidation, load
cleanup, explicit recovery, and stale/failed event guards where the event
path supports them.

The additive lifecycle hooks never scan candidates or create relationships.
Exact `on_became_dynasty_head` coverage and `on_game_start_after_lobby` timing
remain runtime-only questions.

## 4. Capacity and record integrity

### 4.1 Accepted-pair storage

The actor owns 32 explicit slots. Every slot stores:

1. `subject`
2. `partner`
3. `direction`
4. `relationship_type`
5. `placeholder`
6. `reservation_id`

`reservation_id` is a second reference to `subject` and is written last. A
slot is committed only if all six fields exist and the marker equals the
subject. A partially written slot is neither reserved nor executable.

Thirty-two pairs reserve at most 64 characters. Pair 33 is never written:
the capacity event directs the player to final confirmation or cancellation.
The limit is visible in entry, review, summary, and capacity localisation.
A later clean workflow may process remaining members.

### 4.2 Rejected-pair storage

The actor owns 64 explicit rejection records. Every rejection stores
`subject`, `partner`, and a subject-reference marker written last. Rejected
records prevent **Show me another partner** from immediately returning the
same ordered pair during that workflow. When all 64 records are occupied, the
alternative-partner option is no longer available rather than overwriting a
record.

### 4.3 Duplicate and mirror safety

Before a pair is accepted, both proposed characters are checked against both
roles in every committed slot. A committed participant therefore cannot be
accepted as a later subject or partner. This single invariant also eliminates
mirror pairs.

Final preflight independently adds the subject and partner of each committed
slot to one participant list and fails on the first repeated character. This
is defense in depth against duplicate, overlapping, and mirror plans.

## 5. Authority and eligibility closure

### 5.1 Authority

The selected production model is:

`workflow-scoped Dynast override for same-Dynasty AI participants`

It allows eligible landed rulers and members in external courts. It does not
require the actor to be the vanilla matchmaker or require a recipient ruler or
AI acceptance. It excludes every player-controlled participant. The override
ends with centralized cleanup and is never used by a background action.

### 5.2 Shared base eligibility

Both subject and partner must:

- be alive and AI-controlled;
- be a member of the actor's recorded current Dynasty;
- not be the actor;
- be `is_available = yes`;
- not be travelling or incapable;
- be unmarried and unbetrothed;
- not be imprisoned or a hostage;
- not be a concubine;
- not be pregnant;
- not be a pool guest;
- not have the vanilla `celibate` trait; and
- not be reserved in an accepted pair.

`can_marry_character_trigger` is then required in both directions for each
pair. Direct ancestor/descendant pairs are independently excluded. CK3 faith,
gender, clergy, holy-order, special-role, government, and consanguinity
restrictions represented by the vanilla trigger remain in force.

No guessed generic "missing character" trigger was added. The conservative
availability and explicit state exclusions define the first supported class.
Landed status, external court, guest status other than `is_pool_guest`, and
House/cadet branch do not disqualify an otherwise eligible same-Dynasty AI
character.

### 5.3 Role-specific fertility

- A minor may be a proactive subject or normal partner without a positive
  fertility requirement.
- An adult proactive subject must have `fertility > 0`.
- A normal adult partner must have `fertility > 0`.
- A zero-or-negative-fertility adult is never a proactive subject.

Fertile divorced or widowed adults remain eligible because the workflow does
not exclude `any_former_spouse`.

## 6. Relationship type and age protection

The relationship type is derived at acceptance and revalidated before
execution:

- adult + adult: marriage;
- either participant is a minor: betrothal.

Both role directions enforce the hard safety boundaries:

- a woman aged 30 or older cannot be paired with a minor; and
- a man aged 40 or older cannot be paired with a minor.

Age 29 and age 39 are not excluded by those project thresholds. Ordinary and
matrilineal options share the same acceptance and final-preflight guards.

## 7. Ranking closure

### 7.1 Subject order

Subjects are selected deterministically from the current eligible list by:

1. minors before adults;
2. higher evaluated fertility;
3. younger age; and
4. engine list order only when all exposed components tie.

This is a production default, not a claim that CK3 exposes a globally unique
stable character identifier to script.

### 7.2 Adult partner order

For an adult subject:

1. determine the highest current eligible partner fertility;
2. retain candidates from that value down through exactly `best - 0.05`,
   inclusive;
3. order the retained band by age proximity;
4. then congenital score;
5. then coarse kinship score;
6. then a finite script-visible fingerprint; and
7. use engine list order only for an exact remaining tie.

After the player rejects the displayed pair, that pair is removed from the
current run and the candidate set is rebuilt. The best band is therefore
recomputed from the remaining legal candidates; no separate guessed fertility
bucket table is used. Current evaluated fertility is used without clamping, so
values above 1.0 or below 0.0 remain comparable.

### 7.3 Minor partner order

For a minor subject the complete candidate pool is ordered by:

1. age proximity;
2. congenital score;
3. coarse kinship score;
4. the finite script-visible fingerprint; and
5. engine list order only for an exact remaining tie.

### 7.4 Congenital score

The finite score uses the same verified vanilla trait keys already registered
for this project:

- favorable: the three beauty, intellect, and physique tiers,
  `pure_blooded`, and `fecund`;
- unfavorable: the three negative beauty, intellect, and physique tiers,
  `clubfooted`, `hunchbacked`, `lisping`, `stuttering`, `dwarf`, `inbred`,
  `spindly`, `scaly`, `wheezing`, `bleeder`, and `infertile`.

Positive tier weights increase from 10 to 30. Negative traits subtract finite
weights, and matching known negative tier traits or `inbred` on both
participants receives an additional penalty. Unknown or modded congenital
traits are ignored safely. The score is a deterministic preference heuristic,
not an inheritance-probability calculation.

### 7.5 Kinship score

Direct ancestry is prohibited. Legal remaining relationships receive these
coarse preference values:

- close family: `0`;
- avuncular/nibling: `1`;
- cousin: `2`;
- extended family: `3`;
- no detected close/extended category: `4`.

The last category is never described to players as "unrelated." Faith legality
remains authoritative.

## 8. Placeholder closure

A zero-or-negative-fertility partner is considered only when:

- the subject is an adult with `fertility > 0`;
- the subject has at least one former spouse;
- no normal positive-fertility partner remains;
- the placeholder is an adult and passes every normal legality and safety
  guard; and
- the player explicitly accepts the visibly marked fallback.

No placeholder is used for a minor. Two zero-fertility characters are never
proactively paired. The verified script can establish former-spouse history
but does not reliably separate divorce from widowhood in every case, so the
production rule intentionally treats both as "previously married."

Ordinary is displayed as the first option, but ordinary and matrilineal remain
explicit player choices. No direction is silently forced by placeholder
status.

## 9. Review semantics

- **Accept ordinary** or **accept matrilineal** commits the complete current
  pair, immediately reserves both participants, and continues.
- **Show another partner** commits only a rejected-pair record, rebuilds the
  current subject's pool, and creates no relationship.
- **Skip** removes the subject from the current run.
- **Defer** revisits the subject after not-yet-reviewed subjects where a valid
  proposal remains.
- **Finish early** preserves accepted records and opens final confirmation.
- **Cancel** discards all temporary state and executes nothing.
- Final confirmation allows execution or cancellation/restart; it does not
  edit individual accepted records.

Displayed but unaccepted participants are not reserved and may later appear in
another proposal. No "accept all" path exists.

## 10. Preflight and execution safety

Final confirmation performs a complete read-only pass before changing any
relationship. It verifies:

- active actor, phase, Dynasty, Dynast status, and token;
- slot completeness, commit marker, enum values, and accepted-pair count;
- distinct and unique participants;
- current eligibility and same-Dynasty membership;
- current marriage and betrothal state;
- mutual vanilla legality and direct-ancestry exclusion;
- relationship type against current ages;
- both hard adult-minor age thresholds; and
- current placeholder policy.

Any preflight failure stops the entire plan before the first relationship
effect.

After a successful preflight, slots execute in numeric order. The only
relationship-changing effects are:

- `marry`;
- `marry_matrilineal`;
- `create_betrothal`; and
- `create_betrothal_matrilineal`.

After each effect, the workflow checks for the expected spouse or betrothed
relationship. If the postcondition is absent, later slots are not attempted.
Already created relationships are preserved, no rollback is attempted, and a
partial-result event shows the completed count and failing slot.

This is intentionally not described as transactional. Direct-effect alliance,
Prestige, court, succession, memory, and other engine-owned side effects remain
runtime observations. The Mod adds no compensating gameplay consequence.

## 11. Integration closure

Phase 3 is additive:

- its Decision, events, scripted triggers/effects/values, and localisation use
  the `breedimp_dynasty_matchmaking_` production stem;
- event namespace `breedimp_dynasty_matchmaking` is allocated range
  `2000-2399`;
- current implementation uses `2000-2190`;
- lifecycle integration appends named child on-actions rather than replacing
  vanilla or project children; and
- no Phase 1 or Phase 2 trigger, effect, event, interaction, value, modifier,
  or localisation behavior is called or modified by Phase 3.

No descriptor, release metadata, package, Workshop staging file, or Workshop
ID belongs to this implementation.

## 12. Remaining runtime gates

The following are not established by static review:

- repeated clean runs in one save;
- stale visible-event behavior across alternating-token reuse;
- recovery after abnormal event closure;
- death, Dynast transfer, and load-hook timing;
- candidate ordering stability after save/reload;
- exact `is_available` coverage for special activities and roles;
- external-court and landed-ruler relationship side effects;
- all four direct relationship forms in production integration;
- fertility values outside the usual range and exact `0.05` boundary behavior;
- congenital and kinship order in controlled ties;
- former-spouse placeholder discovery and presentation;
- 32-pair capacity UI and performance;
- preflight invalidation and post-effect failure handling;
- full English and Simplified Chinese presentation;
- Phase 1 and Phase 2 runtime regression; and
- a clean CK3 `error.log`.

These gates are specified in
`docs/testing/phase3_production_targeted_runtime_plan.md`. Until Ray records
them, the production candidate remains unreleased.
