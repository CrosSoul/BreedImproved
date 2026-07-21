# CK3 Syntax Reference

## Purpose

Use this file as a verification registry for Crusader Kings III syntax. Do not treat it as a complete API catalog. Add an entry only after verifying the exact construct against this repository, a user-provided target-version reference, same-version vanilla CK3 files, or version-matched official CK3 documentation.

Never add syntax based only on model memory, naming similarity, community claims without corroboration, or examples from another Paradox game.

## Admission Requirements

Record all of the following before marking a construct as verified:

- Exact token or field name.
- Category: trigger, effect, modifier, value, scope link, control structure, event field, localisation function, GUI field, file structure, or other CK3-defined element.
- Valid file family and enclosing block.
- Required input scope and any resulting scope or state change.
- Supported arguments and value types.
- CK3 version used for verification.
- Evidence path or document reference.
- A minimal source excerpt or a precise pointer to the verified example.
- Known restrictions, DLC dependencies, or version differences.

A matching name alone is not sufficient. The role, context, scope, and argument form must also match.

## Verification Status

Use only these statuses:

- `VERIFIED`: Confirmed for the target CK3 version and usage context.
- `VERSION-SPECIFIC`: Confirmed only for the recorded CK3 version.
- `DEPRECATED`: Confirmed obsolete or replaced in the recorded version.
- `UNVERIFIED`: Recorded as a research lead only; never use in runnable mod code.

## Entry Template

Copy this template for each verified construct:

```markdown
### <exact construct name>

- Status:
- Category:
- CK3 version:
- File family:
- Enclosing context:
- Input scope:
- Output scope or state change:
- Arguments:
- Evidence:
- Minimal verified example:
- Restrictions and notes:
```

## File Structure Verification

For directories, filenames, descriptors, history, map data, GUI, assets, and localisation, record:

- Exact relative path.
- How CK3 loads or merges the file.
- Naming and extension requirements.
- Encoding, BOM, and localisation requirements where applicable.
- Override or replacement behavior.
- Same-version vanilla or project evidence.

Treat `replace_path` as a high-risk override. Record its full masking effect before approving its use.

## Current Registry

The entries below are verified only for the recorded CK3 version and context. They do not form a general CK3 API catalog.

### `create_dynasty`

- Status: `VERIFIED`
- Category: effect
- CK3 version: `1.19.0.6`
- File family: effect blocks in scripted effects and events
- Enclosing context: a character-scoped effect block; the intended character is entered before the call
- Input scope: character
- Output scope or state change: creates a Dynasty for the scoped character; cited vanilla flows access that character's resulting `house` immediately afterward
- Arguments: verified keys are `name`, `coat_of_arms`, `spread_to_descendants = yes`, and `save_scope_as = <saved_scope_name>`; the minimal verified form used by the test harness is `create_dynasty = { save_scope_as = new_dynasty }`
- Evidence: `common/scripted_effects/00_accolades_scripted_effects.txt`; `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`; `events/dlc/tgp/tgp_japan_decision_events.txt`; `events/dlc/tgp/tgp_mandala_task_contract_events.txt`; `docs/research/Lynn_to_Jay_Phase1_Followup.md`, section 1
- Minimal verified example: `create_dynasty = { save_scope_as = new_dynasty }`
- Restrictions and notes: no target argument is verified; enter the intended character scope first. Existing-character use is verified, but use on an arbitrary existing highborn unlanded target requires T1. Omission of `spread_to_descendants` is verified syntax, but target-only runtime behavior is not verified and requires T7. Do not infer other arguments or default descendant behavior.

### `category`

- Status: `VERIFIED`
- Category: Character Interaction field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: assigns the interaction to an interaction category
- Arguments: a valid interaction-category identifier; verified example value `interaction_category_friendly`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `category = interaction_category_friendly`
- Restrictions and notes: the field is documented as required. The verified value is reused only as test-only UI presentation and does not establish the production category.

