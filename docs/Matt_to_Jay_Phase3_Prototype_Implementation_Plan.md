# Breed Improved Phase 3 - Isolated Prototype Implementation Plan

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6 (Scribe)`
- Phase 3 isolated prototype:
  `STATIC IMPLEMENTATION COMPLETE — RUNTIME TEST REQUIRED`
- Plan status: `P0 CORRECTED AND CLOSED`
- Prototype direction: `DYNAST OVERRIDE + AUTHORITY LIMITED TO THE CURRENT WORKFLOW`
- Execution approach: `APPROACH B - DIRECT EFFECTS AFTER FINAL CONFIRMATION`
- Production implementation: `NOT APPROVED`
- P0 evidence/design checkpoint: `P0 CORRECTED AND CLOSED`
- P1-P5 status: `STATIC COMPLETE`
- P6 status: `AWAITING RAY RUNTIME APPROVAL`
- Prototype implementation: `ISOLATED; PRODUCTION NOT APPROVED`
- CK3 runtime: `NOT RUN`

This plan translates the approved Phase 3 authority and execution decisions into
a bounded, isolated prototype. P0 is corrected and closed, and P1-P5 static work
is complete. P6 runtime approval and execution remain with Ray. Nothing in this document
authorizes production implementation or claims a CK3 runtime result.

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

These identifiers are evidenced for marriage at
`common/scripted_effects/00_game_rule_effects.txt:22-28`, for betrothal at
`common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111`, and for the
adult/minor branch at
`events/activities/tournaments/tournament_events.txt:1159-1177`.

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

The isolated prototype architecture is confined to:

```text
tests/phase3_dynasty_matchmaking/
```

The test Mod must be self-contained. Test-owned non-event identifiers will use
the project-prefixed stem:

```text
breedimp_p3_proto
```

The exact separator and declaration form must follow the verified CK3 rule for
each identifier family.

The isolated static architecture is:

```text
tests/phase3_dynasty_matchmaking/
  BreedImprovedPhase3Prototype.mod
  BreedImprovedPhase3Prototype/
    descriptor.mod
    common/
      decisions/
        breedimp_p3_proto_matchmaking_decisions.txt
      on_action/
        breedimp_p3_proto_matchmaking_on_actions.txt
      scripted_triggers/
        breedimp_p3_proto_matchmaking_lifecycle_triggers.txt
        breedimp_p3_proto_matchmaking_candidate_triggers.txt
        breedimp_p3_proto_matchmaking_plan_triggers.txt
      scripted_effects/
        breedimp_p3_proto_matchmaking_lifecycle_effects.txt
        breedimp_p3_proto_matchmaking_candidate_effects.txt
        breedimp_p3_proto_matchmaking_plan_effects.txt
        breedimp_p3_proto_matchmaking_relationship_effects.txt
      script_values/
        breedimp_p3_proto_matchmaking_values.txt
    events/
      breedimp_p3_proto_matchmaking_events.txt
    localization/
      english/
        breedimp_p3_proto_l_english.yml
      simp_chinese/
        breedimp_p3_proto_l_simp_chinese.yml
