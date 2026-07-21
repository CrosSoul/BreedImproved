# Breed Improved Roadmap

## v0.1.0 — Individual Exile from Dynasty

Status: release candidate; production gameplay runtime-verified.

Version 0.1.0 contains only the individual **Exile from Dynasty** Character Interaction. It supports minors, adults, unlanded characters, landed rulers, and current player heirs when the target meets the production validation rules. House Heads and the Dynast are excluded.

The target and descendants enter a generated replacement Dynasty. The interaction applies the approved opinion, stress, ten-year modifier, permanent marker, conditional House Head Hook removal, and native personal-Prestige cost. It performs no automatic or background processing.

## Phase 2 — Bulk Dynasty Cleanup

Status: deferred design; not implemented.

The following product boundaries are recorded for later design:

- Bulk cleanup must use a separate, conservative candidate trigger.
- It must not automatically reuse the manual interaction's blood-impurity cost trigger as its candidate rule.
- Dynasty-external parents may later be marked as accepted founder parents.
- Children of accepted founder parents must be protected from inclusion in a player-initiated bulk cleanup candidate set.
- The individual **Exile from Dynasty** interaction remains available independently.
- No character names or save-specific character IDs may be hardcoded.
- The accepted-founder-parent whitelist and bulk cleanup require separate design approval, CK3 syntax verification, implementation approval, and runtime testing.
- Any scan must occur only after explicit player initiation. No scheduled, background, or recurring scan is permitted.

“Protected from automatic cleanup” means excluded from a future player-initiated bulk candidate set. It does not authorize autonomous cleanup or background execution.

## Later phases

Dynasty marriage assistance and advanced breeding assistance remain conceptual future work. They are not part of v0.1.0 or the approved Phase 2 implementation scope. No release dates are promised.
