# Breed Improved Phase 3 - Isolated Prototype Implementation Plan

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6 (Scribe)`
- Plan status: `AWAITING APPROVAL`
- Prototype direction: `DYNAST OVERRIDE + AUTHORITY LIMITED TO THE CURRENT WORKFLOW`
- Execution approach: `APPROACH B - DIRECT EFFECTS AFTER FINAL CONFIRMATION`
- Production implementation: `NOT APPROVED`
- Prototype implementation: `NOT STARTED`
- CK3 runtime: `NOT RUN`

This plan translates the approved Phase 3 authority and execution decisions into
a bounded, isolated prototype. It does not authorize production implementation
and does not itself define runnable CK3 script.

The word "authorization" in this plan describes a Breed Improved workflow guard.
It is not a verified CK3 permission, a change to the vanilla marriage
interaction, or a claim that a Dynast has this authority in the base game.

This approved prototype decision supersedes the earlier vanilla-authority
recommendation in
`docs/research/Matt_Phase3_Dynasty_Matchmaking_Feasibility.md`. It does not
supersede that report's evidence that CK3 has no verified blanket Dynast
matchmaking authority, or any of its unresolved syntax and runtime findings.

## 1. Purpose of the prototype

The prototype exists to answer whether the approved architecture can be made
safe and predictable before any production design is accepted.

It must demonstrate:

1. a temporary Dynast override that is usable only within one explicitly
   initiated workflow;
2. reliable cleanup or invalidation of that authorization on every exit path;
3. same-Dynasty pair discovery without relying on vanilla matchmaker authority
   or AI acceptance;
4. stable storage of subject, partner, direction, relationship type, placeholder
   state, and character reservations;
5. ordinary and matrilineal adult marriages;
6. ordinary and matrilineal minor betrothals;
7. a dynamic fertility tier spanning the current best value down through five
   percentage points below it;
8. age-difference priority within that fertility tier;
9. complete all-or-nothing preflight validation;
10. direct-effect side-effect comparison against vanilla behavior;
11. acceptable behavior with a large Dynasty;
12. save/reload and one-day-advance persistence; and
13. no regressions in Phase 1 or Phase 2.

Passing the prototype would establish technical viability only. It would not
approve the workflow, balance, presentation, candidate policy, or direct effects
for a production release.

## 2. Approved prototype decisions

### 2.1 Authority model

The actor must be:

- player-controlled;
- alive;
- the current Dynast of the Dynasty being managed; and
- the character who explicitly starts and confirms the workflow.

After confirmation, Breed Improved may treat that actor as authorized to plan
relationships for eligible members of the actor's current Dynasty during that
workflow only.

This override bypasses only:

- the need for the actor to be each participant's vanilla matchmaker; and
- the need for an external-court ruler or AI participant to accept the proposal.

It does not bypass any other legality, safety, or candidate rule.

### 2.2 Execution model

The prototype uses direct relationship effects only after a separate final
confirmation:

| Participants | Direction | Verified relationship operation |
| --- | --- | --- |
| Both adults | Ordinary | `marry` |
| Both adults | Matrilineal | `marry_matrilineal` |
| Either participant is a minor | Ordinary | `create_betrothal` |
| Either participant is a minor | Matrilineal | `create_betrothal_matrilineal` |

These identifiers are evidenced in
`events/interaction_events/marriage_interaction_events.txt:1016-1032`; the
minor branch also has evidence in
`events/activities/tournaments/tournament_events.txt:1631-1644`.

The exact enclosing scopes and argument forms must be copied from the verified
CK3 `1.19.0.6` examples during the evidence-registration stage. This table is
not substitute syntax.

Grand Weddings are excluded from the prototype.

### 2.3 Failure policy

Immediately before execution, the prototype validates the complete accepted
plan without changing any relationship.

If one pair fails any required check:

- the complete batch stops;
- no marriage or betrothal is created;
- no replacement partner is selected;
- no invalid pair is silently removed;
- no remaining valid pair is executed; and
- the player is informed that the plan could not be executed.

The prototype may retain diagnostic information long enough to show the failure,
but all workflow authority and temporary plan state must then be cleared. A
production design for editing and reconfirming an invalid plan remains deferred.

## 3. Explicit prototype boundaries

### Included

- a player-initiated test Decision and confirmation;
- current-Dynasty candidate discovery;
- temporary workflow authorization;
- sequential pair review;
- ordinary or matrilineal direction;
- unexecuted accepted-pair planning;
- complete final-plan preflight;
- the four direct relationship operations listed above;
- external-court and landed same-Dynasty AI participants;
- cancellation, stale-state, re-entry, and lifecycle cleanup tests;
- static validation, logging, and the existing manual runtime matrix.

### Deferred, not cancelled

- Grand Weddings;
- handing a pair to the vanilla marriage window;
- accepting all remaining best pairs;
- editing accepted pairs on the final confirmation screen;
- partners outside the actor's Dynasty;
- political, alliance, title, inheritance, and realm-benefit scoring;
- automatic invitation or court movement;
- polygamous marriage-slot management;
- divorce or betrothal breaking;
- the final positive-congenital-trait scoring set;
- any negative-congenital-trait score;
- exact relatedness coefficients or genetic-risk prediction;
- final player-facing fertility presentation;
- formal lower fertility tiers;
- final stable tie-breaking and subject ordering;
- precise divorced-versus-widowed treatment;
- final use of never-married zero-fertility characters;
- exhaustive pregnancy, lover, concubine, vow, clergy, activity, government,
  adventurer, hostage, prisoner, and other special-state policy;
- multiplayer consent and authorization for other player characters.

None of these items may be treated as permanently rejected merely because the
first isolated prototype does not implement them.

### Prohibited

The prototype must not:

- modify the production Mod under `MyCK3Mod/`;
- modify or replace the vanilla marriage interaction;
- grant a permanent character or Dynasty permission;
- create a relationship before final confirmation;
- automatically dissolve a marriage or betrothal;
- explicitly move a courtier;
- explicitly change a title, government, House, Dynasty, claim, succession, or
  inheritance state;
- perform background matchmaking, recurring scans, or scheduled pairing;
- enter Workshop staging or release packaging; or
- claim runtime success before CK3 testing.

The direct relationship effects may have engine-owned consequences. Detecting
and comparing those consequences is a prototype objective, not permission to
add compensating effects.

## 4. Isolated prototype boundary and proposed layout

The prototype should be created only after approval under:

```text
tests/phase3_dynasty_matchmaking/
```

The test Mod should be self-contained. Test-owned identifiers should use the
project-prefixed stem:

```text
breedimp_p3_proto
```

The exact separator and declaration form must follow the verified CK3 rule for
each identifier family. In particular, this stem does not allocate an event
namespace or assert an event-ID form.

The likely content families are:

```text
tests/phase3_dynasty_matchmaking/
  BreedImprovedPhase3Prototype.mod
  BreedImprovedPhase3Prototype/
    descriptor.mod
    common/
      decisions/
      scripted_triggers/
      scripted_effects/
      script_values/
    events/
    localization/
      english/
      simp_chinese/
