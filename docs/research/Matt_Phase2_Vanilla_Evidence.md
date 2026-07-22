# Breed Improved Phase 2 - CK3 1.19.0.6 Vanilla Evidence Record

Research purpose: support the first manual multi-mode Dynasty cleanup implementation without inventing CK3 syntax.

- Installed target verified from `launcher/launcher-settings.json`: `1.19.0.6 (Scribe)`.
- Evidence policy: exact target-version vanilla files only.
- Runtime status: `NOT RUN`.
- Vanilla files were read-only and were not copied wholesale.

## Verification classification

- **VERIFIED AND IMPLEMENTATION-READY**: exact same-version vanilla form and enclosing context were found.
- **VERIFIED BUT CONTEXT-DEPENDENT**: syntax exists, but the product meaning or engine result needs controlled game testing.
- **NOT USED**: a broader mechanism exists but cannot guarantee the approved fixed behavior.

## 1. Native Decision mode selector

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

`common/decisions/_decisions.info` documents Decision fields including `title`, `picture`, `selection_tooltip`, `desc`, `confirm_text`, `sort_order`, `is_shown`, `is_valid_showing_failures_only`, `is_valid`, `effect`, `ai_check_interval`, `ai_potential`, `ai_will_do`, and `widget`.

The Decision actor can be captured with `save_scope_as = actor` inside the Decision effect. Exact same-context evidence appears in `common/decisions/dlc_decisions/mpo/mpo_decisions.txt:4409-4417`. This verifies the capture itself; continuity through Breed Improved's repeated visible-event loop remains a runtime test.

The same file documents `decision_option_list_controller` and its `item` fields. The relevant form is:

```text
widget = {
    gui = "<verified option-list widget>"
    controller = decision_option_list_controller
    decision_to_second_step_button = "<localisation_key>"
    item = {
        value = <option_scope_name>
        current_description = <localisation_key>
        localization = <localisation_key>
        is_default = yes
        ai_chance = { value = 100 }
    }
}
```

Exact generic option-list use appears in:

- `common/decisions/00_cultural_tradition_decisions.txt`, `recruit_terrain_specialist_decision`, using `gui = "decision_view_widget_option_list_generic"`, `controller = decision_option_list_controller`, and `decision_to_second_step_button = "CHOOSE_TERRAIN_SPECIALIST_DECISION_NEXT_STEP_BUTTON"`.

The selected item is exposed in the Decision trigger/effect context as `scope:<item value> = yes`. Exact evidence:

- `common/decisions/dlc_decisions/fp3_decisions.txt`, `struggle_persia_ending_rekindle_iran_decision`, checks `scope:struggle_persia_ending_rekindle_iran_decision_option_secret_faith = yes` in both validity and effect.

Decision-to-event execution is verified by:

- `common/decisions/00_dynasty_decisions.txt`, which calls `trigger_event = tgp_japan_decision.9001` from a Decision effect.

The Dynasty-themed Decision illustration is an observed vanilla asset:

- `common/decisions/test_decision.txt` references `gfx/interface/illustrations/decisions/decision_dynasty_house.dds`.

Restriction: the native controller selects one item. It is used only to choose one cleanup mode; it is not presented as an arbitrary multi-character selector.

## 2. Dynasty member discovery

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

`every_dynasty_member`, `any_dynasty_member`, and `random_dynasty_member` are used from Dynasty scope.

Exact evidence:

- `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, event `diplomacy_family.2300`, enters `dynasty = { ... }` and uses `any_dynasty_member` plus `every_dynasty_member` with `limit`.
- `events/relations_events/parent_events.txt`, event `parent.1009`, enters `scope:parent.dynasty` and uses `random_dynasty_member` with `limit`, `alternative_limit`, and `save_scope_as = new_courtier`.
- `events/decisions_events/major_decisions_events.txt`, event `major_decisions.0501`, enters `dynasty` and adds qualifying member data to a list.

Implementation restriction: Breed Improved calls these iterators only after the player confirms a cleanup mode. They are not placed in an `on_action`, pulse, recurring event, or background process.

## 3. Event-context workflow lists

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

The following forms are verified:

```text
add_to_list = <list_name>

