# Breed Improved Phase 3 - Dynasty Matchmaking Feasibility

Current runtime status (2026-07-23): `PROTOTYPE ACCEPTED — PRODUCTION DESIGN
MAY PROCEED`; 40 mapped matrix cases pass and 116 remain `NOT RUN`. Historical
research-gate wording below remains part of the pre-runtime feasibility record.
See `docs/Matt_to_Jay_Phase3_Prototype_Runtime_Acceptance.md`.

- Target: CK3 `1.19.0.6 (Scribe)`
- Research status: `COMPLETE FOR STATIC FEASIBILITY`
- Phase 3 isolated prototype:
  `STATIC IMPLEMENTATION COMPLETE — PARTIAL RUNTIME ACCEPTANCE COMPLETE`
- Prototype approval: `P0 CORRECTED AND CLOSED`
- P0 evidence/design checkpoint: `P0 CORRECTED AND CLOSED`
- P1-P5 status: `STATIC COMPLETE`
- P6 status: `PROTOTYPE ACCEPTED — PRODUCTION DESIGN MAY PROCEED`
- Production implementation: `NOT APPROVED`
- CK3 runtime: `40 MAPPED PASS / 0 FAIL / 116 NOT RUN`

This report evaluates Phase 3 against the installed same-version vanilla files. It does not implement gameplay or claim runtime behavior.

## 1. Classification and conclusion

- **CONFIRMED FEASIBLE** - the required static mechanism exists in the required version and context.
- **FEASIBLE WITH LIMITATIONS** - relevant mechanisms exist, with a named product or technical limit.
- **REQUIRES PROTOTYPE** - static evidence cannot establish the combined/runtime behavior.
- **NOT FEASIBLE** - verified vanilla behavior contradicts the proposed form.
- **NOT VERIFIED** - sufficient same-version evidence was not established.

CK3 provides the individual building blocks for a guarded prototype: Dynasty iteration, sequential review, fertility and age values, marriage-legality checks, coarse kinship categories, native UI preselection, and direct ordinary/matrilineal marriage or betrothal effects.

The approved isolated-prototype model is **Dynast override, limited to one explicitly initiated workflow**, using direct Approach B only after final confirmation. This is a Breed Improved test power, not vanilla authority. Because exact numeric run identity remains unverified, the prototype uses a permanent one-workflow-per-save lock. The mapped runtime sequences validate the selected architecture sufficiently for production design, while direct-effect side effects, broader lifecycle and state coverage, product scoring, and exact relatedness remain unresolved. Recommended status: `PROTOTYPE ACCEPTED — PRODUCTION DESIGN MAY PROCEED; PRODUCTION IMPLEMENTATION NOT APPROVED`.

The existing Phase 1/2 production baseline, including v0.2.0, is already
published on Steam Workshop item `3769010534`. GitHub remains the source and
release-record channel; the Workshop item is the player-distribution channel.
The isolated Phase 3 prototype is not a published release.

## 2. Vanilla evidence inventory

Paths are relative to the CK3 `game/` directory except the version file, whose
`launcher/launcher-settings.json` path is relative to the CK3 installation
root.

