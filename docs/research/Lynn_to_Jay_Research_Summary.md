# Breed Improved - Vanilla Research Summary

Research handoff from Lynn (CK3ModResearcher) to Jay (CK3ModLeader). This summary covers verified vanilla behavior relevant to design decisions before work is assigned to Matt.

## 1. Confirmed Vanilla Findings

### House assignment changes character affiliation

- **Mechanic:** Vanilla assigns a character to an existing House with `set_house`. It is used for adoption, legitimization, historical choices, parentage-related changes, and Japanese House restructuring.
- **Files:**
  - `events/bookmark_events.txt`
  - `common/scripted_effects/00_bastard_effects.txt`
  - `common/scripted_effects/05_dlc_bp2_effects.txt`
  - `events/interaction_events/bastard_interaction_events.txt`
  - `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`
- **Verified identifier:** `set_house`
- **Why it matters:** A character can be moved to a valid House. Since Houses belong to Dynasties, vanilla examples treat House assignment as supplying the character's dynastic affiliation as well.

### Vanilla can create a new Dynasty for a character

- **Mechanic:** `create_dynasty` is used in character scope, including flows that save the new Dynasty and then access the character's resulting House.
- **Files:**
  - `common/scripted_effects/00_accolades_scripted_effects.txt`
  - `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`
  - `events/dlc/tgp/tgp_japan_decision_events.txt`
- **Verified identifier:** `create_dynasty`
- **Why it matters:** Vanilla provides a verified way to give a character a replacement Dynasty/House affiliation rather than leaving them in the managed Dynasty.

### Vanilla can create a cadet House

- **Mechanic:** A scoped character can found a cadet branch, producing a new House within the existing Dynasty.
- **Files:**
  - `common/decisions/00_dynasty_decisions.txt`
  - `common/scripted_effects/00_decisions_effects.txt`
- **Verified identifier:** `create_cadet_branch`
- **Why it matters:** This supports House separation, but not Dynasty separation. Cadet Houses remain in the original Dynasty.

### Vanilla represents absent noble affiliation as lowborn

- **Mechanic:** Vanilla uses `set_to_lowborn = yes`; character creation can also specify `dynasty = none`.
- **Files:**
  - `common/scripted_effects/00_bastard_effects.txt`
  - `events/travel_events/travel_events_james.txt`
  - `events/dlc/tgp/tgp_tai_migration_events.txt`
- **Verified identifiers:** `set_to_lowborn`, creation field `dynasty = none`
- **Why it matters:** Dynasty-less creation and lowborn conversion exist, but lowborn status is broader than removal from a managed lineage.

### Banishment and Dynasty membership are separate systems

- **Mechanic:** Unlanded banishment uses `banish = yes`. Landed banishment can remove titles and optionally convert the character into a landless adventurer.
- **Files:**
  - `common/character_interactions/00_prison_interactions.txt`
  - `common/scripted_effects/07_dlc_ep3_scripted_effects.txt`
  - `events/dlc/ep3/ep3_laamp_events.txt`
  - `common/scripted_triggers/00_laamp_triggers.txt`
- **Verified identifiers:** `banish`, `banish_effect`, `ep3_laamps.0021`, `is_laamp_exiled_from_province_trigger`
- **Why it matters:** The verified banishment paths do not change House or Dynasty. Realm exile must not be treated as “Exile from Dynasty.”

### Claims are changed independently

- **Mechanic:** Vanilla removes a specified claim with `remove_claim`. It can add pressed or unpressed claims separately. Prison release can iterate selected claims for renunciation.
- **Files:**
  - `common/scripted_effects/00_title_effects.txt`
  - `common/character_interactions/00_prison_interactions.txt`
  - `events/activities/funeral_activity/funeral_events.txt`
- **Verified identifiers:** `remove_claim`, `add_pressed_claim`, `add_unpressed_claim`, `make_claim_weak`
- **Why it matters:** Changing Dynasty affiliation must not be assumed to remove claims. Claim policy is a separate design decision.

### Inheritance can be blocked without changing Dynasty

- **Mechanic:** The `disinherited` trait uses `inheritance_blocker = dynasty`. The `gallivanter` and `bastard` traits use broader inheritance blockers.
- **Files:**
  - `common/traits/00_traits.txt`
  - `common/character_interactions/00_dynast_interactions.txt`
  - `common/decisions/dlc_decisions/ep_3/06_ep3_laamp_decisions.txt`
- **Verified identifiers:** `disinherit_effect`, `restore_inheritance_effect`, `inheritance_blocker`, `claim_inheritance_blocker`; traits `disinherited`, `gallivanter`, `bastard`
- **Why it matters:** Disinheritance is not Dynasty removal. It changes inheritance while the character remains a Dynasty member.

### Parentage is separate from House and Dynasty

