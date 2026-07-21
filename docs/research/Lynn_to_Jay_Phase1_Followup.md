# Breed Improved Phase 1 - Focused Vanilla Follow-up

Research handoff from Lynn to Jay. Scope: a living, non-ruler unlanded character is disinherited, loses approved claims, receives a replacement Dynasty, and may then leave the player's court. This document reports vanilla evidence only.

## Status summary

| Proposed operation | Status | Main finding |
|---|---|---|
| Create a replacement Dynasty | **REQUIRES IN-GAME TESTING** | `create_dynasty` is verified, including on existing characters, but the exact proposed case—an arbitrary existing highborn unlanded target—is not demonstrated in vanilla. |
| Automatic House creation | **VERIFIED** | Vanilla accesses the character's `house` immediately after `create_dynasty`. |
| Disinherit the target | **VERIFIED** | `disinherit_effect` is a scripted effect and is called in recipient scope by the vanilla Dynasty interaction. |
| Remove all claims | **VERIFIED** | Vanilla directly removes claims while iterating `every_claim`. The definition of “relevant claims” remains a design question. |
| Make an unlanded courtier leave | **VERIFIED, WITH RISKS** | Vanilla uses both `banish = yes` and `move_to_pool = yes` on unlanded courtiers. Edge cases require testing. |
| Convert the target into a landless adventurer | **NOT SUITABLE AS BASELINE** | The verified flow is EP3/Roads to Power dependent and adds government, title, succession, and claim behavior. |

## 1. `create_dynasty`

### Exact verified syntax and scope

**VERIFIED:** `create_dynasty` is an effect used in **character scope**.

Verified forms include:

```text
create_dynasty = {
	spread_to_descendants = yes
}
```

```text
create_dynasty = {
	name = dynn_Minamoto
	coat_of_arms = japanese_minamoto_seiwa
	spread_to_descendants = yes
	save_scope_as = new_dynasty
}
```

```text
create_dynasty = { save_scope_as = new_dynasty }
```

Verified parameters from these examples:

- `name`
- `coat_of_arms`
- `spread_to_descendants = yes`
- `save_scope_as`

Relevant files:

- `common/scripted_effects/00_accolades_scripted_effects.txt`
- `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`
- `events/dlc/tgp/tgp_japan_decision_events.txt`
- `events/dlc/tgp/tgp_mandala_task_contract_events.txt`

No verified syntax was found for passing a target inside the effect. Vanilla first enters the intended character's scope and then calls `create_dynasty`.

### Use on existing characters

**VERIFIED:** Vanilla uses `create_dynasty` on existing characters in Japanese decision/effect flows. The decision tooltip describes the operation as “Change Dynasty.”

**VERIFIED:** One Japanese trigger permits creation when the character is neither the current Dynast nor House Head and the current Dynast uses an administrative government:

- `common/scripted_triggers/10_tgp_japan_triggers.txt`
- `tgp_japan_cadet_creates_dynasty_trigger`

The surrounding Japanese decision is for an existing landed governor and has many additional government, title, domicile, and descendant restrictions.

**VERIFIED:** Lowborn existing/created characters also receive a Dynasty through `create_dynasty` in accolade and Mandala flows.

**REQUIRES IN-GAME TESTING:** No inspected vanilla example applies `create_dynasty` to the exact Phase 1 target type: an arbitrary existing highborn, non-ruler, unlanded member of another character's Dynasty.

Conclusion: the effect itself and existing-character use are verified, but the proposed general-purpose target class is not yet safe to approve without a controlled test.

### Automatic House creation and assignment

**VERIFIED:** After `create_dynasty`, vanilla immediately enters the same character's `house` scope to save or rename the House:

- `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`
- `events/dlc/tgp/tgp_japan_decision_events.txt`

This is direct evidence that the character has a House associated with the newly created Dynasty after the effect.

**REQUIRES IN-GAME TESTING:** The exact generated House name, coat of arms, founder/history data, and UI refresh behavior for an arbitrary Phase 1 target are not established by these examples.

### Target versus descendants

**VERIFIED:** Vanilla explicitly uses `spread_to_descendants = yes` when descendants should receive the new affiliation.