| Area | Exact source | Verified identifier or behavior |
| --- | --- | --- |
| Version | `launcher/launcher-settings.json` | `1.19.0.6 (Scribe)` |
| Native UI call | `common/important_actions/00_marriage_actions.txt:164-171` | `open_interaction_window`, four participant scopes |
| Marriage schema | `common/character_interactions/_character_interactions.info:576-587,677-706` | Special UI, mutable spouses, matchmaker redirect, validation, alliances, Prestige |
| Marriage interaction | `common/character_interactions/00_marriage_interactions.txt:12-566,758-981,1200-1491` | Lists, redirect, validity, availability, direction, Grand Wedding, authority |
| Window continuation | `common/character_interactions/06_ep3_laamp_interactions.txt:3532-3543` | Enclosing effects continue after opening |
| Marriage triggers | `common/scripted_triggers/00_marriage_triggers.txt:17-210,354-429,464-497` | General/pair legality; a mutually betrothed pair can pass `can_marry_character_trigger`, so independent availability checks remain mandatory |
| Independent relationship availability | `events/activities/tournaments/tournament_events.txt:4819-4824` | Exact `is_betrothed = no` and `is_married = no` checks |
| Direct effects | `common/scripted_effects/00_game_rule_effects.txt:22-28`; `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111` | `marry`, `marry_matrilineal`, `create_betrothal`, `create_betrothal_matrilineal` |
| Adult/minor split | `events/activities/tournaments/tournament_events.txt:1159-1177` | Betrothal if either participant is a minor, marriage otherwise |
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
| Global coordinator values | `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; `events/religion_events/great_holy_war_events.txt:818-824`; `events/dlc/ep3/ep3_frankokratia_events.txt:4255-4266` | A global variable can hold, directly compare, enter, and guardedly remove a character reference |
| Global phase flag | `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; `common/script_values/99_steward_values.txt:694-698` | A global variable can hold and compare a `flag:` phase value |
| Actor-owned character variables | `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167`; `events/board_game_events.txt:1173-1187`; `events/relations_events/adultery_events.txt:2696-2700` | A character can store, dereference, compare, and guardedly remove an explicitly named character-valued variable |
| Actor-owned flag variables | `events/board_game_events.txt:61-82,170-180` | A character variable can hold and later compare a `flag:` value |
| Saved Dynasty scope | `events/court_maintenance_events.txt:609`; `events/religion_events/faith_conversion_events.txt:339-340` | A character's Dynasty scope can be captured with `save_scope_as`; long-chain continuity remains context-dependent |
| Permanent one-workflow-per-save lock | once-only pattern: `events/yearly_events/yearly_events_3.txt:3337-3350,3432-3448`; global flag form: `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`, `common/script_values/99_steward_values.txt:694-698`; long-lived achievement globals: `common/scripted_effects/00_achievement_effects.txt:33-44`, `common/on_action/game_start.txt:5039-5042`, `common/achievements/fp1_achievements.txt:1-4` | The project key `global_var:breedimp_p3_proto_used_in_save` with value `flag:breedimp_p3_proto_used` composes verified absence, global-flag, and equality forms. It is set first by the entry event's explicit activation option and never removed; opening the Decision or cancelling that entry event consumes nothing; exact serialization remains a runtime gate |
| Numeric serial research lead | `events/religion_events/great_holy_war_events.txt:618-621`; `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4410-4413` | Increment and capture components exist, but no exact saved/global equality example was found; numeric run identity is not selected or approved |
| Additive lifecycle registration | `common/on_action/_on_actions.info:102-117` | A Mod can append a child on-action without replacing a vanilla effect block |
| Actor death lifecycle | `common/on_action/death.txt:1-6` | `on_death` root is the character about to die |
| Dynasty-head lifecycle | `common/on_action/dynasty_on_actions.txt:13-17` | `on_became_dynasty_head` root is the new Dynast and `scope:dynasty` is the affected Dynasty; no former-head scope is supplied |
| Load/start cleanup opportunity | `common/on_action/game_start.txt:2590-2592` | `on_game_start_after_lobby` runs after the host/player exits the lobby; exact save-load timing remains a runtime gate |
| Decision/event entry fields | `common/decisions/_decisions.info:125-143`; `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`; `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78`; `events/_events.info:5-38,156-164` | Decision actor capture and event dispatch, namespace, generic event fields, and player-option schema |
| Failed event dispatch cleanup | `events/_events.info:125-129`; `events/board_game_events.txt:1902-1910` | `on_trigger_fail` exists for a queued/instant event that fails trigger checks; it is not a general visible-window close callback |
| Event namespace form | `MyCK3Mod/events/breedimp_dynasty_cleanup_events.txt:1-6` | The project has a loaded namespace declaration and four-digit numeric event IDs in CK3 `1.19.0.6` |
| Test descriptor and English localisation form | `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`; `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod`; `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml` | Portable outer launcher descriptor, path-free inner descriptor, `l_english:` header, and UTF-8 BOM are established project patterns |
| Simplified Chinese localisation form | `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_cleanup_l_simp_chinese.yml` | `l_simp_chinese:` header and UTF-8 BOM are established by the runtime-accepted project file |

## 3. Key feasibility findings

Each row records evidence, recommended use, limitations, and the required runtime observation.

