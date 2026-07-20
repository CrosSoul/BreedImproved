# Phase 1 Implementation Plan: Dynasty Membership Management

## Document Status

- Mod: Breed Improved
- Phase: Phase 1
- Feature: Dynasty Membership Management
- Status: Planning only; no gameplay implementation is authorized by this document
- Internal prefix: `breedimp`
- Target CK3 version currently recorded by the project: `1.19.*`

This document describes desired behavior, open design decisions, research tasks, risks, and a recommended development sequence. It does not define valid Crusader Kings III script.

The current project syntax registry contains no verified CK3 constructs, and the project has no sourced vanilla examples for this feature. Every CK3 implementation detail identified below therefore remains unverified.

## Status Labels

- **CONFIRMED DESIGN:** Approved product behavior that future implementation must preserve.
- **DESIGN DECISION REQUIRED:** Product behavior that must be decided before implementation.
- **UNVERIFIED CK3 SYNTAX:** A possible implementation concept with no verified target-version CK3 construct, context, scope, or file form. Do not copy it into a runnable file.

## Scope and Non-Negotiable Behavior

**CONFIRMED DESIGN:**

- Cleanup is always controlled by the player.
- There is no automatic or scheduled candidate scan.
- There is no yearly cleanup.
- There is no automatic dynasty-member exile or other removal.
- There is no background event or passive process that modifies dynasty membership.
- Every workflow begins with explicit player action.
- Every dynasty exile requires player confirmation.
- The individual and bulk interfaces should share eligibility and exile validation wherever possible.
- Phase 1 does not change vanilla genetics or inheritance rules.

A candidate scan is allowed only inside a management flow explicitly initiated by the player. Opening or activating the bulk interface may request a current candidate list; this must not create recurring work or delayed background behavior.

## Interface Responsibilities

### Character Interaction

Purpose:

- Handle one character at a time.
- Allow the player to initiate cleanup from a specific character's interaction menu.
- Explain why the character is eligible or ineligible.
- Require confirmation immediately before exile from the managed dynasty lineage.

This is the recommended first interface because it can validate the shared rules and dynasty-exile behavior without also depending on bulk candidate presentation and selection.

**UNVERIFIED CK3 SYNTAX:** The exact CK3 interaction file structure, actor and target scopes, visibility and availability fields, confirmation support, and effect execution context have not been verified.

### Dynasty Decision

Purpose:

- Handle large dynasties efficiently.
- Start only when the player explicitly invokes the management flow.
- Evaluate current candidates, present eligible characters, and allow the player to select multiple characters.
- Require confirmation before any selected dynasty exile is applied.
- End without changing membership when cancelled.

**UNVERIFIED CK3 SYNTAX:** It is not yet verified that a standard CK3 decision can present and retain an arbitrary multi-character selection. Vanilla examples must establish whether this can be implemented through a decision alone, a decision-led event flow, verified GUI support, another CK3-native flow, or not at all. These are research alternatives, not approved structures.

## Candidate Eligibility Rules

### Conceptual Rule Shape

Eligibility should be modeled as a shared, side-effect-free decision:

```text
player + intended dynasty + target character
    -> shared eligibility evaluation
    -> eligible or ineligible, with reason information
```

This diagram is conceptual and is not CK3 syntax.

The evaluation must not remove a character, schedule work, or persist a recurring scan. Both interfaces should evaluate the same target under the same player and intended-dynasty context.

### Bastard Cases

**CONFIRMED DESIGN:** Bastard cases are a primary eligibility category.

**DESIGN DECISION REQUIRED:**

- Decide which player-facing bastard categories qualify.
- Decide whether a legitimized bastard remains eligible.
- Decide how disputed heritage, secret parentage, adoption-like relationships, or other non-standard parentage should be treated, if they exist in the target CK3 version.
- Decide whether bastard status alone is sufficient or must be combined with a parent-dynasty mismatch.
- Decide whether eligibility changes immediately when the relevant status changes.

**UNVERIFIED CK3 SYNTAX:** The exact trait keys, status representation, triggers, secret checks, and scope requirements for every bastard-related case are unknown. The design phrase "bastard trait" must not be converted into a guessed trait ID or `has_*` trigger.

### Trait Identification and Save-Data Rule

