# Breed Improved Phase 3 - P0 Checkpoint Report

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6 (Scribe)`
- P0 status: `P0 COMPLETE — CHECKPOINT REVIEW REQUIRED`
- P1 status: `P1 NOT STARTED / NOT AUTHORIZED`
- Production implementation: `NOT APPROVED`
- CK3 runtime: `NOT RUN`

This report closes the static evidence and design questions required by P0. It
does not create a test Mod, grant a runtime authorization, or create a marriage
or betrothal execution path.

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

## 2. Registered implementation evidence

| Mechanism | Classification | Exact evidence | P0 conclusion |
| --- | --- | --- | --- |
| Event namespace and namespaced IDs | `VERIFIED AND IMPLEMENTATION-READY` | `events/_events.info:5-10` | One namespace declaration may own numeric event IDs in an event file. |
| Decision actor capture and event dispatch | `VERIFIED AND IMPLEMENTATION-READY` | `common/decisions/_decisions.info:125-143`; actor capture at `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`; dispatch at `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78` | A character Decision effect can save the actor scope and trigger a namespaced event. |
| Generic event fields and player options | `VERIFIED AND IMPLEMENTATION-READY` as schema | `events/_events.info:10-38,156-164` | `type`, `scope`, `title`, `desc`, `trigger`, `immediate`, `after`, `hidden`, and `option.name` are registered without inferring any window-lifecycle callback. |
| Character-valued actor variable | `VERIFIED AND IMPLEMENTATION-READY` | `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167` | A character can store and later dereference another character through `set_variable` and `var:<name>`. |
| Character-reference variable equality | `VERIFIED AND IMPLEMENTATION-READY` | `events/board_game_events.txt:1173-1187` | `var:<name> = <character_scope>` supports the role-identity checks used by duplicate and mirror prevention. |
| Flag-valued actor variable | `VERIFIED AND IMPLEMENTATION-READY` | `events/board_game_events.txt:61-82,170-180` | A variable may hold a `flag:` value and be compared with an expected flag. |
| Actor-variable cleanup | `VERIFIED AND IMPLEMENTATION-READY` with an existence guard | `events/relations_events/adultery_events.txt:2696-2700`; `events/board_game_events.txt:2314-2328` | Explicit static variables can be removed after `exists = var:<name>`; unguarded absent-variable removal is not asserted. |
| Global active-actor pointer and equality | `VERIFIED AND IMPLEMENTATION-READY` as components | `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; identity at `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; entered scope at `events/religion_events/great_holy_war_events.txt:818-824` | A global variable can store, compare, and enter a character reference. |
| Global phase flag, equality, and cleanup | `VERIFIED AND IMPLEMENTATION-READY` as components | set at `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; compare at `common/script_values/99_steward_values.txt:694-698`; guarded removal at `events/dlc/ep3/ep3_frankokratia_events.txt:4255-4266` | A global flag-valued phase can be set, compared with an expected flag, and removed after an existence check. |
| Six-field fixed-slot commit protocol | `VERIFIED COMPONENTS; COMPOSED LIFECYCLE REQUIRES PROTOTYPE` | variable, equality, flag, and guarded-removal evidence in the rows above | Six static actor variables form one project record; `reservation_id` is written last, and a record is committed only when the expected marker and all five payload fields exist. This is not atomic engine storage. |
| Dynasty scope capture | `VERIFIED AND IMPLEMENTATION-READY`; continuity context-dependent | `events/court_maintenance_events.txt:609`; `events/religion_events/faith_conversion_events.txt:339-340` | The actor's Dynasty can be saved as a named Dynasty scope for the event chain. |
| Mod-safe on_action extension | `VERIFIED AND IMPLEMENTATION-READY` | `common/on_action/_on_actions.info:102-117` | A Mod appends a child through `on_actions`; it must not add a second effect block to a vanilla on_action. |
| Actor-death context | `VERIFIED BUT CONTEXT-DEPENDENT` | `common/on_action/death.txt:1-6` | `on_death` enters the about-to-die character as root; exact cleanup timing still requires runtime testing. |
| Dynast-change context | `VERIFIED BUT CONTEXT-DEPENDENT` | `common/on_action/dynasty_on_actions.txt:13-17` | `on_became_dynasty_head` supplies the new Dynast and affected Dynasty, but no former-Dynast scope. |
| Event trigger-failure cleanup | `VERIFIED AND IMPLEMENTATION-READY` within its documented boundary | `events/_events.info:125-129`; exact use at `events/board_game_events.txt:1902-1910` | `on_trigger_fail` may clean a queued or instant event that fails its trigger; it is not a generic visible-window close callback. |
| Lobby-exit recovery hook | `VERIFIED BUT CONTEXT-DEPENDENT` | `common/on_action/game_start.txt:2590-2592` | `on_game_start_after_lobby` exists; its behavior on every save-load path is not statically proven. |
| Current pair legality | `VERIFIED AND IMPLEMENTATION-READY` for pair legality | `common/scripted_triggers/00_marriage_triggers.txt:183-212,412-427` | `can_marry_character_trigger = { CHARACTER = <character> }` applies underlying pair legality, but its availability branch can pass a pair already betrothed to each other. It is not the independent unbetrothed check. |
| Independent unmarried and unbetrothed checks | `VERIFIED AND IMPLEMENTATION-READY` | `events/activities/tournaments/tournament_events.txt:4819-4824` | Both `is_married = no` and `is_betrothed = no` must be applied independently to both participants. |
| Fertility value and zero comparison | `VERIFIED AND IMPLEMENTATION-READY` as components | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548` | Character fertility is readable as a numeric value; the complete best-minus-`0.05` pipeline remains a prototype gate. |
| Age difference and ordered list | `VERIFIED AND IMPLEMENTATION-READY` as components | `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229` | Numeric age difference and `ordered_in_list` ranking exist; final Phase 3 ordering still needs runtime testing. |
| Four direct relationship effects | `VERIFIED AND IMPLEMENTATION-READY` as individual operations | marriage forms at `common/scripted_effects/00_game_rule_effects.txt:22-28`; betrothal forms at `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111`; adult/minor branch at `events/activities/tournaments/tournament_events.txt:1159-1177` | `marry`, `marry_matrilineal`, `create_betrothal`, and `create_betrothal_matrilineal` exist in character scope with a character target. No P0 execution path is created. |

Static evidence proves that these components exist. It does not prove that the
complete workflow is transactional, save-persistent, or equivalent to the
vanilla marriage interaction.

## 3. Pair-record storage decision

### 3.1 Ownership

The isolated prototype will use:

- one global coordinator containing only the active actor pointer and workflow
  phase;
- the recorded Dynasty as a saved Dynasty scope in the active event chain; and
- sixteen actor-owned, explicitly numbered pair slots.

Only one Phase 3 prototype workflow may be active globally. Concurrent
multiplayer workflows are outside the isolated prototype.

This design is selected over parallel variable lists because the available
evidence does not prove that six independently maintained lists remain an
atomic, index-aligned tuple across the proposed event chain.

### 3.2 Record schema

For slots `01` through `16`, every record has six static actor-variable keys:

| Field | Key pattern | Stored value |
| --- | --- | --- |
| Subject | `breedimp_p3_proto_pair_01_subject` | Character scope |
| Partner | `breedimp_p3_proto_pair_01_partner` | Character scope |
| Direction | `breedimp_p3_proto_pair_01_direction` | Prefixed ordinary or matrilineal flag |
| Relationship type | `breedimp_p3_proto_pair_01_relationship_type` | Prefixed marriage or betrothal flag |
| Placeholder state | `breedimp_p3_proto_pair_01_placeholder` | Explicit prefixed yes or no flag |
| Reservation identity | `breedimp_p3_proto_pair_01_reservation_id` | Slot-specific prefixed reservation flag |

The proposed enum values are project identifiers, not vanilla identifiers:

- `flag:breedimp_p3_proto_direction_ordinary`
- `flag:breedimp_p3_proto_direction_matrilineal`
- `flag:breedimp_p3_proto_type_marriage`
- `flag:breedimp_p3_proto_type_betrothal`
- `flag:breedimp_p3_proto_placeholder_yes`
- `flag:breedimp_p3_proto_placeholder_no`
- `flag:breedimp_p3_proto_reservation_01` through
  `flag:breedimp_p3_proto_reservation_16`

No dynamic variable-name construction is assumed. Every P1-P4 branch must
address the sixteen static slots explicitly if those stages are later approved.

### 3.3 Commit rule

An accepted pair is recorded in this order:

1. recheck that subject and partner are distinct and not reserved;
2. write subject and partner;
3. write direction, relationship type, and explicit placeholder state;
4. write the slot-specific `reservation_id` last.

A slot is committed only when:

- its reservation variable exists;
- the reservation value matches that slot's expected flag;
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
- a marker copied into the wrong slot fails the slot-specific reservation
  identity check; and
- a partial slot without its correct marker is never treated as committed.

Final preflight repeats the complete cross-slot comparison before any
relationship effect. One-person-per-plan is therefore the stronger invariant;
mirror-pair prevention follows from it.

State-collision controls:

- the `breedimp_p3_proto_` prefix isolates prototype variables;
- actor ownership isolates records from unrelated characters;
- the global coordinator blocks a second active workflow;
- an entry by the same recorded actor may explicitly restart only after clearing
  that actor's old state;
- an entry by a different actor rejects while the recorded actor still passes
  the available global guard, and may clear the old actor only after that guard
  is invalid;
- cleanup removes slot payloads before removing the global actor pointer, so an
  interrupted cleanup retains the pointer needed for a later purge; and
- no participant-owned persistent marker is required.

## 6. Authorization invalidation and cleanup

Authorization is conjunctive. No marker alone is sufficient. Every stateful
entry must prove:

- the global active actor exists and equals the current workflow actor;
- the global phase is the expected phase;
- the actor is alive and player-controlled;
- the actor is still the Dynast of the saved workflow Dynasty;
- the event chain still holds the expected actor and Dynasty scopes; and
- every referenced participant is still in that Dynasty.

If any clause fails, authorization is logically invalid even before residual
variables are physically removed.

For an unexpected close of an already displayed event, the required contract is
still immediate logical invalidation. Static evidence provides neither a close
callback nor a window-open predicate that can make or prove that transition.
P0 therefore records the contract but classifies its enforceability as a
runtime prototype gate.

| Path | Logical result | Physical cleanup strategy | Classification |
| --- | --- | --- | --- |
| Normal completion | Authorization closes after the last approved operation | Central cleanup removes all slots and workflow state | Static structure verified; runtime ordering required |
| Review cancellation | No execution entry is reached | Cancel option calls central cleanup | `VERIFIED AND IMPLEMENTATION-READY` as a design path |
| Final-confirmation cancellation | No relationship effect is called | Cancel option calls central cleanup | `VERIFIED AND IMPLEMENTATION-READY` as a design path |
| No valid candidates | Review/execution phase is never entered | Empty-result path calls central cleanup | `VERIFIED AND IMPLEMENTATION-READY` as a design path |
| Full preflight failure | The first relationship effect remains unreachable | Failure result calls central cleanup | Static guard design verified; all-or-nothing runtime behavior requires testing |
| Actor death | Every later entry must recheck `is_alive`; exact state timing during `on_death` is not assumed | Mod child of `on_death` cleans root-owned slots and coordinator | `VERIFIED BUT CONTEXT-DEPENDENT`; hook ordering requires runtime testing |
| Actor loses Dynast status | Every later entry must recheck Dynast/Dynasty identity; exact transition ordering is not assumed | Mod child of `on_became_dynasty_head` checks the global actor and cleans invalid state | `VERIFIED BUT CONTEXT-DEPENDENT`; cause coverage requires runtime testing |
| Follow-up event trigger failure | Failed event cannot enter its normal body | Event `on_trigger_fail` calls cleanup | Verified only for queued/instant trigger failure |
| Visible event closes unexpectedly | Required result: authorization is immediately logically invalid and no relationship path remains reachable. Static result: no verified mechanism proves that transition, and stored coordinator/slot state may remain | The next workflow start must purge residue; lobby-load recovery remains prototype-gated | `NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED`; P1 checkpoint risk |
| New workflow start | Same-actor restart clears its old run; a different actor is rejected while the recorded actor passes the available global guard | For an allowed restart or invalid residue, purge old recorded actor, purge incoming actor's slots, then create the new coordinator | Saved-Dynasty/run-identity gaps and interrupted-transition behavior require testing |

No recurring pulse, scheduled scan, automatic pairing, or background cleanup is
introduced by this design.

## 7. Namespace and event allocation

The stable test event namespace is:

```text
breedimp_matchmaking_validation
```

Allocated range: `1000-1199`.

| Range | Reserved responsibility |
| --- | --- |
| `1000-1019` | Entry and lifecycle |
| `1020-1099` | Candidate and review events |
| `1100-1139` | Final confirmation and preflight |
| `1140-1179` | Failure, diagnostics, and cleanup |
| `1180-1199` | Reserved |

The range is prototype-only. P0 creates no event file and uses no event ID.
Other test-owned identifiers retain the `breedimp_p3_proto_` stem.

## 8. Future test Mod contract

P0 records, but does not create, this standalone layout:

```text
tests/phase3_dynasty_matchmaking/
  BreedImprovedPhase3Prototype.mod
  BreedImprovedPhase3Prototype/
    descriptor.mod
