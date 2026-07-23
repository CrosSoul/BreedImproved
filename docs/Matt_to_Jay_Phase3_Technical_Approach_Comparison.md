# Breed Improved Phase 3 - Technical Approach Comparison

Status: `P0 CORRECTED AND CLOSED`

Target: Crusader Kings III `1.19.0.6 (Scribe)`

Phase 3 isolated prototype:
`STATIC IMPLEMENTATION COMPLETE — RUNTIME TEST REQUIRED`

Runtime status: `NOT RUN`

P0 status: `P0 CORRECTED AND CLOSED`.
P1-P5 status: `STATIC COMPLETE`.
P6 status: `AWAITING RAY RUNTIME APPROVAL`.

This document compares technical approaches for Phase 3 Dynasty Matchmaking Management and records the approved direction for the isolated prototype. The prototype direction is a **Dynast-override model limited to the current, explicitly initiated workflow**. This is a guarded Breed Improved direct-execution pathway, not a vanilla CK3 permission, not evidence that a Dynast is every member's matchmaker, and not approval for production gameplay. It supersedes the earlier recommendation to limit the prototype to the actor's vanilla matchmaker authority. Static work through P5 is complete; CK3 runtime remains `NOT RUN`.

## 1. Required product behavior

The proposed system is player-initiated and limited to members of the actor's current Dynasty. It builds recommendations, lets the player review pairs, and requires a separate final confirmation. Before that confirmation it must not create a marriage or betrothal, break an existing relationship, consume a resource, or otherwise change gameplay state.

The execution approach must support:

- adult marriage and minor betrothal;
- ordinary and matrilineal direction;
- one accepted pair per character;
- final validity checks;
- cancellation without gameplay consequences; and
- a strictly bounded override for eligible same-Dynasty characters outside the player's normal vanilla marriage authority.

Grand Weddings are excluded from the isolated prototype.

The approved prototype authority model is:

- the actor must be the living, player-controlled Dynast when the workflow starts and when final execution is requested;
- the override exists only inside the one player-initiated Phase 3 workflow;
- it applies only to the reviewed and finally confirmed same-Dynasty pairs;
- it never grants a reusable global marriage permission or alters vanilla matchmaker ownership;
- it performs no relationship change before final confirmation; and
- every reachable completion, cancellation, invalidation, or failure path must clear active workflow authorization and pair-plan state; the permanent prototype lock is retained.

## 2. Evidence baseline

All paths in this section are relative to the CK3 `game/` directory.