**CONFIRMED DESIGN:** Save-game numeric trait identifiers are serialization references only. They must never be used as mod script identifiers or treated as evidence of a valid CK3 trait/status key.

Before implementing any bastard-related eligibility rule:

- Inspect the target-version CK3 game files for the actual script key or status representation.
- Verify whether each required concept is represented as a trait, another status type, or a combination of constructs.
- Verify the exact key, category, file family, trigger context, input scope, and target CK3 version.
- Record the evidence in the project's CK3 syntax reference before using the construct in runnable code.
- Do not infer a script key from a numeric save value, translate a numeric ID by guesswork, or assume that serialization numbering is a stable public scripting API.

**UNVERIFIED CK3 SYNTAX:** No bastard-related trait key, status key, or detection trigger is currently verified for this project.

### Parent Dynasty Checks

**CONFIRMED DESIGN:** A mismatch between biological parents and the intended dynasty is a primary eligibility category.

**DESIGN DECISION REQUIRED:**

- Define "intended dynasty." Possible product definitions include the player's dynasty, the dynasty being managed, or another explicitly selected dynasty; no definition is approved yet.
- Decide whether both biological parents must be outside the intended dynasty or whether one outside parent is sufficient.
- Decide how to handle one or both unknown parents.
- Decide whether a parent with no dynasty counts as outside the intended dynasty.
- Decide whether the check uses dynasty membership, house membership, or both.
- Decide whether current parent membership or membership at the target's birth controls the result.
- Decide how deceased parents and parents whose affiliation later changed are evaluated.
- Decide whether marriage type or expected lineage affects eligibility.
- Decide how hidden or disputed biological parentage should affect information shown to the player.

**UNVERIFIED CK3 SYNTAX:** Biological-parent scope links, parent existence checks, dynasty or house comparison, historical affiliation, hidden information access, and their valid trigger contexts have not been verified.

### Common Safety and Authority Gates

The following are required design decisions before the shared eligibility rule is finalized:

| Question | Why it matters |
| --- | --- |
| Who may use the tool? | Determines whether authority belongs to any player, the dynasty head, a house head, or another role. |
| Must the target currently belong to the intended dynasty? | Prevents applying dynasty-exile behavior to an unrelated character. |
| Can the player target their own character? | May require an explicit safeguard. |
| Can another human-controlled character be targeted? | Affects multiplayer consent and control. |
| Are children, adults, or both eligible? | Affects safety, presentation, and expected use. |
| Are living and dead characters both eligible? | May affect history and family-tree consistency. |
| Are rulers, heirs, or otherwise important characters protected? | Dynasty exile may have wider vanilla consequences. |
| Are prisoners, missing characters, or unavailable characters handled differently? | The target may change state between selection and confirmation. |
| Is eligibility `bastard OR parent mismatch`, `bastard AND parent mismatch`, or configurable? | The current design lists both categories but does not define their logical relationship. |
| Can an ineligible character be shown with an explanation? | Influences transparency and interaction availability. |

The actor, target, and intended dynasty must be revalidated immediately before dynasty exile, not only when the interface first displays a candidate.

## Exile Outcome and Behavior

### Confirmed Player-Facing Outcome

The Phase 1 action is named **Exile from Dynasty**.

**CONFIRMED DESIGN:**

- The character is separated from the player's managed dynasty lineage.
- The action does not kill the character.
- The action does not automatically imprison the character.
- Making the character landless is not the feature goal and is not, by itself, equivalent to dynasty exile.
- The intended result is that the character loses inheritance relevance associated with the removed lineage.
- The character should lose claims controlled by the removed lineage if that can be implemented safely with verified CK3 behavior.

"Exile from Dynasty" is a Breed Improved product term. It does not assert that CK3 provides an exile, banishment, dynasty-removal, claim-removal, or inheritance-removal command. It also does not require geographical exile, departure from a court, imprisonment, loss of land, or any other consequence unless later research proves that consequence is technically required and the design explicitly approves it.

**UNVERIFIED CK3 SYNTAX:** True dynasty separation, resulting house or dynasty assignment, dynasty-related inheritance relevance, claim ownership or removal, and any relationship to landless or exile states are all unverified.

### Open Technical Questions