### `icon`

- Status: `VERIFIED`
- Category: Character Interaction UI field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: selects the displayed interaction icon
- Arguments: a valid interaction-icon identifier; verified example value `designate_favorite`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`
- Minimal verified example: `icon = designate_favorite`
- Restrictions and notes: the value is context-dependent vanilla UI data and is approved only for the isolated test harness, not for production branding.

### `interface_priority`

- Status: `VERIFIED`
- Category: Character Interaction UI field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: controls interaction-menu ordering
- Arguments: numeric priority; verified example value `8`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `interface_priority = 8`
- Restrictions and notes: the number is a test-only UI choice and does not establish a production priority.

### `desc`

- Status: `VERIFIED`
- Category: Character Interaction localisation field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: explicitly references the interaction description localisation key
- Arguments: localisation key
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `localization/english/interactions/choose_favorite_l_english.yml`
- Minimal verified example: `desc = choose_favorite_interaction_desc`
- Restrictions and notes: `_desc` is not assumed to resolve automatically; the key must be referenced explicitly.

### `is_shown`

- Status: `VERIFIED`
- Category: Character Interaction trigger-block field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: Character Interaction context with `scope:actor` and `scope:recipient` available
- Output scope or state change: controls visibility; no state change
- Arguments: a trigger block
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `is_shown = { scope:actor != scope:recipient }`
- Restrictions and notes: a condition placed only here hides the interaction. This evidence does not prove that a hidden condition displays a failure reason.

### `is_valid_showing_failures_only`

- Status: `VERIFIED`
- Category: Character Interaction trigger-block field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: Character Interaction context with `scope:actor` and `scope:recipient` available
- Output scope or state change: controls whether the visible interaction can be sent and exposes failed validation; no state change
- Arguments: a trigger block
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`; `gui/interaction_confirmation.gui`
- Minimal verified example: `is_valid_showing_failures_only = { scope:recipient = { custom_tooltip = { text = cant_be_another_player_tt is_ai = yes } } }`
- Restrictions and notes: use explicit localisation keys for the failure text. Do not infer behavior for other availability fields from this entry.

### `on_accept`

- Status: `VERIFIED`
- Category: Character Interaction effect-block field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: accepted Character Interaction context; `scope:actor` and `scope:recipient` are available
- Output scope or state change: runs the enclosed effects after acceptance
- Arguments: an effect block
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `on_accept = { scope:recipient = { <verified character effect> } }`
- Restrictions and notes: the selected vanilla interaction calls a scripted effect with actor and recipient. The test harness instead enters `scope:recipient` and uses the independently verified character effect `create_dynasty`; no result-message behavior is inferred.

### `auto_accept`

- Status: `VERIFIED`
- Category: Character Interaction field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object
- Output scope or state change: with `yes`, the recipient has no accept/decline decision
- Arguments: boolean; verified value `yes`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `auto_accept = yes`
- Restrictions and notes: this is separate from actor confirmation and must not be described as disabling the actor's confirmation window.

### omitted `needs_confirmation`

