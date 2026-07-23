# Breed Improved Phase 3 - Technical Approach Comparison

Status: `ISOLATED PROTOTYPE DIRECTION APPROVED - PRODUCTION IMPLEMENTATION NOT APPROVED`

Target: Crusader Kings III `1.19.0.6 (Scribe)`

Runtime status: `NOT RUN`

This document compares technical approaches for Phase 3 Dynasty Matchmaking Management and records the approved direction for a future isolated prototype. The prototype direction is a **Dynast-override model limited to the current, explicitly initiated workflow**. This is a guarded Breed Improved direct-execution pathway, not a vanilla CK3 permission, not evidence that a Dynast is every member's matchmaker, and not approval for production gameplay.

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
- every completion, cancellation, invalidation, or failure path must clear all workflow authorization and pair-plan state.

## 2. Evidence baseline

All paths in this section are relative to the CK3 `game/` directory.

| Mechanism | Classification | Vanilla evidence | Safe conclusion |
| --- | --- | --- | --- |
| Open the vanilla marriage window with four supplied characters | **CONFIRMED FEASIBLE** | `common/important_actions/00_marriage_actions.txt:164-171`, `open_interaction_window` | The actor, recipient, secondary actor, and secondary recipient can be supplied when opening `arrange_marriage_interaction`. |
| Keep both proposed spouses fixed in that window | **NOT FEASIBLE** through the verified stock form | `common/character_interactions/_character_interactions.info:582-587` | The schema explicitly says the secondary participants may be changed in the interface. No verified locking argument was found. |
| Receive a completion or setup-cancel callback from `open_interaction_window` | **NOT VERIFIED** | `common/character_interactions/06_ep3_laamp_interactions.txt:3532-3543`; targeted stock usages | The call opens a window and the enclosing effect continues. No result, close, or cancel callback was found. |
| Native marriage legality and side effects | **CONFIRMED FEASIBLE** through the native interaction | `_character_interactions.info:576-587`; `common/character_interactions/00_marriage_interactions.txt:563-566` | The special interaction performs its own validation and handles marriage or betrothal, alliances, and Prestige. |
| Direct ordinary and matrilineal marriage | **CONFIRMED FEASIBLE** for the relationship operation | `events/interaction_events/marriage_interaction_events.txt:1016-1032` | `marry` and `marry_matrilineal` exist as character effects. |
| Direct ordinary and matrilineal betrothal | **CONFIRMED FEASIBLE** for the relationship operation | `events/interaction_events/marriage_interaction_events.txt:1016-1032`; `events/activities/tournaments/tournament_events.txt:1631-1644` | `create_betrothal` and `create_betrothal_matrilineal` exist; vanilla selects betrothal when either party is a minor in the cited event. |
| Direct-effect parity with the native interaction | **FEASIBLE WITH LIMITATIONS** | Sources above and `_character_interactions.info:576-587` | Static evidence does not prove identical alliances, Prestige, matchmaker ownership, movement, memories, or other side effects. |
| Pair legality trigger | **CONFIRMED FEASIBLE** | `common/scripted_triggers/00_marriage_triggers.txt:17-210,362-429` | `can_marry_character_trigger` is available for pair legality. Native participant availability has additional interaction checks. |
| Universal Dynast marriage authority | **NOT FEASIBLE** under verified vanilla rules | `common/character_interactions/00_marriage_interactions.txt:94-159,1417-1449` | Dynasty membership does not make the Dynast every member's matchmaker. The approved prototype deliberately tests a Mod-owned override rather than claiming this authority exists. |
| Dynamic best-minus-0.05 fertility tier | **REQUIRES PROTOTYPE** | `common/decisions/90_minor_decisions.txt:1669-1677`; `events/diarchy_events/vizierate_events.txt:200-229`; `common/script_values/_script_values.info` | Fertility and ordered-list components exist, but the complete dynamic filtering and scope lifetime have not been runtime-proven. |
| Arbitrary accepted-pair state | **REQUIRES PROTOTYPE** | Phase 2 event-list evidence in `tests/event_target_lists_tests.txt:45-93` and `docs/research/Matt_Phase2_Vanilla_Evidence.md` | A list can store characters, but one list does not encode subject, partner, direction, and reservation as an atomic pair. |

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

Every pair must still pass the verified `can_marry_character_trigger` legality check and all approved product safeguards, including:

- both participants are alive, single, unbetrothed, and still in the actor's Dynasty;
- neither participant is already reserved by another accepted pair;
- the pair is not self-referential or a mirrored duplicate;
- the female-age-30 and male-age-40 minor-partner prohibitions are enforced as hard exclusions;
- existing `can_not_marry`, clergy, faith, gender, consanguinity, spouse-capacity, and other vanilla marriage failures are respected; and
- actor validity and workflow ownership are rechecked immediately before execution.

The override does not authorize searches outside the actor's current Dynasty, breaking existing marriages or betrothals, moving characters, changing titles, changing government, or applying unrelated political effects.

