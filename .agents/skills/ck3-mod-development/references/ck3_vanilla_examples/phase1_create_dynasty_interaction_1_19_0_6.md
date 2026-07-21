# Phase 1 `create_dynasty` Character Interaction Provenance

## Record

- Project: Breed Improved
- CK3 version: `1.19.0.6`
- Purpose: provenance for the isolated `breedimp_test_create_dynasty_interaction` test harness
- Evidence source: Lynn's target-version vanilla research in `docs/research/Lynn_to_Jay_Phase1_Followup.md` and `docs/research/Lynn_to_Jay_CharacterInteraction_Evidence.md`
- Runtime status: `NOT RUN`

This is a provenance record, not a complete vanilla-file copy and not a statement that the proposed target-class behavior has passed in CK3.

## Character Interaction structure

Primary source:

- `common/character_interactions/00_choose_favorite_interaction.txt`
- Enclosing identifier: `choose_favorite_interaction`

Minimal verified top-level shape:

```text
choose_favorite_interaction = {
    category = interaction_category_friendly
    icon = designate_favorite
    interface_priority = 8
    desc = choose_favorite_interaction_desc
    is_shown = { ... }
    is_valid_showing_failures_only = { ... }
    on_accept = { ... }
    auto_accept = yes
}
```

The selected vanilla definition also contains `on_auto_accept`, but the Breed Improved harness does not need result messaging and does not copy that block.

Format documentation:

- `common/character_interactions/_character_interactions.info`
- Verifies `scope:actor` and `scope:recipient` availability in the relevant interaction contexts.
- Documents that player confirmation defaults to true when deprecated `needs_confirmation` is omitted.
- Distinguishes actor confirmation from `auto_accept = yes`, which removes the recipient's accept/decline choice.

The selected interaction verifies these exact scope and visibility forms:

```text
scope:actor = {
    is_ai = no
}
scope:recipient.dynasty = scope:actor.dynasty
scope:actor != scope:recipient
```

It also verifies recipient validation with explicit failure localisation:

```text
scope:recipient = {
    custom_tooltip = {
        text = cant_be_another_player_tt
        is_ai = yes
    }
}
```

Accepted-effect scope pointer:

- `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`, `on_accept`
- The exact vanilla block passes `scope:actor` and `scope:recipient` to a scripted effect, proving that the selected recipient remains accessible in `on_accept`.
- The Breed Improved test does not reuse the unrelated favorite-child effect or its message blocks.

## Confirmation and validation presentation

- `gui/interaction_confirmation.gui`
- The standard confirmation window uses `GetSendName`, `CanSend`, and `GetCanSendDescription` for the send control.
- Together with `is_valid_showing_failures_only` and `custom_tooltip.text`, this provides the verified disabled-send and visible-failure path.

No custom confirmation key suffix, automatic failure-key suffix, or dynamic character/Dynasty localisation expression is established by these sources.

## Target predicate provenance

| Required check | Exact construct | Vanilla path and enclosing pointer | Evidence boundary |
| --- | --- | --- | --- |
| Living target | `is_alive = yes` | `common/character_interactions/00_education_interactions.txt`, `offer_ward_interaction`, recipient block in `is_shown` | Exact recipient character check |
| Not lowborn | `is_lowborn = no` | `common/character_interactions/06_ep3_scheme_interactions.txt`, `start_challenge_status_interaction`, recipient block in `is_valid_showing_failures_only` | Exact interaction validity check |
| Adult | `is_adult = yes` | `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier` | Exact character trigger; recipient character scope is independently documented |
| Unlanded | `is_landed = no` | `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; recipient use in `common/character_interactions/00_fp3_interactions.txt` | Predicate and recipient context independently verified |
| Non-ruler | `is_ruler = no` | `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; recipient use in `common/character_interactions/00_diarch_interactions.txt` | Predicate and recipient context independently verified |
| Not House Head | `NOT = { is_house_head = yes }` | `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`; recipient use in `common/character_interactions/10_tgp_japan_interactions.txt`, `kick_from_house_bloc_interaction` | Exact character exclusion; direct recipient `is_house_head = no` also exists |
| Not Dynast | `NOT = { is_dynast = yes }` | `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`; definition in `common/scripted_triggers/00_dynasty_triggers.txt` | Exact spelling is `is_dynast`; `is_dynasty_head` is not verified |

The exact `is_landed = no` and `is_ruler = no` pair was found together in a vanilla character trigger, not together inside one Character Interaction block. Both predicates and recipient-character evaluation are independently verified; this context difference remains recorded rather than hidden.

## Same-Dynasty provenance

Primary exact form:

```text
scope:recipient.dynasty = scope:actor.dynasty
```

- `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`, `is_shown`

Supporting comparison:

- `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`
- Uses the actor and recipient Dynasty scopes in the opposite comparison direction.

This proves current Dynasty equality only. It does not prove actor authority, historical membership, candidate reasons, or inheritance behavior.

## English localisation provenance

- `localization/english/interactions/choose_favorite_l_english.yml`

Minimal verified form:

```yaml
l_english:
 choose_favorite_interaction: "Choose Favorite Child"
 choose_favorite_interaction_desc: "Pre-select a character to showcase among your potential next playable characters."
```

Recorded properties:

- first line `l_english:`;
- one leading space before each key;
- key followed by a colon and quoted value;
- the interaction ID supplies the default send name when `send_name` is omitted;
- description and failure keys are explicitly referenced;
- selected vanilla file begins with UTF-8 BOM bytes `EF BB BF`.

The BOM is an observed property of this file, not proof of a universal CK3 engine requirement. No numeric key version, dynamic character expression, dynamic Dynasty expression, or custom confirmation suffix is inferred.

## `create_dynasty` provenance

Lynn verified `create_dynasty` as a character-scoped effect in these CK3 `1.19.0.6` vanilla sources:

- `common/scripted_effects/00_accolades_scripted_effects.txt`
- `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`
- `events/dlc/tgp/tgp_japan_decision_events.txt`
- `events/dlc/tgp/tgp_mandala_task_contract_events.txt`

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

Evidence boundaries:

- The intended character is entered before calling the effect; no target argument is verified.
- `name`, `coat_of_arms`, `spread_to_descendants`, and `save_scope_as` are the only arguments established by this research.
- Vanilla existing-character use is verified, and cited Japanese flows access the character's `house` after creation.
- The exact Breed Improved target class—an arbitrary existing highborn unlanded non-ruler—is not demonstrated and requires T1.
- Omission of `spread_to_descendants` is demonstrated, but its target-only runtime result is not documented and requires T7.
- Generated name, coat of arms, history presentation, UI refresh, and save/reload behavior for this target class remain untested.

## Harness permission boundary

These sources support static construction of one test-only interaction. They do not authorize or verify:

- production gameplay;
- claims or inheritance changes;
- court movement, banishment, imprisonment, or adventurer conversion;
- descendant propagation;
- Decisions, events, scans, iterators, recurring behavior, or bulk execution;
- custom replacement identity; or
- any runtime pass claim before T1/T7 are actually run and reviewed.