- Status: `DEPRECATED` for the explicit field; verified default behavior when omitted
- Category: Character Interaction confirmation behavior
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object
- Output scope or state change: omission retains the documented default player confirmation window
- Arguments: no argument is written; `_character_interactions.info` marks the explicit field deprecated
- Evidence: omission in `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; default documented in `common/character_interactions/_character_interactions.info`; standard window in `gui/interaction_confirmation.gui`
- Minimal verified example: no `needs_confirmation` field in the interaction definition
- Restrictions and notes: no custom confirmation-localisation suffix is established by this evidence. Do not add the deprecated field when the verified default is sufficient.

### `scope:actor` and `scope:recipient`

- Status: `VERIFIED`
- Category: Character Interaction scope access
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: Character Interaction trigger and effect blocks
- Input scope: active Character Interaction context
- Output scope or state change: resolves respectively to the initiating character and the individually targeted character; entering either block changes the current evaluation scope to that character
- Arguments: used as a scoped block or scope reference
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `scope:actor = { is_ai = no }` and `scope:recipient = { is_ai = yes }`
- Restrictions and notes: availability outside the documented Character Interaction context is not established by this entry.

### `scope:recipient.dynasty = scope:actor.dynasty`

- Status: `VERIFIED`
- Category: trigger comparison using Dynasty scope links
- CK3 version: `1.19.0.6`
- File family: Character Interactions
- Enclosing context: `is_shown` in a Character Interaction definition
- Input scope: Character Interaction actor and recipient character scopes
- Output scope or state change: true when both characters' Dynasty scopes are equal; no state change
- Arguments: left and right Dynasty scope references
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; supporting inverse form in `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`
- Minimal verified example: `scope:recipient.dynasty = scope:actor.dynasty`
- Restrictions and notes: this proves current Dynasty equality only. It does not establish historical membership or actor authority.

### `is_ai`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: Character Interactions
- Enclosing context: a character scope inside `is_shown` or `is_valid_showing_failures_only`
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified test uses are `scope:actor = { is_ai = no }` and recipient `is_ai = yes`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`
- Minimal verified example: `scope:actor = { is_ai = no }`
- Restrictions and notes: actor `no` makes the test player-only; recipient `yes` prevents targeting another player. This does not decide future multiplayer policy.

### `custom_tooltip` with `text`

- Status: `VERIFIED`
- Category: trigger presentation control structure
- CK3 version: `1.19.0.6`
- File family: Character Interactions
- Enclosing context: recipient character scope inside `is_valid_showing_failures_only`
- Input scope: the scope required by the enclosed trigger
- Output scope or state change: evaluates the enclosed trigger and associates its failed state with an explicitly named localisation key; no state change
- Arguments: `text = <localisation_key>` followed by a verified trigger
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; failure display path in `gui/interaction_confirmation.gui`
- Minimal verified example: `custom_tooltip = { text = cant_be_another_player_tt is_ai = yes }`
- Restrictions and notes: the key must exist. Do not infer an automatic tooltip suffix or dynamic localisation expression.

### `NOT`

- Status: `VERIFIED`
- Category: trigger control structure
- CK3 version: `1.19.0.6`
- File family: character trigger contexts, including events and scripted triggers
- Enclosing context: a trigger block evaluated on a character
- Input scope: inherited from the enclosing trigger context
- Output scope or state change: negates the enclosed trigger result; no state change
- Arguments: one or more enclosed verified triggers
- Evidence: `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`; `common/scripted_triggers/00_dynasty_triggers.txt`
- Minimal verified example: `NOT = { is_dynast = yes }`
- Restrictions and notes: this entry supports only ordinary trigger negation in the cited character-trigger context; it does not validate an unverified enclosed construct.

### `is_alive`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: Character Interactions
- Enclosing context: recipient character scope in `is_shown`; the test uses the same recipient character scope in `is_valid_showing_failures_only`
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified use `yes`
- Evidence: `common/character_interactions/00_education_interactions.txt`, `offer_ward_interaction`
- Minimal verified example: `scope:recipient = { is_alive = yes }`
- Restrictions and notes: this entry verifies the character check only and does not establish dead-character mutation behavior.

### `is_lowborn`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: Character Interactions
- Enclosing context: recipient character scope in `is_valid_showing_failures_only`
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified use `no`
- Evidence: `common/character_interactions/06_ep3_scheme_interactions.txt`, `start_challenge_status_interaction`
- Minimal verified example: `scope:recipient = { is_lowborn = no }`
- Restrictions and notes: this is the verified implementation check for the test's highborn requirement. Do not infer other noble-status guarantees.

