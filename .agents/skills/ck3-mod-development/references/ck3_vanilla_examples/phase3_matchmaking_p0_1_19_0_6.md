# Phase 3 Matchmaking P0 - CK3 1.19.0.6

## Implementation-ready conclusion

CK3 `1.19.0.6 (Scribe)` provides the individual variable, event, lifecycle,
legality, ranking, marriage, and betrothal constructs required to design the
isolated Phase 3 prototype.

P0 selects a global active-workflow coordinator and sixteen actor-owned,
explicitly numbered pair slots. This is a project design assembled from
verified components. Its cross-event, save/reload, and interruption behavior
remains a runtime prototype requirement.

No runnable Phase 3 file was created during this research.

## Research checklist

Target version: CK3 `1.19.0.6`

- [x] Scope-owned character and flag variables
- [x] Global active-actor and phase variables
- [x] Variable existence, dereference, comparison, and cleanup
- [x] Event namespace, Decision entry, and event failure field
- [x] Mod-safe on_action extension and relevant lifecycle contexts
- [x] Marriage legality, fertility, age ordering, and direct relationship effects
- [x] Test descriptor and localisation conventions from project evidence
- [ ] Exact numeric saved-scope/global run-identity comparison
- [ ] Runtime lifecycle, side effects, and persistence

Product decisions excluded: final matchmaking scores, production capacity,
multiplayer authority, special-state policy, and production implementation.

## Evidence register

All paths are relative to the CK3 `game/` directory unless identified as
project evidence.