**VERIFIED:** The Japanese scripted effect also calls `create_dynasty` without `spread_to_descendants`, proving the parameter is optional.

**NOT VERIFIED:** The inspected files do not explicitly document the default descendant behavior when `spread_to_descendants` is omitted. It is tempting to infer “target only,” but that must be confirmed in game.

**REQUIRES IN-GAME TESTING:** With `spread_to_descendants = yes`, the exact treatment of:

- existing children in another House,
- married children,
- landed descendants,
- descendants in another realm,
- descendants who are House Heads,

is not demonstrated by the inspected examples.

For comparison, `japan_set_house_effect` uses a separate scripted effect to move descendants recursively when changing to an existing House. That flow should not be assumed to describe `create_dynasty` internals.

### Known restrictions and edge cases

**VERIFIED vanilla restrictions in the Japanese flow:**

- The character is not the current Dynast.
- The character is not the current House Head when the new-Dynasty branch is used.
- The decision blocks cases involving direct descendants who are governors, regents, or lieges.
- The flow is written for a landed governor and also changes government and noble-family state.

These restrictions belong to that vanilla feature; they are not proven engine requirements for `create_dynasty`.

**REQUIRES IN-GAME TESTING:**

- Current House Head.
- Current Dynasty Head.
- Last member of a House.
- Spouse of the player or another ruler.
- Parent with existing children.
- Prisoner, hostage, councillor, or court-position holder.
- Landless adventurer or administrative-family member.
- Character holding any special or non-landed title.

The proposed MVP should not treat these categories as safe until tested.

## 2. Inheritance handling

### Exact `disinherit_effect` behavior

**VERIFIED:** `disinherit_effect` is defined in:

- `common/scripted_effects/00_interaction_effects.txt`

Verified call form:

```text
disinherit_effect = { DISINHERITOR = scope:actor }
```

The effect is run in the target character's scope. Its verified behavior is:

- Adds trait `disinherited`.
- Adds `disinherited_opinion` toward `$DISINHERITOR$`.
- Applies House-member opinion consequences.
- May apply an authority-usurpation opinion from the Dynast when the disinheritor is not the Dynast.
- May create a potential rivalry.
- Applies extra courtly-vassal opinion effects when the target is an heir of the disinheritor.

The trait is defined in `common/traits/00_traits.txt` with:

```text
inheritance_blocker = dynasty
```

`disinherit_effect` does not remove claims, change House, change Dynasty, or politically banish the character.

### Vanilla interaction requirements

**VERIFIED:** `common/character_interactions/00_dynast_interactions.txt` defines `disinherit_interaction` and calls `disinherit_effect` in `scope:recipient`.

The normal interaction requires, among other checks:

- Actor is `is_dynast = yes`.
- Actor and recipient have the same Dynasty.
- Recipient does not already have `disinherited`.
- The actor's culture does not prohibit disinheritance.
- The recipient does not have a strong hook on the actor.
- Renown and same-realm checks apply in specified cases.

The scripted effect itself does not repeat all of these interaction validations. Vanilla events sometimes call the effect directly after their own event-specific selection logic.

### Must it occur before Dynasty replacement?

**VERIFIED dependency:** The vanilla interaction is no longer valid once actor and recipient are in different Dynasties, because same-Dynasty membership is part of `is_shown`.

**VERIFIED dependency:** `disinherit_effect` reads the target's current House and Dynasty while applying opinion consequences.

**Research recommendation:** If Jay requires vanilla-style disinheritance from the original managed Dynasty, it should occur before `create_dynasty`.

**NOT VERIFIED:** There is no vanilla sequence combining `disinherit_effect` and `create_dynasty` on the same character. The persistence and precise succession consequences of the `disinherited` trait after the target enters a replacement Dynasty require in-game testing. Because the trait says `inheritance_blocker = dynasty`, it may continue to affect inheritance associated with the replacement Dynasty rather than recording only the original Dynasty.

### Use from a Character Interaction

**VERIFIED:** Vanilla's `disinherit_interaction` calls the effect directly on its recipient. This is an exact vanilla example of the intended call context.

## 3. Claim removal

