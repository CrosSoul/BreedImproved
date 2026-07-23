# Breed Improved Phase 3 - P0 Checkpoint Report

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6 (Scribe)`
- Phase 3 isolated prototype:
  `STATIC IMPLEMENTATION COMPLETE — RUNTIME TEST REQUIRED`
- P0 status: `P0 CORRECTED AND CLOSED`
- P1-P5 status: `STATIC COMPLETE`
- P6 status: `AWAITING RAY RUNTIME APPROVAL`
- Production implementation: `NOT APPROVED`
- CK3 runtime: `NOT RUN`

This corrected report closes the static evidence and design questions required
by P0. It records the approved isolated-prototype architecture and the completed
P1-P5 static design. It does not claim that CK3 has run, approve production
implementation, or report a runtime-verified marriage or betrothal path.

## 1. Evidence boundary

All vanilla paths below are relative to the CK3 `game/` directory unless the
launcher path is stated explicitly. The installed target is recorded in
`launcher/launcher-settings.json` as `1.19.0.6 (Scribe)`, raw version
`1.19.0.6`.

Evidence classifications:

- `VERIFIED AND IMPLEMENTATION-READY`: exact syntax exists in the required
  CK3 version, scope, and enclosing context.
- `VERIFIED BUT CONTEXT-DEPENDENT`: the construct exists, but the proposed
  multi-construct lifecycle still requires an isolated prototype.
- `NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED`: static files cannot prove the
  required behavior.

The concise source excerpts and full context notes are registered in:

- `.agents/skills/ck3-mod-development/references/ck3_syntax_reference.md`
- `.agents/skills/ck3-mod-development/references/ck3_evidence_index.md`
- `.agents/skills/ck3-mod-development/references/ck3_vanilla_examples/phase3_matchmaking_p0_1_19_0_6.md`

The earlier Phase 3 changes under `.agents/skills/ck3-mod-development/` are
ratified only as Phase 3 evidence and status registration. They do not approve
production implementation, alter the CK3 skill's general correctness rules, or
authorize any other feature.

## 2. Registered implementation evidence

| Mechanism | Classification | Exact evidence | P0 conclusion |
| --- | --- | --- | --- |
| Event namespace and namespaced IDs | `VERIFIED AND IMPLEMENTATION-READY` | `events/_events.info:5-10` | One namespace declaration may own numeric event IDs in an event file. |
| Decision actor capture and event dispatch | `VERIFIED AND IMPLEMENTATION-READY` | `common/decisions/_decisions.info:125-143`; actor capture at `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`; dispatch at `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78` | A character Decision effect can save the actor scope and trigger a namespaced event. |
| Generic event fields and player options | `VERIFIED AND IMPLEMENTATION-READY` as schema | `events/_events.info:10-38,156-164` | `type`, `scope`, `title`, `desc`, `trigger`, `immediate`, `after`, `hidden`, and `option.name` are registered without inferring any window-lifecycle callback. |
| Character-valued actor variable | `VERIFIED AND IMPLEMENTATION-READY` | `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167` | A character can store and later dereference another character through `set_variable` and `var:<name>`. |
| Character-reference variable equality | `VERIFIED AND IMPLEMENTATION-READY` | `events/board_game_events.txt:1173-1187` | `var:<name> = <character_scope>` supports the role-identity checks used by duplicate and mirror prevention. |
| Flag-valued actor variable | `VERIFIED AND IMPLEMENTATION-READY` | `events/board_game_events.txt:61-82,170-180` | A variable may hold a `flag:` value and be compared with an expected flag. |
| Numeric actor-variable assignment | `VERIFIED AND IMPLEMENTATION-READY` | `value = $VALUE$` in `common/scripted_effects/00_achievement_effects.txt:33-44`; explicit numeric caller in `common/on_action/game_start.txt:5333-5339` | A fixed scripted-effect argument can supply the numeric failure-slot diagnostic; the prototype uses unpadded integer tokens `1`-`16`. |
| Actor-variable cleanup | `VERIFIED AND IMPLEMENTATION-READY` with an existence guard | `events/relations_events/adultery_events.txt:2696-2700`; `events/board_game_events.txt:2314-2328` | Explicit static variables can be removed after `exists = var:<name>`; unguarded absent-variable removal is not asserted. |
| Global active-actor pointer and equality | `VERIFIED AND IMPLEMENTATION-READY` as components | `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; identity at `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; entered scope at `events/religion_events/great_holy_war_events.txt:818-824` | A global variable can store, compare, and enter a character reference. |
| Global phase flag, equality, and cleanup | `VERIFIED AND IMPLEMENTATION-READY` as components | set at `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; compare at `common/script_values/99_steward_values.txt:694-698`; guarded removal at `events/dlc/ep3/ep3_frankokratia_events.txt:4255-4266` | A global flag-valued phase can be set, compared with an expected flag, and removed after an existence check. |
| Permanent one-workflow-per-save lock | `VERIFIED AND IMPLEMENTATION-READY` as composed static components; save/reload remains runtime-only | once-only nonexistence/set pattern at `events/yearly_events/yearly_events_3.txt:3337-3350,3432-3448`; verified global flag value at `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254` and `common/script_values/99_steward_values.txt:694-698`; achievement-long-lived global use at `common/scripted_effects/00_achievement_effects.txt:33-44`, `common/on_action/game_start.txt:5039-5042`, and `common/achievements/fp1_achievements.txt:1-4` | The prototype lock is `global_var:breedimp_p3_proto_used_in_save = flag:breedimp_p3_proto_used`. It is checked for absence before activation, set first by the entry event's explicit activation option, and never removed. Opening the Decision or cancelling that entry event consumes nothing. Serialization still requires P6. |
| Six-field fixed-slot commit protocol | `VERIFIED COMPONENTS; COMPOSED LIFECYCLE REQUIRES PROTOTYPE` | character-variable storage/equality, flag, parameter expansion, and guarded-removal evidence in the rows above | Six actor variables form one project record; `reservation_id` is written last as a second reference to that slot's subject, and a record is committed only when it equals `subject` and all five payload fields exist. This is not atomic engine storage. |
| Dynasty scope capture | `VERIFIED AND IMPLEMENTATION-READY`; continuity context-dependent | `events/court_maintenance_events.txt:609`; `events/religion_events/faith_conversion_events.txt:339-340` | The actor's Dynasty can be saved as a named Dynasty scope. The selected prototype instead uses an actor-owned typed Dynasty variable, so named-scope continuity is evidence only, not the selected storage contract. |
| Mod-safe on_action extension | `VERIFIED AND IMPLEMENTATION-READY` | `common/on_action/_on_actions.info:102-117` | A Mod appends a child through `on_actions`; it must not add a second effect block to a vanilla on_action. |
| Actor-death context | `VERIFIED BUT CONTEXT-DEPENDENT` | `common/on_action/death.txt:1-6` | `on_death` enters the about-to-die character as root; exact cleanup timing still requires runtime testing. |
| Dynast-change context | `VERIFIED BUT CONTEXT-DEPENDENT` | `common/on_action/dynasty_on_actions.txt:13-17` | `on_became_dynasty_head` supplies the new Dynast and affected Dynasty, but no former-Dynast scope. |
| Event trigger-failure cleanup | `VERIFIED AND IMPLEMENTATION-READY` within its documented boundary | `events/_events.info:125-129`; exact use at `events/board_game_events.txt:1902-1910` | `on_trigger_fail` may clean a queued or instant event that fails its trigger; it is not a generic visible-window close callback. |
| Lobby-exit recovery hook | `VERIFIED BUT CONTEXT-DEPENDENT` | `common/on_action/game_start.txt:2590-2592` | `on_game_start_after_lobby` exists; its behavior on every save-load path is not statically proven. |
| Current pair legality | `VERIFIED AND IMPLEMENTATION-READY` for pair legality | `common/scripted_triggers/00_marriage_triggers.txt:183-212,412-427` | `can_marry_character_trigger = { CHARACTER = <character> }` applies underlying pair legality, but its availability branch can pass a pair already betrothed to each other. It is not the independent unbetrothed check. |
| Independent unmarried and unbetrothed checks | `VERIFIED AND IMPLEMENTATION-READY` | `events/activities/tournaments/tournament_events.txt:4819-4824` | Both `is_married = no` and `is_betrothed = no` must be applied independently to both participants. |
| Conservative special-state exclusions | `VERIFIED` trigger forms; prototype-only policy | `is_imprisoned = no` at `common/character_interactions/00_marriage_interactions.txt:514-540`; `is_hostage = no` and `is_concubine = no` at `common/scripted_triggers/00_marriage_triggers.txt:244-252,274-282,536-544`; `is_pregnant = no` at `events/dlc/ep3/ep3_wedding_events.txt:2055-2061` | Apply all four checks to both participants in the isolated prototype. This narrows the supported test class without asserting a universal vanilla rule or settling production policy. |
| Sex and age-threshold checks | `VERIFIED` trigger forms; project threshold policy | `is_female` and `is_male` at `common/scripted_triggers/00_marriage_triggers.txt:484-493`; numeric `age >=` at `common/character_interactions/00_marriage_interactions.txt:3456-3463` | Apply the approved female 30+/male 40+ versus minor exclusion symmetrically to both pair roles. The thresholds are Breed Improved rules, not inferred vanilla policy. |
| Fertility value and zero comparison | `VERIFIED AND IMPLEMENTATION-READY` as components | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548` | Character fertility is readable as a numeric value; the complete best-minus-`0.05` pipeline remains a prototype gate. |
| Age difference and ordered list | `VERIFIED AND IMPLEMENTATION-READY` as components | `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229` | Numeric age difference and `ordered_in_list` ranking exist; final Phase 3 ordering still needs runtime testing. |
| Four direct relationship effects | `VERIFIED AND IMPLEMENTATION-READY` as individual operations | marriage forms at `common/scripted_effects/00_game_rule_effects.txt:22-28`; betrothal forms at `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111`; adult/minor branch at `events/activities/tournaments/tournament_events.txt:1159-1177` | `marry`, `marry_matrilineal`, `create_betrothal`, and `create_betrothal_matrilineal` exist in character scope with a character target. The P4 isolated test path now calls only these four after full preflight; runtime remains `NOT RUN`. |

Static evidence proves that these components exist. It does not prove that the
complete workflow is transactional, save-persistent, or equivalent to the
vanilla marriage interaction.

## 3. Pair-record storage decision

### 3.1 Ownership

The isolated prototype uses:

- one global coordinator containing only the active actor pointer and workflow
  phase;
- one separate permanent one-workflow-per-save global lock that is not part of
  authorization and is never cleared;
- the recorded Dynasty as a typed variable on the active actor; and
- sixteen actor-owned, explicitly numbered pair slots.

Only one Phase 3 prototype workflow may be active globally. Concurrent
multiplayer workflows are outside the isolated prototype.

The exact project-owned global keys are:

| Responsibility | Identifier | Value contract |
| --- | --- | --- |
| Permanent save lock | `global_var:breedimp_p3_proto_used_in_save` | Expected value `flag:breedimp_p3_proto_used`; set once and never removed |
| Active actor | `global_var:breedimp_p3_proto_active_actor` | Character reference; removable active state |
| Active phase | `global_var:breedimp_p3_proto_phase` | Approved `flag:breedimp_p3_proto_phase_*` value; removable active state |

These are Breed Improved identifiers assembled from the verified global
reference, flag-value, equality, existence, and cleanup forms. They are not
claimed as vanilla identifiers.

This design is selected over parallel variable lists because the available
evidence does not prove that six independently maintained lists remain an
atomic, index-aligned tuple across the proposed event chain.

### 3.2 Record schema

For slots `01` through `16`, every record has six static actor-variable keys:

| Field | Key pattern | Stored value |
| --- | --- | --- |
| Subject | `breedimp_p3_proto_slot_1_subject` | Character scope |
| Partner | `breedimp_p3_proto_slot_1_partner` | Character scope |
| Direction | `breedimp_p3_proto_slot_1_direction` | Prefixed ordinary or matrilineal flag |
| Relationship type | `breedimp_p3_proto_slot_1_relationship_type` | Prefixed marriage or betrothal flag |
| Placeholder state | `breedimp_p3_proto_slot_1_placeholder` | Explicit `none` flag for the prototype |
| Reservation identity | `breedimp_p3_proto_slot_1_reservation_id` | Character reference equal to this slot's `subject`, written last |

The proposed enum values are project identifiers, not vanilla identifiers:

- `flag:breedimp_p3_proto_direction_ordinary`
- `flag:breedimp_p3_proto_direction_matrilineal`
- `flag:breedimp_p3_proto_relationship_marriage`
- `flag:breedimp_p3_proto_relationship_betrothal`
- `flag:breedimp_p3_proto_placeholder_none`

No runtime variable-name construction or array indexing is assumed. Fixed
scripted helpers expand only explicit call-site tokens `01` through `16`, and
every P1-P4 branch addresses that closed whitelist.

### 3.3 Commit rule

An accepted pair is recorded in this order:

1. recheck that subject and partner are distinct and not reserved;
2. write subject and partner;
3. write direction, relationship type, and explicit placeholder state;
4. write the slot-specific `reservation_id` last.

A slot is committed only when:

- its reservation variable exists;
- the reservation value equals that slot's `subject` character reference;
- both character fields exist;
- all three metadata fields exist; and
- every enum value belongs to the approved set.

A partial slot without the final marker is not reserved, is not displayed in
the final summary, and is not executable. Cleanup removes its partial fields.
This ordering is a defensive protocol, not a claim that CK3 supplies an atomic
multi-variable transaction.

Every cleanup branch must check `exists = var:<static_name>` before removing
each of the 96 static slot fields. The evidence does not establish that
removing an absent variable is harmless.

## 4. Capacity decision

The isolated prototype capacity is:

- 16 accepted pairs;
- at most 32 reserved characters; and
- 120 unordered slot-pair comparisons during complete cross-slot integrity
  validation, with four role-to-role identity checks per pair, for at most 480
  character-reference comparisons.

This is sufficient to exercise ordinary and matrilineal adult marriages, both
betrothal directions, placeholder records, invalidation, mixed batches, slot
boundaries, and cleanup while keeping every key and branch explicit.

When slot 16 is committed, an attempted seventeenth pair must not overwrite or
reuse any slot. The workflow must report or present the prototype capacity
boundary and proceed only through an approved review/final-confirmation path.
The limit is not a proposed production limit.

## 5. Duplicate, mirror, and collision proof

Before a slot is written, both proposed characters are compared with both the
subject and partner of every committed slot. A character is reserved when it
appears in either role.

Therefore:

- `(A, B)` followed by `(A, C)` fails because `A` is reserved;
- `(A, B)` followed by `(C, B)` fails because `B` is reserved;
- `(A, B)` followed by `(B, A)` fails because both characters are reserved;
- `(A, A)` fails the distinct-character check;
- a missing or stale reservation reference, including one copied from a slot
  with a different subject, fails the slot-to-subject comparison; and
- a partial slot without its correct marker is never treated as committed.

Final preflight repeats the complete cross-slot comparison before any
relationship effect. One-person-per-plan is therefore the stronger invariant;
mirror-pair prevention follows from it.

State-collision controls:

- the `breedimp_p3_proto_` prefix isolates prototype variables;
- actor ownership isolates records from unrelated characters;
- the global coordinator blocks a second active workflow;
- the permanent lock blocks every second workflow in the same save, including a
  same-actor retry after completion, cancellation, failure, death, Dynast loss,
  or abnormal closure;
- no numeric run identity, stale-context comparison, restart, resume, or
  reauthorization path is required or permitted;
- cleanup removes slot payloads before removing the global actor pointer, so an
  interrupted cleanup retains the pointer needed for a later purge; and
- no participant-owned persistent marker is required.

## 6. Authorization invalidation and cleanup

Authorization is conjunctive. No marker alone is sufficient. Every stateful
entry must prove:

- the global active actor exists and equals the current workflow actor;
- the global phase is the expected phase;
- the actor is alive and player-controlled;
- the actor-owned `breedimp_p3_proto_managed_dynasty` variable exists and
  resolves to the recorded Dynasty;
- the actor is still the Dynast of that recorded Dynasty; and
- every referenced participant is still in that Dynasty.

If any clause fails, authorization is logically invalid even before residual
variables are physically removed.

The permanent lock is an activation barrier, not an authorization marker.
Opening the Decision only dispatches the pre-activation confirmation event and
does not set the lock. Cancelling that event consumes nothing. Its explicit
activation option calls the activation effect, which writes the lock first,
before coordinator state or candidate scanning. The lock is never removed.

For an unexpected close of an already displayed event, no generic callback or
window-open predicate is claimed. The approved contract is therefore
**orphaned and permanently locked**, not "detected and immediately cleaned":

- no delayed event, recurring on_action, background effect, or resume entry may
  advance the workflow;
- closing the only displayed continuation leaves any residual active state
  unreachable;
- the lock prevents a later workflow from reusing or being confused with that
  state; and
- cleanup hooks may remove reachable residue, but they must never remove the
  permanent lock or resume the workflow.

Whether every relevant UI-close path is truly unreachable is a P6 runtime
observation, not a static claim.

| Path | Logical result | Physical cleanup strategy | Classification |
| --- | --- | --- | --- |
| Normal completion | Authorization closes after the last approved operation | Central cleanup removes active slots and workflow state; permanent lock remains | Static structure verified; runtime ordering required |
| Review cancellation | No execution entry is reached | Cancel option calls central active-state cleanup; permanent lock remains | `VERIFIED AND IMPLEMENTATION-READY` as a design path |
| Final-confirmation cancellation | No relationship effect is called | Cancel option calls central active-state cleanup; permanent lock remains | `VERIFIED AND IMPLEMENTATION-READY` as a design path |
| No valid candidates | Review/execution phase is never entered | Empty-result path calls central active-state cleanup; permanent lock remains | `VERIFIED AND IMPLEMENTATION-READY` as a design path |
| Full preflight failure | The first relationship effect remains unreachable; actor variables retain the first failing numeric slot and flag-valued reason for the result page | Acknowledging the failure result calls central active-state cleanup; permanent lock remains. Abnormally closing that result follows the general orphaned/locked contract | Static guard design verified; all-or-nothing and result lifecycle require testing |
| Actor death | Every later entry must recheck `is_alive`; exact state timing during `on_death` is not assumed | Mod child of `on_death` cleans root-owned active slots and coordinator; permanent lock remains | `VERIFIED BUT CONTEXT-DEPENDENT`; hook ordering requires runtime testing |
| Actor loses Dynast status | Every later entry must recheck Dynast/Dynasty identity; exact transition ordering is not assumed | Mod child of `on_became_dynasty_head` checks the global actor and cleans invalid active state; permanent lock remains | `VERIFIED BUT CONTEXT-DEPENDENT`; cause coverage requires runtime testing |
| Follow-up event trigger failure | Failed event cannot enter its normal body | Event `on_trigger_fail` calls active-state cleanup; permanent lock remains | Verified only for queued/instant trigger failure |
| Visible event closes unexpectedly | No close callback or immediate-cleanup claim. With no delayed/background continuation, the residual workflow is orphaned and cannot advance | No resume or reauthorization path exists; later Decision activation is blocked permanently. Any cleanup hook may remove residue but not the lock | `NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED` for UI-close behavior |
| New workflow start | If the permanent lock exists, every actor is rejected before activation | No restart cleanup creates a new run; the lock is never removed | Static lock structure verified; save/reload persistence requires P6 |

No recurring pulse, scheduled scan, automatic pairing, or background cleanup is
introduced by this design.

## 7. Namespace and event allocation

The stable test event namespace is:

```text
breedimp_p3_proto_matchmaking
```

Allocated range: `1000-1199`.

| Range | Reserved responsibility |
| --- | --- |
| `1000-1019` | Entry and lifecycle |
| `1020-1099` | Candidate and review events |
| `1100-1139` | Final confirmation and preflight |
| `1140-1179` | Failure, diagnostics, and cleanup |
| `1180-1199` | Reserved |

The range is prototype-only. All prototype events use this namespace and the
reserved `1000-1199` range. Other test-owned identifiers retain the
`breedimp_p3_proto_` stem.

## 8. Isolated test Mod contract

The static prototype uses this standalone layout:

```text
tests/phase3_dynasty_matchmaking/
  BreedImprovedPhase3Prototype.mod
  BreedImprovedPhase3Prototype/
    descriptor.mod