### `is_adult`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks
- Enclosing context: character trigger `parent_1009_valid_new_courtier`; the test moves the same character trigger into a documented recipient character trigger block
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified use `yes`
- Evidence: `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; recipient scope support from `common/character_interactions/_character_interactions.info`
- Minimal verified example: `is_adult = yes`
- Restrictions and notes: Lynn did not cite the exact predicate inside the selected Character Interaction; its character scope and the interaction's recipient character scope are independently verified.

### `is_landed`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and Character Interactions
- Enclosing context: character trigger `parent_1009_valid_new_courtier`; separate recipient-scoped Character Interaction use
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified use `no`
- Evidence: `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; `common/character_interactions/00_fp3_interactions.txt`
- Minimal verified example: `is_landed = no`
- Restrictions and notes: do not treat `is_landed = no` as equivalent to `is_ruler = no`; the test checks both.

### `is_ruler`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and Character Interactions
- Enclosing context: character trigger `parent_1009_valid_new_courtier`; separate recipient-scoped Character Interaction use
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified use `no`
- Evidence: `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; `common/character_interactions/00_diarch_interactions.txt`
- Minimal verified example: `is_ruler = no`
- Restrictions and notes: do not treat `is_ruler = no` as equivalent to `is_landed = no`; the test checks both. The exact pair was not found together inside one interaction block, but both predicates and recipient context are independently verified.

### `is_house_head`

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and Character Interactions
- Enclosing context: character candidate trigger; separate recipient-scoped Character Interaction use
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified exclusion forms are `NOT = { is_house_head = yes }` and recipient `is_house_head = no`
- Evidence: `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`; `common/character_interactions/10_tgp_japan_interactions.txt`, `kick_from_house_bloc_interaction`
- Minimal verified example: `NOT = { is_house_head = yes }`
- Restrictions and notes: the test excludes House Heads; it does not establish behavior if the effect is applied to one.

### `is_dynast`

- Status: `VERIFIED`
- Category: scripted character trigger
- CK3 version: `1.19.0.6`
- File family: `common/scripted_triggers/*.txt` definition and character trigger callers
- Enclosing context: character trigger block
- Input scope: character
- Output scope or state change: true when the scoped character is the Dynasty's Dynast; no state change
- Arguments: `yes` in the verified call, negated with `NOT`
- Evidence: definition in `common/scripted_triggers/00_dynasty_triggers.txt`; use in `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`
- Minimal verified example: `NOT = { is_dynast = yes }`
- Restrictions and notes: exact identifier is `is_dynast`. `is_dynasty_head` is not verified and must not be substituted.

### English localisation file form

- Status: `VERIFIED`
- Category: file structure and localisation format
- CK3 version: `1.19.0.6`
- File family: `localization/english/*.yml`
- Enclosing context: English localisation file
- Input scope: not applicable; static localisation database entries
- Output scope or state change: registers English text for explicitly referenced localisation keys
- Arguments: first line `l_english:`; entries use one leading space, a key, a colon, and a quoted value
- Evidence: `localization/english/interactions/choose_favorite_l_english.yml`
- Minimal verified example: `l_english:` followed by ` choose_favorite_interaction: "Choose Favorite Child"`
- Restrictions and notes: this cited vanilla file begins with UTF-8 BOM bytes `EF BB BF`; the test file preserves that observed property. The evidence does not prove BOM is universally required. Numeric key versions such as `:0` are not established as required by this example. Interaction name resolves from the interaction ID when `send_name` is omitted; description and failure keys are explicitly referenced. Dynamic character or Dynasty expressions are not verified and are not used.

## Uncertainty Protocol

When a required element is absent from the verified registry and cannot be confirmed from a higher-priority source:

1. Stop before writing the element into a runnable file.
2. Report `UNVERIFIED CK3 SYNTAX: <specific uncertainty>`.
3. State the missing version, scope, file-context, or source evidence.
4. Request a project example, same-version vanilla CK3 file, or version-matched official reference.
5. Keep any sketch separate and label it `PSEUDOCODE - NOT VALIDATED FOR CK3`.
