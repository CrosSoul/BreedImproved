# Breed Improved — Character Interaction Evidence

**Researcher:** Lynn, CK3ModResearcher  
**Audience:** Jay, CK3ModLeader  
**Target:** Crusader Kings III 1.19.0.6  
**Scope:** A test-only, player-initiated Character Interaction with one selected recipient, a confirmation window, validation checks, and one recipient-scoped operation.

This report records vanilla evidence only. It does not investigate the runtime behavior of `create_dynasty`, bulk selection, decisions, claims, inheritance, banishment, or descendant propagation.

## Classification

- **VERIFIED AND IMPLEMENTATION-READY** — the exact form and relevant scope are demonstrated by vanilla script or vanilla interaction documentation.
- **VERIFIED BUT CONTEXT-DEPENDENT** — the exact vanilla form exists, but its behavior depends on placement, timing, UI context, or surrounding script.
- **NOT VERIFIED** — no supporting vanilla example was found in this focused search.

## 1. Selected vanilla interaction

### Evidence source

- File: `common/character_interactions/00_choose_favorite_interaction.txt`
- Enclosing identifier: `choose_favorite_interaction` (lines 2–92)
- Interaction format documentation: `common/character_interactions/_character_interactions.info`
- English localisation: `localization/english/interactions/choose_favorite_l_english.yml`
- Referenced scripted effect: `assign_favourite_child_effect`, defined in `common/scripted_effects/07_dlc_ep3_scripted_effects.txt` (lines 13118–13170)

This is a suitable structural reference because it is player-only, operates on one `scope:recipient`, has a default confirmation window, is automatically accepted rather than offered to the recipient, presents explicit validation failures, and supplies result messaging. Its favorite-child gameplay effect is not proposed for reuse.

### Complete top-level field structure

The following is the complete ordered list of fields at the top level of `choose_favorite_interaction`; nested bodies are intentionally omitted here:

```text
choose_favorite_interaction = {
    category = interaction_category_friendly
    icon = designate_favorite
    interface_priority = 8
    desc = choose_favorite_interaction_desc
    is_shown = { ... }
    is_valid_showing_failures_only = { ... }
    on_auto_accept = { ... }
    on_accept = { ... }
    auto_accept = yes
}
```

No other top-level field occurs in this definition. In particular, it has no explicit `needs_confirmation`, `is_valid`, `is_available`, `notification_text`, `send_name`, `on_send`, `on_decline`, `ai_accept`, or `ai_will_do` field.

| Field or omission | Vanilla meaning/evidence | Readiness |
|---|---|---|
| `category = interaction_category_friendly` | Places the interaction in a documented interaction category. `_character_interactions.info` says `category` is required (lines 16–18). | **VERIFIED AND IMPLEMENTATION-READY** as a field; the chosen category is design-dependent. |
| `icon = designate_favorite` | Selects the displayed interaction icon. | **VERIFIED BUT CONTEXT-DEPENDENT** because the value refers to this interaction's vanilla icon. |
| `interface_priority = 8` | Sort priority in the interaction menu; documented at `_character_interactions.info` lines 6–10. | **VERIFIED BUT CONTEXT-DEPENDENT** because the numeric priority is a UI choice. |
| `desc = choose_favorite_interaction_desc` | Explicit localisation key for the short description. | **VERIFIED AND IMPLEMENTATION-READY** as a field/key form. |
| `is_shown` | Controls whether the interaction appears. The documentation identifies `scope:actor` and `scope:recipient` as available (lines 225–233). | **VERIFIED AND IMPLEMENTATION-READY**. |
| `is_valid_showing_failures_only` | Controls whether the visible interaction is enabled and displays failed conditions; documented at lines 235–239 and 708–709. | **VERIFIED AND IMPLEMENTATION-READY**. |
| `on_auto_accept` | Runs only when the interaction is auto-accepted; documented at lines 375–382. | **VERIFIED BUT CONTEXT-DEPENDENT**, because it depends on `auto_accept`. |
| `on_accept` | Runs when the recipient accepts; documented at lines 360–365. With `auto_accept = yes`, this interaction reaches the accepted path without recipient choice. | **VERIFIED AND IMPLEMENTATION-READY** as an accepted-effect hook. |
| `auto_accept = yes` | The recipient does not decide whether to accept. The documentation distinguishes this from player confirmation (lines 265–272). | **VERIFIED AND IMPLEMENTATION-READY** for an actor-controlled action. |
| omitted `needs_confirmation` | `_character_interactions.info` states that player confirmation is true when this field is not specified (lines 265–268). The same documentation marks the explicit field deprecated. | **VERIFIED AND IMPLEMENTATION-READY**: omission retains the documented default confirmation window. |
| omitted `is_available` | The selected interaction performs actor/recipient gating in `is_shown` and `is_valid_showing_failures_only`. Documentation says `is_available` has actor as root when used (lines 545–556). | **VERIFIED BUT CONTEXT-DEPENDENT**; omission is verified for this interaction, not a universal rule. |