- Does the target CK3 version support true removal from, or separation from, a dynasty lineage?
- Must the character receive a new house or dynasty to remain in a valid state?
- Is a landless or exile-like status technically required, merely one possible method, or unrelated to dynasty separation?
- How can lineage-controlled claims and inheritance relevance be changed safely without damaging unrelated claims or altering vanilla inheritance rules?

### Required Behavioral Contract

**CONFIRMED DESIGN:**

- Scanning and selection do not change dynasty membership.
- Cancelling does not change dynasty membership.
- Confirmation occurs before the state-changing operation.
- Eligibility is checked again at confirmation time.
- The individual and bulk paths should invoke the same verified dynasty-exile operation where possible.
- No dynasty-exile operation may schedule future cleanup or create a recurring process.
- Exile from Dynasty must not invoke killing or automatic imprisonment as a substitute for lineage separation.

**DESIGN DECISION REQUIRED:**

- Determine whether CK3 supports true dynasty removal or separation from the managed lineage.
- Define the target's state after exile: no dynasty, a new or existing house/dynasty, or another outcome supported by verified CK3 behavior.
- Decide whether landless or another exile-like status is technically required, merely optional, or unrelated.
- Define "inheritance relevance" precisely and determine how it can be changed without modifying vanilla inheritance rules.
- Define which claims are "controlled by the removed lineage" and determine whether they can be removed safely.
- Decide whether the bulk operation is all-or-nothing or skips candidates who become invalid.
- Decide how partial failure is presented to the player.
- Decide whether and how the operation affects descendants, existing children, parents, spouses, or other relatives. No propagation is approved.
- Decide whether dynasty exile can be reversed and what recovery behavior is expected.
- Decide what confirmation text must disclose about known consequences.

### Possible CK3 Research Approaches

These are feasibility investigations, not implementation recommendations.

| Research approach | Potential value | Risks and limitations | Verification required |
| --- | --- | --- | --- |
| Directly change or clear the target's dynasty or house affiliation | Could match the requested Exile from Dynasty outcome | A suitable CK3 effect may not exist; dynasty and house may not be independently mutable; the operation may create inconsistent or unsupported state | Exact effect, valid input scope, required destination or value, house/dynasty relationship, save behavior, and target-version vanilla usage |
| Reuse a vanilla CK3 workflow that changes family affiliation, if one exists | May preserve more vanilla invariants than a low-level mutation | No suitable workflow is currently known; it may impose unrelated requirements or consequences | Same-version vanilla example, callable context, player-control behavior, side effects, and whether it supports the required targets |
| Use a project-owned exclusion state without changing vanilla membership | Could provide a reversible fallback if true dynasty separation is unsupported | Does not actually exile the character from the vanilla dynasty and therefore does not satisfy the confirmed outcome without an explicit design change; every downstream Breed Improved feature would need to honor the exclusion | A verified persistent state mechanism, save compatibility, visibility, cleanup, and explicit user approval of this changed product meaning |

**UNVERIFIED CK3 SYNTAX:** No dynasty-exile, dynasty-removal, house-change, membership-clear, claim-removal, inheritance-relevance, landless-state, character-state, or persistent-marker command is verified. Do not invent an effect name from English verbs such as `exile`, `remove`, `set`, `clear`, or `change`.

### Principal Risks

- A membership change may have downstream consequences in vanilla dynasty, house, renown, succession, inheritance, relationship, history, or user-interface systems. The exact effects must be researched and tested; this list identifies risk areas, not confirmed behavior.
- Separating a character without a valid resulting affiliation may be unsupported.
- House membership and dynasty membership may require coordinated handling.
- Dynasty separation may not automatically remove claims or change inheritance relevance in the intended way.
- Removing claims broadly could affect claims unrelated to the managed lineage.
- Making a character landless, moving them between courts, imprisoning them, or killing them would not by itself satisfy the confirmed lineage-separation outcome.
- Cached or previously presented candidates may become invalid before confirmation.
- A bulk operation may leave a partially modified group if one target fails.
- Hidden parentage information may reveal information the player should not know.
- Multiplayer authority and consent may differ from single-player expectations.
- Other mods may depend on the original dynasty or house state.
- Existing saves may respond differently from new games.

## Technical Architecture

### Conceptual Components

```text
Character Interaction ----\
                           -> Shared Eligibility -> Confirmation -> Shared Dynasty-Exile Operation
Player-Initiated Decision-/           ^                                  |
          -> Candidate presentation ---|                                  -> Result reporting
```