| Mechanism | Classification | Vanilla evidence | Safe conclusion |
| --- | --- | --- | --- |
| Open the vanilla marriage window with four supplied characters | **CONFIRMED FEASIBLE** | `common/important_actions/00_marriage_actions.txt:164-171`, `open_interaction_window` | The actor, recipient, secondary actor, and secondary recipient can be supplied when opening `arrange_marriage_interaction`. |
| Keep both proposed spouses fixed in that window | **NOT FEASIBLE** through the verified stock form | `common/character_interactions/_character_interactions.info:582-587` | The schema explicitly says the secondary participants may be changed in the interface. No verified locking argument was found. |
| Receive a completion or setup-cancel callback from `open_interaction_window` | **NOT VERIFIED** | `common/character_interactions/06_ep3_laamp_interactions.txt:3532-3543`; targeted stock usages | The call opens a window and the enclosing effect continues. No result, close, or cancel callback was found. |
| Native marriage legality and side effects | **CONFIRMED FEASIBLE** through the native interaction | `_character_interactions.info:576-587`; `common/character_interactions/00_marriage_interactions.txt:563-566` | The special interaction performs its own validation and handles marriage or betrothal, alliances, and Prestige. |
| Direct ordinary and matrilineal marriage | **CONFIRMED FEASIBLE** for the relationship operation | `common/scripted_effects/00_game_rule_effects.txt:22-28` | `marry` and `marry_matrilineal` exist as character effects. |
| Direct ordinary and matrilineal betrothal | **CONFIRMED FEASIBLE** for the relationship operation | `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111`; `events/activities/tournaments/tournament_events.txt:1159-1177` | Both `create_betrothal` forms exist; vanilla selects betrothal when either party is a minor in the cited tournament effect. |
| Direct-effect parity with the native interaction | **FEASIBLE WITH LIMITATIONS** | Sources above and `_character_interactions.info:576-587` | Static evidence does not prove identical alliances, Prestige, matchmaker ownership, movement, memories, or other side effects. |
| Pair legality trigger | **CONFIRMED FEASIBLE** | `common/scripted_triggers/00_marriage_triggers.txt:183-212,412-427` | `can_marry_character_trigger` is available for pair legality, but can pass a pair already betrothed to each other. It is not a standalone unbetrothed check. |
| Independent unmarried/unbetrothed checks | **CONFIRMED FEASIBLE** | `events/activities/tournaments/tournament_events.txt:4819-4824` | Apply both `is_married = no` and `is_betrothed = no` to each participant. |
| Universal Dynast marriage authority | **NOT FEASIBLE** under verified vanilla rules | `common/character_interactions/00_marriage_interactions.txt:94-159,1417-1449` | Dynasty membership does not make the Dynast every member's matchmaker. The approved prototype deliberately tests a Mod-owned override rather than claiming this authority exists. |
| Dynamic best-minus-0.05 fertility tier | **REQUIRES PROTOTYPE** | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/diarchy_events/vizierate_events.txt:200-229`; `common/script_values/_script_values.info` | Fertility and ordered-list components exist, but the complete dynamic filtering and scope lifetime have not been runtime-proven. |
| Bounded accepted-pair state | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | Character variables: `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167`; identity equality: `events/board_game_events.txt:1173-1187`; flags: `events/board_game_events.txt:61-82,170-180`; guarded removal: `events/relations_events/adultery_events.txt:2696-2700` | P0 selects actor-owned numbered slots rather than character lists. Component types and comparisons are verified; combined tuple lifetime is not a runtime result. |
| Single global coordinator | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | active actor storage/equality: `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`, `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; phase storage/equality: `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`, `common/script_values/99_steward_values.txt:694-698`; guarded cleanup: `events/dlc/ep3/ep3_frankokratia_events.txt:4255-4266` | Actor and phase components are verified. Full lifecycle and multiplayer behavior require prototype validation. |
| Permanent one-workflow-per-save lock | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | once-only pattern: `events/yearly_events/yearly_events_3.txt:3337-3350,3432-3448`; global flag form: `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`, `common/script_values/99_steward_values.txt:694-698`; long-lived achievement globals: `common/scripted_effects/00_achievement_effects.txt:33-44`, `common/on_action/game_start.txt:5039-5042`, `common/achievements/fp1_achievements.txt:1-4` | `global_var:breedimp_p3_proto_used_in_save = flag:breedimp_p3_proto_used` composes the verified forms. The prototype's entry event sets it first only from the explicit activation option; opening the Decision or cancelling that event does not. It is never removed. Save/reload persistence remains a runtime gate. |
| Additive lifecycle cleanup | **FEASIBLE WITH LIMITATIONS; REQUIRES PROTOTYPE** | `common/on_action/_on_actions.info:102-117`; `common/on_action/death.txt:1-6`; `common/on_action/dynasty_on_actions.txt:13-17`; `common/on_action/game_start.txt:2590-2592`; `events/_events.info:125-129`; `events/board_game_events.txt:1902-1910` | Additive child on-actions, actor-death root, new-Dynast root, load/start hook, and event `on_trigger_fail` exist. There is no verified generic visible-event close callback. |

## 3. Approach A - Open the native marriage interface

### 3.1 Proposed flow

After reviewing recommendations, the player confirms a plan. Breed Improved then opens the vanilla marriage interface for each planned pair so the player can choose ordinary or matrilineal marriage and any native options that are available.

### 3.2 What static evidence supports

**CONFIRMED FEASIBLE:** one invocation can open `arrange_marriage_interaction` with the proposed marrying characters preselected. The native interaction preserves its matchmaker redirection, validation, AI acceptance, ordinary or matrilineal selection, conditional Grand Wedding option, alliances, and Prestige handling.

For minors, the native interaction's `marriage_interaction_valid_target_trigger` selects the betrothal branch when one participant is not an adult. For two adults, it selects the marriage branch. This is static evidence for the native validation path, not a runtime result for a custom batch flow.

### 3.3 Blocking limitations

