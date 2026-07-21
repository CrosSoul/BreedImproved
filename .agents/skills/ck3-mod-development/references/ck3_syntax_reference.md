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

## Uncertainty Protocol

When a required element is absent from the verified registry and cannot be confirmed from a higher-priority source:

1. Stop before writing the element into a runnable file.
2. Report `UNVERIFIED CK3 SYNTAX: <specific uncertainty>`.
3. State the missing version, scope, file-context, or source evidence.
4. Request a project example, same-version vanilla CK3 file, or version-matched official reference.
5. Keep any sketch separate and label it `PSEUDOCODE - NOT VALIDATED FOR CK3`.