| Construct | Category; source/target scope; enclosing context; arguments | Exact evidence | Status and restriction |
| --- | --- | --- | --- |
| Character reference variable | Variable effect/access; character owner stores a character; event/effect/trigger; `set_variable`, `exists = var:`, `var:` | `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167` | `VERIFIED AND IMPLEMENTATION-READY`; combined lifetime not proven |
| Character-reference equality | Variable trigger; owner to expected character; character trigger; `var:<name> = <scope>` | `events/board_game_events.txt:1173-1187` | `VERIFIED AND IMPLEMENTATION-READY`; check existence first |
| Flag-valued character variable | Variable effect/trigger; character owner; `value = flag:<value>` and `<scope>.var:<name> = flag:<value>` | `events/board_game_events.txt:61-82,170-180` | `VERIFIED AND IMPLEMENTATION-READY`; not an atomic tuple |
| Character-variable removal | Variable effect; character owner; `remove_variable = <name>` | `events/relations_events/adultery_events.txt:2696-2700` | `VERIFIED AND IMPLEMENTATION-READY` only with `exists = var:<name>` guard |
| Global active actor | Global variable effect/trigger; stored character; `set_global_variable`, direct equality, scoped block | `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; `events/religion_events/great_holy_war_events.txt:818-824` | Components `VERIFIED`; save/load lifecycle not proven |
| Global phase flag | Global variable effect/trigger; global flag; `value = flag:<value>` and equality | `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; `common/script_values/99_steward_values.txt:694-698` | Component `VERIFIED AND IMPLEMENTATION-READY` |
| Global cleanup | Global variable effect; `remove_global_variable` | `events/dlc/ep3/ep3_frankokratia_events.txt:4252-4266` | `VERIFIED AND IMPLEMENTATION-READY` with existence guard |
| Dynasty scope capture | Saved-scope effect; character to Dynasty; `dynasty = { save_scope_as = <name> }` | `events/court_maintenance_events.txt:609`; `events/religion_events/faith_conversion_events.txt:339-340` | `VERIFIED BUT CONTEXT-DEPENDENT`; long-chain/save lifetime needs testing |
| Decision entry | Decision schema/effect; Decision taker; `effect`, `save_scope_as` | `common/decisions/_decisions.info:125-143`; `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417` | Components `VERIFIED AND IMPLEMENTATION-READY` |
| Decision event dispatch | Event effect; Decision taker to event; `trigger_event = <id>` | `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78` | `VERIFIED AND IMPLEMENTATION-READY` |
| Namespace and event ID | Event-file structure; file top level; `namespace`, `<namespace>.<id>` | `events/_events.info:5-10` | `VERIFIED AND IMPLEMENTATION-READY` |
| Generic event fields/options | Event schema; event root; `type`, `scope`, `title`, `desc`, `trigger`, `immediate`, `after`, `hidden`, `option.name` | `events/_events.info:10-38,156-164` | `VERIFIED` schema only; no lifecycle inference |
| Trigger-failure cleanup | Event field/effect; failed queued/instant event; `on_trigger_fail` | `events/_events.info:125-129`; `events/board_game_events.txt:1902-1910` | `VERIFIED` only for documented trigger failure; not a close callback |
| Additive on_action child | on_action composition; inherited parent scopes; `on_actions = { <child> }` | `common/on_action/_on_actions.info:102-117` | `VERIFIED`; do not add a second parent effect block |
| Actor death context | Code on_action; dying character root; child of `on_death` | `common/on_action/death.txt:1-6` | `VERIFIED BUT CONTEXT-DEPENDENT` |
| Dynast-change context | Code on_action; new Dynast root and `scope:dynasty`; child of `on_became_dynasty_head` | `common/on_action/dynasty_on_actions.txt:13-17` | `VERIFIED BUT CONTEXT-DEPENDENT`; no former-head scope |
| Lobby-exit recovery | Code on_action; game-start context; child of `on_game_start_after_lobby` | `common/on_action/game_start.txt:2590-2592` | `VERIFIED BUT CONTEXT-DEPENDENT`; exact load timing not proven |
| Pair legality | Parameterized character trigger; subject to partner; `can_marry_character_trigger` | `common/scripted_triggers/00_marriage_triggers.txt:183-212,412-427` | `VERIFIED` for legality; grants no authority and can pass an already-mutually-betrothed pair |
| Independent availability | Character triggers on both participants; `is_married = no`, `is_betrothed = no` | `events/activities/tournaments/tournament_events.txt:4819-4824` | `VERIFIED`; required in addition to pair legality |
| Fertility | Character numeric value/trigger; `fertility` and comparison | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548` | Component `VERIFIED`; best-minus-`0.05` needs prototype |
| Age ordering | Script value/list iterator; `age_difference`, `ordered_in_list`, `order_by` | `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229` | Components `VERIFIED`; tie behavior needs prototype |
| Ordinary/matrilineal marriage | Character effects; first to second participant; `marry`, `marry_matrilineal` | `common/scripted_effects/00_game_rule_effects.txt:22-28` | Operations `VERIFIED`; runtime side effects not verified |
| Ordinary/matrilineal betrothal | Character effects; first to second participant; both `create_betrothal*` forms | `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111` | Operations `VERIFIED`; wrapper is not selected |
| Adult/minor relationship branch | Scripted effect; selected character to prize character | `events/activities/tournaments/tournament_events.txt:1159-1177` | `VERIFIED` execution example; parity still needs prototype |

## Composed P0 storage decision

The future prototype has one global coordinator containing only active actor
and phase. The actor owns sixteen explicit slots. Each slot stores `subject`,
`partner`, `direction`, `relationship_type`, `placeholder`, and a
slot-specific `reservation_id`.

Write the first five fields, then write `reservation_id` last. A slot is
committed only when the expected marker and all five payload fields exist and
all enum values are approved. Guard every field removal with `exists`. This is
`VERIFIED COMPONENTS; COMPOSED LIFECYCLE REQUIRES PROTOTYPE`, not a vanilla
transaction.

Before insertion and again at preflight, compare each proposed character with
both roles in every committed slot. Sixteen slots yield 120 unordered slot-pair
comparisons and up to 480 role-to-role character-reference comparisons.

## Future test-file contract

Project evidence:

- descriptor pair: `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`
  and `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod`;
- English BOM/header:
  `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml`;
- Simplified Chinese BOM/header:
  `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml`.

Future Phase 3 paths are documentation only. The outer template uses
`path="<LOCAL_MOD_PATH>"`; the inner descriptor omits `path`, Workshop ID, and
production metadata. Both declare test-only name, `version="0.1.0"`, and
`supported_version="1.19.*"`. Localisation uses `l_english:` and
`l_simp_chinese:` with identical keys and UTF-8 BOM. BOM is an observed vanilla
property and project convention, not a universal engine claim.

## NOT VERIFIED and stop

- Exact comparison of a captured numeric run identity to a current global
  serial. Do not invent this syntax.
- A generic callback for closing a displayed event unexpectedly.
- Combined coordinator, saved-scope, slot, event-chain, and save/reload life.
- Exact lobby-load ordering and complete Dynast-loss hook coverage.
- Multi-variable atomicity and interrupted-write behavior.
- Direct-effect alliances, Prestige, court, inheritance, memory, and other
  side effects.
- Concurrent multiplayer workflows.

The evidence index and syntax reference were updated. P0 did not research Grand
Weddings, custom GUI, exact kinship coefficients, same-sex direct-effect
policy, or production multiplayer consent. CK3 runtime is `NOT RUN`.