- **Mechanic:** Legal parents, biological father, and House can be read or changed independently.
- **Files:**
  - `common/scripted_triggers/00_family_triggers.txt`
  - `common/scripted_triggers/00_bastard_triggers.txt`
  - `common/scripted_effects/00_secret_effects.txt`
  - `events/birth_events.txt`
- **Verified identifiers:** `father`, `mother`, `real_father`, `set_father`, `set_mother`, `set_real_father`, `is_parent_of`, `is_child_of`
- **Why it matters:** Moving a character out of a Dynasty does not mean blood relationships or parentage disappear.

## 2. Relevant to Phase 1: Exile from Dynasty

### Directly supported by vanilla

- A player-triggered Character Interaction can handle an individual target.
- A player-triggered Decision can provide a separate confirmed management action.
- `set_house` can assign a target to a valid House.
- `create_dynasty` can give a target a replacement Dynasty and House.
- `every_dynasty_member` provides verified Dynasty-member iteration.
- Claims can be removed individually, but only as a separate explicit consequence.
- Inheritance can be blocked with verified trait mechanics, but that is separate from membership.
- None of these capabilities requires a yearly scan or automatic maintenance event.

### Possible but not confirmed

- **UNVERIFIED:** Calling `create_dynasty` repeatedly for multiple selected members in one bulk Decision.
- **UNVERIFIED:** The exact effects of moving complex established characters, including rulers, House Heads, Dynasty Heads, and characters with noble-family titles.
- **UNVERIFIED:** A standard Dynasty Decision providing a native multi-character selection or complete preview interface.
- **UNVERIFIED:** The exact behavior of `spread_to_descendants` for existing descendants in mixed Houses or realms.
- **UNVERIFIED:** Converting an established Dynasty member to lowborn without unwanted effects on titles, claims, marriage value, history, or succession.

### Not supported by current evidence

- No verified `set_dynasty`, `remove_dynasty`, or `remove_house` effect was found.
- No verified `set_house = none` usage was found.
- No generic standalone `create_house` effect was found; verified House creation is through `create_cadet_branch` or a new Dynasty.
- No verified highborn state with neither House nor Dynasty was found.
- Banishment, landlessness, disinheritance, and cadet-branch creation do not independently remove a character from their Dynasty.

## 3. Technical Risks and Research Blockers

- **Replacement affiliation:** Jay must decide whether separation means a new Dynasty per target, assignment to an existing House, or another explicitly defined outcome.
- **Highborn Dynasty-less state:** Not verified. The confirmed alternatives are replacement affiliation or lowborn conversion.
- **Leadership cases:** Effects on a current House Head, Dynasty Head, or last House member have not been verified.
- **Descendants:** Whether children and later descendants move with the target is unresolved. Broad propagation risks altering unrelated Houses, heirs, and realms.
- **Titles and succession:** Dynasty-sensitive succession may recalculate after affiliation changes. Exact outcomes for landed targets require testing.
- **Claims:** Claims are separate state and are not shown to disappear after House/Dynasty reassignment.
- **Inheritance:** Disinheritance and general inheritance blockers are separate mechanics. Whether Breed Improved should apply them is a design decision, not an automatic consequence.
- **Bulk processing:** Member iteration is verified, but safe repeated Dynasty creation, stable filtering, and player-readable preview remain unverified.
- **UI presentation:** Family and Dynasty-tree views may continue to show biological links across separate Dynasties; runtime presentation has not been tested.

## 4. Recommendations for Jay

- Design around the verified concept of **replacement affiliation**, not a highborn House-less character.
- Treat “Exile from Dynasty” as distinct from realm banishment, landlessness, disinheritance, and claim removal.
- Use individual, player-confirmed management as the safest first design target.
- Keep claims, parentage, political status, and inheritance consequences separate unless Jay explicitly approves them as additional outcomes.
- Do not use cadet-branch creation when the design requires leaving the Dynasty.
- Require in-game testing before approving bulk Dynasty creation, descendant propagation, lowborn conversion, or use on leadership and landed edge cases.
- If bulk management remains required for Phase 1, define the player-selection and preview rules before assigning implementation work.

## 5. Important Warnings

- Do not assume `banish` means removal from a Dynasty; verified vanilla behavior does not support that.
- Do not assume `disinherited` removes Dynasty membership; it applies a Dynasty inheritance blocker.
- Do not assume a cadet House is a new Dynasty.
- Do not assume House/Dynasty reassignment removes claims, parentage, marriages, relationships, titles, or ruler legitimacy.
- Do not assume lowborn conversion is a harmless synonym for Dynasty exile.
- The following syntax is **UNVERIFIED and must not be used as established CK3 syntax:** `set_dynasty`, `remove_dynasty`, `remove_house`, `set_house = none`, and generic `create_house`.
- `dynasty = none` is verified inside character creation. It is not verified as a general effect for changing an existing character.
- Save-game numeric IDs are data references for a particular save, not valid reusable script identifiers.
- Absence of a vanilla example does not prove an engine capability is impossible; it means the capability is not approved for implementation without further evidence or controlled testing.