### Actor and recipient scopes

The selected interaction establishes the player actor and the single recipient in `is_shown`:

```text
scope:actor = {
    is_ai = no
    NOT = { has_relation_favorite_child = scope:recipient }
}
scope:recipient.dynasty = scope:actor.dynasty
scope:actor != scope:recipient
```

Source: `common/character_interactions/00_choose_favorite_interaction.txt`, lines 9–15.

- `scope:actor` is the character initiating the interaction. `is_ai = no` makes this definition player-only. **VERIFIED AND IMPLEMENTATION-READY.**
- `scope:recipient` is the individually targeted character. The definition compares that recipient to the actor and then evaluates recipient character triggers inside `scope:recipient = { ... }`. **VERIFIED AND IMPLEMENTATION-READY.**
- The interaction also restricts the recipient to the actor's child, grandchild, or great-grandchild. That gameplay restriction is specific to this vanilla interaction and is not part of the requested Phase 1 target checks. **VERIFIED BUT NOT RELEVANT FOR REUSE.**

### Visibility, availability, and failures

The selected interaction uses this separation:

- `is_shown`: player-only, not the actor, same Dynasty, direct descendant, and not already the favorite.
- `is_valid_showing_failures_only`: actor alive plus recipient validity checks.

Its failure-text pattern is:

```text
scope:recipient = {
    custom_tooltip = {
        text = cant_be_another_player_tt
        is_ai = yes
    }
}
```

Source: `common/character_interactions/00_choose_favorite_interaction.txt`, lines 25–31.

The standard confirmation GUI binds its Send button as follows:

```text
text = "[CharacterInteractionConfirmationWindow.GetSendName]"
onclick = "[CharacterInteractionConfirmationWindow.Send]"
enabled = "[CharacterInteractionConfirmationWindow.CanSend]"
tooltip = "[CharacterInteractionConfirmationWindow.GetCanSendDescription]"
```

Source: `gui/interaction_confirmation.gui`, lines 397–409.

Therefore, failed `is_valid_showing_failures_only` conditions feed the standard disabled-state description, while `custom_tooltip.text` supplies the human-readable reason. This presentation path is **VERIFIED AND IMPLEMENTATION-READY**. A condition placed only in `is_shown` hides the interaction and is not demonstrated here as an unavailable-reason path; expecting hidden conditions to display a failure reason is **NOT VERIFIED**.

### Confirmation and recipient acceptance

Two separate controls must not be conflated:

1. **Actor confirmation window:** `needs_confirmation` is absent. Vanilla documentation says confirmation is true if unspecified. The standard window uses `GetSendName` for both header and Send button. **VERIFIED AND IMPLEMENTATION-READY.**
2. **Recipient response:** `auto_accept = yes`, so the recipient does not receive a choice to accept or decline. **VERIFIED AND IMPLEMENTATION-READY.**

An explicit `needs_confirmation = { ... }` does exist in `become_tributary_interaction` at `common/character_interactions/00_tributary_interactions.txt`, lines 81–83, but `_character_interactions.info` marks that field deprecated. Adding it when the default already confirms is **VERIFIED BUT CONTEXT-DEPENDENT** and is not necessary evidence for this test shape.

### Effect block and result presentation

The accepted-effect hook passes both characters explicitly to a scripted effect:

```text
on_accept = {
    assign_favourite_child_effect = {
        ACTOR = scope:actor
        RECIPIENT = scope:recipient
    }
}
```

