[h1]Breed Improved[/h1]

[b]Manage your Dynasty's marriages and betrothals from one player-controlled review.[/b]

Breed Improved v0.3.0 is a Crusader Kings III dynasty-management utility. It keeps every action under player control and does not alter vanilla genetics or inheritance rules.

[h2]New in v0.3.0 — Manage Dynasty Matchmaking[/h2]

A living player-controlled Dynast can start the [b]Manage Dynasty Matchmaking[/b] Decision to review same-Dynasty AI candidates one proposal at a time.

For each proposal you may:

[list]
[*][b]Accept ordinary[/b] — add the pair as an ordinary marriage or betrothal plan.
[*][b]Accept matrilineal[/b] — add the pair as a matrilineal marriage or betrothal plan when legal.
[*][b]Show me another partner[/b] — keep the current subject and offer a different partner.
[*][b]Skip[/b] — leave the current subject unmatched for this run.
[*][b]Defer[/b] — come back to the current subject after reviewing other candidates.
[*][b]Finish early[/b] — stop reviewing and move to final confirmation with the pairs you already accepted.
[/list]

Nothing changes during the review. A separate final confirmation is required before any marriage or betrothal is created.

[h2]Adults and minors[/h2]

[list]
[*]Adult plus adult pairs become marriages.
[*]Any pair containing a minor becomes a betrothal.
[*]Both ordinary and matrilineal directions are offered where legal.
[/list]

[h2]Ranking and boundaries[/h2]

Adult candidates are ranked by fertility first, with the top candidates grouped in an inclusive five-percentage-point band, then by age proximity, congenital traits, and coarse kinship preference. Minor candidates are ranked by age proximity first, then congenital traits and kinship preference. A small set of known vanilla congenital traits is used for scoring; unknown or modded trait groups are ignored rather than assigned invented values.

Woman 29 or man 39 can still be matched with a minor; woman 30+ or man 40+ are not matched to minors. Fertile divorced and widowed adults may be rematched. A zero-fertility adult is used only as a clearly warned fallback placeholder for a fertile previously married adult when no positive-fertility partner remains. Minors never receive placeholder partners and the Mod will not proactively pair two zero-fertility characters.

[h2]v0.2.0 — Manage Dynasty Cleanup[/h2]

The player-initiated [b]Manage Dynasty Cleanup[/b] Decision remains available. Choose one mode per run:

[list]
[*][b]Bloodline Cleanup[/b] — reviews public bastard cases and Dynasty members whose explicitly existing legal father and mother are each either lowborn or outside your Dynasty. One outside parent or a missing parent is not enough.
[*][b]Negative Congenital Trait Cleanup[/b] — reviews Dynasty members with Breed Improved's fixed negative congenital-trait preset. The review warns you when a candidate also has a positive congenital trait worth preserving.
[/list]

Candidates are shown one at a time. You may add the current candidate to the exile list, spare them and continue, keep the current list and finish early, or add the current and all remaining eligible candidates while preserving anyone you already spared. A separate final confirmation is required before any exile is applied.

[h2]Individual Exile from Dynasty[/h2]

The original individual [b]Exile from Dynasty[/b] Character Interaction remains available. Eligible targets include minors, adults, unlanded characters, landed rulers, and the current player heir. The actor cannot target themself, a House Head, the Dynast, a lowborn character, or another player-controlled character.

The individual interaction is free when the target has [i]bastard[/i], has [i]legitimized_bastard[/i], or has at least one explicitly existing legal parent outside your Dynasty. Otherwise it costs 100 personal Prestige through CK3's native interaction-cost system.

After confirmation, the target and descendants enter a generated replacement Dynasty. The approved opinion, stress, ten-year modifier, permanent exile marker, and conditional House Head Hook removal are applied to the direct target.

[h2]Player control[/h2]

Breed Improved performs no automatic cleanup, background scan, scheduled scan, recurring action, AI-initiated cleanup, automatic matchmaking, or background relationship creation. Every workflow is started by the player, and every exile, marriage, or betrothal requires final confirmation.

The Mod does not automatically kill, imprison, divorce, remove claims from, or strip titles from characters. Claims, marriages, titles, court status, government, and imprisonment are not directly changed beyond the relationships created after explicit confirmation in the matchmaking workflow.

[h2]Limitations[/h2]

[list]
[*]Matchmaking candidates are limited to AI-controlled members of your current Dynasty.
[*]Up to 32 accepted pairs are allowed in one matchmaking run.
[*]There is no accept-all-remaining option and no Grand Wedding orchestration.
[*]Only one matchmaking workflow can be active at a time.
[*]Known vanilla congenital traits are used for scoring; unknown/modded trait groups are not assigned invented genetic values.
[*]Direct relationship operations are used after final confirmation.
[/list]

[h2]Compatibility and languages[/h2]

[list]
[*]Crusader Kings III: 1.19.*
[*]Breed Improved: v0.3.0
[*]English
[*]Simplified Chinese
[/list]

Compatibility with other mods has not been comprehensively tested. Breed Improved uses prefixed identifiers and no replace_path, but mods changing the same Dynasty, Decision, event, or Character Interaction systems may still interact unexpectedly.

[h2]Installation[/h2]

Steam Workshop is the only supported installation channel for ordinary players. Subscribe to this item, enable [b]Breed Improved[/b] in a CK3 Launcher playset, and launch the game.

No manual-install ZIP is provided. GitHub source archives are source snapshots and are not supported installable Mod packages.

[h2]Source and bug reports[/h2]

[url=https://github.com/CrosSoul/BreedImproved]GitHub source, documentation, roadmap, and issue tracker[/url]

When reporting a bug, include the CK3 version, Breed Improved version, enabled DLC, Mod load order, game language, reproduction steps, and the relevant error-log excerpt. Please state whether the issue reproduces with only Breed Improved enabled.