| Requirement | Classification | Evidence and recommended method | Limit and runtime gate |
| --- | --- | --- | --- |
| Open vanilla marriage UI with proposed spouses | **CONFIRMED FEASIBLE** | `00_marriage_actions.txt:164-171`; supply four scopes to `arrange_marriage_interaction` | Spouses are mutable; test displayed scopes, changes, send, and close |
| Lock both spouses in stock UI | **NOT FEASIBLE** through verified stock form | `_character_interactions.info:582-587` explicitly allows changes | No locking argument found |
| Continue a native-UI batch | **NOT FEASIBLE** through stock call; alternative **REQUIRES PROTOTYPE** | EP3 source continues immediately; use an explicit Resume design only if approved | No result/setup-cancel callback or general betrothal-created on-action; test close/send/reject/save |
| Native legality/options/consequences | **CONFIRMED FEASIBLE** through native interaction | Use `arrange_marriage_interaction` | External matchmakers can refuse; test ordinary, matrilineal, minor, and Grand Wedding availability |
| Direct ordinary/matrilineal marriage/betrothal | **CONFIRMED FEASIBLE** for relationship operations | Four direct effects in `00_game_rule_effects.txt:22-28`, `04_dlc_ep2_wedding_effects.txt:97-111`, and the adult/minor branch at `tournament_events.txt:1159-1177` | Test each adult/minor direction and persistence |
| Direct parity with native interaction | **FEASIBLE WITH LIMITATIONS** | Recheck `can_marry_character_trigger`; do not call `marriage_interaction_on_accept_effect` as a shortcut | Compare alliances, Prestige, matchmaker, court, titles, government, succession, memories, on-actions |
| All-or-nothing final batch | **REQUIRES PROTOTYPE** | Complete preflight before the first effect | No rollback verified; test invalidation and partial-execution protection |
| Universal Dynast marriage authority | **NOT FEASIBLE** under vanilla rules | `00_marriage_interactions.txt:94-159,1417-1449`; the approved prototype deliberately supplies a workflow-scoped Mod override | Test own court, other court, child-vassal, ruler, minor, and other player; never describe the result as vanilla authority |
| Rulers/external courts | **FEASIBLE WITH LIMITATIONS** | Native proposals can redirect to their matchmaker | Acceptance, range, war, movement, and authority require tests |
| Current fertility/zero check | **CONFIRMED FEASIBLE** | Read `fertility`; use the verified zero comparison | Values may be negative or over `1.0`; exact UI formatting requires testing |
| Dynamic best-minus-0.05 tier | **REQUIRES PROTOTYPE** | Order legal candidates, save best, derive threshold, staged-filter | Test `.50/.45/.449`, `1/.95/.949`, negative, zero, >1, next partner, save/reload |
| Age proximity | **CONFIRMED FEASIBLE** | Reuse `age_difference` concept; minors rank age first, adults after fertility tier | Do not infer a new age cap; test high ages and boundary birthdays |
| Female 30+/male 40+ with minor | **CONFIRMED FEASIBLE** as product comparison; full flow **REQUIRES PROTOTYPE** | Independent hard exclusion at generation and final preflight | Test 29/30, 39/40, swapped subject roles, exceptional traits, and placeholders |
| Never married vs previously married | **CONFIRMED FEASIBLE** | Current spouse/betrothal state plus `any_former_spouse` | Test living/dead former spouses |
| Exact divorce vs widowhood | **NOT VERIFIED** | Use broader “previously married” fallback only if Ray accepts | Memories are not permanent proof; test save histories |
| Genetic ranking | **FEASIBLE WITH LIMITATIONS** | Exact approved trait keys can be ranked lexicographically | Phase 2 warning set is not automatically a Phase 3 scoring model |
| Vanilla kinship legality | **CONFIRMED FEASIBLE** | Call the vanilla pair trigger rather than copying doctrine logic; independently require both participants to be unmarried and unbetrothed | A mutually betrothed pair can pass the pair trigger; mixed-faith courtier exception needs runtime coverage |
| Coarse kinship ranking | **FEASIBLE WITH LIMITATIONS** | Use verified close/extended, cousin, avuncular, and direct categories | Lowest bucket means “no close/extended relation detected,” not “unrelated” |
| Exact relatedness/genetic risk | **NOT VERIFIED** | Do not simulate CK3's internal coefficient | No script-visible numeric accessor found |
| Half siblings | **CONFIRMED FEASIBLE** with sufficient legal-parent data | Use verified family pattern | Missing legal parents limit classification; test incomplete records |
| `pure_blooded` | **CONFIRMED FEASIBLE** as trait input | May contribute after legality | Never overrides doctrine or hard age exclusions |
| Bounded pair records | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | Use the P0-selected actor-owned 16-slot design; every slot has six separately named fields and is committed by writing `reservation_id` last | The component variable types are verified; tuple lifetime, interruption behavior, save/reload, summary access, permanent-lock persistence, and rejection of a second activation remain runtime gates. Repeated activated workflows are outside this prototype. |
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
| Married/betrothed; concubine pending decision; direct ancestor/descendant; other player; outside the current Dynasty; pregnant pending tests | Recommended hard product exclusion |
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
| B: direct final-confirmation effects | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | Approved isolated prototype under the workflow-scoped Dynast override |
| Hybrid | **REQUIRES PROTOTYPE** | Defer; mixed completion semantics are harder to explain and recover |

