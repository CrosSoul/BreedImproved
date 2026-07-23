# Breed Improved Roadmap

## v0.1.0 — Individual Exile from Dynasty

Status: implemented and production runtime-verified.

Version 0.1.0 introduced the individual **Exile from Dynasty** Character Interaction. It supports minors, adults, unlanded characters, landed rulers, and current player heirs when the target meets production validation. House Heads and the Dynast are excluded.

The target and descendants enter a generated replacement Dynasty. The interaction applies the approved opinion, stress, ten-year modifier, permanent marker, conditional House Head Hook removal, and native personal-Prestige cost. It performs no automatic or background processing.

## v0.2.0 — Multi-Mode Dynasty Cleanup

Status: implemented and runtime-accepted for v0.2.0; Ray recommends release and Jay/Boss approved the final artifact. Ready for Ray's manual update of the existing Workshop item; not yet published.

Version 0.2.0 adds:

- one player-initiated **Manage Dynasty Cleanup** Decision for a living player-controlled Dynast;
- **Bloodline Cleanup** and **Negative Congenital Trait Cleanup** modes;
- a fixed negative congenital-trait preset with positive-trait warnings;
- shared mandatory exclusions and player-managed direct-candidate protection;
- ancestor-first sequential review;
- controls to select, spare, finish early, or add the current and all remaining candidates;
- a separate final confirmation and final eligibility revalidation;
- selected ancestor/descendant branch-root folding; and
- execution through the unchanged v0.1.0 **Exile from Dynasty** effect.

Direct-candidate protection is not whole-branch protection. It prevents a protected character from being chosen as a direct candidate or direct execution root, but the character may still move as part of a selected ancestor's complete descendant branch.

The first release has no batch cost. Candidate discovery begins only after explicit player confirmation and never runs on a schedule, in the background, or through AI.

The final candidate-page layout, quoted option labels, tooltips, complete cleanup matrix, CK3 error log, and release approval are recorded as passing in `docs/testing/phase2_dynasty_cleanup_manual.md`. No Workshop upload is performed by repository automation, and v0.2.0 must not be described as published until Ray completes the existing-item update.

Deferred Phase 2 extensions include accepted-founder-parent and whole-branch protection, combined modes, arbitrary trait selection, scoring, saved mode preferences, and broader descendant-topology handling. No character names or save-specific character IDs will be hardcoded.

## Phase 3 - Dynasty Matchmaking Management

Status: `STATIC FEASIBILITY COMPLETE - ISOLATED PROTOTYPE DIRECTION APPROVED; PRODUCTION NOT APPROVED`.

Phase 3 is a proposed player-initiated workflow for reviewing same-Dynasty marriage and betrothal recommendations. Static CK3 `1.19.0.6` research confirms individual building blocks for native marriage-window preselection, direct marriage and betrothal effects, current fertility, age comparison, vanilla marriage legality, and coarse kinship categories.

The approved isolated-prototype direction is the **Dynast-override model, with authority limited to the current workflow**, combined with direct execution after final confirmation (Approach B). A living player-controlled Dynast must explicitly start and confirm the workflow. Breed Improved then supplies a temporary internal authority for that run only. This is an intentional Mod power: verified vanilla evidence does not grant a Dynast general marriage authority over every Dynasty member.

The prototype must preserve all non-authority legality and safety rules, store only an unexecuted temporary plan during review, and perform complete all-or-nothing preflight validation before creating any relationship. If any planned pair is invalid, the whole plan stops without creating a marriage or betrothal. The prototype must also prove temporary-authority cleanup, pair-state integrity, ordinary and matrilineal adult marriages and minor betrothals, direct-effect side effects, dynamic fertility tiers, large-Dynasty performance, save/reload behavior, and Phase 1/2 regression safety.

Production implementation remains unapproved. Native marriage-window batch continuation, final trait scoring, lower fertility tiers, exact kinship calculation, special-state policy, multiplayer consent, Grand Weddings, and other product refinements remain deferred rather than cancelled. No automatic or background matchmaking is planned.

The next gate is approval of `docs/Matt_to_Jay_Phase3_Prototype_Implementation_Plan.md`. Only after that approval may an isolated test-only prototype be created. CK3 runtime status remains `NOT RUN`.

## Later phases

### Advanced breeding assistance

Long-term breeding planning remains a future concept. It will remain player-assisted rather than fully autonomous.

No future release date is promised.
