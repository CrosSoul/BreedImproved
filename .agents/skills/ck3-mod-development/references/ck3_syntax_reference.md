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
- Arguments: verified keys are `name`, `coat_of_arms`, `spread_to_descendants = yes`, and `save_scope_as = <saved_scope_name>`; the approved test harness and production wrapper use `spread_to_descendants = yes` with `save_scope_as = <saved_scope_name>`
- Evidence: `common/scripted_effects/00_accolades_scripted_effects.txt`; `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`; `events/dlc/tgp/tgp_japan_decision_events.txt`; `events/dlc/tgp/tgp_mandala_task_contract_events.txt`; `docs/research/Lynn_to_Jay_Phase1_Followup.md`, section 1
- Minimal verified example: `create_dynasty = { spread_to_descendants = yes save_scope_as = new_dynasty }`
- Restrictions and notes: no target argument is verified; enter the intended character scope first. Breed Improved's isolated harness runtime tests confirmed Dynasty replacement for approved highborn AI targets, including minors, adults, unlanded characters, landed rulers, and the current player heir. With `spread_to_descendants = yes`, descendants moved to the replacement Dynasty while parents and siblings remained unchanged; tested landed targets retained titles and government. These observations validate the approved harness behavior, not every possible character state or the production interaction as a whole. Do not infer other arguments or default descendant behavior.

### `category`

- Status: `VERIFIED`
- Category: Character Interaction field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: assigns the interaction to an interaction category
- Arguments: a valid interaction-category identifier; verified values are `interaction_category_friendly` and `interaction_category_hostile`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `category = interaction_category_hostile`
- Restrictions and notes: the field is documented as required. The production interaction follows the hostile-category pattern used by vanilla `disinherit_interaction`.

### `icon`

