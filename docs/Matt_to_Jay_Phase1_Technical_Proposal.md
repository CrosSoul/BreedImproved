# Breed Improved Phase 1 - Technical Proposal

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

Evidence basis:

- [Lynn's initial research summary](research/Lynn_to_Jay_Research_Summary.md)
- [Lynn's focused Phase 1 follow-up](research/Lynn_to_Jay_Phase1_Followup.md)
- CK3 target build: `1.19.0.6`

This proposal interprets Lynn's evidence and recommends a technical direction. It is not an approved feature specification and does not authorize gameplay implementation. No combined Exile from Dynasty transaction is demonstrated by vanilla; every combined sequence below remains subject to Jay's architecture approval, the Boss's product decisions, and controlled in-game testing.

## 1. Technical interpretation of Lynn's findings

### Confirmed script capabilities

The following capabilities have direct CK3 `1.19.0.6` vanilla evidence in Lynn's reports.

| Capability | Verified identifier | Evidence and technical meaning |
| --- | --- | --- |
| Assign a character to an existing House | `set_house` | Used in `events/bookmark_events.txt`, `common/scripted_effects/00_bastard_effects.txt`, `common/scripted_effects/05_dlc_bp2_effects.txt`, `events/interaction_events/bastard_interaction_events.txt`, and `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`. Assignment to a House also supplies the House's Dynasty affiliation. The exact call form and destination-scope pattern must be copied from a matching vanilla example before implementation. |
| Create a replacement Dynasty for a scoped character | `create_dynasty` | Verified in character scope in `common/scripted_effects/00_accolades_scripted_effects.txt`, `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`, `events/dlc/tgp/tgp_japan_decision_events.txt`, and `events/dlc/tgp/tgp_mandala_task_contract_events.txt`. Verified parameters are `name`, `coat_of_arms`, `spread_to_descendants`, and `save_scope_as`. Vanilla enters the target character's scope before calling it. |
| Obtain a House with a newly created Dynasty | Character `house` scope after `create_dynasty` | `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt` and `events/dlc/tgp/tgp_japan_decision_events.txt` enter the same character's `house` scope immediately after Dynasty creation. This confirms automatic House association in those flows. |
| Create a cadet House | `create_cadet_branch` | Verified in `common/decisions/00_dynasty_decisions.txt` and `common/scripted_effects/00_decisions_effects.txt`. It separates Houses but leaves the target inside the original Dynasty, so it cannot implement Exile from Dynasty by itself. |
| Convert a character to lowborn | `set_to_lowborn = yes` | Verified in `common/scripted_effects/00_bastard_effects.txt`, `events/travel_events/travel_events_james.txt`, and `events/dlc/tgp/tgp_tai_migration_events.txt`. This is broader than lineage separation. The creation field `dynasty = none` is verified only during character creation, not as an effect for an existing character. |
| Apply vanilla disinheritance | `disinherit_effect` | Defined in `common/scripted_effects/00_interaction_effects.txt` and called on the recipient by `disinherit_interaction` in `common/character_interactions/00_dynast_interactions.txt`. It adds `disinherited` and opinion/rivalry consequences; it does not change House, Dynasty, claims, or court. |
| Block Dynasty inheritance through a trait | `inheritance_blocker = dynasty` | Verified on `disinherited` in `common/traits/00_traits.txt`. This is a broad trait rule, not a record tied to one source Dynasty. |
| Enumerate and remove claims | `every_claim`, `remove_claim` | Verified in `common/scripted_effects/05_dlc_fp3_scripted_effects.txt`, `common/character_interactions/00_prison_interactions.txt`, `events/interaction_events/character_interaction_events.txt`, and `events/yearly_events/bp1_yearly_james.txt`. Vanilla preserves the original character scope while iteration changes scope to the claimed title. |
| Filter claims in known ways | `explicit`, `pressed`, holder, liege, and de jure relationships | Verified patterns exist in `common/character_interactions/00_prison_interactions.txt` and the other claim sources above. No lineage-provenance filter was found. |
| Politically banish an unlanded character | `banish = yes` | The standard flow in `common/character_interactions/00_prison_interactions.txt` is prisoner-based. `events/yearly_events/yearly_events_5.txt` also applies the raw effect to an unlanded courtier without demonstrating an imprisonment prerequisite. |
| Return an unlanded character to the pool | `move_to_pool = yes` | Verified in `events/yearly_events/yearly_events_5.txt`, `events/yearly_events/yearly_events_3.txt`, `events/yearly_events/yearly_events_sahara.txt`, and `events/activities/hunt_activity/hunt_events.txt`. This is political/court movement, not Dynasty separation. |
| Convert eligible characters into landless adventurers | `banish_effect`, event `ep3_laamps.0021` | `common/scripted_effects/07_dlc_ep3_scripted_effects.txt` calls `events/dlc/ep3/ep3_laamp_events.txt`. The flow is EP3/Roads to Power dependent and changes titles, government, succession law, and claims. |
| Read or change family data separately from Dynasty | `father`, `mother`, `real_father`, `set_father`, `set_mother`, `set_real_father`, `is_parent_of`, `is_child_of` | Verified in `common/scripted_triggers/00_family_triggers.txt`, `common/scripted_triggers/00_bastard_triggers.txt`, `common/scripted_effects/00_secret_effects.txt`, and `events/birth_events.txt`. Parentage does not disappear when Dynasty affiliation changes. |

Lynn's initial summary also marks `every_dynasty_member` as verified Dynasty-member iteration. The report does not include its precise vanilla source path or scope example. Under this project's evidence standard, it is a credible research result but not yet implementation-ready until that pointer is recorded.

Before production code, the verified constructs above should be promoted into `.agents/skills/ck3-mod-development/references/ck3_syntax_reference.md` with their exact context, scopes, arguments, version, and evidence pointers. The registry is currently empty.

### Behavior requiring controlled in-game testing

Source evidence establishes that individual constructs exist; it does not establish that the complete Breed Improved sequence is safe. The following require isolated tests:

- `create_dynasty` on an arbitrary existing highborn, living, non-ruler, unlanded member of someone else's Dynasty.
- Generated Dynasty/House name, coat of arms, founder/history data, UI refresh, and save persistence for that target class.
- Default descendant behavior when `spread_to_descendants` is omitted.
- Existing-descendant behavior when `spread_to_descendants = yes`, especially married, landed, cross-realm, or House-Head descendants.
- `set_house` into a House belonging to a different Dynasty for the exact Phase 1 target class.
- `set_to_lowborn = yes` on an established highborn character, including titles, claims, marriage, family history, succession, and UI.
- Persistence and scope of `disinherited` after `create_dynasty`.
- Whether `inheritance_blocker = dynasty` then blocks inheritance associated with the replacement Dynasty.
- Implicit-claim behavior in an unrestricted `every_claim` loop.
- Raw `banish = yes` and `move_to_pool = yes` on spouses, parents, children, prisoners, hostages, councillors, court-position holders, and other obligated characters.
- House Head, Dynasty Head, last-House-member, special-title, administrative-family, adventurer, and landed cases.
- The complete operation order as one sequence. No cited vanilla flow combines disinheritance, claim removal, Dynasty creation, and political exile.

### Unresolved design choices

Technical evidence does not decide:

- Whether Exile from Dynasty means a replacement Dynasty, assignment to an existing outside House, or lowborn conversion.
- Whether descendants remain in the original Dynasty or move with the target.
- Whether disinheritance is part of exile.
- Which, if any, claims are removed.
- Whether political/court exile is part of the action.
- Which target classes are allowed in the first release.
- Whether a replacement Dynasty uses generated identity or player/project-defined naming and coat of arms.
- Whether bulk exile ships with the first implementation or follows the proven individual workflow.

### Unsupported assumptions

The current evidence does not support any of the following:

- `set_dynasty`, `remove_dynasty`, `remove_house`, `set_house = none`, or a generic `create_house` effect.
- A general runtime use of `dynasty = none` on an existing character.
- A safe highborn state with neither House nor Dynasty.
- Claim filtering by the Dynasty or lineage from which a claim originated.
- Automatic claim removal, parentage removal, marriage changes, title changes, or political exile after House/Dynasty reassignment.
- Cadet-branch creation as Dynasty exile.
- `banish`, `move_to_pool`, landlessness, or disinheritance as Dynasty exile by themselves.
- Native multi-character selection or a complete preview UI in a standard Dynasty Decision.
- Transactional rollback if a multi-step script fails after an earlier mutation.

## 2. Candidate implementation approaches

### Comparison summary

| Approach | Leaves managed Dynasty | Preserves highborn identity | Replacement affiliation | Phase 1 assessment |
| --- | --- | --- | --- | --- |
| Create a replacement Dynasty | Expected, but exact target class needs testing | Yes | New Dynasty and automatically associated House in verified flows | Best technical candidate for a narrow individual MVP after tests |
| Assign to an existing House in another Dynasty | Yes if the destination House belongs to another Dynasty | Yes | Existing House/Dynasty | Feasible only after a destination policy and cross-Dynasty test |
| Convert to lowborn | Expected to remove noble affiliation, but established highborn behavior needs testing | No | None/lowborn state | Too broad and risky as the baseline |
| Create a cadet House | No | Yes | New House inside original Dynasty | Not suitable |
| Disinherit only | No | Yes | Unchanged | Not suitable as lineage separation; possible optional consequence |
| `banish` or `move_to_pool` only | No | Yes | Unchanged | Not suitable as lineage separation; possible optional political consequence |

### Approach A: Create a replacement Dynasty

Expected player-visible result:

- The target remains a named highborn character but displays a newly created Dynasty and associated House.
- The target no longer appears as a member of the player's managed Dynasty if the effect behaves for the target class as it does in the verified vanilla flows.
- Biological relationships remain visible because parentage is independent.
- Court/realm location, marriage, titles, and claims should remain unchanged unless separate effects alter them; this must still be confirmed in the combined test.

Required CK3 effects and scopes:

- `create_dynasty` in the target character's scope, matching the character-scoped vanilla forms in `common/scripted_effects/00_accolades_scripted_effects.txt`, `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`, `events/dlc/tgp/tgp_japan_decision_events.txt`, and `events/dlc/tgp/tgp_mandala_task_contract_events.txt`.
- Optional verified parameters are `name`, `coat_of_arms`, `spread_to_descendants`, and `save_scope_as`. No other parameter should be assumed.
- The character's resulting `house` scope is available in the cited Japanese flows after successful creation.

Technical risks and consequences:

- **Dynasty/House:** Creates a new persistent Dynasty and House per target unless a reuse strategy exists. Bulk use could produce large numbers of one-person Dynasties, additional save data, generated names/arms, and UI clutter.
- **Inheritance:** Leaving the old Dynasty may affect Dynasty-specific inheritance, but title succession can still depend on blood relationship, law, claims, or other rules. No automatic guarantee exists.
- **Claims:** Claims remain independent and should be expected to persist unless separately removed.
- **Descendants:** `spread_to_descendants = yes` is verified, but its exact coverage is not. Omission is verified syntax, but target-only behavior is not yet confirmed.
- **Court/realm:** No political movement is evidenced as an automatic consequence. The target may remain in the player's court.
- **Compatibility:** Other mods may reference the original House/Dynasty, target status, historical identity, or family roles. Generated Dynasty proliferation may conflict with UI assumptions or balance systems.
- **Leadership:** Current House Heads, Dynasty Heads, and last House members are unsafe until tested.

Phase 1 suitability:

- Suitable as the leading candidate for a narrow Character Interaction MVP restricted to a tested target class.
- Not yet suitable for bulk execution, descendants, leadership cases, or optional consequences in one transaction.

### Approach B: Assign the target to another House

Expected player-visible result:

- The target adopts the destination House and its Dynasty.
- If the destination House belongs to the same Dynasty, the target has not been exiled from the Dynasty.
- If it belongs to another Dynasty, the target leaves the managed Dynasty but becomes part of an existing lineage that may not logically accept them.

Required CK3 effects and scopes:

- `set_house`, using an exact matching pattern from `events/bookmark_events.txt`, `common/scripted_effects/00_bastard_effects.txt`, `common/scripted_effects/05_dlc_bp2_effects.txt`, `events/interaction_events/bastard_interaction_events.txt`, or `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`.
- Lynn's summary confirms the capability but does not quote the full call form. Implementation must not guess the argument or destination-scope syntax.

Technical risks and consequences:

- **Dynasty/House:** The target joins an existing House and Dynasty. This can contaminate another lineage, alter membership counts, and create political or narrative ownership questions.
- **Inheritance:** The target may become relevant to the destination House/Dynasty while still retaining blood-based or title-law relevance elsewhere.
- **Claims:** No automatic change.
- **Descendants:** The Japanese `japan_set_house_effect` moves descendants through separate recursive logic. That does not prove direct `set_house` propagates; test target-only behavior.
- **Court/realm:** No automatic movement is evidenced.
- **Compatibility:** Highest risk when the destination House is vanilla-owned, controlled by another player, or used by another mod. A shared project-owned exile House would itself require approved creation/ownership design and verified setup.

Phase 1 suitability:

- Potentially suitable if the Boss approves a defined destination House/Dynasty and tests show safe target-only assignment.
- Less clean than a replacement Dynasty because it inserts the target into an unrelated existing lineage.

### Approach C: Convert the target to lowborn

Expected player-visible result:

- The target loses noble House/Dynasty presentation and becomes lowborn.
- This is a status demotion, not merely separation from the managed lineage.

Required CK3 effects and scopes:

- `set_to_lowborn = yes`, using an exact vanilla pattern from `common/scripted_effects/00_bastard_effects.txt`, `events/travel_events/travel_events_james.txt`, or `events/dlc/tgp/tgp_tai_migration_events.txt`.
- Do not use `dynasty = none`; Lynn verified it only as a character-creation field.

Technical risks and consequences:

- **Dynasty/House:** Likely removes noble affiliation, but exact behavior on an established highborn must be tested.
- **Inheritance:** Lowborn conversion may change more than Dynasty-specific relevance. Titles, succession eligibility, marriage value, prestige, and history require observation.
- **Claims:** No evidence shows automatic removal; claims must be inspected.
- **Descendants:** Unknown. Existing descendants may retain their affiliations, creating a parent/child status split.
- **Court/realm:** No automatic political movement is established.
- **Compatibility:** High risk for mods and vanilla systems that expect the character's original historical Dynasty or noble status.

Phase 1 suitability:

- Not recommended as the default. It is suitable only if the Boss explicitly wants Exile from Dynasty to include loss of highborn identity and controlled tests show acceptable consequences.

### Approach D: Replacement affiliation plus optional independent consequences

Expected player-visible result:

- The core operation changes lineage using Approach A or B.
- Separately approved modules may address claims, inheritance, or court departure.

Required capabilities:

- One verified affiliation change.
- Optional `disinherit_effect`, filtered `every_claim`/`remove_claim`, and either `banish = yes` or `move_to_pool = yes`, each in its verified scope and context.

Technical risks and consequences:

- This is the closest match to the full product wish, but it is not atomic. If an early step succeeds and a later step fails, the target can be left partially modified.
- Disinheritance and claim filters may require original Dynasty/realm context, so ordering matters.
- Political exile must be last to preserve stable access to original court and realm context.
- Every added consequence increases localisation, confirmation, validation, compatibility, and regression-test requirements.

Phase 1 suitability:

- Suitable as a later composition after the affiliation-only operation is proven.
- Not recommended for the first implementation because there is no verified rollback mechanism.

### Approaches that do not meet the core action

- `create_cadet_branch` from `common/decisions/00_dynasty_decisions.txt` or `common/scripted_effects/00_decisions_effects.txt` keeps the character inside the original Dynasty.
- `disinherit_effect` from `common/scripted_effects/00_interaction_effects.txt` changes inheritance and opinions but not membership.
- `banish = yes`, `move_to_pool = yes`, and the EP3 `banish_effect`/`ep3_laamps.0021` flow change political placement, not lineage.
- A project-owned exclusion marker would not change vanilla Dynasty membership and is not supported as the confirmed player-facing outcome without a design change.

## 3. Claim policy options

No policy is technically mandatory. `create_dynasty`, `set_house`, and `set_to_lowborn` must not be assumed to remove claims. The Boss must choose the product policy.

### Remove all claims

Technical basis:

- `every_claim` plus `remove_claim` during iteration is verified in `common/scripted_effects/05_dlc_fp3_scripted_effects.txt`. Related patterns also exist in `common/character_interactions/00_prison_interactions.txt`, `events/interaction_events/character_interaction_events.txt`, and `events/yearly_events/bp1_yearly_james.txt`.

Consequences:

- Simple definition: every claim enumerated for the target is removed.
- Potentially destroys claims unrelated to the managed Dynasty, including claims earned personally or inherited through another line.
- Inclusion and behavior of implicit claims in an unrestricted loop require testing.
- Strongest political punishment and highest compatibility risk.
- Confirmation must enumerate or clearly disclose the full scope; a generic warning is inadequate for high-impact targets.

### Remove only explicit claims

Technical basis:

- Lynn verified `explicit = yes` claim filtering in vanilla claim flows.

Consequences:

- Narrower than all-claim removal and avoids claiming support for a lineage-provenance filter that does not exist.
- Still removes explicit claims worldwide, including claims unrelated to the managed Dynasty.
- The player-visible distinction between explicit and other claims must be explained accurately in localisation.
- Implicit or other claim categories may continue to provide political relevance after exile.

### Remove claims connected to the actor's realm

Technical basis:

- `common/character_interactions/00_prison_interactions.txt` contains verified filters using current holder, holder's liege, actor realm relationships, and actor de jure hierarchy.

Consequences:

- Better aligned with protecting the actor's political domain than removing every claim.
- It is a realm-protection policy, not a lineage-origin policy.
- Results depend on the current realm and title hierarchy at execution time and may change after wars or succession.
- The filter must run while original actor/realm context is still available if the selected vanilla pattern depends on it.
- Exact filter syntax must be copied from the cited vanilla flow; no general title-tier or lineage-origin filter is verified.

### Remove no claims by default

Technical basis:

- Requires no claim mutation. It respects the verified separation between Dynasty affiliation and claims.

Consequences:

- Lowest technical and compatibility risk.
- The exiled character can retain political claims against titles connected to the old family or realm.
- The confirmation text must state that claims are unchanged.
- This makes Exile from Dynasty a lineage operation rather than a comprehensive political purge.

### Make claim removal a separate optional consequence

Technical basis:

- Uses one of the verified claim policies only after the player explicitly opts in.

Consequences:

- Preserves a conservative default while supporting stronger cleanup when requested.
- Adds UI, confirmation, result-reporting, and test complexity.
- If executed in the same effect chain, it increases partial-execution risk.
- If executed as a separate later action, authority and eligibility must be defined after the target is no longer in the managed Dynasty.
- The optional policy still cannot identify claim provenance by old Dynasty.

Technical assessment:

- No option is required for Dynasty replacement to function.
- From a risk perspective, no removal by default or a separately confirmed optional consequence is safer than automatic removal, but this is a recommendation for product review, not a selected policy.

## 4. Inheritance handling

### Whether to use `disinherit_effect`

`disinherit_effect` is technically available, but it should not be treated as an automatic part of Exile from Dynasty.

Verified behavior from `common/scripted_effects/00_interaction_effects.txt` and `common/character_interactions/00_dynast_interactions.txt`:

- It runs in recipient scope with the disinheritor supplied to the scripted effect.
- It adds `disinherited`.
- It adds target/disinheritor, House-member, possible authority-usurpation, rivalry, and heir-related opinion consequences.
- It does not remove claims or change House/Dynasty.
- The normal `disinherit_interaction` requires the actor and target to share a Dynasty and performs authority, culture, hook, renown, and realm validations that the scripted effect does not repeat.

### Correct operation order

If the Boss approves vanilla-style disinheritance, the research-supported order is:

1. Perform all final validations while actor and target still share the original Dynasty.
2. Apply `disinherit_effect` in target scope, reproducing every Breed Improved validation Jay approves rather than assuming the scripted effect enforces the vanilla interaction rules.
3. Apply any approved claim policy while original realm/Dynasty context is still available.
4. Apply the approved affiliation change, with `create_dynasty` currently the leading candidate.
5. Apply an approved political exile last.

This order preserves the dependencies Lynn identified, but the combined sequence is not verified or transactional. If step 4 fails after disinheritance or claim removal, the target remains partially modified.

### Persistence after Dynasty replacement

`disinherited` is a trait defined in `common/traits/00_traits.txt`. No Lynn source demonstrates removing or re-scoping that trait during `create_dynasty`. Persistence is therefore a strong hypothesis, not a verified combined behavior.

Required test:

- Apply `disinherit_effect` while actor and target share the old Dynasty.
- Apply `create_dynasty` to the target.
- Save/reload.
- Confirm whether `disinherited` persists and inspect succession in both the original and replacement Dynasties.

### Risk of blocking inheritance in the replacement Dynasty

The trait property is `inheritance_blocker = dynasty`, not a stored reference to the original Dynasty. It may therefore block Dynasty inheritance in the replacement Dynasty as well. This is not proven until tested, but it is serious enough to block default use.

If the target founds a new Dynasty and the trait blocks the target from inheritance associated with that replacement Dynasty, `disinherit_effect` would overreach the product requirement. Any downstream effect on the replacement Dynasty's succession planning must be observed rather than assumed. Opinion and rivalry effects may also be inappropriate for a utility action.

### Narrower alternatives

- First test whether Dynasty/House replacement alone produces the Boss's intended meaning of “loses Dynasty inheritance relevance.”
- Keep claims as an independent policy rather than using disinheritance as a proxy.
- Do not create a custom inheritance blocker until a target-version CK3 mechanism proves it can be narrower than `inheritance_blocker = dynasty`.
- A custom trait using the same broad blocker would reproduce the same scope problem and would not be a narrower solution.
- If CK3 title succession remains blood/law based after Dynasty replacement, the Boss may need to narrow the product promise rather than approve a global inheritance override.

Technical recommendation:

- Exclude `disinherit_effect` from the first affiliation-only MVP.
- Reconsider it only after the persistence/replacement-Dynasty test and after the Boss decides whether its opinion, rivalry, and broad inheritance consequences are desirable.

## 5. Political exile options

Political exile is optional and technically independent from Dynasty exile.

| Option | Evidence and prerequisites | Expected player-visible behavior | Risks and Phase 1 suitability |
| --- | --- | --- | --- |
| `banish = yes` | Prisoner release in `common/character_interactions/00_prison_interactions.txt` requires imprisonment for that UI flow. Raw use on an unlanded courtier appears in `events/yearly_events/yearly_events_5.txt` without a demonstrated imprisonment prerequisite. No DLC gate is identified in Lynn's cited examples. | Target should leave the acting court/realm in a banishment-like state; exact destination and UI presentation for the Phase 1 target require testing. | Spouses, close family, prisoners, hostages, councillors, and court-position holders may behave unexpectedly. Suitable only as an optional tested consequence for a narrow unlanded class. |
| `move_to_pool = yes` | Verified for unlanded characters in `events/yearly_events/yearly_events_5.txt`, `events/yearly_events/yearly_events_3.txt`, `events/yearly_events/yearly_events_sahara.txt`, and `events/activities/hunt_activity/hunt_events.txt`. No DLC gate is identified in those cited examples. | Removes the character from the current court/context and returns them to the character pool. It may be less visibly punitive than formal banishment. | Safety for highborn relatives and obligated characters is unverified. The target may appear to vanish from court without a clear exile narrative. Optional only after testing. |
| Leave target in current court | Requires no political movement effect. | Target changes lineage but remains physically/politically present at court. | Lowest implementation and compatibility risk. May conflict with the player's ordinary-language expectation of “exile,” so UI must clearly say “Exile from Dynasty,” not realm banishment. Strong baseline candidate. |
| Landless adventurer conversion | `banish_effect` in `common/scripted_effects/07_dlc_ep3_scripted_effects.txt` triggers `ep3_laamps.0021` in `events/dlc/ep3/ep3_laamp_events.txt`; requires `has_ep3_dlc_trigger = yes`. | Can strip titles, create a landless-adventurer title, change government, add `landless_adventurer_succession_law`, and add an unpressed claim to a lost primary title. | EP3/Roads to Power dependent, politically invasive, and may add a claim instead of removing claims. Not suitable as the Phase 1 baseline. |

Technical recommendation:

- Leave the target in the current court in the first affiliation-only MVP unless the Boss explicitly defines political departure as part of the product action.
- If departure is approved, compare `banish = yes` and `move_to_pool = yes` through controlled tests and show the exact consequence in confirmation text.
- Do not use landless adventurer conversion as a generic fallback.

## 6. Proposed controlled test matrix

### Test discipline

- Run on CK3 `1.19.0.6` with recorded DLC, game rules, language, and load order.
- Use a separate, explicitly authorized test-only mod or development branch. Never edit vanilla CK3 files.
- Copy exact constructs and contexts from Lynn's cited vanilla sources. Do not improvise syntax.
- Record character, House, Dynasty, court, titles, claims, traits, marriage, children, and succession state before each action.
- Inspect the first relevant game error and record the actual log path only after verifying it in the environment.
- Save immediately after the action, reload, advance time enough to force state refresh, and inspect the same state again.
- Use a fresh baseline or restored save for each test so results do not contaminate one another.

No test harness is created by this proposal.

### T1. Ordinary highborn unlanded courtier

- **Setup:** Living highborn adult, non-ruler, unlanded, not House Head or Dynasty Head, no special title or court obligation, in the actor's Dynasty and court.
- **Action:** Apply character-scoped `create_dynasty` using a verified vanilla form without optional claim, inheritance, descendant, or political effects.
- **Expected result:** Test hypothesis: target receives a new Dynasty and House, remains alive/highborn/unlanded, leaves the actor's Dynasty, and remains in the current court; claims and family links remain unchanged.
- **Inspect:** House/Dynasty IDs and UI, generated name/arms, court, employer, titles, traits, claims, parents, marriage, relations, succession lists, errors.
- **Save/reload:** Confirm new affiliation and all unchanged state persist after reload and time advance.
- **Pass/fail:** Pass if the target safely receives a stable replacement affiliation with no unrelated mutation. Fail on invalid state, crash/error, no affiliation change, death/imprisonment, or unexplained side effects.

### T2. Married courtier

- **Setup:** T1 target class, married to a character whose House/Dynasty and court are recorded.
- **Action:** Apply the same affiliation-only `create_dynasty` operation to one spouse.
- **Expected result:** Test hypothesis: marriage persists; only the target changes affiliation; spouse, marriage type, court, and relations remain stable.
- **Inspect:** Both spouses' House/Dynasty, marriage, location, court, children, opinion modifiers, succession, claims, UI family links.
- **Save/reload:** Confirm marriage and both affiliations remain stable.
- **Pass/fail:** Pass if only the intended affiliation changes. Fail if marriage breaks, spouse moves unexpectedly, or the spouse/children change without an approved propagation parameter.

### T3. Character with children using descendant propagation

- **Setup:** T1 target with multiple existing children covering available safe variations: unmarried/married and same/different House or realm where practical. Record each descendant's affiliation and status.
- **Action:** Apply the verified `create_dynasty` form with `spread_to_descendants = yes` in a test-only context.
- **Expected result:** Research hypothesis: descendants are moved according to a deterministic rule. The exact coverage is intentionally unknown and must be measured.
- **Inspect:** Every descendant's House/Dynasty, spouse, titles, court/realm, head status, claims, succession, and family-tree display.
- **Save/reload:** Confirm all observed descendant transitions persist and no later automatic spread occurs.
- **Pass/fail:** Technical pass if behavior is deterministic, stable, error-free, and fully characterizable. Product pass requires a separately approved descendant policy; otherwise keep propagation disabled.

### T4. Character with explicit claims

- **Setup:** T1 target with several recorded explicit claims, including at least one connected and one unrelated to the actor's realm when possible.
- **Action:** On separate baseline copies: (A) apply affiliation-only `create_dynasty`; (B) apply the exact verified explicit-claim filter/removal pattern; (C) apply the approved order if Jay later authorizes a combined test.
- **Expected result:** A should retain all claims. B should remove only claims matched by the copied vanilla filter. No result should be attributed to Dynasty change unless observed.
- **Inspect:** Full claim list, claim type/status shown by the game, title holders, realm/de jure relationships, House/Dynasty, errors, UI.
- **Save/reload:** Confirm removed claims remain absent and retained claims remain present.
- **Pass/fail:** Pass if claim changes exactly match the verified filter and unrelated claims survive. Fail on blanket or unexplained removal.

### T5. Character in the line of succession

- **Setup:** T1-like target visibly listed in succession for at least one recorded title; record law, current order, relationship, claims, House, and Dynasty.
- **Action:** Apply affiliation-only `create_dynasty`; do not disinherit or remove claims.
- **Expected result:** No assumption. Measure whether lineage replacement alone changes the target's position and why.
- **Inspect:** Succession order before/after recalculation, title law, claims, family relation, House/Dynasty, heir UI, tooltips, errors.
- **Save/reload:** Recheck after reload and succession recalculation.
- **Pass/fail:** Technical pass if behavior is stable and explainable. Product pass only if the resulting succession behavior matches the Boss's approved definition of inheritance relevance without global rule changes.

### T6. Disinherited character followed by `create_dynasty`

- **Setup:** T1 target eligible for the vanilla-style disinherit sequence; record original Dynasty, House, succession, claims, and opinions.
- **Action:** Apply `disinherit_effect` in the verified recipient context, then apply character-scoped `create_dynasty`.
- **Expected result:** Test hypothesis: `disinherited` persists. Whether it blocks inheritance in the replacement Dynasty is unknown.
- **Inspect:** Trait persistence, old/new House and Dynasty, original and replacement succession, claims, opinions, rivalry state, errors.
- **Save/reload:** Confirm trait and succession behavior after reload and recalculation.
- **Pass/fail:** Pass for inclusion only if the effect has the Boss-approved consequences and does not unintentionally block replacement-Dynasty inheritance. Otherwise exclude it from Exile from Dynasty.

### T7. `create_dynasty` without `spread_to_descendants`

- **Setup:** T1 target with at least one existing child and recorded descendant affiliations.
- **Action:** Apply a verified `create_dynasty` form that omits `spread_to_descendants`.
- **Expected result:** Test hypothesis: only the target changes affiliation. This is not assumed from omission and must be proven.
- **Inspect:** Target and every descendant's House/Dynasty, court, titles, claims, succession, family tree, and errors.
- **Save/reload:** Confirm no descendant changes occur during reload or subsequent time advance.
- **Pass/fail:** Pass if target-only behavior is stable. Fail if descendants change or later propagation occurs unexpectedly.

### T8. Raw `banish = yes`

- **Setup:** Ordinary unlanded non-ruler courtier in the actor's court, first without imprisonment; use separate cases later for approved edge roles.
- **Action:** Apply raw `banish = yes` using the unlanded vanilla context evidenced in `events/yearly_events/yearly_events_5.txt`.
- **Expected result:** Target leaves the current court/realm without Dynasty change, death, automatic imprisonment, title mutation, or adventurer conversion.
- **Inspect:** Location, court/employer, pool/wanderer status shown by the game, imprisonment, House/Dynasty, titles, claims, marriage, relations, errors.
- **Save/reload:** Locate the target and confirm stable political placement after reload.
- **Pass/fail:** Pass if court departure is stable and limited to expected political effects. Fail if the target becomes invalid, unreachable, imprisoned, dead, or otherwise broadly mutated.

### T9. `move_to_pool = yes`

- **Setup:** Same safe unlanded courtier class as T8.
- **Action:** Apply `move_to_pool = yes` using a matching pattern from `events/yearly_events/yearly_events_5.txt` or another cited vanilla event.
- **Expected result:** Target leaves the current court and returns to the character pool; Dynasty affiliation remains unchanged.
- **Inspect:** Court, location, availability, House/Dynasty, marriage/family links, claims, titles, obligations, errors.
- **Save/reload:** Confirm the target remains valid and discoverable after reload.
- **Pass/fail:** Pass if court removal is stable and limited. Fail if character state is lost, relationships break, or unrelated state changes.

### T10. Assignment to an existing outside House

- **Setup:** T1 target plus a safe destination House belonging to a different Dynasty; record destination membership and leadership.
- **Action:** Apply `set_house` using an exact cross-Dynasty vanilla call pattern supplied by research.
- **Expected result:** Target joins the destination House/Dynasty; no other character changes affiliation.
- **Inspect:** Source and destination membership, House/Dynasty heads, descendants, marriage, court, claims, succession, UI, errors.
- **Save/reload:** Confirm stable reassignment and unchanged unrelated members.
- **Pass/fail:** Pass if target-only reassignment is stable and destination invariants remain valid. Fail if propagation or leadership changes are unexplained.

### T11. Existing highborn converted to lowborn

- **Setup:** T1 target with recorded marriage, children, claims, and succession relevance.
- **Action:** Apply `set_to_lowborn = yes` using the closest matching vanilla existing-character context.
- **Expected result:** Target becomes lowborn and loses noble affiliation; all additional consequences are observations, not assumptions.
- **Inspect:** House/Dynasty, lowborn presentation, name/history, marriage, children, titles, claims, succession, prestige, court, errors.
- **Save/reload:** Confirm status and all observed consequences persist.
- **Pass/fail:** Technical pass if state is valid and fully characterized. Product pass requires explicit Boss approval of every broader consequence.

### T12. Minimal combined transaction

- **Setup:** A target that passed T1 and any separately approved claim, inheritance, and political tests.
- **Action:** Execute the proposed final order with only Boss-approved modules.
- **Expected result:** Each approved consequence occurs once; no unapproved state changes occur.
- **Inspect:** Every pre-recorded category plus operation-specific results and errors after each observable stage.
- **Save/reload:** Confirm the complete final state remains stable.
- **Pass/fail:** Pass only if the whole sequence succeeds repeatedly without partial results. Any partial mutation blocks release and requires narrowing or redesign.

## 7. Recommended Phase 1 architecture

### Recommendation: staged, affiliation-first delivery

Recommend that Jay and the Boss approve a narrower first implementation:

1. Prove one Character Interaction for one living, highborn, non-ruler, unlanded, non-leadership target.
2. Use one approved affiliation strategy, preferably replacement Dynasty creation if T1 and T7 pass.
3. Keep descendants unchanged, omit disinheritance, remove no claims, and leave the target in the current court for the first implementation.
4. Add optional consequences only after their independent tests pass.
5. Build the player-initiated Dynasty Decision as a second interface after the candidate enumeration, preview, selection, and repeated-operation behavior are verified.

This staging preserves the confirmed two-interface direction without treating the unverified bulk UI and combined transaction as already approved.

### Character Interaction structure

Planning identifiers below follow the `breedimp_` convention but are not vanilla syntax.

`UNVERIFIED CK3 SYNTAX:` The declaration forms, call forms, parameters, and scope contracts for these project-owned wrappers have not yet been validated. Their names are architecture labels only.

- Proposed interaction ID: `breedimp_exile_from_dynasty_interaction`.
- Actor: the player character with the Boss-approved authority over the managed Dynasty.
- Recipient: one tested candidate currently in that Dynasty.
- Visibility should use cheap, side-effect-free identity and relationship checks.
- Availability should call the shared final eligibility rule and present exact failure reasons.
- Confirmation must name the target and describe the selected affiliation, descendant, claim, inheritance, and political consequences.
- The effect path must revalidate immediately before mutation and call one shared exile effect.
- No yearly action, background event, delayed event, pulse, or automatic scan is allowed.

Exact interaction fields, scope wiring, confirmation fields, and localisation suffixes must be copied from target-version vanilla patterns; the proposal does not define them.

### Validation triggers

Proposed project definitions:

- `breedimp_is_dynasty_exile_candidate`: complete side-effect-free actor/target eligibility.
- `breedimp_has_dynasty_exile_reason`: approved bastard or parent-dynasty reason.
- `breedimp_can_exile_dynasty_member_now`: final state guard immediately before mutation.
- Optional policy-specific triggers for claims or political exile only after those policies are approved.

Required validation categories:

- Actor authority and managed-Dynasty identity.
- Target alive/current membership state.
- Approved candidate reason using actual target-version keys, never save numeric IDs.
- Tested target class: ruler/landed/head/special-title/obligation exclusions.
- Descendant, marriage, imprisonment, hostage, councillor, and court-position safeguards selected by the Boss.
- Prevention of self-targeting or targeting another player where applicable.
- Idempotency: target has not already left the managed Dynasty.

The exact trigger tokens and scope links must be taken from Lynn's references and entered into the syntax registry before coding.

### Scripted effects

Proposed project definitions:

- `breedimp_exile_dynasty_member`: one final, approved affiliation operation.
- `breedimp_apply_approved_claim_policy`: optional and policy-specific; omit from the first implementation.
- `breedimp_apply_approved_political_exile`: optional; omit from the first implementation.

`breedimp_exile_dynasty_member` should not dynamically choose among replacement Dynasty, outside House, and lowborn conversion. Jay should approve one strategy so the effect has one predictable contract.

If later composition is approved, use the research-supported order: final validation, optional disinheritance, optional claim removal, affiliation change, optional political exile. The combined effect remains blocked until T12 passes.

### Confirmation flow

- Player explicitly opens the interaction or Dynasty management flow.
- The UI computes and displays current eligibility without mutation.
- The UI states whether descendants move, whether claims change, whether inheritance blocking applies, and whether the target leaves court.
- The player confirms the exact consequences.
- The script performs final validation again.
- If validation fails, no state-changing effect runs.
- If validation passes, the single approved state transition runs.
- The player receives a success or failure result appropriate to verified CK3 UI patterns.

Bulk confirmation must preview every selected target and policy consequence. If CK3 cannot provide a safe native multi-selection/preview flow, the Dynasty Decision should initially open a read-only candidate-management flow or process one confirmed target at a time rather than silently mutating every eligible member.

### Logging and debug support

- Do not invent a CK3 logging command. Verify the target-version debug/log mechanism before adding script instrumentation.
- For controlled tests, record before/after character, House, Dynasty, claims, traits, succession, court, and descendant state through verified UI, save inspection, and actual game logs.
- Keep any future debug-only interaction or test harness outside production feature files and behind an explicit development-only condition verified from vanilla.
- Never ship background diagnostic events or recurring scans.
- Record test case ID and result in project documentation even if in-game logging is unavailable.

### Safeguards against partial execution

- Keep the first implementation to one affiliation mutation after final validation.
- Resolve every scope, target, destination, and optional policy before the first state change.
- Do not perform candidate discovery, user selection, or uncertain lookups after mutation begins.
- Do not apply disinheritance or claims first unless the subsequent affiliation change has already passed isolated and combined tests.
- Exclude targets whose edge-case state has not been tested.
- Revalidate all selected bulk targets immediately before execution.
- Do not imply atomicity. If CK3 provides no rollback, either process one explicitly confirmed target at a time or design clear partial-result reporting before bulk mutation is approved.
- Preserve original actor/realm context for any approved claim filter using the exact vanilla scope pattern.

### Localisation and UI requirements

Required player-facing content:

- Interaction name: “Exile from Dynasty.”
- Description distinguishing lineage exile from realm banishment, imprisonment, landlessness, and death.
- Eligibility reasons and clear failure messages.
- Confirmation title/body naming the target and managed Dynasty.
- Explicit lines for replacement affiliation, descendant policy, claim policy, inheritance policy, and court policy.
- Warning for irreversible or high-impact consequences.
- Success/failure result text.
- For bulk management: candidate count, selected targets, per-target exclusions, and partial-failure policy.

All localisation keys must use `breedimp_`. Required CK3 key suffixes, dynamic character/Dynasty expressions, encoding, BOM, and file format must be copied from verified CK3 `1.19.0.6` examples rather than guessed.

## 8. Decisions required from the Boss

Only product choices are listed here; testable engine behavior remains in the test matrix.

| Decision | Available options | Matt's recommendation | Important consequences |
| --- | --- | --- | --- |
| Core exile outcome | New replacement Dynasty; assignment to a defined outside House; lowborn conversion | Replacement Dynasty for the narrow first implementation, conditional on T1/T7 | Preserves highborn identity and avoids inserting the target into an unrelated House, but may create many small Dynasties and generated UI data. |
| First-release target class | Narrow unlanded non-ruler/non-head class; broader family/court class; landed and leadership cases | Start narrow and expand only after specific tests | Narrow scope reduces corruption and compatibility risk but excludes some desired targets initially. |
| Descendant policy | Target only; all descendants; selected descendants; policy choice per action | Target only for the first implementation, conditional on T7 | Propagation can restructure unrelated Houses, marriages, heirs, and realms. |
| Claim policy | All; explicit only; actor-realm connected; none; separate optional consequence | No claims by default, with an optional policy considered later | Safest technically but exiled characters retain political claims. No lineage-provenance filter is verified. |
| Inheritance policy | Use `disinherit_effect`; rely on affiliation change; pursue a narrower verified solution later | Omit `disinherit_effect` until T6 and product review | Avoids broad replacement-Dynasty blocking and vanilla opinion/rivalry side effects, but title succession may remain. |
| Political/court policy | Leave in court; raw `banish`; `move_to_pool`; EP3 adventurer conversion | Leave in current court for the affiliation MVP | Keeps lineage and political exile separate. The word “exile” must be explained clearly to avoid misleading players. |
| Replacement identity | Vanilla-generated name/arms; fixed project-owned identity; player-selected identity | Use the least customized verified behavior for testing, then choose after UI review | Fixed or selected identity adds localisation, coat-of-arms, uniqueness, and bulk-management requirements. |
| Bulk interface release boundary | Ship with individual interaction; follow after individual MVP; read-only candidate decision first | Stage it after the individual path, beginning with preview/read-only behavior | Preserves the confirmed second interface while avoiding unverified native multi-select and repeated Dynasty creation in the first release. |
| Failure policy for future bulk execution | All-or-nothing; skip invalid targets; stop on first failure; one target per confirmation | One target per confirmation until rollback/partial reporting is proven | Slower for large Dynasties but prevents silent partial cleanup. |

## 9. Remaining Lynn research requests

The following questions require additional CK3 `1.19.0.6` vanilla-file research rather than technical reasoning or runtime testing:

1. **Exact `every_dynasty_member` evidence.** Provide the precise vanilla file path, enclosing block, input/output scope behavior, supported filtering context, and at least one same-version caller. Lynn's summary marks the iterator verified but does not include its source pointer.
2. **Native bulk-selection and preview patterns.** Search for a CK3 `1.19.0.6` decision, interaction, event, or verified GUI flow that lets a player review eligible characters, select multiple arbitrary targets, confirm the set, and report partial invalidation. If none is found, document the search coverage rather than inferring support.
3. **Exact Character Interaction confirmation pattern.** Extract the relevant confirmation, recipient-scope, failure-message, and localisation pattern from `common/character_interactions/00_dynast_interactions.txt` or a closer same-version interaction so Matt can implement the individual confirmation without guessing fields or suffixes.
4. **Cross-Dynasty `set_house` call context.** From the already cited `set_house` sources, provide an exact example that moves an existing highborn character into a House belonging to a different Dynasty, including the character and destination scopes and whether descendant movement is separate.

Do not return the following to Lynn; they are controlled-test questions already covered by Section 6:

- Default behavior when `spread_to_descendants` is omitted.
- `disinherited` persistence and replacement-Dynasty inheritance effects.
- Arbitrary-target behavior of `create_dynasty`, `set_to_lowborn`, `banish`, or `move_to_pool`.
- Combined-operation order, save persistence, and partial execution.
- Player-facing claim, descendant, inheritance, and political-exile policies.
