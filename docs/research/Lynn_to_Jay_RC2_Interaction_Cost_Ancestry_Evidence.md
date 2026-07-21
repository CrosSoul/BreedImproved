# Breed Improved RC2 — Interaction, Cost, and Ancestry Evidence

**Target:** CK3 `1.19.0.6` | **Budget:** 15 minutes | **Primary interaction:** `denounce_interaction`

**Product-scope update:** The Boss has superseded the original two-generation proposal. Breed Improved now checks existing script-visible legal parents only. Grandparents are permanently outside the blood-impurity rule; the verified single-level `any_parent` evidence below is the active implementation guidance.

## Implementation-ready conclusion

- Use the ordinary confirmation window; `needs_confirmation` defaults to true.
- Keep all Breed Improved consequences in a visible `scope:recipient` effect. The generic UI creates recipient/actor effect cards only when parsed effects exist for that scope.
- Add no actor effect for presentation. Prestige belongs in top-level `cost`; the UI renders cost separately at the bottom.
- Use native `cost.prestige` with a named conditional scripted value: `0` when `breedimp_recipient_has_blood_impurity_trigger` is true, otherwise `100`.
- Define blood impurity from the public `bastard`/`legitimized_bastard` traits or an existing legal parent outside the actor's Dynasty. Use one `any_parent` level with `even_if_dead = yes`; branch lowborn before Dynasty comparison.

## 1. Confirmation presentation

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Category/scopes/context:** Character Interaction + GUI; actor/recipient named scopes; `on_accept` and generic confirmation window  
**Paths:** `common/character_interactions/00_dynast_interactions.txt:843`; `common/scripted_effects/00_interaction_effects.txt:1773`; `gui/interaction_confirmation.gui:250`; `gui/interaction_templates.gui:1014`  
**Version:** `1.19.0.6`

`denounce_interaction` uses `category = interaction_category_hostile`; its `on_accept` enters `scope:recipient` and calls `denounce_effect`. That effect adds recipient consequences and conditionally enters `$ACTOR$` to `remove_hook` of type `house_head_hook`. The GUI independently tests `HasActorEffects` and `HasRecipientEffects`; each visible card contains that character's portrait. If the hook-removal branch has no result, no actor card is required.

```text
### Actor
vbox_character_interaction_effects_me = {
	visible = "[DisplayedInteractionEffects.HasActorEffects]"
}
### Recipient
vbox_character_interaction_effects_other = {
	visible = "[... DisplayedInteractionEffects.HasRecipientEffects]"
}
```

The generic effects area is shown only when `HasAnyEffects`. There are no vanilla interaction fields named “actor portrait” or “recipient effects” in the schema; the cards are generated from the parsed effect description. `send_option` is not involved. `needs_confirmation` is documented as true when omitted; exact window height is GUI/runtime presentation, not an interaction field.

`category = interaction_category_hostile` is exact. Dynasty classification is contextual: the file is for Dynasty Head interactions, `scope:actor = { is_dynast = yes }`, and `dynasty = scope:recipient.dynasty`. No separate `dynasty_interaction = yes` field was found.

## 2. Conditional personal-Prestige cost

**Classification:** VERIFIED AND IMPLEMENTATION-READY; zero-row visibility requires runtime observation  
**Category/scopes/context:** Character Interaction `cost`; actor pays; condition reads `scope:recipient`; top-level interaction block  
**Paths:** `common/character_interactions/_character_interactions.info:467`; `common/character_interactions/00_dynast_interactions.txt:919`; `common/script_values/_script_values.info`; `gui/interaction_confirmation.gui:381`  
**Version:** `1.19.0.6`

```text
cost = {
	prestige = {
		value = {
			add = medium_prestige_value
			if = { limit = { ... } multiply = 0 }
		}
	}
}
```

The schema states that native cost disables the interaction when the actor cannot pay and subtracts the cost from the actor when the interaction is sent. For this auto-accepted interaction, no manual `add_prestige` loss is needed. The confirmation GUI renders `GetCostDescription` in a separate bottom row when `HasCost`; the send button uses `CanSend` and `GetCanSendDescription`.