Source: `common/character_interactions/00_choose_favorite_interaction.txt`, lines 84–89.

This verifies that `scope:recipient` remains available in `on_accept`, and that an accepted interaction can pass the selected recipient into one effect call. The hook and scope access are **VERIFIED AND IMPLEMENTATION-READY**. The particular `assign_favourite_child_effect` is **VERIFIED BUT CONTEXT-DEPENDENT** and unrelated to Breed Improved's operation.

The interaction also presents an auto-accept result message:

```text
scope:recipient = {
    send_interface_message = {
        title = choose_favorite_interaction_notification
        left_icon = scope:actor
        show_as_tooltip = { ... }
    }
}
```

Source: `common/character_interactions/00_choose_favorite_interaction.txt`, lines 70–81.

The referenced scripted effect separately uses `send_interface_toast` with `title = choose_favorite_interaction_notification`, `left_icon = $ACTOR$`, and `right_icon = $RECIPIENT$` in `common/scripted_effects/07_dlc_ep3_scripted_effects.txt`, lines 13124–13147. These are **VERIFIED BUT CONTEXT-DEPENDENT** result-presentation forms: their timing and displayed effect list depend on the enclosing effect and `show_as_tooltip` content.

No `on_decline` or rejection text is needed by this vanilla definition because `auto_accept = yes`. A recipient-decline presentation pattern for this test shape is therefore **NOT VERIFIED and not required by the selected evidence**.

## 2. Required target checks

### Target is alive

Exact Character Interaction example:

```text
scope:recipient = {
    this != scope:actor
    is_playable_character = yes
    is_alive = yes
}
```

- File: `common/character_interactions/00_education_interactions.txt`
- Enclosing identifier: `offer_ward_interaction`
- Location: `is_shown`, lines 962–967
- Classification: **VERIFIED AND IMPLEMENTATION-READY.** `is_alive` is evaluated on `scope:recipient` in an interaction visibility trigger.

### Target is highborn / not lowborn

Exact Character Interaction example:

```text
is_valid_showing_failures_only = {
    scope:recipient = {
        is_lowborn = no
    }
}
```

- File: `common/character_interactions/06_ep3_scheme_interactions.txt`
- Enclosing identifier: `start_challenge_status_interaction`
- Lines: 1014–1017
- Classification: **VERIFIED AND IMPLEMENTATION-READY.** The verified vanilla identifier is `is_lowborn`; this evidence supports “not lowborn,” without asserting any broader undocumented definition of “highborn.”

### Target is unlanded and not a ruler

Exact combined vanilla character-trigger example:

```text
scripted_trigger parent_1009_valid_new_courtier = {
    is_ai = yes
    is_adult = yes
    is_landed = no
    is_ruler = no
    ...
}
```

- File: `events/relations_events/parent_events.txt`
- Enclosing local identifier: `parent_1009_valid_new_courtier`
- Lines: 614–619
- Classification of `is_landed = no` and `is_ruler = no`: **VERIFIED AND IMPLEMENTATION-READY** as character triggers.
- Classification of moving the exact pair beneath an interaction's `scope:recipient = { ... }`: **VERIFIED BUT CONTEXT-DEPENDENT.** The interaction documentation verifies recipient character scope, and vanilla interactions separately show `scope:recipient = { is_ruler = no }` (`common/character_interactions/00_diarch_interactions.txt`, line 1831) and recipient-scoped `is_landed = no` (`common/character_interactions/00_fp3_interactions.txt`, lines 1563–1570). The focused search did not find the pair together inside one Character Interaction eligibility block.

Vanilla uses both checks together, so treating either one alone as proven equivalent to the pair would be an invalid assumption.

### Target is not House Head

Exact vanilla character-trigger example:

```text
NOT = { is_house_head = yes }
```

- File: `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`
- Enclosing local identifier: `diplomacy_family_2300_relative_trigger`
- Line: 4047
- Usage: invoked while iterating `any_dynasty_member` and `random_dynasty_member` at lines 4170–4173 and 4193–4215, so `this` is the candidate Dynasty member.
- Additional Character Interaction evidence: `scope:recipient = { is_house_head = no }` occurs in the `redirect` block of `kick_from_house_bloc_interaction`, `common/character_interactions/10_tgp_japan_interactions.txt`, lines 1346–1353.
- Classification: **VERIFIED AND IMPLEMENTATION-READY** as a recipient character check.

