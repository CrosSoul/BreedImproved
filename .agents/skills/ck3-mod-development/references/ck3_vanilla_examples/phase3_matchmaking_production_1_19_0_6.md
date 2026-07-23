# Phase 3 Production Matchmaking Evidence — CK3 1.19.0.6

Target: Crusader Kings III `1.19.0.6 (Scribe)`.

This note registers the additional evidence used by the first Phase 3 production
runtime candidate. It does not claim that the production workflow has passed CK3
runtime testing.

## Candidate availability

| Construct | Exact source | Production use | Limitation |
| --- | --- | --- | --- |
| `is_available = yes` | `common/scripted_triggers/00_available_for_events_triggers.txt:78-108` | Conservative availability gate on both participants | This is a broad vanilla event-availability policy, not a universal marriage rule |
| `is_incapable = no` | `common/decisions/dlc_decisions/ep3_decisions.txt:1149-1153` | Explicitly excludes incapable characters | Product safety exclusion |
| `is_travelling = no` | `common/character_interactions/00_education_interactions.txt:304-319` | Explicitly excludes travelling characters | Product safety exclusion |
| `is_pool_guest = no` | `common/character_interactions/00_marriage_interactions.txt:1495-1507` | Excludes pool guests | Does not exclude every ordinary court guest |
| `has_trait = celibate` | `common/character_interactions/00_marriage_interactions.txt:2498-2507`; trait definition at `common/traits/00_traits.txt:8360-8366` | Explicitly excludes celibate characters | `can_marry_character_trigger` alone does not prove this exclusion |
| `any_former_spouse` | `events/birth_events.txt:249-255`; `events/court_events/court_events_new.txt:63-69` | Combined previously-married check for fallback eligibility | Does not reliably distinguish divorce from widowhood |

The production contract also retains the previously registered explicit
`is_married = no`, `is_betrothed = no`, imprisonment, hostage, concubine,
pregnancy, same-Dynasty, AI-control, and two-direction
`can_marry_character_trigger` checks.

No generic character-scope `is_missing` trigger was found. The production
candidate does not invent one.

## Ranking evidence

| Construct | Exact source | Production use | Limitation |
| --- | --- | --- | --- |
| Evaluated `fertility` | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548` | Adult top-band selection and zero-fertility fallback classification | Values are not clamped to `0`-`1` |
| `age_difference` | `common/script_values/00_age_values.txt:82-88` | Primary within-band or minor ranking | Requires `scope:comparator` |
| `ordered_in_list` | `events/diarchy_events/vizierate_events.txt:200-229` | Deterministic non-random selection from event-target lists | Exact ties ultimately retain engine list order; cross-save order is a runtime gate |
| Positive tier keys | `common/traits/00_traits.txt:6941-7079,7243-7405,7541-7697,7700-7752` | Finite positive congenital score | Unknown or modded traits are ignored |
| Negative tier keys | `common/traits/00_traits.txt:6824-6938,7082-7240,7408-7538`; project-verified set in `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_cleanup_triggers.txt:64-102` | Finite negative score and same-trait reinforcement penalties | No exact inheritance probability is claimed |
| Coarse family triggers | `common/trigger_localization/00_character_triggers.txt:376-419,1288-1331`; `common/scripted_triggers/00_family_triggers.txt:17-62` | Close, avuncular/nibling, cousin, extended, and no-detected-category ordering | The lowest category is not called unrelated |

The accepted isolated prototype supplies project runtime evidence for the
inclusive best-minus-`0.05` composition. See
`docs/Matt_to_Jay_Phase3_Prototype_Runtime_Acceptance.md` cases
`P3-FERT-02`, `P3-FERT-03`, and `P3-FERT-05`.

## Relationship execution and observation

| Construct | Exact source | Production use | Limitation |
| --- | --- | --- | --- |
| `marry`, `marry_matrilineal` | `common/scripted_effects/00_game_rule_effects.txt:22-28` | Adult relationship operations | No direct success return or rollback |
| `create_betrothal`, `create_betrothal_matrilineal` | `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111` | Relationship operation when either participant is a minor | No direct success return or rollback |
| `is_spouse_of = <character>` | `common/scripted_triggers/00_marriage_triggers.txt:133-136` | Post-operation marriage existence check | Does not expose all native side effects |
| `is_betrothed = yes`; `betrothed = <character>` | `common/scripted_triggers/00_marriage_triggers.txt:183-190`; `common/character_interactions/00_marriage_interactions.txt:639` | Post-operation betrothal existence check | No verified script query for matrilineal direction after creation |

The production dispatcher therefore stops later slots when the expected
relationship is not observed. It does not attempt rollback and does not claim
transactional execution.

## Workflow design boundary

The alternating `A`/`B` actor-owned flag token is a project composition of
verified flag-valued variables and token-specific event IDs. It reduces the risk
that an event from the immediately previous run can mutate a new run. It is not
a numeric engine run identity and is not claimed to prove collision-free stale
event rejection across arbitrary history.

The production workflow uses 32 explicit six-field accepted-pair slots and 64
explicit three-field rejected-pair records. These are bounded project storage
designs assembled from the fixed-variable primitives already registered in the
P0 provenance note. Their production lifecycle remains `CK3 RUNTIME: NOT RUN`.