Static evidence does not establish whether a calculated zero makes `HasCost` false or displays a zero entry, nor the exact insufficient-Prestige wording. Classify those as **NOT VERIFIED — RUNTIME PROTOTYPE REQUIRED**.

Named formulas are supported wherever a number is accepted and retain the current evaluation context. Proposed project value:

```text
breedimp_exile_prestige_cost_value = {
	value = 100
	if = {
		limit = { scope:recipient = { breedimp_recipient_has_blood_impurity_trigger = yes } }
		multiply = 0
	}
}
```

Integrate it as `cost = { prestige = { value = breedimp_exile_prestige_cost_value } }`. The values `0` and `100` are Breed Improved balance, not vanilla balance.

## 3. Public illegitimate-birth state

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Category/scopes/context:** character trait triggers; current scope is the selected recipient; scripted trigger  
**Paths:** `common/traits/00_traits.txt:10412`; `common/scripted_triggers/00_bastard_triggers.txt`  
**Version:** `1.19.0.6`

```text
bastard = {
	...
	bastard = illegitimate
}
legitimized_bastard = {
	...
	bastard = legitimate
}
```

Exact checks are `has_trait = bastard` and `has_trait = legitimized_bastard`. Vanilla's `has_any_negative_bastard_trait_trigger` is too broad for this product rule because it also includes `disputed_heritage`; `has_any_bastard_trait_trigger` additionally includes `wild_oat`. Use the two explicit public traits unless Jay changes the product definition.

## 4. Legal parents, lowborn parents, and deceased parents

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Category/scopes/context:** character scripted trigger; recipient → legal parent; `scope:actor` remains named  
**Paths:** `common/customizable_localization/00_relations.txt:150`; `common/scripted_triggers/00_family_triggers.txt:34`; `events/decisions_events/middle_europe_decisions_events.txt:168`  
**Version:** `1.19.0.6`

```text
any_parent = {
	even_if_dead = yes
	<trigger>
}
```

One `any_parent` level covers the recipient's script-visible legal `father` and `mother`. Missing relations yield no iterator member, so no comparison runs. `even_if_dead = yes` includes an existing parent even when that character is dead. This deliberately avoids `real_father`, hidden biological parentage, and secrets.

Use a lowborn branch before the verified Dynasty inequality: `breedimp_ancestor_outside_actor_dynasty_trigger = { trigger_if = { limit = { is_lowborn = yes } always = yes } trigger_else = { dynasty != scope:actor.dynasty } }`.

Proposed recipient-scoped trigger:

```text
breedimp_recipient_has_blood_impurity_trigger = {
	OR = {
		has_trait = bastard
		has_trait = legitimized_bastard
		any_parent = {
			even_if_dead = yes
			breedimp_ancestor_outside_actor_dynasty_trigger = yes
		}
	}
}
```

## Implementation-ready recommendation

Keep the existing recipient-scoped consequence effect visible to tooltip parsing, add the native `cost.prestige` block above, and leave `create_dynasty` last. Do not add an artificial actor effect. `breedimp_` identifiers above are project-owned; all CK3 fields inside them are target-version verified.

## Required runtime observations

- Confirm the actor card appears only when the conditional House Head Hook-style actor effect exists; confirm ordinary Breed Improved execution has recipient card only.
- Confirm calculated `0` cost is hidden or acceptably displayed, `100` appears at the bottom, insufficient Prestige disables Send, and successful Send deducts exactly `100`.
- Matrix: missing parent, lowborn parent, dead highborn parent, and same-/different-Dynasty parent cases.

## Evidence-index updates made

- Created `ck3_evidence_index.md`; added confirmation grouping, native cost, conditional scripted values, public bastard traits, and legal-parent iteration.
- Added the same genuinely reusable constructs to `ck3_syntax_reference.md`. No longer-form vanilla-example note was needed.

## Deliberately not researched

- Resolved consequence/create-Dynasty syntax; hidden biological parentage; `wild_oat`/`disputed_heritage` product expansion; exact pixels, wording, and zero-cost UI behavior.
