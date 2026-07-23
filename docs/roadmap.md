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

## Later phases

### Dynasty marriage assistance

Player-assisted marriage planning remains a future concept. Candidate scoring, relationship-distance limits, genetic-risk presentation, and player controls require separate design approval and CK3 evidence.

### Advanced breeding assistance

Long-term breeding planning remains a future concept. It will remain player-assisted rather than fully autonomous.

No future release date is promised.
