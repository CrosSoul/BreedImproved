# Breed Improved Phase 3 - Dynasty Matchmaking Feasibility

- Target: CK3 `1.19.0.6 (Scribe)`
- Research status: `COMPLETE FOR STATIC FEASIBILITY`
- Production implementation: `NOT APPROVED`
- CK3 runtime: `NOT RUN`

This report evaluates Phase 3 against the installed same-version vanilla files. It does not implement gameplay or claim runtime behavior.

## 1. Classification and conclusion

- **CONFIRMED FEASIBLE** - the required static mechanism exists in the required version and context.
- **FEASIBLE WITH LIMITATIONS** - relevant mechanisms exist, with a named product or technical limit.
- **REQUIRES PROTOTYPE** - static evidence cannot establish the combined/runtime behavior.
- **NOT FEASIBLE** - verified vanilla behavior contradicts the proposed form.
- **NOT VERIFIED** - sufficient same-version evidence was not established.

CK3 provides the individual building blocks for an authority-limited prototype: Dynasty iteration, sequential review, fertility and age values, marriage-legality checks, coarse kinship categories, native UI preselection, and direct ordinary/matrilineal marriage or betrothal effects.

Production implementation is blocked because the native window has no verified completion/cancel callback, the Dynast has no blanket vanilla marriage authority, direct effects need side-effect comparison, Phase 2 lists do not represent pairs, the dynamic fertility tier needs a prototype, and no exact relatedness value is exposed. Recommended status: `RESEARCH COMPLETE - PROTOTYPE AND PRODUCT DECISIONS REQUIRED`.

## 2. Vanilla evidence inventory

Paths are relative to the CK3 `game/` directory.

