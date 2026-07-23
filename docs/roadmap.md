# Breed Improved Roadmap

## v0.1.0 — Individual Exile from Dynasty

Status: implemented and production runtime-verified.

Version 0.1.0 introduced the individual **Exile from Dynasty** Character Interaction. It supports minors, adults, unlanded characters, landed rulers, and current player heirs when the target meets production validation. House Heads and the Dynast are excluded.

The target and descendants enter a generated replacement Dynasty. The interaction applies the approved opinion, stress, ten-year modifier, permanent marker, conditional House Head Hook removal, and native personal-Prestige cost. It performs no automatic or background processing.

## v0.2.0 — Multi-Mode Dynasty Cleanup

Status: implemented, runtime-accepted, approved, and published to the existing
Steam Workshop item `3769010534`.

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

The final candidate-page layout, quoted option labels, tooltips, complete cleanup matrix, CK3 error log, and release approval are recorded as passing in `docs/testing/phase2_dynasty_cleanup_manual.md`. GitHub is the project source and release-record channel; Steam Workshop item `3769010534` is the player-distribution channel. Repository automation does not upload Workshop content.

Deferred Phase 2 extensions include accepted-founder-parent and whole-branch protection, combined modes, arbitrary trait selection, scoring, saved mode preferences, and broader descendant-topology handling. No character names or save-specific character IDs will be hardcoded.

## Phase 3 - Dynasty Matchmaking Management

Phase 3 isolated prototype:
`STATIC IMPLEMENTATION COMPLETE — PARTIAL RUNTIME ACCEPTANCE COMPLETE`.

Status: `P0 CORRECTED AND CLOSED`.

P1-P5 status: `STATIC COMPLETE`.

P6 status: `40 MAPPED PASS / 0 FAIL / 116 NOT RUN`.

Phase 3 is a proposed player-initiated workflow for reviewing same-Dynasty marriage and betrothal recommendations. Static CK3 `1.19.0.6` research confirms individual building blocks for native marriage-window preselection, direct marriage and betrothal effects, current fertility, age comparison, vanilla marriage legality, and coarse kinship categories.

The approved isolated-prototype direction is the **Dynast-override model, with authority limited to the current workflow**, combined with direct execution after final confirmation (Approach B). A living player-controlled Dynast must explicitly start and confirm the workflow. Breed Improved then supplies a temporary internal authority for that run only. This is an intentional Mod power: verified vanilla evidence does not grant a Dynast general marriage authority over every Dynasty member.

P0 has registered the CK3 `1.19.0.6` evidence and closed a test-only design with one global actor/phase coordinator, a permanent one-workflow-per-save lock, sixteen actor-owned six-field pair slots, a subject-reference commit marker stored in each slot's `reservation_id`, a 16-pair capacity, duplicate/mirror prevention, lifecycle guards, namespace `breedimp_p3_proto_matchmaking`, event range `1000-1199`, and the standalone test-file contract. Numeric run identity remains unverified and is not used. The full P0 submission is `docs/Matt_to_Jay_Phase3_P0_Checkpoint_Report.md`.

The isolated prototype must preserve all non-authority legality and safety rules, store only an unexecuted temporary plan during review, and perform complete all-or-nothing preflight validation before creating any relationship. If any planned pair is invalid, the whole plan stops without creating a marriage or betrothal. Opening the Decision only dispatches a pre-activation confirmation event; its explicit activation option sets the permanent lock before coordinator state or candidate scanning, while cancelling that event consumes nothing. The lock is never removed. Because no generic visible-event close callback is verified, an abnormally closed workflow is orphaned and locked: it has no delayed/background continuation, resume, or reauthorization path.

Ray's post-fix runtime sequences passed the mapped smoke/lifecycle paths, all four direct relationship forms, accepted-character reservation and duplicate protection, tested batch safety, the 16/17 capacity boundary, the `100/95/94` and `80/75/74` fertility boundaries, within-tier adult age priority, minor age priority, female `29/30` and male `39/40` hard limits, tested save/reload persistence, completion feedback, and one large-Dynasty recommendation scenario. The earlier accepted-character reservation defect is fixed and did not reproduce. Smoke 3's reuse of a displayed but unaccepted character is expected because only accepted and committed pairs reserve participants.

Formal status:
`PROTOTYPE ACCEPTED — PRODUCTION DESIGN MAY PROCEED`.

Production implementation remains unapproved. The matrix records 40 `PASS`,
0 `FAIL`, 116 `NOT RUN`, and 0 `BLOCKED`; no full-matrix or clean-error-log
claim is made. Direct-effect side effects, broader lifecycle/invalidation
variants, special states, external-court and ruler cases, Phase 1/2 regression,
and CK3 error-log review remain gates before production integration or release.
The prototype-only one-run-per-save lock, fixed 16-pair capacity, namespace,
diagnostics, localisation, and UI must not enter production unchanged.

Native marriage-window batch continuation, final trait scoring, lower fertility
tiers, exact kinship calculation, special-state policy, multiplayer consent,
Grand Weddings, and other product refinements remain deferred rather than
cancelled. No automatic or background matchmaking is planned.

The next recommended task is **Phase 3 production implementation design and
gap-closure specification**. It requires Jay/Boss approval. Production coding,
integration, release, and Workshop publication remain unapproved.

## Later phases

### Advanced breeding assistance

Long-term breeding planning remains a future concept. It will remain player-assisted rather than fully autonomous.

No future release date is promised.