```

If P1 is later approved, the outer launcher template will use the repository's
portable `<LOCAL_MOD_PATH>` convention. The inner descriptor will contain no
`path`, no `remote_file_id`, and no production or Workshop metadata.

Both descriptors are reserved as:

- name: `Breed Improved Phase 3 Prototype`
- version: `0.1.0`
- supported version: `1.19.*`
- status: isolated, test-only, non-release

The descriptor structure is based on the repository-owned Phase 1 test pair:

- `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`; and
- `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod`.

Future localisation files must use:

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
   saved Dynasty scopes, and an open review chain is not established.
4. Static files do not prove that `on_became_dynasty_head` fires for every
   possible Dynast-transfer cause.
5. Actor Dynasty change combined with becoming another Dynasty's Dynast has
   unresolved engine timing.
6. A same-context vanilla example comparing a saved numeric workflow identity
   with a global numeric serial was not found. No run-identity syntax is
   approved by P0.
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
runnable file until an exact CK3 `1.19.0.6` example or separately approved
isolated syntax probe establishes its form.

This is a **P1 prerequisite evidence gap** for any design that permits a
same-actor restart while stale delayed events may still exist. Before P1,
Jay/Boss must require new exact evidence or approve a narrower alternative that
cannot confuse old and new event contexts. P0 does not choose that alternative.

## 10. P0 checkpoint outcome

P0 closes the pair-record schema, capacity, collision invariants, namespace,
future test layout, and static lifecycle strategy.

P1 remains unauthorized. Jay/Boss must review:

- the single-global-workflow limitation;
- the 16-pair prototype capacity;
- the fact that ordinary guard failures invalidate authorization while
  unexpected visible-event closure has no proven immediate invalidation or
  cleanup callback; and
- the unresolved run-identity comparison.

No CK3 process was launched. No runtime result is claimed.

## 11. Static validation

| Check | Result |
| --- | --- |
| CK3 evidence paths and identifiers | `PASS` - 33 core construct/identifier checks resolved against the installed CK3 `1.19.0.6` files; the launcher version file was resolved relative to the CK3 installation root |
| Evidence completeness | `PASS` - variable identity, global actor/phase equality, Decision dispatch, generic event fields, trigger failure, legality/availability, ranking components, lifecycle hooks, and all four direct relationship effects are registered |
| Storage closure | `PASS` - six fields, commit-marker order, guarded cleanup, 16-pair/32-character capacity, 120 slot-pair and 480 role-comparison bounds are documented |
| Namespace allocation | `PASS` - `breedimp_matchmaking_validation`, `1000-1199`, has no runnable repository definition or conflicting allocation |
| Test matrix | `PASS` - 130 cases are present; all results remain `NOT RUN` |
| Future test contract | `PASS` - paths, descriptors, localisation headers, key parity, encoding, and BOM rules are recorded; no Phase 3 test directory was created |
| Allowed file scope | `PASS` - changes are limited to the approved P0 evidence/reference and Phase 3 documentation files |
| Prohibited file scope | `PASS` - no file under `MyCK3Mod/`, `tests/`, Workshop staging, publishing/release documentation, or descriptor/version metadata changed |
| Whitespace | `PASS` - no trailing whitespace in changed or new P0 files |
| `git diff --check` | `PASS` |
| Runtime | `NOT RUN` |

The CK3 vanilla files used for verification are external installed-game
evidence, not repository files. No vanilla file was modified.