- Status: `VERIFIED`
- Category: Character Interaction UI field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: selects the displayed interaction icon
- Arguments: a valid interaction-icon identifier; verified values are `designate_favorite` and `icon_dynasty`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`
- Minimal verified example: `icon = icon_dynasty`
- Restrictions and notes: `designate_favorite` remains test-only. Production uses the vanilla Dynasty interaction icon `icon_dynasty` from `disinherit_interaction`.

### `interface_priority`

- Status: `VERIFIED`
- Category: Character Interaction UI field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: controls interaction-menu ordering
- Arguments: numeric priority; verified values include `8` and `60`
- Evidence: `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`; `common/character_interactions/_character_interactions.info`
- Minimal verified example: `interface_priority = 60`
- Restrictions and notes: the production value `60` follows vanilla `disinherit_interaction`; it is a menu-ordering choice, not a gameplay rule.

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

### `prompt`

- Status: `VERIFIED`
- Category: Character Interaction localisation field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: references the localisation text shown under the portrait in the interaction window
- Arguments: localisation key
- Evidence: `common/character_interactions/_character_interactions.info`, lines documenting `prompt = loc_key`
- Minimal verified example: `prompt = breedimp_exile_from_dynasty_interaction_prompt`
- Restrictions and notes: the project key must be explicitly defined. This entry verifies the field and localisation reference, not a guaranteed layout or line-wrapping result.

### `use_diplomatic_range`

- Status: `VERIFIED`
- Category: Character Interaction field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction database object; no character scope transition
- Output scope or state change: determines whether normal diplomatic-range checking applies
- Arguments: `yes`, `no`, or a trigger; production uses the verified boolean value `no`
- Evidence: `common/character_interactions/_character_interactions.info`; `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`
- Minimal verified example: `use_diplomatic_range = no`
- Restrictions and notes: this removes the normal diplomatic-range check only. It does not bypass the interaction's own actor or recipient validation.

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

### no-argument scripted effect definition and call

- Status: `VERIFIED`
- Category: scripted effect definition and effect call
- CK3 version: `1.19.0.6`
- File family: definition in `common/scripted_effects/*.txt`; call from Character Interaction effect blocks
- Enclosing context: a top-level scripted effect definition and a character-scoped `on_accept` effect block
- Input scope: inherited character scope; the caller enters `scope:recipient` before invoking the effect
- Output scope or state change: runs the verified effects inside the named scripted effect
- Arguments: `yes` for a no-argument call
- Evidence: definition `restore_inheritance_effect` in `common/scripted_effects/00_interaction_effects.txt`; recipient-scoped call in `common/character_interactions/00_dynast_interactions.txt`, `restore_inheritance_interaction`
- Minimal verified example: `scope:recipient = { restore_inheritance_effect = yes }`
- Restrictions and notes: only the definition-and-call form is generalized here. Every state-changing construct inside a project scripted effect must be independently verified for the inherited scope.

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

### no-argument scripted trigger definition and call in a Character Interaction

- Status: `VERIFIED`
- Category: scripted trigger definition and trigger call
- CK3 version: `1.19.0.6`
- File family: definition in `common/scripted_triggers/*.txt`; call from Character Interaction trigger blocks
- Enclosing context: a top-level scripted trigger definition and a recipient character scope inside `is_valid_showing_failures_only`
- Input scope: inherited character scope; interaction saved scopes such as `scope:actor` remain available in the cited definition
- Output scope or state change: returns the combined trigger result; no state change
- Arguments: `yes` for a no-argument call
- Evidence: definition `kick_from_court_validity_trigger` in `common/scripted_triggers/00_interaction_triggers.txt`; recipient-scoped call in `common/character_interactions/00_courtier_and_guest_interactions.txt`, `kick_from_court_interaction`
- Minimal verified example: `scope:recipient = { kick_from_court_validity_trigger = yes }`
- Restrictions and notes: the scripted trigger must be called from the character scope it expects. This evidence supports access to `scope:actor` retained from the enclosing Character Interaction context; it does not establish arbitrary saved-scope availability in unrelated callers.

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
- Enclosing context: character trigger `parent_1009_valid_new_courtier`
- Input scope: character
- Output scope or state change: boolean condition; no state change
- Arguments: `yes` or `no`; verified use `yes`
- Evidence: `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; recipient scope support from `common/character_interactions/_character_interactions.info`
- Minimal verified example: `is_adult = yes`
- Restrictions and notes: this construct is registered for reference but is intentionally absent from the approved harness and production v0.1, which permit both minors and adults.

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
- Restrictions and notes: do not treat `is_landed = no` as equivalent to `is_ruler = no`. This construct is intentionally absent from the approved harness and production v0.1, which permit unlanded and landed recipients.

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
- Restrictions and notes: do not treat `is_ruler = no` as equivalent to `is_landed = no`. This construct is intentionally absent from the approved harness and production v0.1, which permit non-rulers and rulers. The exact pair was not found together inside one interaction block, but both predicates and recipient context are independently verified.

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
- Restrictions and notes: the approved harness and production v0.1 exclude House Heads; tested behavior does not establish what would happen if the effect were applied to one.

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
- Evidence: `localization/english/interactions/choose_favorite_l_english.yml`; `localization/english/interactions/dynast_interaction_l_english.yml`
- Minimal verified example: `l_english:` followed by ` choose_favorite_interaction: "Choose Favorite Child"`
- Restrictions and notes: the cited vanilla files begin with UTF-8 BOM bytes `EF BB BF`; project files preserve that observed property. The evidence does not prove BOM is universally required. Vanilla demonstrates both versioned keys (for example `:0`) and unversioned keys; the project uses its established unversioned form. Interaction name resolves from the interaction ID when `send_name` is omitted; description, prompt, and failure keys are explicitly referenced. `dynast_interaction_l_english.yml` verifies `$dynasty_interaction_header$`, `[recipient.GetShortUINameNoTooltip]`, and `[dynasty|E]`-style game-concept links in an interaction description.

### Simplified Chinese localisation file form

- Status: `VERIFIED`
- Category: file structure and localisation format
- CK3 version: `1.19.0.6`
- File family: `localization/simp_chinese/*.yml`
- Enclosing context: Simplified Chinese localisation file
- Input scope: not applicable; static localisation database entries
- Output scope or state change: registers Simplified Chinese text for explicitly referenced localisation keys
- Arguments: first line `l_simp_chinese:`; entries use one leading space, a key, a colon, and a quoted value
- Evidence: `localization/simp_chinese/interactions/dynast_interaction_l_simp_chinese.yml`
- Minimal verified example: `l_simp_chinese:` followed by ` disinherit_interaction: "剥夺继承权"`
- Restrictions and notes: the cited vanilla file begins with UTF-8 BOM bytes `EF BB BF`; the project preserves that observed property without asserting that BOM is a universal engine requirement. The cited file uses unversioned keys and verifies `$dynasty_interaction_header$`, `[recipient.GetShortUINameNoTooltip]`, and `[dynasty|E]`-style game-concept links in Simplified Chinese interaction localisation.

### Generic Character Interaction effect-card grouping

- Status: `VERIFIED`
- Category: GUI presentation generated from Character Interaction effects
- CK3 version: `1.19.0.6`
- File family: `gui/interaction_confirmation.gui`, `gui/interaction_templates.gui`, and `common/character_interactions/*.txt`
- Enclosing context: generic Character Interaction confirmation window parsing accepted effects
- Input scope: interaction effect description with actor and recipient named scopes
- Output scope or state change: no gameplay state change; shows only scope cards with parsed effects
- Arguments: GUI predicates `HasAnyEffects`, `HasActorEffects`, and `HasRecipientEffects`
- Evidence: `denounce_interaction`; `denounce_effect`; `gui/interaction_confirmation.gui:250`; `gui/interaction_templates.gui:1014`
- Minimal verified example: actor card `visible = "[DisplayedInteractionEffects.HasActorEffects]"`
- Restrictions and notes: cost is rendered separately and does not itself create an actor-effect card. Exact visual size and zero-cost behavior require runtime observation.

### `cost` with `prestige`

- Status: `VERIFIED`
- Category: Character Interaction cost field
- CK3 version: `1.19.0.6`
- File family: `common/character_interactions/*.txt`
- Enclosing context: top level of a Character Interaction definition
- Input scope: interaction context; actor pays and `scope:recipient` is readable by the value formula
- Output scope or state change: disables sending when unaffordable and subtracts the calculated personal Prestige when sent
- Arguments: `cost = { prestige = { value = <number-or-scripted-value> } }`; `piety`, `gold`, and `renown` are separately supported currencies
- Evidence: `common/character_interactions/_character_interactions.info:467`; `common/character_interactions/00_dynast_interactions.txt`, `denounce_interaction`
- Minimal verified example: `cost = { prestige = { value = { add = medium_prestige_value if = { limit = { <trigger> } multiply = 0 } } } }`
- Restrictions and notes: positive values are costs. Renown is distinct from personal Prestige. Exact insufficient-cost wording and whether calculated zero is hidden require runtime observation.

### Conditional scripted numeric values

- Status: `VERIFIED`
- Category: scripted value
- CK3 version: `1.19.0.6`
- File family: `common/script_values/*.txt` or inline in a numeric field
- Enclosing context: any supported numeric field, including Character Interaction cost values
- Input scope: current evaluation scope and available named scopes
- Output scope or state change: returns a number; no scope transition
- Arguments: `value`, arithmetic operations, and `if`/`else_if`/`else` with `limit`
- Evidence: `common/script_values/_script_values.info`; inline formula in `denounce_interaction.cost`
- Minimal verified example: `<id> = { value = 100 if = { limit = { <trigger> } multiply = 0 } }`
- Restrictions and notes: operations run in authored order. Named project values must be defined in `common/script_values/`; product numbers are not vanilla balance.

### Public bastard birth-state trait checks

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and scripted triggers
- Enclosing context: character scope
- Input scope: character
- Output scope or state change: boolean; no state change
- Arguments: exact traits `bastard` and `legitimized_bastard`
- Evidence: `common/traits/00_traits.txt:10412`; `common/scripted_triggers/00_bastard_triggers.txt`
- Minimal verified example: `OR = { has_trait = bastard has_trait = legitimized_bastard }`
- Restrictions and notes: `has_any_negative_bastard_trait_trigger` also includes `disputed_heritage`; `has_any_bastard_trait_trigger` additionally includes `wild_oat`. Do not substitute either broader trigger when only the two listed public traits are intended.

### `any_parent` with `even_if_dead`

- Status: `VERIFIED`
- Category: character iterator and scope transition
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and scripted triggers
- Enclosing context: character-scoped trigger
- Input scope: character
- Output scope or state change: evaluates existing legal parents; no state change
- Arguments: `even_if_dead = yes` includes deceased relatives
- Evidence: `even_if_dead = yes` on `any_parent` in `common/scripted_triggers/00_family_triggers.txt`; legal-parent iteration in `common/customizable_localization/00_relations.txt:150`
- Minimal verified example: `any_parent = { even_if_dead = yes <trigger> }`
- Restrictions and notes: missing parent links yield no iterator member. Breed Improved's RC2 impurity rule intentionally uses exactly one `any_parent` level. This does not use `real_father` or hidden parentage secrets. Lowborn parents need an explicit branch before Dynasty comparison.

### Native Decision option-list widget

- Status: `VERIFIED`
- Category: Decision UI field and controller
- CK3 version: `1.19.0.6`
- File family: `common/decisions/*.txt`
- Enclosing context: `widget` at the top level of a Decision definition
- Input scope: Decision taker character; no scope transition while options are displayed
- Output scope or state change: selects exactly one static item; the selected `item.value` is exposed in Decision triggers/effects as `scope:<value> = yes`
- Arguments: `gui = "decision_view_widget_option_list_generic"`, `controller = decision_option_list_controller`, optional `show_from_start = yes`, verified `decision_to_second_step_button = "<localisation_key>"`, and static `item` blocks with verified fields `value`, `is_shown`, `is_valid`, `current_description`, `localization`, `is_default`, `icon`, and `ai_chance`
- Evidence: `common/decisions/_decisions.info:145-190`; `common/decisions/00_cultural_tradition_decisions.txt`, `recruit_terrain_specialist_decision`; `common/decisions/dlc_decisions/fp3_decisions.txt`, `struggle_persia_ending_rekindle_iran_decision`
- Minimal verified example: `widget = { gui = "decision_view_widget_option_list_generic" controller = decision_option_list_controller item = { value = my_option localization = my_option current_description = my_option_desc } }`
- Restrictions and notes: this is a static single-selection controller, not a dynamic character multi-select list. Translate the selected option into a saved scope or other verified event-chain state inside the Decision effect; do not assume the item scope persists independently.

### Player-only Decision entry and Decision-to-event call

- Status: `VERIFIED`
- Category: Decision fields and effect
- CK3 version: `1.19.0.6`
- File family: `common/decisions/*.txt`
- Enclosing context: top level of a Decision definition and its character-scoped `effect`
- Input scope: Decision taker character
- Output scope or state change: the Decision `effect` runs on the Decision taker, may save that actor scope, and may dispatch a namespaced event
- Arguments: verified fields include `title`, `picture`, `selection_tooltip`, `desc`, `confirm_text`, `sort_order`, `is_shown`, `is_valid_showing_failures_only`, `is_valid`, `effect`, `ai_check_interval`, `ai_potential`, and `ai_will_do`; verified effect components include `save_scope_as = <name>` and `trigger_event = <namespace.id>`; `ai_check_interval = 0` disables AI checking
- Evidence: character-scoped Decision `effect` at `common/decisions/_decisions.info:125-143`; actor capture at `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`; event dispatch at `common/decisions/00_major_decisions_iberia_north_africa.txt:72-78`
- Minimal verified example: `effect = { save_scope_as = actor trigger_event = my_namespace.1000 }`
- Restrictions and notes: actor eligibility remains an explicit project trigger. Omitting a cost and cooldown is permitted; it does not imply a hidden resource charge.

### Dynasty member iterators

- Status: `VERIFIED`
- Category: Dynasty-to-character iterators
- CK3 version: `1.19.0.6`
- File family: effects and triggers in Decisions, events, scripted effects, and scripted triggers
- Enclosing context: a Dynasty scope such as `dynasty = { ... }`
- Input scope: Dynasty
- Output scope or state change: `any_dynasty_member` evaluates character triggers; `every_dynasty_member` runs a block on every matching character; `random_dynasty_member` enters one matching character and may save that scope
- Arguments: verified iterator fields include `limit`, `alternative_limit` for the random form, and character effects such as `save_scope_as`
- Evidence: `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt:4170-4266`; `events/relations_events/parent_events.txt`, `parent.1009`; `events/activities/coronation_activity/prelude_events.txt:4603-4609`
- Minimal verified example: `dynasty = { random_dynasty_member = { limit = { is_alive = yes } save_scope_as = candidate } }`
- Restrictions and notes: deceased members are not assumed to be excluded; write `is_alive = yes` when required. Breed Improved permits use only after explicit player initiation.

### Event-target lists

- Status: `VERIFIED`
- Category: event-chain list effects, triggers, and iterators
- CK3 version: `1.19.0.6`
- File family: event, Decision, and scripted-effect blocks that share the same event context
- Enclosing context: character-scoped effects/triggers and event chains
- Input scope: the current typed scope added to or tested against the named event-target list
- Output scope or state change: `add_to_list` appends the current scope; `is_in_list` tests membership; `any_in_list`, `random_in_list`, and `every_in_list` enter list members; `save_scope_as` can save a randomly selected member
- Arguments: list identifier via `add_to_list = <name>`, `is_in_list = <name>`, or `list = <name>`; the iterators accept verified `limit`, `count`, and enclosed trigger/effect blocks
- Evidence: `tests/event_target_lists_tests.txt:45-93`; `common/scripted_effects/00_decisions_effects.txt:1511-1529`; `events/story_cycles/story_cycle_pet_animal_events.txt:834-863`; `events/dlc/fp3/fp3_misc_decision_events.txt:2534-2843`
- Minimal verified example: `random_in_list = { list = candidates limit = { NOT = { is_in_list = reviewed } } save_scope_as = candidate }`
- Restrictions and notes: these are context lists, not persistent character variable lists. Their continuity through the complete Breed Improved review loop is a required runtime test. Do not substitute the `variable = <name>` form unless a persistent variable list is intentionally required.

### `any_ancestor` with selected-list membership

- Status: `VERIFIED`
- Category: character iterator and trigger composition
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and scripted triggers
- Enclosing context: character scope
- Input scope: character
- Output scope or state change: enters ancestors for boolean evaluation; no state change
- Arguments: `even_if_dead = yes` and character triggers including the independently verified `is_in_list = <event_target_list>`
- Evidence: `events/dlc/tgp/tgp_mandala_devaraja_events.txt:1222-1227`; list membership evidence in `common/scripted_effects/00_decisions_effects.txt:1511-1524`
- Minimal verified example: `any_ancestor = { even_if_dead = yes is_in_list = selected_targets }`
- Restrictions and notes: this supports ancestor-first ordering, actor-ancestor exclusion, and collapsing a selected descendant when a still-valid selected ancestor exists. It does not enumerate descendants, calculate a descendant count, or detect two non-ancestor roots whose descendant branches later converge.

### Temporary saved scope inside a scripted trigger

- Status: `VERIFIED`
- Category: temporary scope capture and scope comparison
- CK3 version: `1.19.0.6`
- File family: `common/scripted_triggers/*.txt`
- Enclosing context: scripted trigger evaluated from a typed scope
- Input scope: current typed scope
- Output scope or state change: saves a context-local temporary scope for later trigger comparison; no persistent character state
- Arguments: `save_temporary_scope_as = <name>` and later `scope:<name>` access
- Evidence: `common/scripted_triggers/07_ep3_triggers.txt:888-896`, `is_appointment_valid_trigger`; `common/scripted_triggers/00_activity_triggers.txt:140-145`
- Minimal verified example: `save_temporary_scope_as = candidate_temp` followed by `scope:candidate_temp = { <trigger> }`
- Restrictions and notes: use this only to preserve the caller's typed scope across nested scope changes in the same evaluation context. It is not persistent save configuration and does not establish event-chain lifetime.

### Parameterized scripted trigger scope arguments

- Status: `VERIFIED`
- Category: scripted-trigger argument substitution and scope access
- CK3 version: `1.19.0.6`
- File family: `common/scripted_triggers/*.txt` and supported callers
- Enclosing context: a scripted-trigger definition that declares a `$NAME$` placeholder, called with `NAME = <scope>`
- Input scope: caller's current typed scope plus the explicitly supplied typed scope argument
- Output scope or state change: evaluates the trigger using the supplied scope; no state change
- Arguments: a project-chosen uppercase placeholder such as `$ACTOR$`; the call site supplies the matching name without dollar signs, for example `ACTOR = scope:actor`
- Evidence: definition `ask_for_pardon_available_trigger` in `common/scripted_triggers/00_interaction_triggers.txt:49-61`; call in `common/character_interactions/00_vassal_interactions.txt:2293`
- Minimal verified example: definition `$ACTOR$ = { is_alive = yes }`; call `my_trigger = { ACTOR = scope:actor }`
- Restrictions and notes: argument names are textual parameters, not automatically created saved scopes. Pass every required argument explicitly and preserve the typed scope expected by the trigger.

### `save_scope_as` in a Decision effect

- Status: `VERIFIED`
- Category: saved-scope effect
- CK3 version: `1.19.0.6`
- File family: `common/decisions/*.txt`
- Enclosing context: character-scoped `effect` of a Decision
- Input scope: Decision taker character
- Output scope or state change: saves the current character under a named event scope for the following Decision/event context
- Arguments: project-chosen scope name, for example `save_scope_as = actor`
- Evidence: `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`
- Minimal verified example: `effect = { save_scope_as = actor trigger_event = my_namespace.1000 }`
- Restrictions and notes: the cited form verifies capture in the Decision effect. Scope/list continuity through Breed Improved's repeated visible event loop remains a runtime test; this entry does not establish indefinite or save-persistent lifetime.

### Permanent scalar character flag

- Status: `VERIFIED`
- Category: character effect and trigger
- CK3 version: `1.19.0.6`
- File family: character-scoped events, scripted effects, scripted triggers, and Character Interactions
- Enclosing context: character scope
- Input scope: character
- Output scope or state change: `add_character_flag` adds an untimed scalar marker; `has_character_flag` tests it; `remove_character_flag` removes it
- Arguments: a flag identifier; the verified scalar form has no character-valued payload
- Evidence: `events/dlc/bp2/bp2_yearly_events_6.txt:5411` and `:13373`; `common/story_cycles/bp2_story_cycle_foreign_raised_reformer.txt:59`; detailed project evidence in `docs/research/Lynn_to_Jay_Exile_Consequences_Evidence.md`, section **Persistent character flag**
- Minimal verified example: `add_character_flag = my_flag`, later `has_character_flag = my_flag`, and `remove_character_flag = my_flag`
- Restrictions and notes: an untimed flag remains until explicitly removed by script. It does not identify the character who set it. Save/reload persistence must be confirmed by runtime testing before making a product-level persistence claim.

### Exact active-trait eligibility checks

- Status: `VERIFIED`
- Category: character trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks and scripted triggers
- Enclosing context: character scope
- Input scope: character
- Output scope or state change: boolean; no state change
- Arguments: exact trait database key, for example `has_trait = inbred`
- Evidence: `common/character_interactions/00_dynast_interactions.txt:305-314`; definitions in `common/traits/00_traits.txt`; field behavior in `common/traits/_traits.info`
- Minimal verified example: `has_trait = intellect_bad_3`
- Restrictions and notes: an exact-key preset is narrower than a trait group or `num_of_bad_genetic_traits`. `has_inactive_trait` is a separate construct and is not implied by `has_trait`.

### Character event conditional description segments

- Status: `VERIFIED`
- Category: event fields and dynamic description control structure
- CK3 version: `1.19.0.6`
- File family: `events/*.txt`
- Enclosing context: a `type = character_event` event definition
- Input scope: event root plus inherited saved scopes
- Output scope or state change: no gameplay state change; composes event title/description/portrait/options
- Arguments: verified event fields include `title`, `desc`, `theme`, portraits, and `option`; sibling `triggered_desc` blocks append every matching reason, while `first_valid` chooses one mutually exclusive status
- Evidence: `events/court_position_management_events.txt:1-145`; `events/decisions_events/major_decisions_events.txt`, `major_decisions.0501`; `events/activities/chariot_race_activity/chariot_race_ongoing_events.txt:4509-4525`
- Minimal verified example: `desc = { desc = base_desc triggered_desc = { trigger = { scope:candidate = { has_trait = inbred } } desc = inbred_reason } }`
- Restrictions and notes: do not wrap reasons that must all display in one `first_valid`. Event confirmation uses an ordinary option; no event-level `confirm_text` field is inferred.

### Saved-character event localisation

- Status: `VERIFIED`
- Category: localisation functions and saved-scope access
- CK3 version: `1.19.0.6`
- File family: CK3 localisation `.yml` referenced by events
- Enclosing context: quoted localisation value under the correct language header
- Input scope: event root plus a saved character scope such as `candidate`
- Output scope or state change: rendered text only
- Arguments: `[candidate.GetShortUIName]`, `[candidate.GetAge]`, `[ROOT.Char.Custom2('RelationToMe', SCOPE.sC('candidate'))]`, and `[GetTrait('<exact_key>').GetName( GetNullCharacter )]`
- Evidence: `localization/english/event_localization/lifestyle/statecraft/diplomacy_family_events_l_english.yml`; `localization/english/dlc/ach/dlc_ach_coronation_prelude_events_l_english.yml`; `localization/english/event_localization/religion_events/other_doctrine_events_l_english.yml`; `localization/english/destiny_values_l_english.yml:114-166`
- Minimal verified example: `"[candidate.GetShortUIName], age [candidate.GetAge], is my [ROOT.Char.Custom2('RelationToMe', SCOPE.sC('candidate'))]."`
- Restrictions and notes: localisation uses the saved alias `candidate`, not `scope:candidate`. Do not invent a descendant-count getter or access `candidate.GetPrimaryTitle` without a landed guard.

### Guarded saved-character primary-title localisation

- Status: `VERIFIED`
- Category: localisation function on a saved character scope
- CK3 version: `1.19.0.6`
- File family: CK3 localisation `.yml` referenced from a conditional event-description branch
- Enclosing context: quoted localisation value rendered only after a character-scoped landed check succeeds
- Input scope: a saved landed character scope
- Output scope or state change: renders the character's primary title name; no gameplay state change
- Arguments: `[saved_character.GetPrimaryTitle.GetName]`
- Evidence: base accessor form `[CHARACTER.GetPrimaryTitle.GetName]` in `localization/english/character_l_english.yml:10`; saved-character localisation access is independently verified by the **Saved-character event localisation** entry
- Minimal verified example: event trigger `scope:candidate = { is_landed = yes }` with guarded text `[candidate.GetPrimaryTitle.GetName]`
- Restrictions and notes: Breed Improved uses this only in the landed branch. Do not evaluate the title accessor for an unlanded character, and do not infer an unguarded nullable-title behavior from this evidence.

### `any_child` existing-child check

- Status: `VERIFIED`
- Category: character iterator and count trigger
- CK3 version: `1.19.0.6`
- File family: character trigger blocks, including event-description triggers
- Enclosing context: character scope
- Input scope: character
- Output scope or state change: boolean; no state change
- Arguments: `even_if_dead = yes` and `count >= 1`
- Evidence: `events/pregnancy_events.txt:977-989`; additional count examples in `events/birth_events.txt:383-421`
- Minimal verified example: `any_child = { even_if_dead = yes count >= 1 }`
- Restrictions and notes: this detects whether at least one legal child scope exists, including deceased children. It is not a descendant iterator and does not provide a verified dynamic descendant-count localisation expression.

### Scope-owned character variables

- Status: `VERIFIED`
- Category: variable effects, trigger access, and stored-scope access
- CK3 version: `1.19.0.6`
- File family: character-scoped events and effects
- Enclosing context: an effect block on the variable-owning character; later trigger/effect blocks on the same owner
- Input scope: character owner plus a character value to store
- Output scope or state change: `set_variable` stores the character reference; `var:<name>` dereferences it; `remove_variable` deletes the variable
- Arguments: `set_variable = { name = <static_name> value = <character_scope> }`, `exists = var:<static_name>`, `var:<static_name> = { ... }`, and guarded `remove_variable = <static_name>`
- Evidence: `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167`; guarded removal at `events/relations_events/adultery_events.txt:2696-2700`
- Minimal verified example: `set_variable = { name = stored_character value = scope:target }`, later `exists = var:stored_character`
- Restrictions and notes: the owner and every static variable name must be known. Guard every removal with `exists = var:<static_name>`; safety of removing an absent variable is not established by the cited evidence. The examples establish later dereferencing in event script; they do not prove the complete Phase 3 multi-event or save/reload lifetime.

### Character-reference equality through a variable

- Status: `VERIFIED`
- Category: stored character-reference trigger comparison
- CK3 version: `1.19.0.6`
- File family: character-scoped event triggers and triggered descriptions
- Enclosing context: the character that owns the variable is current scope
- Input scope: variable-owning character and expected character scope
- Output scope or state change: boolean identity result; no state change
- Arguments: `var:<static_name> = <character_scope>`
- Evidence: `events/board_game_events.txt:1173-1187`
- Minimal verified example: `var:stored_character = scope:expected_character`
- Restrictions and notes: existence should be checked before equality. This establishes the identity comparison needed to search subject and partner roles; it does not make a six-field slot atomic.

### Scope-owned Dynasty variables and equality

- Status: `VERIFIED COMPONENTS; PROPOSED ACTOR-OWNED LIFETIME REQUIRES PROTOTYPE`
- Category: typed scope-variable storage, dereference, and identity comparison
- CK3 version: `1.19.0.6`
- File family: event effects, artifact effects, and later trigger blocks on the same variable owner
- Enclosing context: an effect on the variable-owning scope followed by a trigger or effect that can access the same owner
- Input scope: variable owner plus a valid Dynasty scope
- Output scope or state change: stores a typed Dynasty reference and later compares or enters that Dynasty; no Dynasty gameplay mutation
- Arguments: `set_variable = { name = <name> value = <character_scope>.dynasty }`, `exists = var:<name>`, and `var:<name> = <dynasty_scope>`
- Evidence: Dynasty storage at `events/interaction_events/adoption_events.txt:83-98`; artifact-owned Dynasty storage at `common/scripted_effects/01_ep1_court_artifact_creation_effects.txt:1469-1476`; equality and dereference at `events/court_maintenance_events.txt:597-618,663-680` and `common/character_interactions/00_artifact_interactions.txt:4046-4077`
- Minimal verified example: `set_variable = { name = recorded_dynasty value = scope:actor.dynasty }`, later guarded by `exists = var:recorded_dynasty` before `var:recorded_dynasty = scope:actor.dynasty`
- Restrictions and notes: the cited storage owners are memories and artifacts, while the Phase 3 composition stores the Dynasty on the workflow actor. Typed Dynasty storage and equality are verified variable primitives, but the proposed actor-owned, multi-event, save/reload lifetime remains a P6 runtime gate. Always verify that the actor is highborn and that both the saved variable and the comparison Dynasty exist.

### Flag-valued variables and equality

- Status: `VERIFIED`
- Category: variable effect and trigger comparison
- CK3 version: `1.19.0.6`
- File family: character-scoped events and effects
- Enclosing context: an effect block on the variable owner and a later trigger on that owner
- Input scope: character owner
- Output scope or state change: stores a flag value and later compares the stored value with an expected flag
- Arguments: `set_variable = { name = <static_name> value = flag:<value> }` and `<character_scope>.var:<static_name> = flag:<value>`
- Evidence: `events/board_game_events.txt:61-82,170-180`
- Minimal verified example: `set_variable = { name = result value = flag:success }`
- Restrictions and notes: this verifies enum-like flag values. It does not make a multi-field record atomic. Breed Improved's Phase 3 reservation marker must be written last and checked with every other required field.

### Parameter-expanded variable names and flag enum values

- Status: `VERIFIED`
- Category: scripted-effect argument substitution
- CK3 version: `1.19.0.6`
- File family: parameterized scripted effects and their explicit callers
- Enclosing context: a scripted-effect definition that consumes a caller-supplied token
- Input scope: the scripted effect's current scope plus fixed caller arguments
- Output scope or state change: resolves a variable name or flag enum token before applying the enclosed verified variable operation
- Arguments: embedded name form such as `name = education_$SKILL$_variable`; whole flag-token form such as `value = flag:$POS$`
- Evidence: embedded variable-name parameter and five explicit calls at `events/culture_events/culture_tradition_events.txt:844-873`; parameter-expanded flag value at `events/court_events/01_ep3_court_events.txt:3263-3280`; additional flag parameter and call evidence at `events/board_game_events.txt:29-44,1948-1951`
- Minimal verified example: define `name = pair_$SLOT$_subject` and call the scripted effect with a fixed approved `SLOT = 1`; pass a complete approved flag token through `value = flag:$ENUM$`
- Restrictions and notes: this is scripted-argument expansion from explicit call-site tokens, not runtime string construction, array indexing, or player-supplied data. Phase 3 may call helpers only with the fixed whitelisted slots `1` through `16` and complete approved enum tokens. The evidence verifies an embedded variable-name parameter and a whole flag-token parameter separately; do not invent an unevidenced embedded form such as `flag:prefix_$SLOT$` when the complete prefixed token can be passed as `$ENUM$`.

### Numeric scope variables and `change_variable`

- Status: `VERIFIED`
- Category: numeric variable initialization and mutation
- CK3 version: `1.19.0.6`
- File family: event and scripted-effect blocks on a variable-owning scope
- Enclosing context: effect block on the same owner that stores and later changes the numeric variable
- Input scope: variable owner and numeric value
- Output scope or state change: initializes or increments/decrements a numeric variable
- Arguments: `set_variable = { name = <name> value = <number> }` followed by `change_variable = { name = <name> add = <number_or_formula> }`; a parameterized scripted effect may use `value = $VALUE$` when its explicit caller supplies a numeric token
- Evidence: initialization to zero and later `add = 1` or `add = -1` at `events/court_events/introduce_court_fashion_events.txt:84-109,157-175`; parameter-expanded fixed name at `events/culture_events/culture_tradition_events.txt:844-858`; numeric `value = $VALUE$` at `common/scripted_effects/00_achievement_effects.txt:33-44` with explicit numeric caller at `common/on_action/game_start.txt:5333-5339`
- Minimal verified example: initialize `accepted_pair_count` to `0`, then `change_variable = { name = accepted_pair_count add = 1 }`; for a diagnostic assignment, call a fixed helper with `VALUE = 1` and store `value = $VALUE$`
- Restrictions and notes: initialize the numeric variable before changing it. This verifies bounded counters, not an atomic transaction with the six pair fields. Counter/record agreement after interruption and save/reload remains a P6 runtime test.

### Global character variables and identity

- Status: `VERIFIED`
- Category: global-variable effects, existence trigger, and stored-scope access
- CK3 version: `1.19.0.6`
- File family: Decisions, events, scripted effects, and on_action effects
- Enclosing context: an effect or trigger block
- Input scope: any context with access to the character or flag value being stored
- Output scope or state change: stores globally addressable character state; direct equality compares its identity; a block enters the stored character; guarded `remove_global_variable` deletes it
- Arguments: `set_global_variable = { name = <static_name> value = <character_scope> }`, `exists = global_var:<static_name>`, `global_var:<static_name> = <character_scope>`, `global_var:<static_name> = { ... }`, and guarded `remove_global_variable = <static_name>`
- Evidence: `common/decisions/00_major_decisions_iberia_north_africa.txt:243-249`; direct identity at `events/dlc/ep1/ep1_fund_inspiration_events.txt:945-956`; entered scope at `events/religion_events/great_holy_war_events.txt:818-824`; guarded removal at `events/dlc/ep3/ep3_frankokratia_events.txt:4255-4266`
- Minimal verified example: `set_global_variable = { name = active_actor value = scope:actor }`
- Restrictions and notes: guard removal with an existence check. The Phase 3 prototype may use one global actor pointer only after P1 approval. Save/reload persistence and cleanup timing remain runtime tests.

### Global flag-valued phase and equality

- Status: `VERIFIED`
- Category: global variable effect and trigger comparison
- CK3 version: `1.19.0.6`
- File family: scripted effects, script values, Decisions, events, and on_actions
- Enclosing context: an effect that stores a phase and a later trigger that checks it
- Input scope: global variable name plus a flag value
- Output scope or state change: stores a global flag or returns a boolean equality result
- Arguments: `set_global_variable = { name = <static_name> value = flag:<value> }` and `global_var:<static_name> = flag:<value>`
- Evidence: set at `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:249-254`; compare at `common/script_values/99_steward_values.txt:694-698`
- Minimal verified example: `global_var:active_phase = flag:review`
- Restrictions and notes: existence should be checked before equality. This verifies a phase component, not the combined workflow lifecycle.

### Permanent global one-workflow-per-save lock

- Status: `VERIFIED COMPONENTS; SAVE/RELOAD PERSISTENCE REQUIRES P6`
- Category: global scalar/flag marker, existence guard, and project lifecycle policy
- CK3 version: `1.19.0.6`
- File family: Decisions, events, scripted effects, on_actions, and achievement triggers
- Enclosing context: a pre-activation trigger checks nonexistence; the explicit entry-confirmation option calls an activation effect that sets the global marker first; no approved cleanup path removes it
- Input scope: global variable name and a fixed marker value
- Output scope or state change: consumes the isolated prototype's only activation opportunity in the current save
- Arguments: `NOT = { exists = global_var:<lock_name> }` followed by `set_global_variable = { name = <lock_name> value = yes }`; the independently verified enum form may instead store `value = flag:<fixed_value>`
- Evidence: same-event nonexistence guard and set-to-`yes` once-only patterns at `events/yearly_events/yearly_events_3.txt:3337-3350,3432-3448`; long-lived achievement-global set and later existence check at `common/scripted_effects/00_achievement_effects.txt:33-44`, `common/on_action/game_start.txt:5039-5042`, and `common/achievements/fp1_achievements.txt:1-4`; global `flag:` storage and equality at `common/scripted_effects/05_dlc_fp3_scripted_effects.txt:23-28` and `common/scripted_triggers/06_fp3_scripted_triggers.txt:206-211`
- Minimal verified example: reject activation while `exists = global_var:prototype_lock`; from the explicit confirmation option, set the lock before creating coordinator state or scanning candidates; never call `remove_global_variable` for that lock
- Restrictions and notes: “never clear the lock” is the approved Breed Improved isolated-prototype policy, not a separate CK3 command. The lock is only an activation barrier and never grants workflow authority. Opening the Decision or cancelling its entry-confirmation event must not set it. Static script proves the guard/set design, but save serialization, persistence after reload, and every UI lifecycle path require P6. This lock deliberately prevents every second workflow in the same save after completion, cancellation, failure, actor death, Dynast loss, or an orphaned visible event.

### Dynasty scope capture with `save_scope_as`

- Status: `VERIFIED`
- Category: Dynasty scope link and saved-scope effect
- CK3 version: `1.19.0.6`
- File family: events and effect blocks
- Enclosing context: character scope with a valid `dynasty` scope link, followed by a Dynasty-scoped effect block
- Input scope: highborn character with a Dynasty
- Output scope or state change: saves the current Dynasty scope under a named event scope
- Arguments: `dynasty = { save_scope_as = <name> }`
- Evidence: `events/court_maintenance_events.txt:609`; `events/religion_events/faith_conversion_events.txt:339-340`
- Minimal verified example: `dynasty = { save_scope_as = workflow_dynasty }`
- Restrictions and notes: exact scope capture is verified. Continuity across a long visible-event chain and save/reload remains a runtime prototype question. If a visible event closes unexpectedly, no generic close callback or immediate cleanup is claimed; the approved isolated-prototype result is an orphaned, permanently locked workflow with no resume, reauthorization, delayed execution, or background execution.

### Event namespace declaration and namespaced numeric ID

- Status: `VERIFIED`
- Category: event file structure
- CK3 version: `1.19.0.6`
- File family: `events/*.txt`
- Enclosing context: namespace declaration at the event file top level and event definitions in the same file
- Input scope: not applicable
- Output scope or state change: registers the namespace and its event IDs
- Arguments: `namespace = <namespace>` followed by `<namespace>.<numeric_id> = { ... }`
- Evidence: `events/_events.info:5-10`; existing project events in `MyCK3Mod/events/breedimp_dynasty_cleanup_events.txt`
- Minimal verified example: `namespace = my_events`, followed by `my_events.1001 = { type = character_event ... }`
- Restrictions and notes: the approved Phase 3 isolated-prototype namespace is `breedimp_p3_proto_matchmaking`, range `1000`-`1199`. P0 is corrected and closed; P1-P5 are static-complete, but runtime remains `NOT RUN`.

### Generic event fields and player options

- Status: `VERIFIED`
- Category: event definition schema
- CK3 version: `1.19.0.6`
- File family: `events/*.txt`
- Enclosing context: top level of a namespaced event definition
- Input scope: event root, whose default is character unless overridden
- Output scope or state change: declares event type/scope, text, trigger/effect phases, visibility, and player options
- Arguments: verified fields include `type`, `scope`, `title`, `desc`, `trigger`, `immediate`, `after`, `hidden`, `left_portrait`, `right_portrait`, and `option = { name = <key> ... }`; exact vanilla character events also use `theme = dynasty`
- Evidence: core fields and options at `events/_events.info:10-38,156-164`; portrait blocks at `events/_events.info:54-96`; exact `theme = dynasty` at `events/decisions_events/major_decisions_events.txt:433`
- Minimal verified example: `type = character_event`, `theme = dynasty`, `left_portrait = { character = root }`, `trigger = { ... }`, and `option = { name = my_option ... }`
- Restrictions and notes: this is static schema evidence only. It establishes neither window lifecycle callbacks nor save/reload continuity.

### Event `on_trigger_fail`

- Status: `VERIFIED`
- Category: event effect field
- CK3 version: `1.19.0.6`
- File family: `events/*.txt`
- Enclosing context: top level of an event definition
- Input scope: the event context available when a queued or instant event fails trigger checks
- Output scope or state change: runs the enclosed effects after that documented trigger failure
- Arguments: an effect block
- Evidence: `events/_events.info:125-129`; exact vanilla use at `events/board_game_events.txt:1902-1910`
- Minimal verified example: `on_trigger_fail = { <verified cleanup effect> }`
- Restrictions and notes: the schema explicitly limits the field to queued/instant event trigger failure. It is not evidence for a generic callback when a player closes an already displayed event.

### Mod-safe on_action child registration

- Status: `VERIFIED`
- Category: on_action file structure and composition
- CK3 version: `1.19.0.6`
- File family: `common/on_action/*.txt`
- Enclosing context: top-level named on_action definitions
- Input scope: inherited from the vanilla parent on_action
- Output scope or state change: appends a Mod-owned child on_action without replacing the vanilla parent effect
- Arguments: `<vanilla_on_action> = { on_actions = { <mod_child> } }`; the child may contain one verified `effect` block
- Evidence: `common/on_action/_on_actions.info:102-117`
- Minimal verified example: `on_death = { on_actions = { my_death_cleanup } }`
- Restrictions and notes: do not add a second `effect` or `trigger` block directly to a named vanilla on_action that already owns one. Every inherited scope must be verified against that parent.

### `on_death` character context

- Status: `VERIFIED`
- Category: code-triggered on_action
- CK3 version: `1.19.0.6`
- File family: `common/on_action/*.txt`
- Enclosing context: the named `on_death` on_action or a Mod child invoked from it
- Input scope: root is the character just about to die; optional `scope:killer` exists when known
- Output scope or state change: runs on_action effects before the character is fully dead
- Arguments: no caller arguments; code-triggered
- Evidence: `common/on_action/death.txt:1-6`
- Minimal verified example: a Mod child registered through the independently verified `on_actions` composition
- Restrictions and notes: the exact point at which a complete Phase 3 coordinator and actor-owned slots can be cleaned requires runtime testing. This evidence does not authorize recurring death scans.

### `on_became_dynasty_head` context

- Status: `VERIFIED`
- Category: code-triggered on_action
- CK3 version: `1.19.0.6`
- File family: `common/on_action/*.txt`
- Enclosing context: the named `on_became_dynasty_head` on_action or a Mod child invoked from it
- Input scope: root is the new Dynast; `scope:dynasty` is the affected Dynasty
- Output scope or state change: runs effects for that Dynasty-head change
- Arguments: no caller arguments; code-triggered
- Evidence: `common/on_action/dynasty_on_actions.txt:13-17`
- Minimal verified example: a Mod child registered through the independently verified `on_actions` composition
- Restrictions and notes: no former-Dynast scope is documented. No `on_lost_dynasty_head` or generic Dynasty-change on_action was found in the same-version files. Coverage of every engine cause of Dynast transfer requires runtime testing.

### `on_game_start_after_lobby`

- Status: `VERIFIED`
- Category: code-triggered on_action
- CK3 version: `1.19.0.6`
- File family: `common/on_action/*.txt`
- Enclosing context: the named on_action or a Mod child invoked from it
- Input scope: game-start context after the host or single player exits the lobby
- Output scope or state change: runs enclosed effects once at that documented point
- Arguments: no caller arguments; code-triggered
- Evidence: `common/on_action/game_start.txt:2590-2592`
- Minimal verified example: a Mod child registered through the independently verified `on_actions` composition
- Restrictions and notes: static evidence does not establish exact ordering for every save/reload path or an already open Phase 3 event chain.

### `can_marry_character_trigger`

- Status: `VERIFIED`
- Category: parameterized scripted character trigger
- CK3 version: `1.19.0.6`
- File family: definition in `common/scripted_triggers/00_marriage_triggers.txt`; supported character-trigger callers
- Enclosing context: character scope with the proposed partner passed through `CHARACTER`
- Input scope: one character as current scope and one character argument
- Output scope or state change: boolean current-availability and pair-legality result; no state change
- Arguments: `can_marry_character_trigger = { CHARACTER = <character_scope> }`
- Evidence: definition at `common/scripted_triggers/00_marriage_triggers.txt:183-212`; use for marriage and betrothal validation at `:412-427`
- Minimal verified example: `can_marry_character_trigger = { CHARACTER = scope:partner }`
- Restrictions and notes: the trigger delegates gender, recent-divorce, allowed-marriage, and consanguinity checks to `could_marry_character_trigger`. Its availability branch also permits a pair already betrothed to each other, so it is not sufficient by itself to prove that both participants are unbetrothed. The Phase 3 Dynast override bypasses matchmaker authority only; it must not bypass this trigger, the independent relationship-availability checks below, or approved product safeguards.

### Independent `is_married` and `is_betrothed` availability checks

- Status: `VERIFIED`
- Category: character triggers
- CK3 version: `1.19.0.6`
- File family: event, Decision, scripted-trigger, and interaction trigger blocks
- Enclosing context: each proposed participant's character scope
- Input scope: character
- Output scope or state change: boolean current relationship state; no state change
- Arguments: `is_married = no` and `is_betrothed = no`
- Evidence: both checks together at `events/activities/tournaments/tournament_events.txt:4819-4824`
- Minimal verified example: `is_betrothed = no` followed by `is_married = no`
- Restrictions and notes: the approved Phase 3 policy requires both checks on both participants in addition to `can_marry_character_trigger`.

### Phase 3 conservative special-state exclusions

- Status: `VERIFIED TRIGGER SYNTAX; PROTOTYPE-ONLY POLICY`
- Category: character triggers
- CK3 version: `1.19.0.6`
- File family: character interactions, scripted triggers, and event trigger blocks
- Enclosing context: each proposed participant's character scope during candidate filtering and final preflight
- Input scope: character
- Output scope or state change: boolean current-state result; no state change
- Arguments: `is_imprisoned = no`, `is_hostage = no`, `is_concubine = no`, and `is_pregnant = no`
- Evidence: `is_imprisoned = no` for marriage-interaction participants at `common/character_interactions/00_marriage_interactions.txt:514-540`; `is_hostage = no` at `common/scripted_triggers/00_marriage_triggers.txt:536-544`; `is_concubine = no` at `common/scripted_triggers/00_marriage_triggers.txt:244-252,274-282`; `is_pregnant = no` at `events/dlc/ep3/ep3_wedding_events.txt:2055-2061`
- Minimal verified example: apply all four negative checks directly in the proposed participant's character scope
- Restrictions and notes: the four trigger forms are verified individually. Their combined use is a conservative isolated-prototype supported-class boundary, not a claim that vanilla marriage universally requires all four and not a final production policy. Do not infer unregistered activity, government, adventurer, or other special-state triggers from this entry.

### Character sex and numeric age checks

- Status: `VERIFIED TRIGGER SYNTAX; PROJECT AGE POLICY`
- Category: character triggers
- CK3 version: `1.19.0.6`
- File family: marriage scripted triggers, marriage interactions, events, and scripted triggers
- Enclosing context: proposed participant's character scope
- Input scope: character
- Output scope or state change: boolean sex or age-threshold result; no state change
- Arguments: `is_female = yes`, `is_male = yes`, and numeric comparisons such as `age >= 30`
- Evidence: sex checks in marriage validation at `common/scripted_triggers/00_marriage_triggers.txt:484-493`; numeric age comparison in marriage-interaction evaluation at `common/character_interactions/00_marriage_interactions.txt:3456-3463`
- Minimal verified example: `AND = { is_female = yes age >= 30 }`
- Restrictions and notes: the trigger syntax is verified. The Phase 3 rules forbidding a woman aged 30 or older or a man aged 40 or older from pairing with any minor are approved Breed Improved prototype policy, not vanilla thresholds. Both role directions must be checked; fertility and ranking cannot override the hard exclusion.

### Character `fertility` value

- Status: `VERIFIED`
- Category: character numeric value and numeric trigger
- CK3 version: `1.19.0.6`
- File family: numeric value blocks, scripted values, Decisions, and event trigger modifiers
- Enclosing context: character evaluation scope
- Input scope: character
- Output scope or state change: returns or compares the character's evaluated fertility; no state change
- Arguments: bare numeric value `fertility` or a comparison such as `fertility <= 0`
- Evidence: `common/decisions/90_minor_decisions.txt:1669-1677`; `events/health_events.txt:12544-12548`
- Minimal verified example: `value = fertility`
- Restrictions and notes: values may require handling below zero or above `1.0`. The full dynamic best-minus-`0.05` tier, capture lifetime, inclusive boundary, and presentation remain prototype tests.

### `age_difference` and `ordered_in_list`

- Status: `VERIFIED`
- Category: scripted numeric value and ordered event-list iterator
- CK3 version: `1.19.0.6`
- File family: `common/script_values/*.txt` and effect blocks using an event-target list
- Enclosing context: character scope with `scope:comparator`; ordered iteration over a previously built list
- Input scope: current character and comparator for `age_difference`; list members for `ordered_in_list`
- Output scope or state change: returns a negative absolute age difference and orders list members by a numeric value
- Arguments: `age_difference` reads `scope:comparator`; verified iterator fields include `list`, `order_by`, `max`, and `check_range_bounds`
- Evidence: `common/script_values/00_age_values.txt:82-88`; `events/diarchy_events/vizierate_events.txt:200-229`
- Minimal verified example: `ordered_in_list = { list = candidates order_by = age_difference }`
- Restrictions and notes: component syntax is verified, but the complete Phase 3 lexicographic pipeline and deterministic tie behavior require the isolated prototype.

### Dynamic best-minus-`0.05` fertility threshold composition

- Status: `VERIFIED COMPONENTS; COMPLETE COMPOSITION REQUIRES P6`
- Category: character numeric value, saved numeric event-scope values, formula arithmetic, numeric comparison, and ordered-list selection
- CK3 version: `1.19.0.6`
- File family: event effects/triggers, numeric formula blocks, and ordered event-target lists
- Enclosing context: an active event chain with the required saved numeric values in scope
- Input scope: fertility-evaluated characters, a captured best value, and candidate numeric values
- Output scope or state change: derives and checks a dynamic lower threshold; no relationship or character state change
- Arguments: verified components include `value = fertility`, `save_scope_value_as`, formula `subtract`, saved numeric comparison such as `scope:left < scope:right`, and `ordered_in_list` with numeric `order_by`
- Evidence: fertility capture at `common/decisions/90_minor_decisions.txt:1669-1677`; numeric formula derivation and saved-value reuse at `events/decisions_events/pledge_loyalty_to_liege_events.txt:190-211`; saved numeric-to-numeric comparison at `events/decisions_events/pledge_loyalty_to_liege_events.txt:454-466`; subtraction formula at `common/script_values/00_age_values.txt:82-88`; ordered numeric list evaluation at `events/diarchy_events/vizierate_events.txt:200-229,1105-1113`
- Minimal verified example: none for the complete fertility pipeline; the isolated prototype composes the registered primitives to capture the best fertility, derive a floor five percentage points lower, and compare candidate values with that floor
- Restrictions and notes: no same-version vanilla block was found that performs the entire fertility maximum → subtract `0.05` → inclusive candidate comparison pipeline. Scope-value lifetime, inclusive boundary behavior, ties, values outside `0`-`1`, and deterministic ordering remain P6 runtime gates. Do not describe the full composition as vanilla-proven.

### Remove current scope from an event-target list

- Status: `VERIFIED`
- Category: event-target list mutation
- CK3 version: `1.19.0.6`
- File family: event and scripted-effect blocks using event-target lists
- Enclosing context: a typed current scope that is already a member of the named list
- Input scope: current typed list member and list name
- Output scope or state change: removes the current scope from that event-target list
- Arguments: `remove_from_list = <list_name>`
- Evidence: candidates are added to `students`, iterated, and removed from the same list at `events/court_events/01_ep3_court_events.txt:475-502`
- Minimal verified example: inside the current candidate scope, `remove_from_list = available_partners`
- Restrictions and notes: the exact evidence removes the current scope, not an arbitrary separately supplied target. Event-target list persistence across the complete Phase 3 event chain and save/reload remains a P6 runtime test.

### Direct marriage and betrothal effects

- Status: `VERIFIED`
- Category: character relationship effects
- CK3 version: `1.19.0.6`
- File family: event and scripted-effect character effect blocks
- Enclosing context: the first participant is current character scope; the effect value is the second participant character scope
- Input scope: character plus character target
- Output scope or state change: creates the requested ordinary/matrilineal marriage or betrothal relationship
- Arguments: `marry = <character_scope>`, `marry_matrilineal = <character_scope>`, `create_betrothal = <character_scope>`, or `create_betrothal_matrilineal = <character_scope>`
- Evidence: ordinary/matrilineal marriage at `common/scripted_effects/00_game_rule_effects.txt:22-28`; ordinary/matrilineal betrothal at `common/scripted_effects/04_dlc_ep2_wedding_effects.txt:97-111`; adult/minor execution branch at `events/activities/tournaments/tournament_events.txt:1159-1177`
- Minimal verified example: `scope:subject = { marry = scope:partner }`
- Restrictions and notes: each individual operation exists. Static evidence does not prove parity with the native arrange-marriage interaction for alliances, Prestige, court movement, succession, memories, on_actions, or other side effects. The isolated P4 test path now calls exactly these four operations only after full preflight; CK3 runtime remains `NOT RUN`, and no production use is approved.

### Global numeric serial components

- Status: `UNVERIFIED` for the proposed run-identity combination
- Category: global numeric-variable effects and saved numeric scope value
- CK3 version: `1.19.0.6`
- File family: events and Decisions
- Enclosing context: effect blocks
- Input scope: context with access to the global numeric variable
- Output scope or state change: `change_global_variable` can increment a global number; `save_scope_value_as` can copy a global numeric value into an event scope value
- Arguments: verified components are `change_global_variable = { name = <name> add = 1 }` and `save_scope_value_as = { name = <name> value = global_var:<name> }`
- Evidence: `events/religion_events/great_holy_war_events.txt:618-621`; `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4410-4413`
- Minimal verified example: none approved for Phase 3
- Restrictions and notes: no same-context CK3 `1.19.0.6` example was found for comparing the saved numeric scope value with the active global serial. `UNVERIFIED CK3 SYNTAX`: do not implement a Phase 3 numeric run identity. The isolated prototype closes this dependency with the narrower permanent one-workflow-per-save lock; it does not convert numeric run identity into verified syntax.

### Phase 3 fixed-slot commit protocol

- Status: `VERIFIED COMPONENTS; COMPOSED LIFECYCLE REQUIRES PROTOTYPE`
- Category: project storage design composed from verified character variables
- CK3 version: `1.19.0.6`
- File family: isolated-prototype Decision/event/effect contexts only
- Enclosing context: the recorded workflow actor owns sixteen explicitly named slots
- Input scope: actor, subject, partner, and three approved enum-like flag values
- Output scope or state change: one committed pair record per slot
- Arguments: six static variables per slot: `subject`, `partner`, `direction`, `relationship_type`, `placeholder`, and slot-specific `reservation_id`
- Evidence: character storage at `events/yearly_events/bp1_yearly_james.txt:1067-1071,1153-1167`; character identity at `events/board_game_events.txt:1173-1187`; flag values at `events/board_game_events.txt:61-82,170-180`; parameter-expanded fixed names at `events/culture_events/culture_tradition_events.txt:844-873`; numeric counter evidence at `events/court_events/introduce_court_fashion_events.txt:84-109,157-175`; guarded removal at `events/relations_events/adultery_events.txt:2696-2700`
- Minimal verified example: none; this is a composed project protocol, not a vanilla command
- Restrictions and notes: write `reservation_id` last as a second character reference to that slot's `subject`. A slot is committed only if the two character references compare equal, all five payload fields exist, and all enum values are approved. Parameterized helpers may address only explicitly whitelisted slot names and complete enum tokens; they do not create a runtime array or an embedded parameterized flag name. Guard every field removal with `exists`. Multi-variable atomicity, interrupted writes, cross-event persistence, count/record agreement, and save/reload behavior require P6.

### Event localisation access to ROOT-owned character, numeric, and flag variables

- Status: `VERIFIED`
- Category: event localisation variable access
- CK3 version: `1.19.0.6`
- File family: character events plus referenced English localisation `.yml`
- Enclosing context: a character event whose `ROOT` is the character that owns the stored variable
- Input scope: character event ROOT and an existing character-, numeric-, or flag-valued variable on that character
- Output scope or state change: renders the stored character, number, or localised flag name; no gameplay state change
- Arguments: verified chains include `[ROOT.Char.MakeScope.Var('<name>').Char.GetShortUIName]`, `[ROOT.Char.MakeScope.Var('<name>').GetValue]`, and `[ROOT.Char.MakeScope.Var('<name>').GetFlagName]`
- Evidence: exact `ROOT.Char.MakeScope.Var(...).GetValue` at `localization/english/dlc/ach/dlc_ach_coronation_events_klank_l_english.yml:137,143`; exact `ROOT.Char.MakeScope.Var(...).GetFlagName` at `localization/english/dlc/ce1/ce1_legend_spread_events_l_english.yml:609-610`; exact `ROOT.Char.MakeScope.Var(...).Char` character access at `localization/english/dlc/bp3/bp3_experimental_brew_l_english.yml:14,20,25,32`; exact `MakeScope.Var(...).Char.GetShortUIName` at `localization/english/decisions_l_english.yml:135-136`; direct saved-scope `GetShortUIName` is independently registered above
- Minimal verified example: `[ROOT.Char.MakeScope.Var('stored_character').Char.GetShortUIName]`
- Restrictions and notes: the complete `ROOT.Char.MakeScope.Var(...).Char.GetShortUIName` expression is a composition of the exact ROOT/variable/character chain and the exact verified character function; runtime rendering remains a P6 check. `ROOT` is not automatically synonymous with a Decision actor or interaction actor. The event scope contract must make the variable-owning workflow actor ROOT, and script must guard variable existence before selecting localisation that dereferences it. Do not guess additional `.Var`, `.Char`, or rendering functions.

### Standalone test Mod descriptor pair

- Status: `VERIFIED`
- Category: project file structure and launcher metadata
- CK3 version: `1.19.0.6`
- File family: one outer `.mod` launcher template plus an inner `descriptor.mod` at the test Mod content root
- Enclosing context: repository-owned standalone test harness
- Input scope: not applicable
- Output scope or state change: launcher metadata only
- Arguments: verified fields are `version`, `name`, and `supported_version`; only the outer local launcher template contains `path="<LOCAL_MOD_PATH>"`
- Evidence: `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod`; `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod`; current isolated descriptors at `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype.mod` and `tests/phase3_dynasty_matchmaking/BreedImprovedPhase3Prototype/descriptor.mod`
- Minimal verified example: outer template with `path="<LOCAL_MOD_PATH>"`, inner descriptor without `path`
- Restrictions and notes: the Phase 3 isolated-prototype descriptors use version `0.1.0`, compatibility `1.19.*`, no Workshop ID, and no absolute committed path. They are test-only and excluded from production and Workshop packaging.

### Standalone test Mod localisation contract

- Status: `VERIFIED PROJECT CONVENTION`
- Category: localisation file header, bilingual key parity, and encoding
- CK3 version: `1.19.0.6`
- File family: `localization/english/*.yml` and `localization/simp_chinese/*.yml`
- Enclosing context: test-only Mod content root
- Input scope: not applicable
- Output scope or state change: localised player-facing strings only
- Arguments: first-line headers `l_english:` and `l_simp_chinese:`; identical key sets; UTF-8 BOM
- Evidence: `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml`; `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml`
- Minimal verified example: one BOM-prefixed file beginning with `l_english:`
- Restrictions and notes: UTF-8 BOM is an observed vanilla property and an established project convention, not an asserted universal engine requirement. The isolated prototype's English and Simplified Chinese files follow this project convention; runtime rendering remains `NOT RUN`.

## Uncertainty Protocol

When a required element is absent from the verified registry and cannot be confirmed from a higher-priority source:

1. Stop before writing the element into a runnable file.
2. Report `UNVERIFIED CK3 SYNTAX: <specific uncertainty>`.
3. State the missing version, scope, file-context, or source evidence.
4. Request a project example, same-version vanilla CK3 file, or version-matched official reference.
5. Keep any sketch separate and label it `PSEUDOCODE - NOT VALIDATED FOR CK3`.