- **NOT FEASIBLE through the verified stock form:** the supplied secondary participants cannot be guaranteed to remain fixed.
- **NOT VERIFIED:** the caller cannot determine whether the player sent the proposal, closed setup, or changed the proposed pair.
- **NOT VERIFIED:** no reliable continuation callback was found for resuming the next pair.
- **NOT VERIFIED:** no general betrothal-created on-action was found that could resume a queue for minors.
- **FEASIBLE WITH LIMITATIONS:** external-court members and landed rulers may redirect to another matchmaker and require acceptance rather than completing immediately.
- **REQUIRES PROTOTYPE:** any important-action or explicit Resume mechanism would change the product flow and must prove state retention, cancellation, and save/reload behavior.

### 3.4 Suitability

Approach A is not selected for the isolated prototype and is not suitable as its batch executor. It remains an optional, deferred advisory feature that may open one vanilla proposal at the player's request without promising automatic continuation.

## 4. Approach B - Direct execution after final confirmation

### 4.1 Proposed flow

During review, the player accepts a subject, partner, and ordinary or matrilineal direction. Final confirmation first validates the entire accepted plan and the actor's workflow-scoped authorization. If every pair and the actor remain valid, the isolated prototype uses the verified direct relationship effects.

The prototype must cover four separate operation modes:

1. adult ordinary marriage;
2. adult matrilineal marriage;
3. minor ordinary betrothal; and
4. minor matrilineal betrothal.

These are separate test cases, not one assumed shared behavior.

### 4.2 Advantages

- **CONFIRMED FEASIBLE:** the four required relationship operations exist.
- The accepted pair and direction can remain exact.
- No relationship needs to change before final confirmation.
- The Mod can attempt a full preflight before applying the first relationship.
- The review and confirmation experience can remain close to Phase 2.

### 4.3 Risks and limitations

- **NOT FEASIBLE under vanilla authority:** Dynast status alone does not permit controlling every same-Dynasty member. The approved override is intentionally a Breed Improved power.
- **FEASIBLE WITH LIMITATIONS:** direct effects bypass native matchmaker redirection and AI acceptance.
- **REQUIRES PROTOTYPE:** alliance, Prestige, spouse relocation, court and realm, betrothal matchmaker, titles, government, succession, memories, on-actions, and save/reload outcomes.
- **REQUIRES PROTOTYPE:** ordinary and matrilineal direction for every supported adult/minor target class.
- **NOT VERIFIED:** the engine provides no transactional rollback for a later pair failing after earlier pairs have changed.
- The stock `marriage_interaction_on_accept_effect` must not be called as a shortcut. It depends on interaction scopes and options and contains unrelated consequences.
- Direct Grand Wedding setup is context- and DLC-dependent and is excluded from the isolated prototype.

### 4.4 Required safeguards

The prototype must use two conceptual phases:

1. **Complete preflight:** re-evaluate the actor, every participant, every pair, direction, reservation, product hard rule, workflow authorization, and vanilla legality condition without changing relationships.
2. **Execution:** run only if the complete plan passes. One failed pair blocks the entire plan; no invalid pair is silently dropped.

This reduces, but does not eliminate, partial-execution risk. CK3 may still change state while the execution loop is running, and no rollback mechanism is claimed.

Every pair must still pass the verified `can_marry_character_trigger` legality check, independent `is_married = no` and `is_betrothed = no` checks on both participants, and all approved product safeguards, including:

- both participants are alive, single, unbetrothed, and still in the actor's Dynasty;
- neither participant is already reserved by another accepted pair;
- the pair is not self-referential or a mirrored duplicate;
- the female-age-30 and male-age-40 minor-partner prohibitions are enforced as hard exclusions;
- existing `can_not_marry`, clergy, faith, gender, consanguinity, spouse-capacity, and other vanilla marriage failures are respected; and
- actor validity and workflow ownership are rechecked immediately before execution.

The override does not authorize searches outside the actor's current Dynasty, breaking existing marriages or betrothals, moving characters, changing titles, changing government, or applying unrelated political effects.

The prototype must include external-court and landed same-Dynasty cases. Their inclusion proves only the guarded override behavior under test; it must not be reported as vanilla matchmaker authority or automatically approved for production.

### 4.5 Authorization lifecycle and cleanup

