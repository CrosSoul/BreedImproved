# Breed Improved Roadmap

## v0.1.0 — Individual Exile from Dynasty

Status: release candidate; production gameplay runtime-verified.

Version 0.1.0 contains only the individual **Exile from Dynasty** Character Interaction. It supports minors, adults, unlanded characters, landed rulers, and current player heirs when the target meets the production validation rules. House Heads and the Dynast are excluded.

The target and descendants enter a generated replacement Dynasty. The interaction applies the approved opinion, stress, ten-year modifier, permanent marker, conditional House Head Hook removal, and native personal-Prestige cost. It performs no automatic or background processing.

## Phase 2 — Bulk Dynasty Cleanup

Status: development implementation prepared; static validation `PASS`; runtime status `NOT RUN`; not included in v0.1.0.

The conservative first implementation provides:

- one player-initiated **Manage Dynasty Cleanup** Decision for a living player Dynast;
- one mode per run: **Bloodline Cleanup** or **Negative Congenital Trait Cleanup**;
- a fixed, evidence-backed negative congenital trait preset;
- positive congenital trait warnings without automatic offset or scoring;
- shared mandatory exclusions and player-managed individual direct-candidate protection;
- ancestor-first sequential candidate review with select, leave-unselected, finish, and cancel controls;
- a separate final confirmation and final eligibility revalidation;
- selected ancestor/descendant overlap collapse; and
- execution through the unchanged v0.1.0 **Exile from Dynasty** effect.

Bloodline Cleanup is intentionally more conservative than the individual interaction's free-cost rule. It includes public bastard states or requires both explicitly existing legal parents to be outside the actor's Dynasty. It does not use the v0.1.0 cost trigger as its candidate rule.

The first implementation has no batch cost. It supports only individual direct-candidate protection across both modes; this is not whole-descendant-branch protection. The ordinary individual **Exile from Dynasty** interaction remains available independently. Candidate discovery begins only after explicit player confirmation and never runs on a schedule, in the background, or through AI.

Before Phase 2 can be released, Ray must complete the manual matrix in `docs/testing/phase2_dynasty_cleanup_manual.md`, including both languages, all candidate branches, protection, control flow, branch overlap, large-Dynasty behavior, save/reload, and error-log review. Jay/Boss must then explicitly approve the runtime result.

Deferred work includes accepted-founder-parent and whole-branch protection, combined modes, arbitrary trait selection, scoring, saved mode preferences, and any broader descendant-deduplication design. No character names or save-specific character IDs may be hardcoded.

## Later phases

Dynasty marriage assistance and advanced breeding assistance remain conceptual future work. They are not part of v0.1.0 or the approved Phase 2 implementation scope. No release dates are promised.