This is an architectural diagram, not CK3 script or proof that each component maps to a CK3 construct.

### Possible Shared Scripted Triggers

The following are planning names that follow the confirmed `breedimp_` convention. Their existence, parameters, scopes, return behavior, and file format are not verified.

| Planning identifier | Conceptual responsibility | Status |
| --- | --- | --- |
| `breedimp_is_dynasty_cleanup_candidate` | Combine authority, target-membership, safety, and approved reason checks | **UNVERIFIED CK3 SYNTAX** |
| `breedimp_has_cleanup_bastard_reason` | Evaluate the approved bastard-case definition | **UNVERIFIED CK3 SYNTAX** |
| `breedimp_has_parent_dynasty_mismatch` | Evaluate the approved biological-parent rule against the intended dynasty | **UNVERIFIED CK3 SYNTAX** |
| `breedimp_can_exile_dynasty_member` | Revalidate actor, target, and current state immediately before dynasty exile | **UNVERIFIED CK3 SYNTAX** |

Before using any scripted trigger, verify:

- That CK3 supports the scripted-trigger file family in the intended target version and path.
- Its declaration and call syntax.
- How actor, target, and intended-dynasty context are supplied.
- The input scope expected by each parent, dynasty, house, and status check.
- Whether reason-specific results can be exposed to either interface without duplicating logic.

### Possible Shared Scripted Effects

| Planning identifier | Conceptual responsibility | Status |
| --- | --- | --- |
| `breedimp_exile_dynasty_member` | Apply one verified separation from the managed dynasty lineage after final validation and confirmation | **UNVERIFIED CK3 SYNTAX** |
| `breedimp_process_selected_dynasty_exile` | Revalidate one selected bulk candidate, invoke the shared dynasty-exile operation, and report its result | **UNVERIFIED CK3 SYNTAX** |

The earlier planning name `breedimp_remove_dynasty_member` is superseded by the preferred planning name `breedimp_exile_dynasty_member`. Prefer `exile` over `remove` because the design represents separation from a managed lineage, not deletion of a character. These are naming recommendations only; no implementation file or CK3 definition currently exists to rename.

Before using any scripted effect, verify:

- That CK3 supports the scripted-effect file family in the intended target version and path.
- Its declaration and call syntax.
- The exact state-changing CK3 effect and its valid character, house, dynasty, claim, or inheritance-related scope.
- Whether lineage separation, claim changes, and inheritance relevance require separate verified operations.
- How the operation guarantees that the character is neither killed nor automatically imprisoned.
- Whether a scripted effect can safely centralize the operation for both interfaces.
- How failure or changed eligibility is handled without partial or silent corruption.
- Whether any return or result-reporting model assumed by the architecture actually exists.

### Interface Adapters

The character interaction should contain only interface-specific visibility, player initiation, target presentation, and confirmation behavior, then delegate to shared eligibility and dynasty-exile logic if verified CK3 patterns allow it.

The dynasty decision should contain only player initiation, candidate discovery, presentation and selection, confirmation, and result reporting, then delegate each target to the same shared logic.

**UNVERIFIED CK3 SYNTAX:** CK3 support for multi-character selection, retaining selections between screens, passing an intended-dynasty context, iterating selected targets, and showing per-target validation reasons is unknown. Do not design runnable files until same-version vanilla references establish a valid flow.

## Verification Backlog

| Priority | Verification item | Evidence needed | Current status |
| --- | --- | --- | --- |
| 1 | Actual dynasty-exile or lineage-separation feasibility and consequences | Same-version vanilla CK3 files or version-matched official documentation | Unverified |
| 2 | Character, house, and dynasty scope relationships | Same-version examples with identical usage contexts | Unverified |
| 3 | Bastard and legitimized-bastard script keys or status representation; numeric save IDs are not acceptable evidence | Same-version trait/status definitions and trigger usage | Unverified |
| 4 | Biological-parent access and hidden-parentage behavior | Same-version scope and trigger examples | Unverified |
| 5 | Character interaction structure and confirmation | Same-version vanilla interaction examples | Unverified |
| 6 | Decision structure and explicit player activation | Same-version vanilla decision examples | Unverified |
| 7 | Candidate enumeration and multi-character selection | Same-version vanilla flow demonstrating the required behavior | Unverified |
| 8 | Scripted trigger/effect declaration, calls, and scope passing | Same-version vanilla scripted definitions and callers | Unverified |
| 9 | Safe handling of claims and inheritance relevance after lineage separation | Same-version claim, dynasty, and inheritance examples with documented consequences | Unverified |
| 10 | Whether a new house/dynasty or landless/exile-like state is required | Same-version vanilla behavior and state-transition examples | Unverified |
| 11 | Bulk-operation failure policy feasibility | Verified control-flow and state-change behavior | Unverified |
| 12 | Localisation keys and dynamic character text | Same-version localisation examples for the chosen interfaces | Unverified |