Approved prototype boundary: current Dynasty only; player-initiated by a living player Dynast; exactly one confirmed prototype workflow per save; workflow-scoped override of matchmaker authority and AI acceptance only; ordinary/matrilineal; full-plan preflight; no Grand Wedding; no accept-all-remaining action; no delayed or background execution.

Expected later production families, if approved: additive files under `common/decisions/`, `common/scripted_triggers/`, `common/script_values/`, `common/scripted_effects/`, `events/`, and both verified localisation directories. Production IDs remain unallocated. The isolated prototype uses namespace `breedimp_p3_proto_matchmaking` and event IDs `1000-1199`.

### 5.1 P0 pair-state design closure

P0 selects one **global prototype coordinator**, one separate **permanent
one-workflow-per-save lock**, and one **actor-owned bounded plan**. The
coordinator permits only one active workflow; the lock forbids every second
workflow in that save. Multiplayer-concurrent and repeated workflows are
deliberately unsupported by this prototype and remain production questions.

The global coordinator records only the active actor and active phase. The
permanent lock grants no authorization. Opening the Decision only dispatches a
pre-activation confirmation event; its explicit activation option writes the
lock first, before coordinator state and candidate scanning. Cancelling that
event consumes nothing, and the lock is never removed. The active actor stores
the recorded Dynasty in a typed actor variable. The actor also owns 16 numbered
pair slots. Participant characters receive no reservation variables or
permanent markers.

Each numbered slot contains exactly these six fields, in this order:

| Field | Stored value | Integrity rule |
| --- | --- | --- |
| `subject` | Character scope | Must exist and differ from `partner` |
| `partner` | Character scope | Must exist and differ from `subject` |
| `direction` | Flag value: ordinary or matrilineal | Must be one of the two prototype directions |
| `relationship_type` | Flag value: marriage or betrothal | Must match both participants' current ages at preflight |
| `placeholder` | Flag value: `none` in this prototype | Preserves the required record field without claiming deferred placeholder-product behavior |
| `reservation_id` | Character reference equal to that slot's `subject` | Written last and treated as the slot-bound record commit marker |

A slot whose `reservation_id` is absent or does not equal its `subject` is
incomplete. It reserves no character, appears in no summary, cannot execute,
causes whole-plan preflight failure if it remains in a non-empty slot, and is
then removed by cleanup. Writing the character-reference commit marker last
prevents a partially populated slot from becoming executable without relying
on an unverified embedded flag name.

The maximum of 16 accepted pairs is a prototype-only capacity, not a product limit. It bounds the design at 96 pair-field variables, 120 unordered slot-pair comparisons, and up to 480 subject/partner role comparisons. This permits exhaustive static enumeration and cleanup and is large enough to exercise multi-pair preflight and summary behavior without claiming large-Dynasty scalability. A seventeenth acceptance must produce an explicit capacity result; it must never be silently truncated or overwrite a prior slot.

Every cleanup branch must test `exists = var:<static_name>` before removing a
slot field. The verified removal example does not establish unguarded removal
of an absent variable.

Duplicate and mirror prevention is closed as follows:

1. reject a self-pair before storage;
2. before committing a slot, compare both proposed characters against both character fields of every committed slot;
3. reject the proposal if either character appears anywhere in the accepted plan;
4. because both positions are checked, accepting `A-B` also blocks `B-A`, `A-C`, and `C-B`;
5. write into the first empty numbered slot and write its `reservation_id` last;
6. repeat the same all-slot uniqueness check during complete final preflight.

This design does not derive identity from save-game numeric character IDs and does not assume index alignment across parallel lists.

### 5.2 P0 lifecycle closure

Every internal entry remains guarded by active actor, phase, matching
event-chain actor and actor-owned recorded Dynasty, actor
alive/player-controlled, actor still the Dynast of the recorded Dynasty, and
participant membership in that Dynasty. The permanent global lock is only an
activation barrier and never grants authorization.