```

This path allocation remains test-only. It does not authorize a production file
or any copy into `MyCK3Mod/`, release packaging, or Workshop staging.

The production baseline through v0.2.0 is already published on Steam Workshop
item `3769010534`; GitHub remains the source and release-record channel, while
the Workshop item is the player-distribution channel. The isolated Phase 3
prototype belongs to neither release surface and must not alter that published
baseline.

The `common/on_action/` file is allocated only for additive child
on-actions. `common/on_action/_on_actions.info:102-117` forbids appending a
second effect block directly to a named vanilla on-action and documents the
child-on-action form. No vanilla file will be replaced or copied.

The metadata contract is:

- outer launcher template:
  `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype.mod`;
- inner descriptor:
  `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype/descriptor.mod`;
- display name: `Breed Improved Phase 3 Prototype`;
- descriptor version: `0.1.0`;
- compatibility: `1.19.*`;
- outer path: the established portable `<LOCAL_MOD_PATH>` placeholder;
- inner descriptor: no `path` and no `remote_file_id`;
- test-only and non-release; and
- never included in Workshop staging or release packages.

The descriptor field structure follows
`tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod` and its inner
`descriptor.mod`. This contract does not invent a Workshop association.

The localisation contract is:

- English path:
  `BreedImprovedPhase3Prototype/localization/english/breedimp_p3_proto_l_english.yml`;
- Simplified Chinese path:
  `BreedImprovedPhase3Prototype/localization/simp_chinese/breedimp_p3_proto_l_simp_chinese.yml`;
- exact headers `l_english:` and `l_simp_chinese:`;
- matching key sets, quoted values, established one-space indentation, and no
  duplicate or unresolved keys; and
- UTF-8 with BOM in both files.

The test event namespace is now allocated as:

| Purpose | Namespace | Event range | Status |
| --- | --- | --- | --- |
| Phase 3 isolated validation | `breedimp_p3_proto_matchmaking` | `1000-1199` | P0 allocation; isolated prototype only |

Production Phase 3 IDs remain unallocated.

## 5. Evidence gate before prototype code

P0 registers the following CK3 `1.19.0.6` evidence. Paths beginning with
`common/`, `events/`, `tests/`, or `localization/` in the evidence column are
relative to the installed CK3 `game/` directory unless a repository path is
spelled out.

| Required construct | Exact evidence | P0 classification and restriction |
| --- | --- | --- |
| Player Decision fields, actor capture, and event call | Decision schema: `common/decisions/_decisions.info:125-143`; actor capture: `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`; event dispatch: `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78` | **VERIFIED AND IMPLEMENTATION-READY** as entry components; repeated-chain continuity remains runtime |
| Event namespace, generic fields, and options | `events/_events.info:5-38,156-164`; project namespace form at `MyCK3Mod/events/breedimp_dynasty_cleanup_events.txt:1-8` | **VERIFIED AND IMPLEMENTATION-READY** as event schema; this supplies no window-lifecycle callback |
| Dynasty member iteration | `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt:4170-4266`; `events/relations_events/parent_events.txt`, `parent.1009`; `events/activities/coronation_activity/prelude_events.txt:4603-4609` | **VERIFIED AND IMPLEMENTATION-READY**; candidate discovery remains player-initiated only |
| Pair legality | `common/scripted_triggers/00_marriage_triggers.txt:183-212,412-427` | **VERIFIED AND IMPLEMENTATION-READY** for `can_marry_character_trigger` in its evidenced pair context; a mutually betrothed pair can pass, so the trigger is not a standalone unbetrothed check |
| Current marriage and betrothal state | `events/activities/tournaments/tournament_events.txt:4819-4824` | **VERIFIED AND IMPLEMENTATION-READY** for independent `is_married = no` and `is_betrothed = no` checks on both participants |
| Conservative special-state exclusions | `is_imprisoned = no`: `common/character_interactions/00_marriage_interactions.txt:514-540`; `is_hostage = no` and `is_concubine = no`: `common/scripted_triggers/00_marriage_triggers.txt:244-252,274-282,536-544`; `is_pregnant = no`: `events/dlc/ep3/ep3_wedding_events.txt:2055-2061` | All four character-trigger forms are **VERIFIED**. Applying them to both participants is a prototype-only conservative supported-class boundary, not a universal vanilla rule or final production policy. |
| Sex and age-threshold checks | `is_female` and `is_male`: `common/scripted_triggers/00_marriage_triggers.txt:484-493`; numeric `age >=`: `common/character_interactions/00_marriage_interactions.txt:3456-3463` | Trigger forms are **VERIFIED**. The female 30+/male 40+ with a minor thresholds are approved prototype policy and are applied in both role directions. |
| Adult/minor relationship selection | `events/activities/tournaments/tournament_events.txt:1159-1177`; `common/scripted_triggers/00_marriage_triggers.txt:354-429` | **VERIFIED AND IMPLEMENTATION-READY** for distinguishing adult marriage from a pair containing a minor; combined prototype behavior remains runtime |
| Direct relationship effects | marriage forms: `common/scripted_effects/00_game_rule_effects.txt:22-28`; betrothal forms: `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111` | **VERIFIED AND IMPLEMENTATION-READY** for the four identifiers in their cited character scopes; side effects and supported target classes are **REQUIRES PROTOTYPE** |
| Dynast check and identity | `common/decisions/80_major_decisions.txt:847`; `events/court_maintenance_events.txt:301-305`; `common/character_interactions/00_marriage_interactions.txt:214,234` | **VERIFIED AND IMPLEMENTATION-READY** for `is_dynast` and comparing a character with `dynasty.dynast` |
| Fertility and age components | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548`; `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229`; `common/script_values/_script_values.info` | Individual values, zero comparison, age difference, and numeric ordering are verified; the complete best-minus-`0.05` pipeline is **REQUIRES PROTOTYPE** |
| Direct-ancestor and kinship components | `common/scripted_triggers/00_family_triggers.txt:17-62`; `common/scripted_triggers/00_religious_triggers.txt:231-301`; `common/religion/doctrine_types/20_doctrines.txt:682-793` | Verified family and doctrine mechanisms exist; use the exact registered context and preserve an explicit direct-ancestor/descendant exclusion |
| Character-valued actor variable and identity comparison | storage: `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167`; equality: `events/board_game_events.txt:1173-1187` | **VERIFIED AND IMPLEMENTATION-READY** components for actor-owned subject/partner references and duplicate-role comparisons; combined slot lifetime needs runtime |
| Flag-valued actor variable | `events/board_game_events.txt:61-82,170-180` | **VERIFIED AND IMPLEMENTATION-READY** component for direction, relationship type, placeholder, failure reason, and preflight-pass values; `reservation_id` is instead a character reference equal to `subject` |
| Numeric actor-variable assignment | `value = $VALUE$` at `common/scripted_effects/00_achievement_effects.txt:33-44`; explicit numeric caller at `common/on_action/game_start.txt:5333-5339` | **VERIFIED AND IMPLEMENTATION-READY** for the unpadded `1`-`16` failure-slot diagnostic |
| Typed Dynasty actor variable | `events/interaction_events/adoption_events.txt:83-98`; `common/scripted_effects/01_ep1_court_artifact_creation_effects.txt:1469-1476`; `events/court_maintenance_events.txt:597-618,663-680`; `common/character_interactions/00_artifact_interactions.txt:4046-4077` | **VERIFIED COMPONENTS** for recording and comparing a Dynasty on the workflow actor; visible-chain and save/reload continuity remain runtime |
| Remove actor variables | `events/relations_events/adultery_events.txt:2696-2700`; `events/board_game_events.txt:2314-2328` | **VERIFIED AND IMPLEMENTATION-READY** only with an `exists = var:<name>` guard for every explicit field |
| Global active-actor coordinator | storage: `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; identity equality: `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; entered scope: `events/religion_events/great_holy_war_events.txt:818-824` | Global actor storage, comparison, and scope entry are verified; combined workflow use is **VERIFIED BUT CONTEXT-DEPENDENT** |
| Global phase flag | set: `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; compare: `common/script_values/99_steward_values.txt:694-698` | Global `flag:` storage and equality are **VERIFIED AND IMPLEMENTATION-READY** components |
| Remove global coordinator state | `events/dlc/ep3/ep3_frankokratia_events.txt:4255-4266` | **VERIFIED AND IMPLEMENTATION-READY** only with the evidenced existence guard |
| Permanent one-workflow-per-save lock | once-only pattern: `events/yearly_events/yearly_events_3.txt:3337-3350,3432-3448`; global flag values: `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`, `common/script_values/99_steward_values.txt:694-698`; long-lived achievement globals: `common/scripted_effects/00_achievement_effects.txt:33-44`, `common/on_action/game_start.txt:5039-5042`, `common/achievements/fp1_achievements.txt:1-4` | `global_var:breedimp_p3_proto_used_in_save = flag:breedimp_p3_proto_used` composes verified absence, global flag, and equality forms. The entry event's explicit activation option sets it before coordinator/candidate work; opening the Decision or cancelling that entry event does not. It is never cleared. Exact save/reload persistence remains a P6 runtime gate. |
| Numeric run-identity research lead | `events/religion_events/great_holy_war_events.txt:618-621`; `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4410-4413` | Increment and scope-value capture are verified; exact saved/global comparison is **NOT VERIFIED**, so the prototype uses no numeric run identity |
| Additive on-action registration | `common/on_action/_on_actions.info:102-117` | **VERIFIED AND IMPLEMENTATION-READY** only through a Mod-owned child on-action; never append a second effect block to the vanilla on-action |
| Actor-death cleanup context | `common/on_action/death.txt:1-6` | **VERIFIED AND IMPLEMENTATION-READY** root scope; cleanup timing and save/reload remain runtime |
| Dynast-change cleanup context | `common/on_action/dynasty_on_actions.txt:13-17` | `on_became_dynasty_head` root and `scope:dynasty` are verified; it exposes no former head and complete coverage is **REQUIRES PROTOTYPE** |
| Load/start cleanup context | `common/on_action/game_start.txt:2590-2592` | Hook exists; exact timing for every save-load path is **NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED** |
| Event trigger-failure cleanup | `events/_events.info:125-129`; exact use at `events/board_game_events.txt:1902-1910` | `on_trigger_fail` is verified for queued/instant trigger failure; it is not a general visible-event close callback |
| Descriptor and portable path pattern | `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`; `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod` | **VERIFIED AND IMPLEMENTATION-READY** project pattern for a portable outer test descriptor and path-free inner descriptor |
| Localisation headers and BOM | `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml`; `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_cleanup_l_simp_chinese.yml` | Exact headers and UTF-8 BOM are verified by project files; final text and UI presentation remain unapproved |

No verified CK3 `1.19.0.6` generic callback was found for closing or abandoning a
visible event window. Targeted inspection also found no
`on_lost_dynasty_head`, `on_ceased_to_be_dynasty_head`,
`on_dynasty_head_changed`, or `on_character_dynasty_changed` on-action in the
top-level vanilla on-action files. These identifiers must not be invented.

The following remain explicitly `NOT VERIFIED` or runtime-only after P0:

- an exact numeric run-identity comparison; it is not approved or used because
  the permanent lock forbids every later workflow in that save;
- combined save/reload persistence of the coordinator, actor metadata, all
  numbered slots, and visible event scopes;
- immediate physical cleanup after a visible event is closed abnormally;
- any generic event-window close callback or guaranteed immediate cleanup after
  abnormal closure;
- exact `on_game_start_after_lobby` timing for every load path;
- whether `on_became_dynasty_head` covers every engine cause by which the actor
  loses or changes Dynast status;
- save/reload behavior for an open review event and the permanent lock;
- direct-effect alliances, Prestige, court movement, memories, succession, and
  other engine-owned consequences;
- the complete dynamic best-minus-`0.05` fertility pipeline;
- large-Dynasty performance; and
- concurrent multiplayer workflows, which the single-coordinator prototype
  deliberately excludes.

No construct may be borrowed from Stellaris, Europa Universalis IV, Victoria 3,
or another Paradox title. No plausible-looking CK3 syntax may be accepted
without project or vanilla evidence.

## 6. Workflow authorization design

### 6.1 Authorization is conjunctive; the permanent lock grants nothing

The prototype uses these exact project-owned global keys:

- `global_var:breedimp_p3_proto_used_in_save` with
  `flag:breedimp_p3_proto_used` as the permanent activation barrier;
- `global_var:breedimp_p3_proto_active_actor` as the removable character
  pointer; and
- `global_var:breedimp_p3_proto_phase` as the removable workflow-phase flag.

The names are Breed Improved identifiers. Their storage and comparison forms
come from the registered CK3 evidence; they are not vanilla identifiers.

An internal workflow marker alone must never grant authority. Every stateful
entry point must require all of the following:

1. the global active actor matches the event-chain actor;
2. the global workflow is in the expected active phase;
3. the actor is alive;
4. the actor is player-controlled;
5. the actor-owned `breedimp_p3_proto_managed_dynasty` variable exists and
   resolves to the recorded Dynasty;
6. the actor is still the Dynast of that recorded Dynasty; and
7. the pair participants still belong to that Dynasty.

If any condition is false, the authorization is invalid even if stale storage
has not yet been physically removed. No candidate action or execution path may
use stale state. The permanent lock is checked only to block activation and
never satisfies an authorization clause.

This statement applies when an internal entry is evaluated. Static evidence
does not show that closing a displayed event invokes an entry or cleanup
callback. The prototype therefore has no delayed/background continuation and no
resume path: an abnormally closed workflow is orphaned and permanently locked.

### 6.2 Activation

The sequence is:

1. the actor invokes the test-only Manage Dynasty Matchmaking Decision;
2. pre-entry validation confirms the actor is a living player Dynast;
3. the Decision remains unavailable or invalid if the permanent lock already
   exists;
4. an explanatory confirmation is shown;
5. only the actor's explicit confirmation option in the entry event calls the
   activation effect and sets the permanent lock;
6. the permanent lock is written before coordinator state or candidate
   scanning; and
7. candidate discovery begins for that sole run.

Opening the Decision only dispatches the pre-activation confirmation event.
Opening it or cancelling that event must not activate authority, set the lock,
or scan candidates. The lock is never removed.

### 6.3 Required cleanup table

| Exit or invalidation path | Required outcome |
| --- | --- |
| Successful execution | Clear active authority, accepted pairs, reservations, rejected alternatives, review cursors, and candidate state after execution completes. Keep the permanent lock. |
| Review-stage cancel | Clear active Phase 3 prototype state; create no relationship; keep the permanent lock. |
| Final-confirmation cancel | Clear active Phase 3 prototype state; create no relationship; keep the permanent lock. |
| No valid candidates | Show the no-candidate result, clear active state, and keep the permanent lock. |
| Any final preflight failure | Execute no pair; store the first failing numeric slot and reason in actor variables; show the failure result; clear active state when that result is acknowledged; keep the permanent lock. Abnormal result-window closure follows the orphaned/locked contract. |
| Actor death | Every later entry rechecks `is_alive`; a Mod child of `on_death` cleans the root-owned slots and coordinator when root is the recorded actor. The lock remains. Exact hook/state ordering remains a runtime gate. |
| Actor ceases to be Dynast | Every later entry rechecks Dynast/Dynasty identity; a Mod child of `on_became_dynasty_head` checks the recorded actor and cleans invalid active state. The lock remains. Exact transition ordering and cause coverage remain runtime gates. |
| Queued/instant event trigger failure | Event `on_trigger_fail` invokes centralized active-state cleanup; the lock remains. |
| Unexpected visible-event exit | No generic close callback or immediate-cleanup claim. Because the workflow has no delayed/background continuation or resume path, residual state is orphaned and cannot advance. The permanent lock prevents reauthorization. |
| New workflow start | If the permanent lock exists, reject every actor before activation. There is no same-actor restart, resume, or residue-reuse path. |

P0 establishes the static cleanup strategy. Physical timing for death, Dynast
transfer, load/start, and abnormal visible-event closure remains a runtime
prototype question. Cleanup removes slot payloads first, then phase, and the
global actor pointer last so an interrupted cleanup retains the owner pointer
needed for a later purge. It never removes the permanent lock. Each slot-field
removal and each removable global field must first use the corresponding
verified existence guard.

No cleanup mechanism may perform candidate scanning or matchmaking in the
background.

## 7. Candidate and pair legality

The prototype candidate pool is limited to characters who:

- belong to the workflow actor's current Dynasty;
- are alive;
- are not currently married;
- are not currently betrothed;
- are not imprisoned, hostages, concubines, or pregnant in this conservative
  isolated test class;
- are not already reserved by another accepted pair;
- are not controlled by another player; and
- pass every supported vanilla and project safety check.

The prototype must permit eligible same-Dynasty AI characters who are landed or
in another court. It must not require the actor to be their vanilla matchmaker
and must not require their AI ruler to accept.

Every proposed pair must:

- contain two distinct characters from the same recorded Dynasty;
- pass `can_marry_character_trigger` in the verified pair context;
- independently pass `is_married = no` and `is_betrothed = no` on both
  participants;
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

The four explicit conservative exclusions above use same-version vanilla
character triggers. They do not imply a final production policy for prisoners,
hostages, concubines, or pregnant characters, and no unverified generic
activity, government, adventurer, or other special-state trigger is invented.

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

P0 selects sixteen explicitly numbered actor-owned slots. A single character
list is insufficient, and parallel lists must not be assumed to behave as
indexed tuples. Participant characters receive no reservation variables.

Each slot stores:

1. `subject` as a character reference;
2. `partner` as a character reference;
3. `direction` as an ordinary or matrilineal flag value;
4. `relationship_type` as a marriage or betrothal flag value;
5. `placeholder` as an explicit yes or no flag value; and
6. `reservation_id` as a second character reference to that slot's `subject`.

The first five fields are written before `reservation_id`. A slot is committed
only when all six fields exist, every enum belongs to the approved set, and the
reservation reference equals that slot's subject. The slot-specific variable
name plus subject equality is the commit identity; no embedded flag-name
construction is used. A partial slot cannot reserve a character, appear in the
final summary, or execute.

The six-field protocol is `VERIFIED COMPONENTS; COMPOSED LIFECYCLE REQUIRES
PROTOTYPE`. It is not an atomic CK3 record. Cleanup checks existence before
removing every static field.

Before writing and again during final preflight, both proposed characters are
compared with both character fields of every committed slot. This prevents
subject reuse, partner reuse, and the mirror pair `(B, A)` after `(A, B)`.

The prototype capacity is sixteen accepted pairs and at most 32 reserved
characters. Complete uniqueness validation performs 120 unordered slot-pair
comparisons and four subject/partner role checks per pair, for at most 480
character-reference comparisons. A seventeenth pair must not overwrite, wrap,
or truncate a committed slot. This explicit bound is for the isolated
prototype only and does not establish a production limit.

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

Status: `P0 CORRECTED AND CLOSED`.

- Register exact CK3 `1.19.0.6` examples for every construct listed in Section 5.
- Select and document a pair-state representation.
- Propose a prototype-only accepted-pair capacity if bounded slots are required.
- Close a guarded lifecycle and recovery strategy for actor death, Dynast loss,
  and abnormal exit while preserving every unverified callback/timing gap.
- Select the permanent one-workflow-per-save lock because numeric run identity
  remains unverified.
- Allocate a test namespace and non-overlapping event range.
- Confirm exact test Mod paths, metadata form, localisation headers, and BOM.
- Stop for Jay review if any core construct remains unverified.

Deliverable: an evidence-backed implementation map; no gameplay claim.

### P1 - Isolated scaffold and authorization lifecycle

Status: `STATIC COMPLETE — RUNTIME NOT RUN`.

- Create only the standalone test Mod.
- Add the player-Dynast entry and explicit confirmation.
- Add the permanent lock first in the entry event's explicit activation option and reject every
  second workflow in the same save.
- Implement the conjunctive workflow guard.
- Implement every explicit cancel, no-candidate, completion, death,
  Dynast-loss, and trigger-failure cleanup path supported by verified
  evidence.
- For abnormal visible-event closure, provide no delayed/background
  continuation, resume, or reauthorization path; do not claim a close callback.
- Test statically that internal execution cannot be entered without the active
  workflow guard.

Deliverable: a non-executing authorization and cleanup harness.

### P2 - Candidate pools and ranking proof

Status: `STATIC COMPLETE — RUNTIME NOT RUN`.

- Build the filtered current-Dynasty test pool.
- Apply supported legality and safety checks.
- Implement reservation-aware pair discovery.
- Prove the dynamic best-minus-`0.05` adult fertility tier.
- Prove age-difference priority inside the tier.
- Add only the minimum minor ordering required for the prototype.
- Record large-Dynasty timings through the manual runtime matrix; do not invent
  unverified logging syntax.

Deliverable: reviewable pair recommendations with no relationship mutation.

### P3 - Pair review and temporary plan

Status: `STATIC COMPLETE — RUNTIME NOT RUN`.

- Add ordinary and matrilineal acceptance paths.
- Store subject, partner, type, direction, and placeholder state.
- Enforce one pair per character and mirror elimination.
- Add next, skip, defer, finish, and cancel behavior.
- Add a read-only final summary.
- Prove every pre-confirmation exit leaves relationships unchanged.

Deliverable: a stable unexecuted plan.

### P4 - Full preflight and direct relationship operations

Status: `STATIC COMPLETE — RUNTIME NOT RUN`.

- Implement the complete read-only preflight.
- Abort the whole plan on the first invalid pair.
- Add the four verified direct relationship operations.
- Add no unrelated state-changing effect.
- Clear workflow state after success or failure.

Deliverable: the isolated execution harness, still not runtime-approved.

### P5 - Static review

Status: `STATIC COMPLETE`.

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

Status: `AWAITING RAY RUNTIME APPROVAL`.

The existing Phase 3 manual matrix, with the added workflow-authorization
cases, remains the runtime source of truth. Every case remains `NOT RUN` until
Ray records an observed CK3 result.

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

## 15. P0 closure and P6 handoff

P0 closes:

1. the evidence registry and provenance record;
2. the single-global-workflow coordinator limited to actor and phase;
3. the actor-owned sixteen-slot, six-field pair plan;
4. slot-bound character-reference reservation markers written last;
5. duplicate, mirror, and state-collision prevention;
6. static guard and cleanup strategy, with abnormal close defined as an
   orphaned, permanently locked state and immediate cleanup explicitly not
   claimed;
7. permanent one-workflow-per-save lock because numeric run identity remains
   unverified;
8. namespace `breedimp_p3_proto_matchmaking`, range `1000-1199`; and
9. isolated test paths, descriptor, localisation-header, encoding, and BOM
   contracts.

P0 is `CORRECTED AND CLOSED`; P1-P5 are `STATIC COMPLETE`; P6 is
`AWAITING RAY RUNTIME APPROVAL`. The permanent lock deliberately forbids same-actor restart,
so no unverified numeric comparison enters the prototype. Abnormal visible-event
closure, lock persistence, save/reload lifecycle, Dynast-change coverage, and
all direct-effect side effects remain explicit P6 gates.

No approval is implied for production implementation, Workshop packaging, or
release publication. CK3 runtime remains `NOT RUN`.