### Enumerating all claims held by one character

**VERIFIED:** In character scope, vanilla uses:

```text
every_claim = {
	...
}
```

Relevant files:

- `common/scripted_effects/05_dlc_fp3_scripted_effects.txt`
- `common/character_interactions/00_prison_interactions.txt`
- `events/interaction_events/character_interaction_events.txt`
- `events/yearly_events/bp1_yearly_james.txt`

The FP3 effect is explicitly commented as making involved rulers “lose all their claims” and performs `remove_claim` inside `every_claim`.

### Removing during iteration

**VERIFIED:** Vanilla directly removes each iterated claim:

```text
every_claim = {
	scope:claim_loser = { remove_claim = prev }
}
```

This is verified evidence that removal during `every_claim` iteration is a supported vanilla pattern.

The outer character is saved as `claim_loser` because `every_claim` changes the current scope to the title/claim target. Correct scope preservation is important.

### Verified claim filters

**VERIFIED:** Vanilla examples filter claims using:

- `explicit = yes`
- `pressed = yes`
- `pressed = no`
- current title holder
- holder's liege relationship
- actor's de jure title hierarchy

The prisoner-release flow removes only explicit claims relevant to the actor's realm and de jure hierarchy rather than every claim worldwide.

**NOT VERIFIED:** No inspected example exposes a claim-provenance field meaning “this claim came from the old Dynasty/lineage.” Claims should not be assumed to carry a filterable lineage origin.

**NOT VERIFIED:** Although claims iterate in title scope, the inspected `every_claim` removal examples do not demonstrate a general title-type or title-tier filter for this operation. Such filtering requires separate vanilla evidence or in-game validation before approval.

### Claim-removal risks

- **VERIFIED:** “All claims” and “explicit claims only” are different vanilla patterns.
- **REQUIRES DESIGN DECISION:** Jay must define whether “relevant claims” means all claims, explicit claims, claims inside the player's realm, claims held by the player, or claims in the player's de jure hierarchy.
- **REQUIRES IN-GAME TESTING:** Inclusion and behavior of implicit claims when using an unrestricted `every_claim` loop.
- **VERIFIED:** Removing claims is independent of changing Dynasty. `create_dynasty` must not be assumed to remove them.

## 4. Political exile

Political exile remains separate from Dynasty replacement.

### `banish = yes`

**VERIFIED:** `common/character_interactions/00_prison_interactions.txt` uses `banish = yes` for an unlanded non-adventurer prisoner during `release_from_prison_interaction`.

**VERIFIED:** Imprisonment is a prerequisite for that particular Character Interaction and its banishment release option.

**VERIFIED:** The raw effect is not universally restricted to prisoners in vanilla script. `events/yearly_events/yearly_events_5.txt` applies `banish = yes` directly to an unlanded courtier, with the comment that the landed-character `banish_effect` is not used for unlanded characters.

Therefore:

- The standard prisoner UI flow requires imprisonment.
- The raw `banish` effect is also used by vanilla event logic on unlanded courtiers without a demonstrated imprisonment prerequisite.

**REQUIRES IN-GAME TESTING:** Direct use on the proposed arbitrary target, especially spouses, close family, prisoners, hostages, councillors, or court-position holders.

### `move_to_pool = yes`

**VERIFIED:** Vanilla uses `move_to_pool = yes` to remove unlanded characters from the current context/court and return them to the character pool.

Examples include:

- `events/yearly_events/yearly_events_5.txt`
- `events/yearly_events/yearly_events_3.txt`
- `events/yearly_events/yearly_events_sahara.txt`
- `events/activities/hunt_activity/hunt_events.txt`

In `yearly_events_5.txt`, the same courtier-removal choice uses `banish = yes` when the acting character is landed and `move_to_pool = yes` otherwise.

**REQUIRES IN-GAME TESTING:** Whether `move_to_pool` is safe for all highborn Dynasty members and whether it produces the desired realm departure, rather than only removing court affiliation. Player characters, rulers, spouses, close family, prisoners, and characters with obligations should be excluded until verified.

### Landless adventurer conversion

