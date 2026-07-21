# Breed Improved v0.1.0 — Runtime Acceptance Record

## Status

- CK3 target: `1.19.0.6`
- Production v0.1.0 runtime acceptance: `PASS`
- Save/reload persistence: `PASS`
- CK3 runtime errors: none observed
- Other abnormalities: none observed
- Evidence owner: Boss-reported production acceptance
- Clean-package installation regression: manual release gate, not performed during documentation and packaging preparation

This record distinguishes the final production acceptance result from the earlier standalone test-harness iterations. The test harness under `tests/phase1_create_dynasty/` was used during development and is not release content. The final production result below supersedes earlier iterative harness statuses and corrected-RC2 pending notes.

## Final production acceptance matrix

| Scenario | Final result |
| --- | --- |
| Production interaction appears correctly | `PASS` |
| Hostile/Dynasty interaction presentation | `PASS` |
| English localisation | `PASS` |
| Simplified Chinese localisation | `PASS` |
| Minor target | `PASS` |
| Adult target | `PASS` |
| Unlanded target | `PASS` |
| Landed ruler target | `PASS` |
| Current player heir target | `PASS` |
| House Head exclusion | `PASS` |
| Dynast exclusion | `PASS` |
| Target enters generated replacement Dynasty | `PASS` |
| Descendants enter replacement Dynasty | `PASS` |
| Parents and siblings remain unchanged | `PASS` |
| Actor-held House Head Hook is removed when present | `PASS` |
| Hook-absent case does not remove an unrelated Hook | `PASS` |
| Recipient opinion of actor begins at `-60` | `PASS` |
| Opinion recovers by `0.5` monthly | `PASS` |
| Recipient base stress gain is `60` | `PASS` |
| Ten-year modifier contains `diplomacy = -1` | `PASS` |
| Ten-year modifier contains `stress_gain_mult = 0.2` | `PASS` |
| Ten-year modifier contains `monthly_prestige = -0.25` | `PASS` |
| Permanent exile marker is applied | `PASS` |
| Free-cost case | `PASS` |
| Paid 100-personal-Prestige case | `PASS` |
| Native affordability and deduction behavior | `PASS` |
| Save/reload persistence | `PASS` |

## Final cost-rule matrix

| Recipient condition | Expected cost | Final result |
| --- | --- | --- |
| Has `bastard` | 0 personal Prestige | `PASS` |
| Has `legitimized_bastard` | 0 personal Prestige | `PASS` |
| At least one explicitly existing legal parent is outside actor's Dynasty | 0 personal Prestige | `PASS` |
| No qualifying trait and all existing legal parents are inside actor's Dynasty | 100 personal Prestige | `PASS` |
| Parent relation is missing | Missing relation does not qualify by itself | `PASS` |

Only script-visible legal parent scopes are used. Spouses, descendants, hidden biological-parent secrets, and ancestry beyond parents are excluded from the calculation.

## Accepted consequence boundary

The accepted operation:

- creates a generated replacement Dynasty for the target;
- propagates that Dynasty change to descendants;
- removes only an existing actor-held `house_head_hook` over the recipient;
- applies the approved opinion, stress, ten-year modifier, and permanent marker to the recipient; and
- uses CK3's native interaction-cost system.

It does not directly change claims, marriage, titles, court membership, government, imprisonment, or other political status.

## Deferred married-character claim observation

**DEFERRED — NOT BLOCKING v0.1.0**

A married target was previously observed to receive spouse-related strong claims after game time advanced. The cause has not been established. Breed Improved v0.1.0 does not add claim removal or divorce behavior.

## Release-package regression gate

The production gameplay is accepted, but the finished ZIP still requires the manual clean-install checks listed in `docs/publishing/v0.1.0_release_checklist.md`. No CK3 runtime test is performed as part of the release documentation and packaging pass.