The prototype must include external-court and landed same-Dynasty cases. Their inclusion proves only the guarded override behavior under test; it must not be reported as vanilla matchmaker authority or automatically approved for production.

### 4.5 Authorization lifecycle and cleanup

The exact CK3 storage and invalidation syntax is not approved by this document. Conceptually, the prototype authorization must follow this lifecycle:

1. **Open:** create a single actor-owned workflow only after an eligible player Dynast explicitly starts Phase 3.
2. **Collect:** keep pair recommendations and review choices as temporary workflow state; do not change relationships.
3. **Lock:** prevent the same actor from starting a second concurrent Phase 3 workflow.
4. **Preflight:** confirm the original actor still owns the workflow, remains the living player Dynast, and every accepted participant remains inside the same Dynasty and passes every legality rule.
5. **Execute:** apply only the four approved relationship operations and only after the full plan passes.
6. **Close:** clear authorization, pair records, reservations, review state, and any continuation marker after success.
7. **Cancel or empty exit:** perform the same cleanup after review cancellation, final-confirmation cancellation, an empty accepted plan, or no valid candidates.
8. **Invalidate:** make the authorization unusable and clean its state when the actor dies, stops being player-controlled, loses Dynast status, changes Dynasty, a participant invalidates the plan, the event chain ends unexpectedly, or preflight fails.
9. **Recover:** before a new run, detect and clear any stale Phase 3 authorization or pair-plan state instead of reusing it.

Save/reload and abnormal event-chain termination are mandatory prototype tests. No unverified on-action, timeout, variable lifetime, or cleanup hook is presented here as valid CK3 syntax.

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

Jay and Ray's approved technical direction for the next separately authorized test implementation is Approach B with a **Dynast override limited to the current workflow**. This selects what the isolated prototype should investigate; it does not approve production implementation.

The prototype should prove:

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

The preferred conceptual owner is the initiating actor: one temporary pair plan attached to the actor's active workflow, rather than unrelated persistent markers distributed across every candidate. Each record must remain addressable as one pair plus its direction.

The exact storage representation is **NOT VERIFIED** and requires an evidence check before prototype code is written. This document does not assert that an actor-owned scope list, variable list, saved scope, bounded slot, or on-action cleanup form is valid for the required lifetime. Parallel character lists are not accepted as an implicit index-based tuple system. Any verified representation must prove:

- pair integrity across the complete event chain;
- exclusive ownership by the initiating actor and current workflow;
- cleanup on every exit;
- no collision between consecutive runs;
- no concurrent second plan for the same actor;
- save/reload behavior;
- no persistent gameplay-visible residue; and
- stable final-summary access.

## 9. Candidate generation and performance

Naively comparing every Dynasty member with every other member is quadratic. A large Dynasty therefore requires staged filtering:

1. build the active-subject pool;
2. build normal and placeholder partner pools;
3. exclude hard-invalid and reserved characters before scoring;
4. evaluate vanilla legality only for plausible pairs;
5. apply lexicographic ranking in successive filters; and
6. retain only the bounded alternatives needed for review.

The dynamic tier, staged ranking, and large-Dynasty responsiveness are **REQUIRES PROTOTYPE**. No acceptable dynasty-size or elapsed-time threshold is asserted without a measured baseline.

## 10. Provisional production file scope

If a later prototype is approved and passes, production would likely require additive, project-prefixed files in these existing CK3 content families:

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
| Pair-plan persistence | Disallow save/reload mid-flow; or support verified persistence and cleanup | Decide after storage evidence and prototype | Actor-owned storage and cleanup hooks are not yet verified. |
| Exact fertility display | Show exact script value; or show qualitative tiers | Qualitative tiers until runtime presentation and information disclosure are approved | Exact display may expose normally opaque values and needs formatting tests. |
| Genetic trait model | Reuse Phase 2 warning set; approve a new Phase 3 set; or omit genetics initially | Approve a dedicated Phase 3 set after research | Phase 2 traits were selected for warnings, not matchmaking weights. |
| Exact-score ties | Treat as equivalent; add a neutral tiebreak; or let order remain unspecified | Treat as equivalent and let the player cycle choices | Stable engine ordering is not verified; names and save IDs must not be used. |
| Grand Weddings | Include; native-UI-only; or defer | Defer | Direct setup is DLC- and context-dependent. |

## 12. Stop condition

No production implementation should begin until:

- the isolated prototype receives separate implementation approval;
- exact actor-owned pair-plan storage and cleanup syntax is verified;
- the four relationship modes, external-court targets, and landed targets complete their runtime matrix;
- direct-effect side effects are compared with native-interaction behavior;
- the genetic trait model is separately approved;
- the selected prototype passes its runtime matrix; and
- Jay and Ray approve the resulting production authority and architecture.

Evidence-index updates: none. The task's permitted file boundary excludes `.agents`; reusable evidence registration requires a separate approved pass.