### Target is not Dynasty Head

Exact vanilla character-trigger example:

```text
NOT = { is_dynast = yes }
```

- File: `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`
- Enclosing local identifier: `diplomacy_family_2300_relative_trigger`
- Line: 4046
- Supporting definition: `is_dynast` is defined in `common/scripted_triggers/00_dynasty_triggers.txt`, lines 15–24; it tests whether the current character is the Dynasty's `dynast`.
- Classification: **VERIFIED AND IMPLEMENTATION-READY** as a character check.
- Exact spelling warning: vanilla uses `is_dynast`, not an assumed `is_dynasty_head` identifier. `is_dynasty_head` was **NOT VERIFIED** in this research.

### Actor and target belong to the same Dynasty

Exact selected-interaction example:

```text
scope:recipient.dynasty = scope:actor.dynasty
```

- File: `common/character_interactions/00_choose_favorite_interaction.txt`
- Enclosing identifier: `choose_favorite_interaction`
- Location: `is_shown`, line 14
- Additional exact pattern: `scope:actor = { dynasty = scope:recipient.dynasty }` in `disinherit_interaction`, `common/character_interactions/00_dynast_interactions.txt`, lines 24–27.
- Classification: **VERIFIED AND IMPLEMENTATION-READY.** The selected interaction itself uses the direct scoped Dynasty comparison.

## 3. Localisation evidence

### Exact English file form

The selected interaction's vanilla file begins:

```yaml
l_english: 
 choose_favorite_interaction: "Choose Favorite Child"
 choose_favorite_interaction_desc: "Pre-select a character to showcase among your potential next playable characters."
 choose_favorite_interaction_notification: "Favorite Chosen"
 choose_favorite_interaction_notification.tt: "All other [children|E] will #N lose#! [opinion|E]"
```

Source: `localization/english/interactions/choose_favorite_l_english.yml`, lines 1–5.

Verified file-form observations:

- First line is `l_english:`. **VERIFIED AND IMPLEMENTATION-READY.**
- Entries have one leading space, a key, a colon, and a quoted value. **VERIFIED AND IMPLEMENTATION-READY.**
- This file does not use numeric key versions such as `:0`. Therefore, a numeric suffix is not established as required by this example. **NOT VERIFIED AS A REQUIREMENT.**
- The file's first three bytes are decimal `239,187,191` (`EF BB BF`), proving this vanilla file is UTF-8 with BOM. **VERIFIED FILE PROPERTY.**
- This observation alone does not prove that the engine requires a BOM for every localisation file. **BOM REQUIREMENT: NOT VERIFIED.**

### Keys and suffix behavior

| Key/form | Why it resolves in the selected interaction | Readiness |
|---|---|---|
| `choose_favorite_interaction` | `send_name` is omitted. `_character_interactions.info` says `send_name` defaults to the database object key (lines 120–123). The standard confirmation window displays `GetSendName`. | **VERIFIED AND IMPLEMENTATION-READY.** |
| `choose_favorite_interaction_desc` | Explicitly referenced by `desc = choose_favorite_interaction_desc`. | **VERIFIED AND IMPLEMENTATION-READY.** |
| `choose_favorite_interaction_notification` | Explicitly referenced as the interface-message/toast `title`. | **VERIFIED AND IMPLEMENTATION-READY.** |
| `choose_favorite_interaction_notification.tt` | Explicitly referenced by `custom_tooltip` inside `assign_favourite_child_effect`. | **VERIFIED BUT CONTEXT-DEPENDENT** on using that presentation effect. |
| `cant_be_another_player_tt` and other failure keys | Explicitly supplied through `custom_tooltip = { text = <key> ... }`. | **VERIFIED AND IMPLEMENTATION-READY.** |
| automatic `_desc`, `_notification`, `_confirm`, `_accept`, `_decline`, or `_tt` discovery | The selected interaction explicitly names `_desc`, `_notification`, and tooltip keys; vanilla evidence here does not show automatic suffix discovery for those forms. | **NOT VERIFIED.** |

The suffixes in the selected file are naming conventions attached to explicitly referenced keys, except that the interaction's own identifier supplies the default `send_name`. No separate custom confirmation-text key is used by this interaction.