If any required construct cannot be verified, report `UNVERIFIED CK3 SYNTAX: <specific uncertainty>` and pause that implementation path rather than substituting a similar construct from another Paradox game.

## Recommended Development Order

No step below authorizes gameplay-file creation. It is the recommended order for a future, separately approved implementation task.

1. **Resolve product decisions.** Define intended dynasty, authority, logical relationship between eligibility categories, target protections, post-exile state, claim scope, inheritance relevance, bulk failure policy, reversibility, and multiplayer policy.
2. **Acquire target-version evidence.** Populate the syntax registry with sourced CK3 examples for every required scope, trigger, effect, interaction, decision, confirmation, scripted definition, candidate flow, and localisation format.
3. **Verify trait and status identity.** Resolve actual target-version bastard-related script keys from game files. Reject numeric save-game trait IDs as implementation identifiers.
4. **Prove dynasty-exile feasibility first.** Determine whether CK3 can safely separate a character from the managed lineage, produce an approved resulting affiliation, change inheritance relevance, and remove only applicable lineage-controlled claims. Confirm that the approach does not kill or automatically imprison the character. Stop Phase 1 implementation if this cannot be verified.
5. **Specify shared eligibility.** Write a test matrix covering approved bastard cases, parent-dynasty cases, authority gates, safety exclusions, and state changes between display and confirmation.
6. **Plan the shared validation layer.** Map each rule to verified CK3 constructs and define actor, target, and intended-dynasty scope contracts.
7. **Plan the single-target dynasty-exile layer.** Map final revalidation, lineage separation, resulting affiliation, inheritance relevance, applicable claim handling, and failure behavior to verified CK3 constructs.
8. **Implement and test the Character Interaction first.** In a future approved task, use the simplest player-initiated path to validate one target, one confirmation, and one dynasty exile.
9. **Validate actual game consequences.** Test relevant character types and inspect logs, saves, dynasty/house displays, claims, inheritance behavior, and downstream vanilla behavior before bulk work begins.
10. **Research and prototype a read-only bulk flow.** Verify candidate enumeration, presentation, and selection without performing dynasty exile. Do not add timers or background processing.
11. **Integrate confirmed bulk dynasty exile.** Revalidate every selected target at confirmation time and invoke the same verified single-target operation under the approved all-or-nothing or partial-failure policy.
12. **Run consistency and regression tests.** Confirm that both interfaces agree on eligibility, cancellation never changes state, no automatic process exists, no target is killed or automatically imprisoned, and every applied dynasty exile followed explicit player confirmation.

## Planning Acceptance Criteria

Phase 1 is ready for implementation only when:

- Every design-decision item required by the first interface has an approved answer.
- The exact CK3 version is confirmed.
- True dynasty-exile feasibility and post-exile affiliation are verified.
- Bastard-related script keys or statuses are verified from target-version game files; no numeric save-game identifiers are used as script IDs.
- The effect on lineage-controlled claims and inheritance relevance is defined and verified, or explicitly documented as technically infeasible before the design proceeds.
- The approved approach does not kill or automatically imprison the target and does not treat landlessness alone as dynasty exile.
- Every required CK3 construct is recorded with version, context, scope, and evidence.
- The interaction and decision flows have sourced, same-version CK3 reference patterns.
- The shared eligibility contract and test matrix are approved.
- Confirmation and cancellation behavior is defined for both interfaces.
- Bulk selection feasibility and failure policy are resolved before bulk mutation is attempted.
- No proposed architecture includes automatic scans, yearly cleanup, background events, or automatic removal.

Until these conditions are met, this document remains a research and design plan only.
