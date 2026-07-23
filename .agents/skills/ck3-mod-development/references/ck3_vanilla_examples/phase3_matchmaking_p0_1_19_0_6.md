# Phase 3 Matchmaking P0 - CK3 1.19.0.6

## Corrected P0 conclusion

CK3 `1.19.0.6 (Scribe)` provides the individual variable, event, lifecycle,
legality, ranking, marriage, and betrothal constructs required to design the
isolated Phase 3 prototype.

The Phase 3 isolated prototype is
`STATIC IMPLEMENTATION COMPLETE — RUNTIME TEST REQUIRED`.
P0 is `CORRECTED AND CLOSED`. P1-P5 are `STATIC COMPLETE`; P6 is
`AWAITING RAY RUNTIME APPROVAL`. Production implementation is `NOT APPROVED`, and CK3
runtime is `NOT RUN`.

The corrected design uses a global active-workflow coordinator, a separate
permanent one-workflow-per-save activation lock, and sixteen actor-owned,
explicitly bounded pair slots. This is a project composition assembled from
verified CK3 primitives. Its cross-event, save/reload, interruption, and
direct-effect behavior remains a P6 runtime requirement. The standalone
prototype is isolated under `tests/phase3_dynasty_matchmaking/`; nothing in
`MyCK3Mod/` or Workshop staging is authorized by this evidence record.

## Research checklist

Target version: CK3 `1.19.0.6`