### Dynamic expressions

The selected interaction's localisation contains game-concept expressions such as `[children|E]` and `[opinion|E]`, plus styling markers such as `#N ... #!`. It contains **no dynamic character expression and no dynamic Dynasty expression**.

- Dynamic character expression used by the selected interaction: **NOT VERIFIED — none present.**
- Dynamic Dynasty expression used by the selected interaction: **NOT VERIFIED — none present.**
- Inventing forms such as `[recipient.GetName]`, `[actor.GetName]`, or a Dynasty accessor on the strength of this selected example would be unsupported by this evidence.

### Confirmation and failure-text patterns

- Confirmation header/button text: the standard GUI uses `CharacterInteractionConfirmationWindow.GetSendName`; for this interaction that resolves through the default `send_name` behavior to `choose_favorite_interaction`. **VERIFIED AND IMPLEMENTATION-READY.**
- Validation failure: `custom_tooltip = { text = <loc_key> <trigger> }` inside `is_valid_showing_failures_only`; the standard Send button tooltip uses `GetCanSendDescription`. **VERIFIED AND IMPLEMENTATION-READY.**
- Success title: explicit localisation key passed to `send_interface_message` or `send_interface_toast`. **VERIFIED BUT CONTEXT-DEPENDENT.**
- A special localisation suffix for confirmation text: **NOT VERIFIED.**
- A failure reason for a condition placed solely in `is_shown`: **NOT VERIFIED.**

## 4. Implementation-readiness summary

### VERIFIED AND IMPLEMENTATION-READY

- One-recipient actor/recipient scopes: `scope:actor`, `scope:recipient`.
- Player-only gating with `scope:actor = { is_ai = no }`.
- Visibility through `is_shown`.
- Enabled/disabled state and visible reasons through `is_valid_showing_failures_only` plus `custom_tooltip.text`.
- Default player confirmation by omitting `needs_confirmation`.
- No recipient choice with `auto_accept = yes`.
- Accepted-effect access to `scope:recipient` in `on_accept`.
- Target checks: `is_alive = yes`, `is_lowborn = no`, `is_landed = no`, `is_ruler = no`, `NOT = { is_house_head = yes }`, and `NOT = { is_dynast = yes }`.
- Same-Dynasty comparison: `scope:recipient.dynasty = scope:actor.dynasty`.
- Localisation header/entry form and the selected interaction's explicit keys.

### VERIFIED BUT CONTEXT-DEPENDENT

- The exact category, icon, and interface priority values.
- `on_auto_accept` and its interface message, because it depends on `auto_accept` and the chosen presentation timing.
- `send_interface_message`, `send_interface_toast`, and `show_as_tooltip` content.
- Moving the verified combined `is_landed = no` / `is_ruler = no` event trigger pair into a recipient block: both predicates and recipient scope are independently verified, but that exact combined Character Interaction block was not found.
- Explicit `needs_confirmation`: it exists, but vanilla documentation marks it deprecated and confirms that omission defaults to confirmation.

### NOT VERIFIED

- Any custom confirmation localisation suffix.
- Any automatic discovery of `_desc`, `_notification`, `_accept`, `_decline`, or `_tt` keys beyond the documented default `send_name` behavior.
- A dynamic character or Dynasty localisation expression in the selected interaction.
- That a UTF-8 BOM is an engine requirement; only its presence in the cited vanilla English file is verified.
- `is_dynasty_head` as a trigger identifier. The verified vanilla identifier is `is_dynast`.
- That `is_landed = no` alone and `is_ruler = no` alone are equivalent.
- Failure text for conditions hidden exclusively by `is_shown`.

## Research conclusion

Vanilla 1.19.0.6 provides a complete, verified interaction pattern for the requested test shape: a player actor selects one recipient, sees the standard confirmation window by default, cannot send while recipient validation fails, receives localisation-backed failure text, and reaches an auto-accepted `on_accept` block where `scope:recipient` is available. All six requested eligibility concepts have exact vanilla trigger evidence. The only material context gap is that the combined unlanded/non-ruler pair was found in a vanilla character trigger and separately in recipient-scoped interactions, but not together inside one Character Interaction eligibility block.