P0 selects a single global coordinator and a separate permanent
one-workflow-per-save lock. The coordinator stores only the active actor and
phase. The actor stores the recorded Dynasty in a typed variable and owns
review state and all accepted-pair slots. Opening the Decision only dispatches
the pre-activation confirmation event; its explicit activation option writes
the lock first, before coordinator state or candidate scanning. Cancelling that
event consumes nothing. The lock grants no authorization, is never removed,
and blocks every later workflow in that save. This conservative prototype limit
avoids inventing the still-unverified numeric run identity; it is not a
production multiplayer decision.

Every mutable entry requires the same conjunction: the current event root matches the coordinator actor and phase; the actor-owned `breedimp_p3_proto_managed_dynasty` variable exists and resolves to the recorded Dynasty; the actor is alive and player-controlled; the actor is still Dynast of that Dynasty; and any participants remain inside it. Stale storage alone therefore cannot grant the override.

| Exit or invalidation | Physical cleanup strategy | Remaining gate |
| --- | --- | --- |
| Success | Central cleanup after the final operation removes actor slots/workflow metadata, then the coordinator; permanent lock remains | Combined runtime ordering |
| Review cancel; final cancel; no candidates | The same active-state cleanup runs before the terminal event exits; no relationship effect is reachable; permanent lock remains | Event-chain runtime |
| Preflight failure | No relationship operation runs; actor variables retain the first failing numeric slot and reason for the failure page; acknowledging it uses the same active-state cleanup; permanent lock remains | All-before-any behavior and failure-result lifecycle under runtime state changes |
| Actor death | Every later entry rechecks `is_alive`; an additive child of `on_death` cleans when root is the coordinator actor; permanent lock remains | Exact hook/state timing and save/reload |
| Actor loses Dynast status or changes Dynasty | Every later entry rechecks Dynast/Dynasty identity; an additive child of `on_became_dynasty_head` cleans if the new head is the active actor or the active actor is no longer Dynast; permanent lock remains | The vanilla hook has no former-head scope; transition ordering and coverage of every engine cause need runtime proof |
| Queued/instant event trigger failure | Event-specific `on_trigger_fail` uses central active-state cleanup; permanent lock remains | Only the documented event path is covered |
| Abnormal visible-event close | No close callback or immediate-cleanup claim. The workflow has no delayed/background continuation, resume, or reauthorization path, so residual state is orphaned and cannot advance | UI-close behavior remains a runtime gate; the permanent lock blocks every later run |
| Load/start with residue | An additive child of `on_game_start_after_lobby` may clear residual coordinator and actor state but never removes the lock or resumes the workflow | Exact save-load timing |
| New start | If the permanent lock exists, reject every actor before activation | No restart, stale-run adoption, or numeric run-identity comparison exists |

Save/reload, lock persistence, hook timing, stale event-context isolation, and abnormal event-chain termination remain mandatory runtime tests. No recurring pulse, timeout, delayed continuation, candidate scan, background matchmaking, resume, or reauthorization is part of cleanup.

### 4.6 Explicit non-effects

The prototype must not script any effect that changes:

- court or realm location;
- titles, claims, government, contracts, or vassal relationships;
- Dynasty or House;
- imprisonment, activities, wars, or travel;
- Prestige, alliances, succession, or inheritance directly; or
- opinions, hooks, stress, modifiers, or flags unrelated to temporary workflow state.

Some of these may change indirectly when CK3 processes a marriage or betrothal. That behavior is a runtime observation, not permission to reproduce or suppress it without a later decision.

## 5. Hybrid approaches

### 5.1 Review in Breed Improved, execute through native UI

This hybrid retains Phase 3 scoring but hands each accepted pair to the vanilla interface after final confirmation.

Classification: **REQUIRES PROTOTYPE**.

It preserves native proposal behavior, but inherits Approach A's mutable participants and missing completion/cancel callback. A player-driven Resume action could make the workflow recoverable, but the final confirmation would approve a plan rather than execute it. This remains deferred and is not part of the selected isolated prototype.

### 5.2 Direct conservative pairs, native UI for external pairs

Classification: **NOT RECOMMENDED FOR MVP**.

This would give different execution semantics to pairs in the same review: some complete immediately, while others become mutable proposals that may be refused. Completion state, cancellation, final summaries, and save/reload would be substantially harder to explain and verify.

### 5.3 Custom clone or override of the vanilla interaction

Classification: **NOT RECOMMENDED**.

Replacing or cloning the large stock marriage interaction would create high compatibility and maintenance risk. The current evidence does not justify that scope.

