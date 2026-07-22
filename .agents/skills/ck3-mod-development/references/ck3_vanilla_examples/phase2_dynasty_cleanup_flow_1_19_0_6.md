# Phase 2 Dynasty Cleanup Flow Provenance — CK3 1.19.0.6

Purpose: concise same-version vanilla pointers for Breed Improved's manual multi-mode Decision and sequential candidate-review flow. This file is not a general CK3 API guide.

## Decision and static mode choice

- `common/decisions/_decisions.info:125-190`
  - character-scoped Decision fields;
  - `decision_option_list_controller`;
  - static `item.value`, descriptions, validity, default, icon, and AI score.
- `common/decisions/00_cultural_tradition_decisions.txt`, `recruit_terrain_specialist_decision`
  - `gui = "decision_view_widget_option_list_generic"`;
  - `controller = decision_option_list_controller`;
  - `decision_to_second_step_button = "CHOOSE_TERRAIN_SPECIALIST_DECISION_NEXT_STEP_BUTTON"`;
  - verified top-level `sort_order` and AI Decision fields in the same file family.
- `common/decisions/dlc_decisions/fp3_decisions.txt`, `struggle_persia_ending_rekindle_iran_decision`
  - selected item read as `scope:<item.value> = yes` in validity and effect.
- `common/decisions/80_major_decisions.txt`, `strengthen_bloodline_decision`
  - `is_dynast = yes` and Decision-to-event execution.
- `common/decisions/00_diarchy_decisions.txt`
  - `ai_check_interval = 0` and `ai_potential = { always = no }`.

Restriction: this controller chooses one static mode. It is not evidence for arbitrary dynamic character multi-selection.

## Dynasty candidate discovery

- `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt:4170-4266`
  - enters Dynasty scope and uses `any_dynasty_member`, `random_dynasty_member`, and `every_dynasty_member` patterns.
- `events/relations_events/parent_events.txt`, `parent.1009`
  - `random_dynasty_member` with `limit` and `save_scope_as`.
- `events/activities/coronation_activity/prelude_events.txt:4603-4609`
  - `dynasty = { every_dynasty_member = { limit = { ... } ... } }`.

Restriction: write `is_alive = yes` explicitly; do not assume the iterator excludes dead characters.

## Event-target lists and sequential review

- `tests/event_target_lists_tests.txt:45-93`
  - `add_to_list`, `any_in_list`, `every_in_list`, and `random_in_list` using `list = <name>`.
- `common/scripted_effects/00_decisions_effects.txt:1511-1529`
  - `is_in_list`, `add_to_list`, then `every_in_list`.
- `events/story_cycles/story_cycle_pet_animal_events.txt:834-863`
  - `random_in_list` with `list`, `limit`, and `save_scope_as`.
- `events/dlc/fp3/fp3_misc_decision_events.txt:2534-2843`
  - event-context lists and saved scopes passed into a visible event.
- `events/dlc/ep3/ep3_laamp_decision_events.txt`
  - event options call a scripted effect that returns to a main event; explicit process cleanup is used on exit.

Restriction: context-list survival through the complete Breed Improved review loop remains a controlled runtime test. Do not silently replace `list =` with persistent `variable =` storage.

## Candidate presentation and confirmation

- `events/court_position_management_events.txt:1-145`
  - standard `character_event`, portrait, sibling `triggered_desc` segments, and ordinary options.
- `events/decisions_events/minor_decision_events.txt`, `minor_decisions.0003`
  - saved candidate portrait and condition-specific description.
- `events/decisions_events/major_decisions_events.txt`, `major_decisions.0501`
  - `theme = dynasty`.
- `events/dlc/bp1/bp1_yearly_develop.txt`, `bp1_yearly.8060`
  - an event option iterates a saved list for preview/processing.
- `events/pregnancy_events.txt:977-989`
  - `any_child = { even_if_dead = yes count >= 1 }` inside a character-event description trigger.

Restriction: final confirmation is an ordinary event option. Do not invent an event `confirm_text` field.

## Ancestor overlap collapse

- `events/dlc/tgp/tgp_mandala_devaraja_events.txt:1222-1227`
  - `any_ancestor = { even_if_dead = yes ... }`.
- `common/scripted_effects/00_decisions_effects.txt:1511-1524`
  - `is_in_list = <name>` inside an entered typed scope.
- `common/scripted_triggers/07_ep3_triggers.txt:888-896`
  - saves the current typed argument with `save_temporary_scope_as` before later nested scope comparisons.
- `common/character_interactions/00_adoption.txt:108-112`
  - `any_ancestor = { this = scope:actor }` character-scope comparison.

Combined verified form:

```text
any_ancestor = {
    even_if_dead = yes
    is_in_list = selected_targets
}
```

Restriction: the verified components support ancestor-first review, actor-ancestor exclusion, and ancestor/descendant selection collapse. They do not detect two non-ancestor selected roots whose descendant branches converge through marriage.

## Parent and congenital-trait evidence

- `common/scripted_triggers/00_birth_triggers.txt`
  - direct `exists = father`, `exists = mother`, and legal-parent Dynasty comparisons.
- `common/character_interactions/00_dynast_interactions.txt:305-314`
  - exact `has_trait` checks in Character Interaction context.
- `common/traits/00_traits.txt:6824-8357`
  - exact fixed negative and positive trait definitions used by the Phase 2 evidence record.
- `common/traits/_traits.info:79-175`
  - genetic, manual inheritance, and trait-group metadata.

Restriction: use exact approved keys. Do not use broad genetic counters, inactive-carrier checks, or appearance triggers for the fixed preset.

## Localisation

- `localization/english/event_localization/lifestyle/statecraft/diplomacy_family_events_l_english.yml`
  - saved candidate name usage.
- `localization/english/dlc/ach/dlc_ach_coronation_prelude_events_l_english.yml`
  - saved character age usage.
- `localization/english/event_localization/relation_events/vassal_events_l_english.yml`
  - `[ROOT.Char.Custom2('RelationToMe', SCOPE.sC('<saved scope>'))]`.
- `localization/english/destiny_values_l_english.yml:114-166`
  - exact trait display names through `[GetTrait('<key>').GetName( GetNullCharacter )]`.

Restriction: no verified dynamic descendant count or arbitrary selected-character list formatter is used.

## Runtime-only gates

- repeated event-chain scope/list continuity;
- very large Dynasty responsiveness;
- repeated `create_dynasty` calls during one confirmation;
- save/reload or unexpected closure mid-review;
- converging descendant branches;
- English and Simplified Chinese layout and line wrapping; and
- CK3 error-log cleanliness.

No runtime outcome is claimed by this provenance note.