- [x] Scope-owned character and flag variables
- [x] Typed Dynasty variables and equality
- [x] Parameter-expanded fixed variable names and flag enum arguments
- [x] Numeric variable counters
- [x] Global active-actor and phase variables
- [x] Permanent one-workflow-per-save global activation lock
- [x] Variable existence, dereference, comparison, and cleanup
- [x] Event-target-list member removal
- [x] Event namespace, Decision entry, and event failure field
- [x] Event ROOT-owned character-variable localisation access
- [x] Mod-safe on_action extension and relevant lifecycle contexts
- [x] Marriage legality, fertility, age ordering, and direct relationship effects
- [x] Dynamic fertility-threshold components
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
| Typed Dynasty variable and equality | Variable effect/trigger; owner stores a Dynasty; `set_variable`, `exists = var:`, `var:<name> = <dynasty>` | `events/interaction_events/adoption_events.txt:83-98`; `common/scripted_effects/01_ep1_court_artifact_creation_effects.txt:1469-1476`; `events/court_maintenance_events.txt:597-618,663-680`; `common/character_interactions/00_artifact_interactions.txt:4046-4077` | Typed storage/equality `VERIFIED`; actor-owned chain lifetime requires P6 |
| Flag-valued character variable | Variable effect/trigger; character owner; `value = flag:<value>` and `<scope>.var:<name> = flag:<value>` | `events/board_game_events.txt:61-82,170-180` | `VERIFIED AND IMPLEMENTATION-READY`; not an atomic tuple |
| Parameter-expanded fixed variable name | Scripted-effect argument substitution; `name = prefix_$ARG$_suffix`; explicit fixed calls | `events/culture_events/culture_tradition_events.txt:844-873` | `VERIFIED`; not runtime string construction or indexing |
| Parameter-expanded flag enum | Scripted-effect argument substitution; `value = flag:$ARG$`; explicit fixed calls | `events/court_events/01_ep3_court_events.txt:3263-3280`; `events/board_game_events.txt:29-44,1948-1951` | `VERIFIED`; pass a complete approved flag token |
| Numeric variable assignment and counter | Variable effect; initialize numeric value; parameterized `value = $VALUE$` with an explicit numeric caller; then `change_variable = { name = <name> add = <value> }` where needed | `events/court_events/introduce_court_fashion_events.txt:84-109,157-175`; `events/culture_events/culture_tradition_events.txt:844-858`; `common/scripted_effects/00_achievement_effects.txt:33-44`; `common/on_action/game_start.txt:5333-5339` | Components `VERIFIED`; counter/record agreement requires P6 |
| Character-variable removal | Variable effect; character owner; `remove_variable = <name>` | `events/relations_events/adultery_events.txt:2696-2700` | `VERIFIED AND IMPLEMENTATION-READY` only with `exists = var:<name>` guard |
| Global active actor | Global variable effect/trigger; stored character; `set_global_variable`, direct equality, scoped block | `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; `events/religion_events/great_holy_war_events.txt:818-824` | Components `VERIFIED`; save/load lifecycle not proven |
| Global phase flag | Global variable effect/trigger; global flag; `value = flag:<value>` and equality | `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; `common/script_values/99_steward_values.txt:694-698` | Component `VERIFIED AND IMPLEMENTATION-READY` |
| Permanent activation lock | Global variable existence guard and set; the project never removes the lock | `events/yearly_events/yearly_events_3.txt:3337-3350,3432-3448`; `common/scripted_effects/00_achievement_effects.txt:33-44`; `common/on_action/game_start.txt:5039-5042`; `common/achievements/fp1_achievements.txt:1-4` | Static lock pattern `VERIFIED`; never-clear is the approved prototype policy; persistence requires P6 |
| Global cleanup | Global variable effect; `remove_global_variable` | `events/dlc/ep3/ep3_frankokratia_events.txt:4252-4266` | `VERIFIED AND IMPLEMENTATION-READY` with existence guard |
| Dynasty scope capture | Saved-scope effect; character to Dynasty; `dynasty = { save_scope_as = <name> }` | `events/court_maintenance_events.txt:609`; `events/religion_events/faith_conversion_events.txt:339-340` | `VERIFIED BUT CONTEXT-DEPENDENT`; long-chain/save lifetime needs testing |
| Decision entry | Decision schema/effect; Decision taker; `effect`, `save_scope_as` | `common/decisions/_decisions.info:125-143`; `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417` | Components `VERIFIED AND IMPLEMENTATION-READY` |
| Decision event dispatch | Event effect; Decision taker to event; `trigger_event = <id>` | `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78` | `VERIFIED AND IMPLEMENTATION-READY` |
| Namespace and event ID | Event-file structure; file top level; `namespace`, `<namespace>.<id>` | `events/_events.info:5-10` | `VERIFIED AND IMPLEMENTATION-READY` |
| Generic event fields/options | Event schema; event root; core text/effect fields, portrait blocks, `option.name`, and exact `theme = dynasty` | `events/_events.info:10-38,54-96,156-164`; `events/decisions_events/major_decisions_events.txt:433` | `VERIFIED` schema only; no lifecycle inference |
| Trigger-failure cleanup | Event field/effect; failed queued/instant event; `on_trigger_fail` | `events/_events.info:125-129`; `events/board_game_events.txt:1902-1910` | `VERIFIED` only for documented trigger failure; not a close callback |
| Additive on_action child | on_action composition; inherited parent scopes; `on_actions = { <child> }` | `common/on_action/_on_actions.info:102-117` | `VERIFIED`; do not add a second parent effect block |
| Actor death context | Code on_action; dying character root; child of `on_death` | `common/on_action/death.txt:1-6` | `VERIFIED BUT CONTEXT-DEPENDENT` |
| Dynast-change context | Code on_action; new Dynast root and `scope:dynasty`; child of `on_became_dynasty_head` | `common/on_action/dynasty_on_actions.txt:13-17` | `VERIFIED BUT CONTEXT-DEPENDENT`; no former-head scope |
| Lobby-exit recovery | Code on_action; game-start context; child of `on_game_start_after_lobby` | `common/on_action/game_start.txt:2590-2592` | `VERIFIED BUT CONTEXT-DEPENDENT`; exact load timing not proven |
| Pair legality | Parameterized character trigger; subject to partner; `can_marry_character_trigger` | `common/scripted_triggers/00_marriage_triggers.txt:183-212,412-427` | `VERIFIED` for legality; grants no authority and can pass an already-mutually-betrothed pair |
| Independent availability | Character triggers on both participants; `is_married = no`, `is_betrothed = no` | `events/activities/tournaments/tournament_events.txt:4819-4824` | `VERIFIED`; required in addition to pair legality |
| Conservative prototype exclusions | Character triggers on both participants; `is_imprisoned = no`, `is_hostage = no`, `is_concubine = no`, `is_pregnant = no` | `common/character_interactions/00_marriage_interactions.txt:514-540`; `common/scripted_triggers/00_marriage_triggers.txt:244-252,274-282,536-544`; `events/dlc/ep3/ep3_wedding_events.txt:2055-2061` | Trigger forms `VERIFIED`; their combination is a prototype-only supported-class boundary, not a universal vanilla rule or final production policy |
| Sex and numeric age checks | Character triggers; `is_female`, `is_male`, and `age >= <number>` | `common/scripted_triggers/00_marriage_triggers.txt:484-493`; `common/character_interactions/00_marriage_interactions.txt:3456-3463` | Trigger forms `VERIFIED`; the prototype's 30/40-with-minor thresholds are project policy |
| Fertility | Character numeric value/trigger; `fertility` and comparison | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548` | Component `VERIFIED`; best-minus-`0.05` needs prototype |
| Dynamic fertility threshold composition | Saved numeric values, formula arithmetic, saved-value comparison, and ordered list | `events/decisions_events/pledge_loyalty_to_liege_events.txt:190-211,454-466`; `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229,1105-1113` | Components `VERIFIED`; complete maximum-minus-`0.05` inclusive pipeline requires P6 |
| Age ordering | Script value/list iterator; `age_difference`, `ordered_in_list`, `order_by` | `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229` | Components `VERIFIED`; tie behavior needs prototype |
| Remove current list member | Event-target-list effect; current typed scope; `remove_from_list = <list>` | `events/court_events/01_ep3_court_events.txt:475-502` | `VERIFIED`; chain/save lifetime requires P6 |
| Event ROOT variable localisation | Character event ROOT owns the variable; `ROOT.Char.MakeScope.Var` followed by verified character, numeric, or flag rendering | `localization/english/dlc/ach/dlc_ach_coronation_events_klank_l_english.yml:137,143`; `localization/english/dlc/ce1/ce1_legend_spread_events_l_english.yml:609-610`; `localization/english/dlc/bp3/bp3_experimental_brew_l_english.yml:14,20,25,32`; `localization/english/decisions_l_english.yml:135-136` | Exact value/flag/character chains `VERIFIED`; `GetShortUIName` is a verified component composition; ROOT must own the variable and runtime rendering requires P6 |
| Ordinary/matrilineal marriage | Character effects; first to second participant; `marry`, `marry_matrilineal` | `common/scripted_effects/00_game_rule_effects.txt:22-28` | Operations `VERIFIED`; runtime side effects not verified |
| Ordinary/matrilineal betrothal | Character effects; first to second participant; both `create_betrothal*` forms | `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111` | Operations `VERIFIED`; wrapper is not selected |
| Adult/minor relationship branch | Scripted effect; selected character to prize character | `events/activities/tournaments/tournament_events.txt:1159-1177` | `VERIFIED` execution example; parity still needs prototype |

## Composed P0 storage decision

The isolated prototype has one removable global coordinator containing only
active actor and phase, plus a separate permanent global activation lock that
is set first by the entry event's explicit activation option and is never
cleared. Opening the Decision or cancelling that entry event does not consume
the lock. The actor
owns sixteen explicit slots. Each slot stores `subject`, `partner`,
`direction`, `relationship_type`, `placeholder`, and a slot-specific
`reservation_id`.

Write the first five fields, then write `reservation_id` last. A slot is
committed only when the final character reference equals that slot's `subject`,
all five payload fields exist, and all enum values are approved. Guard every
field removal with `exists`. This is
`VERIFIED COMPONENTS; COMPOSED LIFECYCLE REQUIRES PROTOTYPE`, not a vanilla
transaction.

Parameterized helpers may substitute a fixed whitelisted slot token into a
variable name and may accept a complete approved enum token for `flag:$ARG$`.
That is compile-time scripted-effect argument expansion, not runtime array
indexing. The prototype remains bounded to slots `01` through `16`; the
accepted-pair counter is a separate numeric variable and cannot make a partial
slot committed.

Before insertion and again at preflight, compare each proposed character with
both roles in every committed slot. Sixteen slots yield 120 unordered slot-pair
comparisons and up to 480 role-to-role character-reference comparisons.

## Isolated test-file contract

Project evidence:

- descriptor pair: `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`
  and `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod`;
- English BOM/header:
  `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml`;
- Simplified Chinese BOM/header:
  `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml`.

The isolated Phase 3 descriptor pair is:

- `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype.mod`; and
- `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype/descriptor.mod`.

The outer template uses `path="<LOCAL_MOD_PATH>"`; the inner descriptor omits
`path`, Workshop ID, and production metadata. Both declare the test-only name,
`version="0.1.0"`, and `supported_version="1.19.*"`. Localisation uses
`l_english:` and `l_simp_chinese:` with identical keys and UTF-8 BOM. BOM is an
observed vanilla property and project convention, not a universal engine
claim.

The stable test namespace is `breedimp_p3_proto_matchmaking`, with event IDs
reserved from `1000` through `1199`. P0 is corrected and closed; P1-P5 static
files do not constitute runtime evidence.

## NOT VERIFIED and stop

- Exact comparison of a captured numeric run identity to a current global
  serial. Do not invent this syntax. The permanent one-workflow-per-save lock
  removes the prototype's dependency on numeric run identity but does not
  verify it.
- A generic callback for closing a displayed event unexpectedly.
- Combined coordinator, saved-scope, slot, event-chain, and save/reload life.
- Exact lobby-load ordering and complete Dynast-loss hook coverage.
- Multi-variable atomicity and interrupted-write behavior.
- Direct-effect alliances, Prestige, court, inheritance, memory, and other
  side effects.
- Concurrent multiplayer workflows. The permanent global lock deliberately
  permits only one confirmed Phase 3 prototype activation per save.

An unexpectedly closed visible event is described only as orphaned and
permanently locked: no generic close callback, immediate cleanup, resume,
reauthorization, delayed execution, or background execution is claimed.

The evidence index and syntax reference are Phase 3-scoped registrations only.
They do not alter the skill's general correctness rules or approve production
implementation. P0 did not research Grand Weddings, custom GUI, exact kinship
coefficients, same-sex direct-effect policy, or production multiplayer consent.
CK3 runtime is `NOT RUN`.