## 6. Comparison

| Criterion | Approach A | Approach B | Hybrid |
| --- | --- | --- | --- |
| Exact recommended pair preserved | No; participants may change | Yes, subject to pair-state prototype | Mixed |
| Native legality and acceptance | Strongest | Legality must be explicitly revalidated; matchmaker authority is deliberately overridden only within the workflow | Mixed |
| Native alliances and Prestige | Preserved | Runtime verification required | Mixed |
| Ordinary/matrilineal choice | Native UI | Must be chosen during review | Mixed |
| Minor betrothal | Native | Direct effect verified; behavior needs testing | Mixed |
| Grand Wedding | Native when available | Deferred | Mixed |
| Continuous batch control | Not verified | Technically controllable | Not verified |
| Cancel/result callback | Not verified | Controlled before execution | Incomplete |
| Final-confirmation semantics | Cannot guarantee completion | Can execute the approved plan | Ambiguous |
| Compatibility risk | Low per window, high if overridden | Moderate to high; additive files plus a guarded custom authority model | Highest workflow complexity |
| Isolated-prototype selection | Deferred | Selected | Not selected |

## 7. Selected isolated-prototype direction

Jay and Ray approved Approach B with a **Dynast override limited to the current workflow** for the isolated prototype. P1-P5 are now statically implemented; P6 runtime execution still requires Ray's explicit approval. This does not approve production implementation.

P6 runtime validation must determine:

1. all four adult/minor and ordinary/matrilineal relationship modes;
2. full-plan preflight followed by multi-pair execution;
3. actor-owned authorization, pair reservation, and cleanup across accept, skip, next partner, defer, finish, cancel, invalidation, save, and reload;
4. the dynamic five-percentage-point fertility tier and lexicographic ranking;
5. external-court and landed same-Dynasty recipients under the guarded override;
6. alliances, Prestige, court movement, titles, government, succession, Dynasty/House, matchmaker ownership, memories, on-actions, and error-log behavior;
7. byte-for-byte confirmation that Phase 1 and Phase 2 gameplay files are not changed by prototype work; and
8. Phase 1 and Phase 2 runtime regression safety.

Approach A may receive a separate one-pair UI prototype later only if Ray wants a native-proposal assistant despite the inability to promise seamless batch continuation.

Phase 3 is not ready for production implementation until the override's runtime behavior and side effects pass the required gates and Jay/Ray separately approve its production scope.

## 8. Batch state architecture

### 8.1 Phase 2 structures that can be reused

- player-initiated Decision entry;
- one-time Dynasty member discovery after explicit confirmation;
- event-driven sequential review;
- reviewed, skipped, and reserved character sets;
- a separate final confirmation;
- final validity rechecks;
- explicit workflow cleanup; and
- no recurring or background processing.

### 8.2 Structures that cannot be copied unchanged

- A Phase 2 selected-character list does not preserve pair membership or marriage direction.
- Ancestor-first branch folding has no Phase 3 equivalent; matchmaking requires one-to-one reservation rather than descendant-root collapse.
- Phase 2's shared exile effect is unrelated and must not be reused.
- Phase 2 can skip one invalid execution root independently. The approved Phase 3 prototype must instead abort the complete plan before any relationship changes when one pair fails preflight. Production invalidation behavior remains a post-prototype decision.

### 8.3 Pair record requirements

Each accepted record must conceptually contain:

- primary subject;
- selected partner;
- ordinary or matrilineal direction;
- expected marriage or betrothal result;
- whether the partner is a zero-fertility placeholder; and
- enough reservation state to prevent either character entering another accepted pair.

P0 selects the initiating actor as the sole pair-plan owner. Participant characters receive no reservation variables. The actor has 16 explicitly numbered slots. Every slot contains exactly six separately named fields:

1. `subject` - character;
2. `partner` - character;
3. `direction` - ordinary or matrilineal flag value;
4. `relationship_type` - marriage or betrothal flag value;
5. `placeholder` - the explicit `none` flag in this infrastructure prototype;
   and
6. `reservation_id` - a second character reference to that slot's `subject`,
   written last.

`reservation_id` is the commit marker. A slot is usable only when all five prior
fields exist and the final character reference equals that slot's `subject`.
The slot-specific variable name and subject equality provide the reservation
identity without embedded flag-name construction. An interrupted partial write
is therefore not a pair: it reserves no character, appears in no summary,
cannot execute, causes preflight failure if it remains in a non-empty slot, and
is then cleaned.