```

This is a proposed layout, not a statement that every listed file is necessary.
Only create a file family after a same-version project or vanilla example proves
its CK3 path and enclosing form.

An additive lifecycle hook may be required to clean state after actor death or
another interruption. No hook file is allocated in this plan. Its exact CK3
`1.19.0.6` declaration, safe additive behavior, and loaded path must be verified
before one is added. If they cannot be verified, implementation stops at the
evidence gate.

The test metadata must:

- identify the content as isolated and non-release;
- target `1.19.*`;
- contain no Workshop ID;
- contain no developer-specific absolute path in committed content; and
- remain outside Workshop staging and release packages.

The event namespace and ID range must be allocated in the project namespace
registry after the exact CK3 namespace declaration is reverified. This plan does
not reserve or invent a range.

## 5. Evidence gate before prototype code

Stage P0 must register exact CK3 `1.19.0.6` evidence for every construct used by
the prototype. Existing Phase 3 research already establishes the high-level
availability of the relationship operations, pair-legality trigger, fertility
value, Dynasty iteration components, and sequential review patterns.

The implementation must stop for verification if any exact form remains
uncertain, including:

- the selected test Decision form and confirmation flow;
- every actor, Dynasty, participant, parent, spouse, betrothal, and age scope;
- `can_marry_character_trigger` context and both participant directions;
- current-spouse and current-betrothal availability checks;
- direct ancestor/descendant checks in both directions;
- current-Dynasty comparison;
- Dynast identity validation;
- fertility value capture, subtraction, and inclusive comparison;
- pair ordering or shortlist iteration;
- temporary state, saved-scope, list, variable, or bounded-slot lifetime;
- cleanup of all actor-owned temporary state;
- actor-death and Dynast-loss lifecycle handling;
- all four direct relationship effect contexts;
- logging and debug-output form;
- event and localisation declaration forms; and
- the exact English and Simplified Chinese localisation headers and encodings.

No construct may be borrowed from Stellaris, Europa Universalis IV, Victoria 3,
or another Paradox title. No plausible-looking CK3 syntax may be accepted
without project or vanilla evidence.

## 6. Workflow authorization design

### 6.1 Authorization is conjunctive, not a permanent flag

An internal workflow marker alone must never grant authority. Every stateful
entry point must require all of the following:

1. the recorded actor matches the current workflow actor;
2. the workflow is in the expected active phase;
3. the actor is alive;
4. the actor is player-controlled;
5. the actor is still the Dynast of the recorded Dynasty; and
6. the pair participants still belong to that Dynasty.

If any condition is false, the authorization is invalid even if stale storage
has not yet been physically removed. No candidate action or execution path may
use stale state.

### 6.2 Activation

The sequence is:

1. the actor invokes the test-only Manage Dynasty Matchmaking Decision;
2. pre-entry validation confirms the actor is a living player Dynast;
3. stale Phase 3 prototype state owned by the actor is cleared;
4. an explanatory confirmation is shown;
5. only the actor's explicit confirmation activates the workflow guard; and
6. candidate discovery begins for that run.

Opening the Decision or cancelling the entry confirmation must not activate
authority or scan candidates.

### 6.3 Required cleanup table

| Exit or invalidation path | Required outcome |
| --- | --- |
| Successful execution | Clear authority, accepted pairs, reservations, rejected alternatives, review cursors, and candidate state after execution completes. |
| Review-stage cancel | Clear all Phase 3 prototype state; create no relationship. |
| Final-confirmation cancel | Clear all Phase 3 prototype state; create no relationship. |
| No valid candidates | Show the no-candidate result and clear all state. |
| Any final preflight failure | Execute no pair, show failure, and clear all state. |
| Actor death | Authorization becomes immediately unusable; use a verified lifecycle path to remove residual state. |
| Actor ceases to be Dynast | Authorization becomes immediately unusable; abort and clear at the next reachable workflow/lifecycle entry point. |
| Unexpected event-chain exit | Residual state must be inert; a verified cleanup path removes it. |
| New workflow start | Clear any stale Phase 3 prototype state before creating the new run. |

The exact physical cleanup mechanism for death, Dynast loss, and abnormal exit
is a required P0/P1 proof. It must not be guessed. Logical invalidation through
the conjunctive guard is mandatory even if cleanup timing needs runtime
measurement.

No cleanup mechanism may perform candidate scanning or matchmaking in the
background.

## 7. Candidate and pair legality

The prototype candidate pool is limited to characters who:

- belong to the workflow actor's current Dynasty;
- are alive;
- are not currently married;
- are not currently betrothed;
- are not already reserved by another accepted pair;
- are not controlled by another player; and
- pass every supported vanilla and project safety check.

The prototype must permit eligible same-Dynasty AI characters who are landed or
in another court. It must not require the actor to be their vanilla matchmaker
and must not require their AI ruler to accept.

Every proposed pair must:

- contain two distinct characters from the same recorded Dynasty;
- pass `can_marry_character_trigger` in the verified pair context;
- obey faith and consanguinity restrictions represented by vanilla legality;
- exclude a direct ancestor/descendant relationship in either direction;
- contain no participant already reserved by another pair;
- have no mirror-equivalent pair already accepted;
- use betrothal when either participant is a minor;
- use marriage only when both participants are adults;
- reject any pairing between a minor and a woman aged 30 or older;
- reject any pairing between a minor and a man aged 40 or older; and
- remain valid for the selected ordinary or matrilineal direction.

The exact handling of special states not included in the prototype must be
conservative. A character outside the documented supported test class is
excluded rather than assigned guessed behavior. That temporary prototype
exclusion does not settle the final product policy.

## 8. Prototype ranking

The prototype is intended to prove only the required ordering components.

### 8.1 Adult partner tier

For the current subject:

1. filter the eligible and legal partner pool;
2. determine the highest current fertility value in that pool;
3. define an inclusive tier from that best value down through exactly `0.05`
   below it;
4. retain all partners inside that tier; and
5. prefer the smallest age difference within the tier.

The calculation is dynamic for the current eligible pool. Its exact CK3 value
storage, arithmetic, comparison, and ordering forms are **REQUIRES PROTOTYPE**
and must pass the evidence gate before implementation.

No final genetics score, exact relatedness value, political score, or formal
lower fertility tiers are part of this proof.

### 8.2 Minor partner ordering

The prototype must enforce the approved age safety rules and may use age
difference as its first ordering dimension. The final positive-trait and
kinship-category ranking remains a post-prototype product decision. Vanilla
marriage legality still applies regardless of how tied legal candidates are
ordered.

### 8.3 Ties and placeholders

The prototype must not claim a final stable ordering when all implemented
dimensions tie. It may use a documented, repeatable test ordering if the engine
form is verified.

Previously married zero-fertility partners may be represented as a last-resort
placeholder class only if their status and storage can be verified. Their final
product use and the treatment of never-married zero-fertility characters remain
deferred.

## 9. Review controls and pair-plan state

The minimum review controls are:

- accept the displayed pair and choose ordinary direction;
- accept the displayed pair and choose matrilineal direction;
- show another eligible partner for the same subject;
- skip the displayed proposal;
- defer the subject for the rest of the current prototype run;
- finish review and proceed to final confirmation;
- cancel the complete workflow.

The prototype does not include "accept all remaining best pairs." It does not
permit editing accepted pairs on the final page.

Accepting a pair writes only temporary plan data. It must reserve both
characters so neither can appear in another pair. It must not create a marriage,
betrothal, cost, opinion change, court move, or other gameplay consequence.

Each accepted record must preserve:

- subject;
- partner;
- ordinary or matrilineal direction;
- expected marriage or betrothal type;
- placeholder status, when applicable; and
- enough reservation identity to reject duplicates and mirror pairs.

The pair representation is a prototype gate. A single character list is
insufficient, and parallel lists must not be assumed to behave as indexed
tuples. The implementation should prefer actor-owned temporary state so cleanup
does not depend on mutating every participant.

A bounded slot representation is a reasonable prototype candidate because it
can make pair integrity and cleanup explicit. The exact representation and
prototype-only maximum must be proposed after evidence review and approved
before coding. This plan does not silently introduce a product pair limit.

## 10. Complete preflight and guarded execution

### 10.1 Preflight

The final confirmation event performs a read-only validation pass over the
complete accepted plan. It must check:

- active authorization and the recorded actor;
- actor alive, player-controlled, and still Dynast;
- recorded Dynasty identity;
- both participants alive and still in that Dynasty;
- neither participant married or betrothed;
- neither participant used in another accepted pair;
- no mirrored duplicate;
- direct ancestor/descendant exclusion;
- vanilla pair legality;
- the female-30 and male-40 minor-pair rules;
- stored direction;
- stored relationship type matching current ages;
- placeholder policy, if the prototype includes placeholders; and
- every additional supported-class protection registered during P0.

No relationship effect may run during this pass.

If the plan is empty, the workflow exits without effects. If any record is
invalid, the whole plan follows the failure policy in Section 2.3.

### 10.2 Execution

Only after every record passes preflight may the prototype execute the stored
records.

The execution stage may call only the one verified relationship operation
corresponding to each record. It must not add separate alliance, Prestige,
court-movement, title, government, House, Dynasty, claim, inheritance, memory,
opinion, stress, or other compensating effects.

Because CK3 script does not have a verified transaction rollback for this
workflow, there must be no conditional validation between the first and last
relationship mutation. Full validation must finish first. Runtime testing must
still check whether an engine-owned side effect can invalidate a later pair.

After all relationship operations finish, clear every Phase 3 prototype state.

## 11. Debug and observability support

The test Mod should provide concise, test-only diagnostics for:

- workflow activation and cleanup reason;
- actor and recorded Dynasty;
- candidate-pool counts after each filter stage;
- selected fertility best value and five-point threshold;
- accepted slot, participant identities, direction, and relationship type;
- preflight success or the first failing slot and reason;
- number of relationship operations attempted; and
- completion cleanup.

Exact logging syntax must be verified before use. Diagnostics must not expose
internal text in player-facing production localisation and must not enter the
production Mod.

The manual tester must also record:

- alliances;
- Prestige;
- court and realm;
- titles and government;
- succession;
- matchmaker ownership where visible;
- memories and relevant history where visible;
- spouses or betrothals;
- save/reload and one-day-advance state; and
- CK3 `error.log`.

## 12. Implementation stages

### P0 - Evidence registration and design closure

- Register exact CK3 `1.19.0.6` examples for every construct listed in Section 5.
- Select and document a pair-state representation.
- Propose a prototype-only accepted-pair capacity if bounded slots are required.
- Prove a safe lifecycle strategy for actor death, Dynast loss, and abnormal exit.
- Allocate a test namespace and non-overlapping event range.
- Confirm exact test Mod paths, metadata form, localisation headers, and BOM.
- Stop for Jay review if any core construct remains unverified.

Deliverable: an evidence-backed implementation map; no gameplay claim.

### P1 - Isolated scaffold and authorization lifecycle

- Create only the standalone test Mod.
- Add the player-Dynast entry and explicit confirmation.
- Add stale-state cleanup before activation.
- Implement the conjunctive workflow guard.
- Implement every cancel, no-candidate, completion, death, Dynast-loss, and
  abnormal-exit cleanup path supported by the verified design.
- Test statically that internal execution cannot be entered without the active
  workflow guard.

Deliverable: a non-executing authorization and cleanup harness.

### P2 - Candidate pools and ranking proof

- Build the filtered current-Dynasty test pool.
- Apply supported legality and safety checks.
- Implement reservation-aware pair discovery.
- Prove the dynamic best-minus-`0.05` adult fertility tier.
- Prove age-difference priority inside the tier.
- Add only the minimum minor ordering required for the prototype.
- Add timing diagnostics for large-Dynasty measurements.

Deliverable: reviewable pair recommendations with no relationship mutation.

### P3 - Pair review and temporary plan

- Add ordinary and matrilineal acceptance paths.
- Store subject, partner, type, direction, and placeholder state.
- Enforce one pair per character and mirror elimination.
- Add next, skip, defer, finish, and cancel behavior.
- Add a read-only final summary.
- Prove every pre-confirmation exit leaves relationships unchanged.

Deliverable: a stable unexecuted plan.

### P4 - Full preflight and direct relationship operations

- Implement the complete read-only preflight.
- Abort the whole plan on the first invalid pair.
- Add the four verified direct relationship operations.
- Add no unrelated state-changing effect.
- Clear workflow state after success or failure.

Deliverable: the isolated execution harness, still not runtime-approved.

### P5 - Static review

- Validate braces, quotes, scopes, references, namespaces, event IDs, and paths.
- Validate bilingual localisation key parity, duplicate keys, references, BOM,
  and non-empty player-facing text.
- Confirm every prototype identifier uses the approved `breedimp_p3_proto`
  test stem in the verified form for that identifier family.
- Confirm no production, descriptor, version, release, or Workshop file changed.
- Confirm no absolute local path, Workshop ID, or test content enters production.
- Confirm no automatic scan, recurring execution, or background matchmaking.
- Confirm the relationship stage contains only the four approved operation
  classes and cannot run before full preflight.
- Run `git diff --check` and a trailing-whitespace check.

Deliverable: a static report that does not claim CK3 runtime success.

### P6 - Approval gate before CK3

After static review, stop and request separate approval to launch CK3. The
existing Phase 3 manual matrix, with the added workflow-authorization cases,
remains the runtime source of truth. Every case starts as `NOT RUN`.

## 13. Runtime acceptance gates

The isolated prototype cannot be recommended for production work unless manual
testing demonstrates:

- authorization activates only after a living player Dynast confirms;
- authorization and temporary state clear or become unusable on every required
  exit and invalidation path;
- no internal operation is callable outside the recorded workflow;
- other-court and landed eligible same-Dynasty AI members can be paired safely;
- ordinary and matrilineal adult marriages work;
- ordinary and matrilineal minor betrothals work;
- direct-effect differences from native marriage behavior are recorded;
- the dynamic fertility tier includes the best value and the inclusive
  best-minus-five-point boundary;
- age difference is preferred within the tier;
- one character cannot enter two pairs;
- mirror duplicates cannot be accepted;
- direction, relationship type, and placeholder state survive the complete
  review chain;
- cancellation and all invalidation paths produce no relationship change;
- one invalid pair stops the entire batch before any relationship is created;
- large-Dynasty timings are recorded and judged acceptable by Ray;
- relationships survive save/reload and a one-day advance;
- Phase 1 and Phase 2 regressions pass; and
- CK3 logs contain no blocking error.

The matrix must record observed results. Static reasoning must not be converted
into a runtime `PASS`.

## 14. Risks and mandatory stop conditions

Implementation stops and returns to Jay if:

- no verified CK3 form can make authorization state both inert outside the
  workflow and cleanable on required lifecycle exits;
- pair records cannot preserve their complete tuple reliably;
- fertility threshold arithmetic or comparison cannot be evidenced;
- full-plan preflight cannot be completed before the first relationship effect;
- a required safety rule cannot be expressed with verified CK3 syntax;
- direct execution requires copying or replacing the vanilla marriage
  interaction;
- the first relationship can invalidate later records in a way preflight cannot
  control;
- a reasonable large-Dynasty prototype requires an unbounded quadratic scan; or
- the requested change would touch production or release files.

These conditions are blockers, not invitations to guess.

## 15. Approval requested

Jay and the Boss are asked to approve only:

1. the isolated test-Mod boundary;
2. the staged P0-P6 implementation sequence;
3. the conjunctive workflow authorization model;
4. the all-or-nothing preflight and failure flow;
5. a later evidence-backed pair-storage proposal before P1/P3 coding; and
6. static completion followed by a separate runtime approval gate.

Approval of this plan would not approve production implementation, Workshop
packaging, release publication, or CK3 execution. Work must stop again after
static prototype preparation and before runtime testing.
