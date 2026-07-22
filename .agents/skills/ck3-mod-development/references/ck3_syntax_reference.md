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
- Output scope or state change: `trigger_event = <namespace.id>` opens the referenced event for the Decision taker
- Arguments: verified fields include `title`, `picture`, `selection_tooltip`, `desc`, `confirm_text`, `sort_order`, `is_shown`, `is_valid_showing_failures_only`, `is_valid`, `effect`, `ai_check_interval`, `ai_potential`, and `ai_will_do`; `ai_check_interval = 0` disables AI checking
- Evidence: `common/decisions/_decisions.info:125-143`; `common/decisions/80_major_decisions.txt`, `strengthen_bloodline_decision`; `common/decisions/00_diarchy_decisions.txt`; `common/decisions/00_dynasty_decisions.txt`
- Minimal verified example: `effect = { trigger_event = my_namespace.1000 }`
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

## Uncertainty Protocol

When a required element is absent from the verified registry and cannot be confirmed from a higher-priority source:

1. Stop before writing the element into a runnable file.
2. Report `UNVERIFIED CK3 SYNTAX: <specific uncertainty>`.
3. State the missing version, scope, file-context, or source evidence.
4. Request a project example, same-version vanilla CK3 file, or version-matched official reference.
5. Keep any sketch separate and label it `PSEUDOCODE - NOT VALIDATED FOR CK3`.