Every field removal must first check `exists = var:<static_name>`. The exact
vanilla removal evidence does not establish that removing an absent variable is
safe.

Sixteen pairs are the prototype-only capacity. This creates 96 bounded pair fields, 120 unordered slot-pair comparisons, and at most 480 subject/partner role comparisons. The slots can be explicitly cleared and preflighted while still exercising multi-pair behavior. This does not set a production limit. A seventeenth acceptance must be rejected explicitly or route the player to final confirmation; it must not overwrite, truncate, or wrap.

Before committing a slot, both proposed characters are compared with both participant fields in every committed slot. A match in any position rejects the new pair. This one rule prevents character reuse, mirror pairs, and overlap cycles: after `A-B`, neither `B-A`, `A-C`, nor `C-B` can be accepted. Final preflight repeats the complete cross-slot uniqueness check.

The global coordinator permits only one active plan across the prototype. P0 does not select a numeric run serial: although increment and capture components exist, no exact CK3 `1.19.0.6` comparison was found between a saved numeric workflow identity and a global serial. That possible stale-context discriminator remains **NOT VERIFIED** and cannot enter runnable script without separate evidence or approval.

The selected representation remains subject to runtime proof for save/reload persistence, visible final-summary access, interrupted writes, cleanup timing, permanent-lock persistence, and rejection of every second activation attempt in the same save. It does not use save-game numeric character IDs and does not treat parallel lists as tuples. Repeated activated workflows are intentionally impossible in this prototype and remain a future architecture question.

## 9. Candidate generation and performance

Naively comparing every Dynasty member with every other member is quadratic. A large Dynasty therefore requires staged filtering:

1. build the active-subject pool;
2. build normal and placeholder partner pools;
3. exclude hard-invalid and reserved characters before scoring;
4. evaluate vanilla legality only for plausible pairs;
5. apply lexicographic ranking in successive filters; and
6. retain only the bounded alternatives needed for review.

The dynamic tier, staged ranking, and large-Dynasty responsiveness are **REQUIRES PROTOTYPE**. No acceptable dynasty-size or elapsed-time threshold is asserted without a measured baseline.

## 10. Isolated prototype path and metadata contract

P0 allocates the following isolated test-only root:

```text
tests/phase3_dynasty_matchmaking/
  BreedImprovedPhase3Prototype.mod
  BreedImprovedPhase3Prototype/
    descriptor.mod
    common/
      decisions/
      on_action/
      scripted_effects/
      scripted_triggers/
      script_values/
    events/
    localization/
      english/
      simp_chinese/
```

This is an isolated test allocation, not production authorization. P1-P5 static
work is complete; P6 is `AWAITING RAY RUNTIME APPROVAL`.

The outer `.mod` uses the established portable `<LOCAL_MOD_PATH>` launcher
placeholder. The inner `descriptor.mod` contains no `path` and no
`remote_file_id`. Both identify **Breed Improved Phase 3 Prototype**, use
`version="0.1.0"` and `supported_version="1.19.*"`, and remain
test-only/non-release. No prototype file may enter production or Workshop
staging.

The English and Simplified Chinese files use matching key sets, the exact
headers `l_english:` and `l_simp_chinese:`, quoted values with the established
one-space indentation, `.yml` extensions in their respective directories, and
UTF-8 with BOM. These requirements follow the existing Phase 1 test
localisation and runtime-accepted production bilingual files; they do not
approve final Phase 3 player-facing text.

The test event namespace is allocated as `breedimp_p3_proto_matchmaking`, with the non-overlapping range `1000-1199`. This range is prototype-only and does not allocate any production namespace.

The existing Phase 1/2 production baseline, including v0.2.0, is already
published on Steam Workshop item `3769010534`. GitHub remains the source and
release-record channel, while that Workshop item is the player-distribution
channel. The Phase 3 prototype must not enter either release artifact.

### 10.1 Provisional production file scope

If the existing isolated prototype passes P6 and production implementation is separately approved, production would likely require additive, project-prefixed files in these existing CK3 content families:

| Responsibility | Provisional path |
| --- | --- |
| Player entry | `MyCK3Mod/common/decisions/breedimp_dynasty_matchmaking_decisions.txt` |
| Candidate, authority, legality, and protection checks | `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_matchmaking_triggers.txt` |
| Fertility, age, genetics, and kinship values | `MyCK3Mod/common/script_values/breedimp_dynasty_matchmaking_values.txt` |
| Pair generation, reservation, preflight, execution, and cleanup | `MyCK3Mod/common/scripted_effects/breedimp_dynasty_matchmaking_effects.txt` |
| Review and confirmation events | `MyCK3Mod/events/breedimp_dynasty_matchmaking_events.txt` |
| English and Simplified Chinese text | Existing verified language directories with matching `breedimp_` localisation files |

These paths are architectural estimates, not permission to create files. Namespace, event range, exact identifiers, UI form, and localisation keys remain unallocated.

## 11. Decisions required from Ray

| Decision | Options | Recommendation | Consequence |
| --- | --- | --- | --- |
| Production approval for the override | Reject after prototype; approve the tested scope; or narrow the tested scope | Decide only after complete runtime evidence | The prototype is not itself approval to ship a new Dynast power. |
| External-court same-Dynasty targets | Production exclude; advisory-only; or direct override | Test now, decide later | Direct execution bypasses their vanilla matchmaker and acceptance. |
| Landed same-Dynasty targets | Production exclude; warn and allow; or direct override | Test now, decide later | Marriage may affect courts, alliances, succession, and political state even without explicit Mod effects. |
| Player-controlled recipients | Always exclude; or permit explicit self-consent | Exclude from the isolated prototype unless separately approved | The actor's confirmation is not necessarily consent for another human player. |
| Side-effect acceptance | Require native parity; accept documented differences; or reject direct execution | Require evidence before choosing | Direct effects are not statically proven equivalent to the native interaction. |
| Pair-plan persistence | Disallow save/reload mid-flow; or support the selected actor-owned slots after runtime proof | Decide after prototype | P0 selected the representation, but combined save/reload persistence and lifecycle cleanup are not runtime-verified. |
| Exact fertility display | Show exact script value; or show qualitative tiers | Qualitative tiers until runtime presentation and information disclosure are approved | Exact display may expose normally opaque values and needs formatting tests. |
| Genetic trait model | Reuse Phase 2 warning set; approve a new Phase 3 set; or omit genetics initially | Approve a dedicated Phase 3 set after research | Phase 2 traits were selected for warnings, not matchmaking weights. |
| Exact-score ties | Treat as equivalent; add a neutral tiebreak; or let order remain unspecified | Treat as equivalent and let the player cycle choices | Stable engine ordering is not verified; names and save IDs must not be used. |
| Grand Weddings | Include; native-UI-only; or defer | Defer | Direct setup is DLC- and context-dependent. |

## 12. P0 checkpoint and stop condition

P0 evidence registration and design closure is complete. The checkpoint records:

- approved prototype direction: workflow-scoped Dynast override with Approach B;
- one global workflow coordinator;
- actor-owned 16-slot pair plan with six fields per slot and `reservation_id` written last;
- centralized explicit cleanup plus additive death, Dynasty-head, and load/start lifecycle hooks;
- permanent one-workflow-per-save lock, with no numeric run identity, restart,
  resume, or delayed/background continuation;
- namespace `breedimp_p3_proto_matchmaking`, event IDs `1000-1199`;
- isolated test path, descriptor, localisation-header, encoding, and BOM contract; and
- CK3 runtime `NOT RUN`.

P0 is `CORRECTED AND CLOSED`; P1-P5 are `STATIC COMPLETE`; P6 is
`AWAITING RAY RUNTIME APPROVAL`. Production remains `NOT APPROVED`, and CK3 runtime remains
`NOT RUN`.

No production implementation should begin until:

- P6 runtime validation is approved and completed by Ray;
- the context-dependent pair-plan, permanent-lock, and cleanup forms pass their
  runtime matrix;
- the four relationship modes, external-court targets, and landed targets complete their runtime matrix;
- direct-effect side effects are compared with native-interaction behavior;
- the genetic trait model is separately approved;
- the selected prototype passes its runtime matrix; and
- Jay and Ray approve the resulting production authority and architecture.

Evidence-index updates: the Phase 3 P0 evidence is registered in `.agents/skills/ck3-mod-development/references/ck3_evidence_index.md` and the accompanying syntax/provenance references.