**VERIFIED:** `banish_effect` in `common/scripted_effects/07_dlc_ep3_scripted_effects.txt` triggers `ep3_laamps.0021` in `events/dlc/ep3/ep3_laamp_events.txt`.

The event requires `has_ep3_dlc_trigger = yes` and can:

- strip landed titles,
- create a landless-adventurer title,
- change government,
- add `landless_adventurer_succession_law`,
- add an unpressed claim to a lost primary title.

**VERIFIED:** This is Roads to Power/EP3-dependent behavior.

**NOT SUITABLE for the proposed MVP:** It is designed for eligible landed or administrative characters continuing as adventurers after banishment. It adds political and succession state unrelated to simple court departure and may add a claim instead of removing claims.

## 5. Recommended operation order

The following is the safest research-supported order, not a fully verified combined vanilla sequence.

### 1. Final validation

**VERIFIED basis:** Vanilla interactions validate immediately before applying their effects.

Reconfirm the approved target state immediately before mutation:

- alive,
- non-ruler and unlanded,
- still in the actor's managed Dynasty,
- actor still has the required Dynasty authority,
- target is not already `disinherited`,
- target is not a House Head or Dynasty Head unless those cases have passed testing,
- target still satisfies any court-membership requirement for political exile.

The exact Breed Improved validation set is a design decision, but validation before mutation is the verified vanilla pattern.

### 2. Disinheritance

**VERIFIED rationale:** The vanilla interaction requires actor and recipient to share a Dynasty, and `disinherit_effect` reads current House/Dynasty state for consequences.

Apply before replacement-Dynasty creation if this consequence remains in Jay's approved design.

### 3. Claim removal

**VERIFIED rationale:** `every_claim` plus `remove_claim` is supported, including direct removal during iteration.

Perform while the target and actor still have their original realm/Dynasty context if the approved claim filter depends on holder, realm, or de jure relationships. Claim removal itself is independent of Dynasty creation.

### 4. Replacement Dynasty creation

**REQUIRES IN-GAME TESTING:** Call only after the target's original-Dynasty validation and disinheritance are complete. Confirm after the operation that the target has a new Dynasty and House and is no longer in the player's Dynasty.

Do not enable descendant propagation until its behavior is separately verified.

### 5. Political exile

**VERIFIED rationale:** Both `banish = yes` and `move_to_pool = yes` can change court/political placement. These should occur last so earlier steps retain reliable access to the target's original court, realm, House, and Dynasty context.

**REQUIRES IN-GAME TESTING:** Choose between `banish` and `move_to_pool` only after testing the intended target class. Do not use the landless-adventurer flow as the baseline.

## Approval boundary for Jay

### VERIFIED

- Character-scoped `create_dynasty` syntax and the listed parameters.
- A new House exists after successful Dynasty creation in the verified Japanese flows.
- `disinherit_effect` definition and direct recipient-scope use from a Character Interaction.
- `every_claim` enumeration and `remove_claim` during iteration.
- Filtering explicit, pressed, unpressed, realm-related, and de jure-related claims in verified examples.
- Direct unlanded-courtier uses of `banish = yes` and `move_to_pool = yes`.
- EP3 dependency and side effects of the landless-adventurer banishment flow.

### REQUIRES IN-GAME TESTING

- `create_dynasty` on an arbitrary existing highborn unlanded target.
- Default descendant behavior when `spread_to_descendants` is omitted.
- Persistence and scope of `disinherited` after the target changes Dynasty.
- Exact implicit-claim behavior in an unrestricted `every_claim` removal.
- Political exile of spouses, children, close relatives, prisoners, hostages, councillors, and court-position holders.
- House/Dynasty Head and special-title edge cases.
- The complete combined operation and proposed order as one transaction.

### NOT VERIFIED

- A dedicated effect for removing Dynasty affiliation without replacement.
- A highborn character remaining House-less and Dynasty-less.
- Claim filtering by the Dynasty or lineage from which a claim originated.
- A verified general title-type filter inside the inspected claim-removal loops.
- Any guarantee that `create_dynasty` alone moves only the target when `spread_to_descendants` is omitted.
- Political exile automatically following Dynasty replacement.
- Any syntax not quoted from the referenced vanilla files.