| Path | P0 cleanup strategy | Evidence status |
| --- | --- | --- |
| Normal completion | After all approved operations, one centralized cleanup removes all 16 slots, actor workflow metadata, then the global coordinator; permanent lock remains | Component removal is **CONFIRMED FEASIBLE**; combined ordering is **REQUIRES PROTOTYPE** |
| Review cancel; final cancel; no candidates | Call the same active-state cleanup before the terminal event exits; no relationship operation is reachable; permanent lock remains | **CONFIRMED FEASIBLE** structure; runtime event-chain behavior remains `NOT RUN` |
| Preflight failure | Execute zero relationship operations; retain the first failing numeric slot and flag-valued reason in actor variables for the failure page; acknowledge the result to call active-state cleanup; permanent lock remains. Abnormal result-window closure follows the orphaned/locked contract | Static all-before-any structure is **FEASIBLE WITH LIMITATIONS**; atomic and result-lifecycle behavior is **REQUIRES PROTOTYPE** |
| Actor death | Every later entry rechecks `is_alive`; an additive child of `on_death` cleans when its root matches the active actor; permanent lock remains | Hook and root scope are **CONFIRMED FEASIBLE**; exact state timing and saved-state behavior are **REQUIRES PROTOTYPE** |
| Actor loses Dynast status or changes Dynasty | Every later entry rechecks Dynast/Dynasty identity; an additive child of `on_became_dynasty_head` cleans when the new head is the active actor or the recorded active actor is no longer Dynast; permanent lock remains | Hook exists but supplies no former head; transition ordering and complete engine-cause coverage are **NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED** |
| Unexpected queued/instant event trigger failure | Event-specific `on_trigger_fail` invokes centralized active-state cleanup; permanent lock remains | **CONFIRMED FEASIBLE** only for the documented event path |
| Abnormal visible-event close | No generic close callback or immediate-cleanup claim. There is no delayed/background continuation, resume, or reauthorization; any residual state is orphaned and cannot advance | UI-close reachability is **NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED**; the permanent lock blocks every later workflow |
| Load/start with residual state | Additive `on_game_start_after_lobby` child may clear the coordinator and actor plan but never removes the lock or resumes the workflow | Hook exists; exact save-load timing is **NOT VERIFIED - RUNTIME PROTOTYPE REQUIRED** |
| New workflow start | If the permanent lock exists, reject every actor before activation | The static lock pattern is verified; save/reload persistence is **REQUIRES PROTOTYPE** |

No cleanup hook scans candidates, ranks pairs, creates relationships, removes
the permanent lock, resumes an orphaned run, or performs delayed or recurring
matchmaking.

## 6. Ray decisions and runtime gates

The prototype authority model, Approach B execution direction, whole-plan failure policy, and 16-slot P0 storage design are closed. Ray must still decide later production policy for exact/qualitative fertility display, the Phase 3 trait set, kinship labels, tie and subject order, lower fertility tiers, zero-fertility never-married handling, previously-married fallback, accepted-pair revision, special-state protection, Grand Weddings, and whether a production system may allow more than 16 pairs or concurrent multiplayer workflows.

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

Phase 3 is **not ready for production implementation**. P0 is `CORRECTED AND
CLOSED`; P1-P5 are `STATIC COMPLETE`; the prototype is
`ACCEPTED — PRODUCTION DESIGN MAY PROCEED`. The matrix records 40 mapped
runtime `PASS` cases and 116 `NOT RUN` cases.

Approved prototype recommendation: use workflow-scoped Dynast override Approach B with the bounded P0 storage and cleanup design above. Retain Approach A only as a separately tested advisory handoff.

Evidence-index updates: the Phase 3 P0 variable, lifecycle, event, legality, ranking, relationship-effect, and descriptor evidence is registered under `.agents/skills/ck3-mod-development/references/`.

Deliberately unresolved: exact numeric run identity, which is not used by the
one-workflow-per-save prototype; permanent-lock and combined coordinator/slot
save persistence; abnormal-close UI behavior and immediate cleanup; complete
Dynast-loss hook coverage; final trait weights; exact relatedness; unsupported
same-sex direct-effect syntax; custom GUI; maximum age gaps; final player-facing
localisation; and all CK3 runtime behavior. A Story Cycle could be researched as
a future repeated-run identity container, but it is not approved or selected
for this prototype.