every_in_list = {
    list = <list_name>
    <effects>
}
```

Exact evidence:

- `events/game_rule_events.txt`, scripted effects `game_rule_1021_process_endings_effect` and `game_rule_1021_process_endings_guts_effect`, add characters to `kill_list` and later run `every_in_list = { list = kill_list ... }`.
- `events/decisions_events/major_decisions_events.txt`, `major_decisions.0501`, adds qualifying Dynasty realms to `dynasty_realms` before list selection.

Breed Improved uses event-context lists for candidates, reviewed candidates, player selections, and the final execution snapshot. It does not create persistent variable lists or character flags for those workflow states. Continuity and lifecycle through the complete Decision/event chain remain controlled runtime tests.

## 4. Ancestor overlap and individual protection

Classification: **VERIFIED AND IMPLEMENTATION-READY** for the trigger form; runtime behavior of the complete product flow still requires testing.

Verified ancestor form:

```text
any_ancestor = {
    even_if_dead = yes
    <character trigger>
}
```

Exact evidence:

- `events/dlc/tgp/tgp_mandala_devaraja_events.txt`, event `tgp_mandala_devaraja.1402`, uses `any_ancestor` with `even_if_dead = yes`.
- `common/character_interactions/00_adoption.txt` and `common/character_interactions/06_ep3_interactions.txt` use `any_ancestor` in Character Interaction conditions.
- `common/scripted_triggers/07_ep3_triggers.txt:888-896`, `is_appointment_valid_trigger`, saves typed arguments with `save_temporary_scope_as` and reads those temporary scopes later in the same scripted trigger.

Breed Improved uses these forms to:

- save the current candidate before entering actor scope and exclude a candidate who is an ancestor of the actor;
- defer a descendant while a still-valid candidate ancestor remains unreviewed, producing ancestor-first review order; and
- collapse a selected descendant when another still-valid selected character is its ancestor.

No `any_descendant` or guessed descendant-count function is required.

Parameterized scripted-trigger arguments are independently verified by `ask_for_pardon_available_trigger` in `common/scripted_triggers/00_interaction_triggers.txt:49-61`, which reads `$ACTOR$`, and its call in `common/character_interactions/00_vassal_interactions.txt:2293`, which supplies `ACTOR = scope:actor`. Breed Improved uses the same verified definition/call shape and does not assume that a parameter automatically creates a saved scope.

The individual protection marker uses the independently verified character-scope forms `add_character_flag`, `has_character_flag`, and `remove_character_flag`. Project evidence and exact vanilla paths are recorded in `docs/research/Lynn_to_Jay_Exile_Consequences_Evidence.md`, section **Persistent character flag**, citing:

- `events/dlc/bp2/bp2_yearly_events_6.txt:5411`;
- `events/dlc/bp2/bp2_yearly_events_6.txt:13372`; and
- `common/story_cycles/bp2_story_cycle_foreign_raised_reformer.txt:59`.

Restriction: the Phase 2 flag protects only the marked character from bulk candidate lists. It does not store an actor, imply branch protection, or block the separate individual exile interaction.

## 5. Legal-parent comparison

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

Direct legal-parent existence and scope access are evidenced in:

- `common/scripted_triggers/00_birth_triggers.txt`, which uses `exists = father`, `exists = mother`, and direct `$CHILD$.mother.dynasty` comparisons.
- `common/customizable_localization/00_relations.txt` and `common/scripted_triggers/00_family_triggers.txt`, which use legal-parent iteration.

Breed Improved's conservative Phase 2 parent branch requires both direct legal-parent scopes to exist and evaluates their current Dynasty state. It reuses the v0.1.0 project helper `breedimp_ancestor_outside_actor_dynasty_trigger`, which handles an explicitly existing lowborn parent before attempting a Dynasty comparison. Missing parents do not pass. Hidden biological-parent secrets are outside the script-visible legal-parent scopes and are not inspected.

## 6. Exact active-trait checks

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

Character-scope exact checks use:

```text
has_trait = <exact_trait_key>
```

Vanilla Character Interaction evidence:

- `common/character_interactions/00_dynast_interactions.txt` checks exact `inbred` and `intellect_bad_3` traits.

Trait metadata evidence:

- `common/traits/_traits.info` documents `genetic = yes`, manual `inherit_chance`, and trait groups.
- `common/traits/00_traits.txt` defines every fixed preset key listed below.

### Fixed negative preset

| Exact keys | Vanilla definition range | Relevant evidence |
| --- | --- | --- |
| `beauty_bad_1`–`beauty_bad_3` | `common/traits/00_traits.txt:6824-6938` | `genetic = yes`; negative Diplomacy/Fertility |
| `intellect_bad_1`–`intellect_bad_3` | `common/traits/00_traits.txt:7082-7240` | `genetic = yes`; negative primary skills/lifestyle XP |
| `physique_bad_1`–`physique_bad_3` | `common/traits/00_traits.txt:7408-7538` | `genetic = yes`; negative Prowess/Health |
| `clubfooted` | `common/traits/00_traits.txt:7832-7858` | `genetic = yes`; negative Prowess |
| `hunchbacked` | `common/traits/00_traits.txt:7860-7887` | `genetic = yes`; negative Prowess/opinions |
| `lisping` | `common/traits/00_traits.txt:7889-7916` | `genetic = yes`; negative Diplomacy |
| `stuttering` | `common/traits/00_traits.txt:7918-7945` | `genetic = yes`; negative Diplomacy |
| `dwarf` | `common/traits/00_traits.txt:7947-7978` | `genetic = yes`; negative Prowess |
| `inbred` | `common/traits/00_traits.txt:8022-8056` | manual inheritance; severe negative skills/Health/Fertility |
| `spindly` | `common/traits/00_traits.txt:8156-8193` | `genetic = yes`; negative Prowess/Health |
| `scaly` | `common/traits/00_traits.txt:8195-8225` | `genetic = yes`; negative Fertility |
| `wheezing` | `common/traits/00_traits.txt:8256-8283` | `genetic = yes`; negative Health |
| `bleeder` | `common/traits/00_traits.txt:8285-8312` | `genetic = yes`; negative Health |
| `infertile` | `common/traits/00_traits.txt:8315-8357` | `genetic = yes`; negative Fertility |

### Fixed positive warning preset

- `beauty_good_1`–`beauty_good_3`;
- `intellect_good_1`–`intellect_good_3`;
- `physique_good_1`–`physique_good_3`;
- `pure_blooded`; and
- `fecund`.

Evidence: `common/traits/00_traits.txt:6941-7752`; these definitions use `genetic = yes` and/or explicit inheritance fields plus `good = yes`.

### Deliberate exclusions

- `depressed_genetic`, `lunatic_genetic`, and `possessed_genetic`: hidden/special health-state behavior.
- `great_pox` and `lovers_pox`: illness flags.
- `albino` and `giant`: mixed or non-direct-negative mechanics.
- `strong`, `shrewd`, `weak`, and `dull`: the definitions do not establish the required genetic/inheritance classification for this fixed preset.
- diseases, wounds, stress traits, education, lifestyle, commander traits, personality traits, event states, and age states.

## 7. Broader genetic mechanisms not used

Classification: **NOT USED**.

`common/trigger_localization/00_character_triggers.txt` and vanilla events verify `num_of_bad_genetic_traits`, `num_of_good_genetic_traits`, and group-compatible `has_trait` checks. The engine's exact membership calculation and other mods' group additions are not statically bounded by Breed Improved's approved list.

The first implementation therefore does not use:

- `num_of_bad_genetic_traits`;
- `num_of_good_genetic_traits`;
- a trait-group key as the eligibility condition;
- `has_inactive_trait`; or
- `has_conventionally_ugly_trigger`, which includes injuries and illness in `common/scripted_triggers/00_physical_appearance_triggers.txt`.

## 8. Character events and conditional descriptions

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

Character event structure, theme, portraits, and options are evidenced by:

- `events/relations_events/vassal_events.txt`, including `vassal.1010` with `type = character_event`, `title`, `desc`, `theme`, `left_portrait`, and `option`.
- `events/decisions_events/major_decisions_events.txt`, `major_decisions.0501`, using `type = character_event` and `theme = dynasty`.

Multiple additive conditional description segments are evidenced by `events/court_position_management_events.txt:1-40`, which places sibling `triggered_desc` blocks after a base `desc`. Multiple sequential `first_valid` blocks are separately evidenced by `events/activities/chariot_race_activity/chariot_race_ongoing_events.txt`, event `chariot_race.4050`, for mutually exclusive status text.

Breed Improved uses sibling `triggered_desc` blocks for reasons that must all display and reserves `first_valid` for landed/unlanded or other mutually exclusive presentation.

## 9. Localisation expressions

Classification: **VERIFIED AND IMPLEMENTATION-READY** for the forms below.

- Saved character scope access uses aliases backed by `SCOPE.sC('<saved_scope>')` in vanilla event localisation.
- Relationship text uses `[ROOT.Char.Custom2('RelationToMe', SCOPE.sC('<saved_scope>'))]`, with examples in `localization/english/event_localization/relation_events/vassal_events_l_english.yml`.
- Trait display names use `[GetTrait('<exact_key>').GetName( GetNullCharacter )]`, with examples throughout `localization/english/accolades/accolades_l_english.yml`.
- Character names and age use saved-scope character accessors found in vanilla event localisation.
- Primary-title display uses `[saved_character.GetPrimaryTitle.GetName]` only in a branch guarded by `is_landed = yes`; the accessor form is present in `localization/english/character_l_english.yml:10`.

Restrictions:

- Breed Improved does not invent a dynamic descendant-count expression.
- The UI states the verified impact scope: the selected target's entire descendant branch moves.
- Gender-dependent trait-name presentation and both supported languages require runtime inspection even when the localisation expression is statically valid.

## 10. Existing-child disclosure

Classification: **VERIFIED AND IMPLEMENTATION-READY**.

The candidate event uses the character-scope trigger form:

```text
any_child = {
    even_if_dead = yes
    count >= 1
}
```

Exact same-context evidence appears in `events/pregnancy_events.txt:977-989`, where a character event description checks `any_child` with `even_if_dead = yes` and `count >= 1` before selecting child-related text. Additional count forms appear in `events/birth_events.txt:383-421`.

Restriction: this establishes only whether at least one legal child scope exists. Breed Improved does not infer or display an exact descendant count from this trigger.

## 11. Existing exile mutation

The Phase 2 implementation does not re-research or replace the v0.1.0 mutation primitive. It calls the already runtime-verified project effect:

```text
breedimp_exile_dynasty_member = {
    ACTOR = <player Dynast>
    RECIPIENT = <revalidated target>
}
```

That project effect retains the verified `create_dynasty` form with `spread_to_descendants = yes` and the accepted v0.1.0 consequences. Its provenance remains in:

- `docs/research/Lynn_to_Jay_Research_Summary.md`;
- `docs/research/Lynn_to_Jay_Phase1_Followup.md`;
- `docs/research/Lynn_to_Jay_CharacterInteraction_Evidence.md`; and
- `.agents/skills/ck3-mod-development/references/ck3_vanilla_examples/phase1_create_dynasty_interaction_1_19_0_6.md`.

## 12. Runtime-only questions

Static vanilla evidence does not establish the complete product flow. Ray's controlled CK3 tests must verify:

- Decision option rendering and selected-mode transfer;
- long sequential review sessions on large Dynasties;
- candidate saved-scope continuity across event options;
- temporary-list stability while multiple Dynasty replacements execute;
- save/reload or unexpected closure during candidate review;
- player protection persistence across save/reload;
- exclusion of an otherwise eligible living ancestor of the actor;
- ancestor-first review order and descendant unlocking after an ancestor is declined;
- ancestor/descendant overlap collapse in the complete flow;
- converging descendant branches from selected non-ancestor roots;
- all English and Simplified Chinese dynamic text;
- candidate inclusion/exclusion for every fixed trait key; and
- absence of CK3 error-log entries.

None of these runtime results is claimed in this evidence record.