```

The isolated prototype contract uses the repository's portable
`<LOCAL_MOD_PATH>` convention in the outer launcher template. The inner
descriptor contains no
`path`, no `remote_file_id`, and no production or Workshop metadata.

Both descriptors use:

- name: `Breed Improved Phase 3 Prototype`
- version: `0.1.0`
- supported version: `1.19.*`
- status: isolated, test-only, non-release

The descriptor structure is based on the repository-owned Phase 1 test pair:

- `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`; and
- `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod`.

Prototype localisation files must use:

- `localization/english/` with header `l_english:`;
- `localization/simp_chinese/` with header `l_simp_chinese:`;
- identical key sets;
- project-prefixed keys; and
- UTF-8 with BOM.

UTF-8 BOM is an observed vanilla property and a project convention. This report
does not claim that it is a universal engine requirement.

The header/BOM observations are grounded in:

- `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml`; and
- `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml`.

## 9. NOT VERIFIED

The following remain explicit prototype or evidence gates:

1. A generic callback for closing an already displayed event window was not
   found.
2. `on_game_start_after_lobby` timing on every save/reload path is not
   statically established.
3. The complete save/reload lifecycle of global variables, actor variables,
   the typed Dynasty variable, and an open review chain is not established.
4. Static files do not prove that `on_became_dynasty_head` fires for every
   possible Dynast-transfer cause.
5. Actor Dynasty change combined with becoming another Dynasty's Dynast has
   unresolved engine timing.
6. A same-context vanilla example comparing a saved numeric workflow identity
   with a global numeric serial was not found. No numeric run-identity syntax is
   approved; the permanent one-workflow-per-save lock removes that dependency
   from the prototype.
7. Six-field persistence through every proposed event transition is not
   runtime-verified.
8. Interruption between payload writes and the reservation marker is not
   runtime-verified.
9. CK3 does not provide a verified atomic multi-variable transaction for this
   workflow.
10. Direct relationship effects have not been compared with vanilla for
    alliances, Prestige, court movement, succession, memories, on_actions, or
    other engine-owned consequences.
11. Full preflight cannot be described as transactional until multi-pair
    runtime tests confirm that the first relationship does not invalidate a
    later record.
12. Multiplayer concurrent workflows are not supported by the single global
    coordinator and remain outside this prototype.

`UNVERIFIED CK3 SYNTAX`: no numeric run-identity comparison may be placed in a
runnable file. P0 closes the gap for this isolated prototype by selecting the
narrower permanent-lock design. Repeated workflows would require a separately
approved identity architecture and new evidence; a Story Cycle is only an
unapproved research alternative, not part of this prototype.

## 10. P0 checkpoint outcome

P0 is `CORRECTED AND CLOSED`. It closes the pair-record schema, capacity,
collision invariants, permanent-lock architecture, namespace, isolated test
layout, and static lifecycle strategy.

P1-P5 are `STATIC COMPLETE`. P6 is `AWAITING RAY RUNTIME APPROVAL`.
Production implementation remains `NOT APPROVED`. The remaining runtime gates
include global-lock save persistence, visible-event abnormal closure,
save/reload behavior, lifecycle-hook ordering, direct-effect side effects, and
large-Dynasty performance.

No CK3 process was launched. No runtime result is claimed.

## 11. Static validation

| Check | Result |
| --- | --- |
| CK3 evidence paths and identifiers | `PASS` - all registered core construct/identifier checks, including the permanent-lock components, resolved against the installed CK3 `1.19.0.6` files; the launcher version file was resolved relative to the CK3 installation root |
| Evidence completeness | `PASS` - variable identity, global actor/phase equality, Decision dispatch, generic event fields, trigger failure, legality/availability, ranking components, lifecycle hooks, and all four direct relationship effects are registered |
| Storage closure | `PASS` - six fields, commit-marker order, guarded cleanup, 16-pair/32-character capacity, 120 slot-pair and 480 role-comparison bounds are documented |
| Namespace allocation | `PASS` - `breedimp_p3_proto_matchmaking`, `1000-1199`, is the isolated prototype allocation |
| Test matrix | `PASS` - 140 cases are present; all results remain `NOT RUN` |
| Isolated test contract | `PASS` - paths, descriptors, localisation headers, key parity, encoding, and BOM rules are recorded |
| Allowed file scope | `PASS` - Phase 3 evidence/status registration, Phase 3 documentation, and the isolated `tests/phase3_dynasty_matchmaking/` prototype are the only ratified Phase 3 scope |
| Prohibited file scope | `PASS` - no file under `MyCK3Mod/`, Workshop staging, publishing/release documentation, or production descriptor/version metadata changed |
| Whitespace | `PASS` - no trailing whitespace in changed or new P0 files |
| `git diff --check` | `PASS` |
| Runtime | `NOT RUN` |

The CK3 vanilla files used for verification are external installed-game
evidence, not repository files. No vanilla file was modified.