| Area | Exact source | Verified identifier or behavior |
| --- | --- | --- |
| Version | `launcher/launcher-settings.json` | `1.19.0.6 (Scribe)` |
| Native UI call | `common/important_actions/00_marriage_actions.txt:164-171` | `open_interaction_window`, four participant scopes |
| Marriage schema | `common/character_interactions/_character_interactions.info:576-587,677-706` | Special UI, mutable spouses, matchmaker redirect, validation, alliances, Prestige |
| Marriage interaction | `common/character_interactions/00_marriage_interactions.txt:12-566,758-981,1200-1491` | Lists, redirect, validity, availability, direction, Grand Wedding, authority |
| Window continuation | `common/character_interactions/06_ep3_laamp_interactions.txt:3532-3543` | Enclosing effects continue after opening |
| Marriage triggers | `common/scripted_triggers/00_marriage_triggers.txt:17-210,354-429,464-497` | General/pair legality and adult/betrothal branch |
| Direct effects | `events/interaction_events/marriage_interaction_events.txt:1016-1032` | `marry`, `marry_matrilineal`, `create_betrothal`, `create_betrothal_matrilineal` |
| Adult/minor split | `events/activities/tournaments/tournament_events.txt:1631-1644` | Betrothal if either participant is a minor |
| Matchmaker model | `events/interaction_events/marriage_interaction_events.txt:104-132` | Unlanded, landed-child, and self-controlled cases |
| Grand Wedding helper | `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:93-120`; `events/government_events/clan_events.txt:96-121` | DLC/context-dependent betrothal setup |
| Fertility | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548` | Numeric `fertility`; comparison with zero |
| Age | `common/script_values/00_age_values.txt:82-88`; `events/dlc/ep3/ep3_story_cycle_grand_ambitions_events.txt:2549-2569` | `age_difference` and marriage ordering |
| Ordered lists | `events/diarchy_events/vizierate_events.txt:200-229`; `common/script_values/_script_values.info` | Numeric `order_by` |
| Defines | `common/defines/00_defines.txt:181-187,351-374,417-419` | Adulthood, fertility curves, internal ancestry calculation |
| Former spouses | `events/birth_events.txt:249-255`; `events/court_events/court_events_new.txt:63-69` | `any_former_spouse`, including dead |
| Spouse-death memory | `common/character_memory_types/character_memories_1.txt:48-74`; `common/on_action/death.txt:986-1001` | Conditional/expiring, not permanent widow proof |
| Consanguinity | `common/scripted_triggers/00_religious_triggers.txt:231-301`; `common/religion/doctrine_types/20_doctrines.txt:682-793` | Doctrine-specific prohibitions |
| Family categories | `common/scripted_triggers/00_family_triggers.txt:17-62`; `common/trigger_localization/00_character_triggers.txt:376-419,1288-1331` | Close/extended, cousin, avuncular, direct relations |
| Half siblings | `common/customizable_localization/00_relations.txt:461-483` | Shared sibling plus non-shared legal parent pattern |
| `pure_blooded` | `common/traits/00_traits.txt:7700-7723` | Fertility/inbreeding modifiers; no legality override |
| Availability | `common/scripted_triggers/05_bp2_hostage_triggers.txt:230-241`; `common/character_interactions/00_marriage_interactions.txt:514-542,1457-1491` | Hostage, transfer, and prison checks |
| Phase 2 lists | `tests/event_target_lists_tests.txt:45-93`; `docs/research/Matt_Phase2_Vanilla_Evidence.md` | Character lists and sequential review, not pair tuples |

## 3. Key feasibility findings

Each row records evidence, recommended use, limitations, and the required runtime observation.

| Requirement | Classification | Evidence and recommended method | Limit and runtime gate |
| --- | --- | --- | --- |
| Open vanilla marriage UI with proposed spouses | **CONFIRMED FEASIBLE** | `00_marriage_actions.txt:164-171`; supply four scopes to `arrange_marriage_interaction` | Spouses are mutable; test displayed scopes, changes, send, and close |
| Lock both spouses in stock UI | **NOT FEASIBLE** through verified stock form | `_character_interactions.info:582-587` explicitly allows changes | No locking argument found |
| Continue a native-UI batch | **NOT FEASIBLE** through stock call; alternative **REQUIRES PROTOTYPE** | EP3 source continues immediately; use an explicit Resume design only if approved | No result/setup-cancel callback or general betrothal-created on-action; test close/send/reject/save |
| Native legality/options/consequences | **CONFIRMED FEASIBLE** through native interaction | Use `arrange_marriage_interaction` | External matchmakers can refuse; test ordinary, matrilineal, minor, and Grand Wedding availability |
| Direct ordinary/matrilineal marriage/betrothal | **CONFIRMED FEASIBLE** for relationship operations | Four effects in `marriage_interaction_events.txt:1016-1032` | Test each adult/minor direction and persistence |
| Direct parity with native interaction | **FEASIBLE WITH LIMITATIONS** | Recheck `can_marry_character_trigger`; do not call `marriage_interaction_on_accept_effect` as a shortcut | Compare alliances, Prestige, matchmaker, court, titles, government, succession, memories, on-actions |
| All-or-nothing final batch | **REQUIRES PROTOTYPE** | Complete preflight before the first effect | No rollback verified; test invalidation and partial-execution protection |
| Universal Dynast marriage authority | **NOT FEASIBLE** under vanilla rules | `00_marriage_interactions.txt:94-159,1417-1449`; restrict MVP to verified player matchmaker authority | Test own court, other court, child-vassal, ruler, minor, and other player |
| Rulers/external courts | **FEASIBLE WITH LIMITATIONS** | Native proposals can redirect to their matchmaker | Acceptance, range, war, movement, and authority require tests |
| Current fertility/zero check | **CONFIRMED FEASIBLE** | Read `fertility`; use the verified zero comparison | Values may be negative or over `1.0`; exact UI formatting requires testing |
| Dynamic best-minus-0.05 tier | **REQUIRES PROTOTYPE** | Order legal candidates, save best, derive threshold, staged-filter | Test `.50/.45/.449`, `1/.95/.949`, negative, zero, >1, next partner, save/reload |
| Age proximity | **CONFIRMED FEASIBLE** | Reuse `age_difference` concept; minors rank age first, adults after fertility tier | Do not infer a new age cap; test high ages and boundary birthdays |
| Female 30+/male 40+ with minor | **CONFIRMED FEASIBLE** as product comparison; full flow **REQUIRES PROTOTYPE** | Independent hard exclusion at generation and final preflight | Test 29/30, 39/40, swapped subject roles, exceptional traits, and placeholders |
| Never married vs previously married | **CONFIRMED FEASIBLE** | Current spouse/betrothal state plus `any_former_spouse` | Test living/dead former spouses |
| Exact divorce vs widowhood | **NOT VERIFIED** | Use broader “previously married” fallback only if Ray accepts | Memories are not permanent proof; test save histories |
| Genetic ranking | **FEASIBLE WITH LIMITATIONS** | Exact approved trait keys can be ranked lexicographically | Phase 2 warning set is not automatically a Phase 3 scoring model |
| Vanilla kinship legality | **CONFIRMED FEASIBLE** | Call vanilla pair trigger rather than copying doctrine logic | Mixed-faith courtier exception needs runtime coverage |
| Coarse kinship ranking | **FEASIBLE WITH LIMITATIONS** | Use verified close/extended, cousin, avuncular, and direct categories | Lowest bucket means “no close/extended relation detected,” not “unrelated” |
| Exact relatedness/genetic risk | **NOT VERIFIED** | Do not simulate CK3's internal coefficient | No script-visible numeric accessor found |
| Half siblings | **CONFIRMED FEASIBLE** with sufficient legal-parent data | Use verified family pattern | Missing legal parents limit classification; test incomplete records |
| `pure_blooded` | **CONFIRMED FEASIBLE** as trait input | May contribute after legality | Never overrides doctrine or hard age exclusions |
| Arbitrary pair records | **REQUIRES PROTOTYPE** | Store subject, partner, direction, relationship type, placeholder, reservations | Parallel lists are not assumed tuples; test cleanup, summary, save/reload, consecutive runs |
| Large-Dynasty ranking | **REQUIRES PROTOTYPE** | Filter pools before pair legality and lexicographic stages | Measure build/review/preflight time; no threshold claimed |

Faith effect on same-Dynasty pairing:

| Doctrine | Verified rejection |
| --- | --- |
| `doctrine_consanguinity_dynastic` | Close/extended family and the same Dynasty; Phase 3 normally has zero legal pairs |
| `doctrine_consanguinity_restricted` | Close/extended family |
| `doctrine_consanguinity_cousins` | Close family and avuncular pairs |
| `doctrine_consanguinity_aunt_nephew_and_uncle_niece` | Close family |
| `doctrine_consanguinity_unrestricted` | No kinship rejection in this trigger |

Faith-hostility branches around `could_marry_character_trigger` are commented out in this version; this report does not claim a general interfaith-hostility ban.

## 4. Eligibility and protection recommendation

This is not a final product decision.

| State | Recommended class |
| --- | --- |
| Illegal pair; `can_not_marry`; forbidden clergy; mercenary holder; peasant/populist leader; herder government | Vanilla hard prohibition |
| Prisoner, hostage, active guardian/ward transfer | Vanilla hard prohibition in native interaction |
| Married/betrothed; concubine pending decision; direct ancestor/descendant; other player; outside approved authority; pregnant pending tests | Recommended hard product exclusion |
| Female `>=30` or male `>=40` with any minor | Confirmed hard product exclusion |
| Dynast, House Head, landed ruler, heir, lover, context-limited landless adventurer | Display with warning or exclude after Ray's decision |
| `celibate` | Warning/placeholder-only; not a verified `can_not_marry` trait |
| Ordinary war/activity/travel | Normal or warning with final revalidation; no blanket participant ban established |
| Legal divorced/widowed member within authority | Normal |

## 5. Architecture, ranking, and recommendation

Reuse from Phase 2: player Decision, one-time Dynasty scan, sequential review, reviewed/skipped sets, finish/cancel, final confirmation, revalidation, and workflow cleanup.

Do not reuse unchanged: selected-character representation, ancestor folding, exile effects, or per-root invalidation policy. Phase 3 needs one-to-one reservations, mirror/cycle prevention, pair direction, relationship type, and exact final summaries.

Ranking is lexicographic, not a weighted sum:

- minors: age difference -> approved genetics -> coarse kinship;
- adults: dynamic fertility tier -> age difference -> approved genetics -> coarse kinship.

Recommended staged performance design: build active/normal/placeholder pools; remove hard-invalid/reserved characters; validate plausible pairs; filter one ranking dimension at a time; retain only reviewable alternatives.

| Approach | Classification | Recommendation |
| --- | --- | --- |
| A: native UI per pair | **FEASIBLE WITH LIMITATIONS** | Later one-pair advisory handoff; not the batch executor |
| B: direct final-confirmation effects | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | Preferred isolated prototype, limited to vanilla player authority |
| Hybrid | **REQUIRES PROTOTYPE** | Defer; mixed completion semantics are harder to explain and recover |

Proposed prototype boundary: current Dynasty only; player-initiated; vanilla matchmaker authority only; ordinary/matrilineal; full-plan preflight; no Grand Wedding; no accept-all-remaining action; no background execution.

Expected later production families, if approved: additive files under `common/decisions/`, `common/scripted_triggers/`, `common/script_values/`, `common/scripted_effects/`, `events/`, and both verified localisation directories. Exact provisional paths are in `docs/Matt_to_Jay_Phase3_Technical_Approach_Comparison.md`; no ID or namespace is allocated here.

## 6. Ray decisions and runtime gates

Ray must decide: authority model; A/B/hybrid prototype; invalid-pair policy; exact/qualitative fertility display; Phase 3 trait set; kinship labels; tie and subject order; lower fertility tiers; zero-fertility never-married handling; previously-married fallback; Skip/Next/Defer behavior; accepted-pair revision; special-state protection; and Grand Wedding deferral.

The prospective runtime matrix is `docs/testing/phase3_dynasty_matchmaking_manual.md`. It covers native UI lifecycle, direct/native side-effect comparison, fertility and age boundaries, marriage histories, doctrines and kinship, authority classes, special states, pair integrity, cancellation, invalidation, save/reload, large Dynasties, Phase 1/2 regression, localisation, and the CK3 error log. Every result remains `NOT RUN`.

## 7. Thirty-item traceability

| # | Requested output | Section |
| --- | --- | --- |
| 1 | Vanilla files, events, interactions, effects, triggers, and window mechanisms | 2 |
| 2 | Exact vanilla evidence for each key mechanism | 2-3 |
| 3 | Reliability of calling the native marriage/betrothal UI | 3 |
| 4 | Preselecting both characters | 3 |
| 5 | Continuous processing of multiple native windows | 3 |
| 6 | Native-interface risks | 3 |
| 7 | Direct-execution risks | 3 |
| 8 | A/B/hybrid recommendation | 5 |
| 9 | Recommended MVP flow | 5 |
| 10 | Minor ordering | 3, 5 |
| 11 | Adult fertility ordering | 3, 5 |
| 12 | Five-percentage-point tier | 3 |
| 13 | Zero-fertility identification | 3 |
| 14 | High-age matching | 3, 5 |
| 15 | Female 30+/male 40+ minor exclusion | 3-4 |
| 16 | Positive genetic-trait scoring | 3 |
| 17 | Kinship-risk tiers | 3 |
| 18 | Legality and authority | 3-4 |
| 19 | Preventing participant reuse | 3, 5 |
| 20 | Candidate-generation and ranking performance | 3, 5 |
| 21 | New protection recommendations | 4 |
| 22 | Invalidation and cancellation recovery | 5-6 |
| 23 | Reusable Phase 2 structures | 5 |
| 24 | Phase 2 structures that cannot be reused | 5 |
| 25 | Proposed new files | 5 |
| 26 | Expected production modification scope | 5 |
| 27 | Manual matrix | 6 |
| 28 | Main technical risks | 1, 3-5 |
| 29 | Ray decisions | 6 |
| 30 | Implementation readiness | 1, 8 |

## 8. Closeout

Phase 3 is **not ready for production implementation**. It is ready for Ray/Jay/Boss decisions and a separately approved isolated prototype plan.

Implementation-ready recommendation: prototype authority-limited Approach B; retain Approach A only as a separately tested advisory handoff.

Evidence-index updates: none. The task's allowed-file boundary excludes `.agents`; reusable evidence registration requires a separate approved pass.

Deliberately unresolved: final trait weights, exact relatedness, unsupported same-sex direct-effect syntax, custom GUI, maximum age gaps, final localisation, and all runtime behavior.
