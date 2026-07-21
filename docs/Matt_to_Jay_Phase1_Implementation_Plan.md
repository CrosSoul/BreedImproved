# Breed Improved Phase 1 - v0.1.0 Implementation Record

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6`
- Product state: `IMPLEMENTED AND RUNTIME-VERIFIED FOR v0.1`
- Production validation state: Boss-reported production runtime acceptance `PASSED`
- Runtime evidence sources: the earlier standalone Phase 1 test harness and the completed production acceptance test
- Feature: player-initiated Character Interaction, **Exile from Dynasty** / **逐出宗族**

This document records the approved v0.1.0 implementation boundary and the Boss-reported production runtime acceptance results.

## 1. Approved player-facing behavior

The current player, while serving as the Dynasty's Dynast, may select one eligible AI-controlled member of the same Dynasty and confirm **Exile from Dynasty**.

On acceptance:

- CK3 creates a generated replacement Dynasty for the selected character;
- the selected character leaves the actor's Dynasty;
- the selected character's descendants move to the replacement Dynasty; and
- CK3 may recalculate succession after the affiliation change.

The script does not directly alter titles, claims, marriages, court membership, realm membership, imprisonment, government, or other political status.

There is no automatic cleanup, background scan, recurring execution, Decision, event, or bulk processing in v0.1.

## 2. Eligibility contract

### Actor requirements

The actor must be:

- player-controlled: `is_ai = no`;
- alive: `is_alive = yes`; and
- the current Dynast: `is_dynast = yes`.

### Recipient requirements

The recipient must be:

- AI-controlled: `is_ai = yes`;
- alive: `is_alive = yes`;
- highborn for this feature boundary: `is_lowborn = no`;
- in the actor's current Dynasty;
- a character other than the actor;
- not a House Head; and
- not the Dynast.

The production interaction intentionally has no restriction based on:

- age or adulthood;
- landed or ruler status;
- current player-heir status;
- marriage or betrothal;
- bastard status; or
- the Dynasties of the recipient's parents.

The last two criteria remain possible future candidate-assistance rules, not v0.1 eligibility gates.

### Runtime-verified supported targets

Production acceptance verified support for:

- minors;
- adults;
- unlanded characters;
- landed rulers; and
- current player heirs.

## 3. Production runtime acceptance

The Boss reported the following results from the production mod:

| Scenario | Production result |
| --- | --- |
| Interaction appears correctly | `PASS` |
| Simplified Chinese localisation | `PASS` |
| Hostile/Dynasty interaction presentation | `PASS` |
| Minor recipient | `PASS` |
| Adult recipient | `PASS` |
| Unlanded character | `PASS` |
| Landed ruler | `PASS` |
| Current player heir | `PASS`; CK3 selected a new player heir when necessary |
| Descendant propagation | `PASS` |
| Save and reload persistence | `PASS` |
| CK3 runtime errors | None observed |
| Other abnormalities | None observed |

The accepted behavior is that the target receives a generated replacement Dynasty, descendants move with the target, and parents and siblings remain unchanged. Titles and political status are not directly modified by Breed Improved. CK3 recalculates the player heir when necessary.

The earlier standalone harness remains the development evidence that established the narrow operation before production implementation. Production acceptance supersedes the previous `NOT RUN` status for the production files, but it does not establish behavior for every government, title arrangement, special character state, multiplayer configuration, or mod combination.

## 4. Production architecture

| Layer | Production identifier | File |
| --- | --- | --- |
| Character Interaction | `breedimp_exile_from_dynasty_interaction` | `MyCK3Mod/common/character_interactions/breedimp_exile_from_dynasty_interaction.txt` |
| Shared validation trigger | `breedimp_can_exile_dynasty_member` | `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_exile_triggers.txt` |
| Shared state-changing effect | `breedimp_exile_dynasty_member` | `MyCK3Mod/common/scripted_effects/breedimp_dynasty_exile_effects.txt` |
| Saved replacement-Dynasty scope | `breedimp_new_dynasty` | inside `breedimp_exile_dynasty_member` |
| English localisation | `breedimp_exile_from_dynasty_interaction*` | `MyCK3Mod/localization/english/breedimp_dynasty_exile_l_english.yml` |
| Simplified Chinese localisation | `breedimp_exile_from_dynasty_interaction*` | `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml` |

The shared trigger keeps recipient validation available for a later approved interface without duplicating the rule set. The shared effect contains the complete mutation boundary so future callers cannot silently diverge from the approved operation.

## 5. Character Interaction structure

The production interaction follows the verified vanilla Dynasty-interaction presentation pattern from:

- `common/character_interactions/00_dynast_interactions.txt`, `disinherit_interaction`; and
- `common/character_interactions/_character_interactions.info`.

It uses:

- `icon = icon_dynasty`;
- `category = interaction_category_hostile`;
- `interface_priority = 60`;
- an explicitly referenced `desc` key;
- an explicitly referenced `prompt` key;
- `use_diplomatic_range = no`;
- default actor confirmation by omitting deprecated `needs_confirmation`;
- `auto_accept = yes` so an eligible AI recipient does not separately accept or reject;
- `is_shown` for stable visibility constraints; and
- `is_valid_showing_failures_only` plus a static `custom_tooltip.text` failure key for mutable recipient validation.

The interaction enters `scope:recipient` before calling the shared effect. No target argument is guessed for `create_dynasty`.

## 6. Shared effect and mutation boundary

The only direct state-changing CK3 effect in the production implementation is:

```text
create_dynasty = {
    spread_to_descendants = yes
    save_scope_as = breedimp_new_dynasty
}
```

The form is supported by Lynn's verified `create_dynasty` sources and by the approved runtime harness. It is executed from the recipient character scope.

The saved scope is retained from the verified harness form for traceability and possible diagnostic inspection. No further effect consumes it in v0.1.

## 7. Localisation and confirmation disclosure

English and Simplified Chinese provide explicit keys for:

- interaction name;
- description;
- confirmation prompt; and
- validation failure text.

The English name is **Exile from Dynasty**. The Simplified Chinese name is **逐出宗族**.

The description and prompt state that:

- the recipient and descendants enter a newly generated Dynasty;
- they leave the actor's Dynasty;
- titles, claims, marriages, court, and political status are not directly changed; and
- CK3 may recalculate succession.

Both localisation files use the correct language header, quoted values, project-established unversioned keys, and UTF-8 BOM. Dynamic forms used in the description are limited to vanilla-verified `$dynasty_interaction_header$`, `[recipient.GetShortUINameNoTooltip]`, and `[dynasty|E]`.

## 8. Explicitly excluded behavior

The v0.1 production implementation does not contain:

- `disinherit_effect` or another inheritance-trait change;
- claim removal or `remove_claim`;
- divorce or betrothal changes;
- banishment, imprisonment, or court movement;
- title removal or transfer;
- government conversion;
- adventurer conversion;
- events or Decisions;
- scans, iterators, recurring execution, or bulk processing; or
- automatic or AI-initiated cleanup.

## 9. Deferred runtime finding: spouse-related claims

**DEFERRED — NOT BLOCKING v0.1**

In the approved harness testing, a married target later gained spouse-related strong claims after time advanced.

This is recorded as a deferred behavior to investigate. Its cause has not been established, and the observation does not by itself prove that `create_dynasty` directly granted the claims. v0.1 therefore adds neither claim removal nor divorce. A future investigation should isolate the claim source through controlled before/after timing, logs, save inspection, and a comparison case before any product policy is proposed.

## 10. Evidence provenance

Primary verified paths used by this production implementation include:

- `common/character_interactions/00_dynast_interactions.txt`
- `common/character_interactions/_character_interactions.info`
- `common/character_interactions/00_courtier_and_guest_interactions.txt`
- `common/scripted_triggers/00_interaction_triggers.txt`
- `common/scripted_triggers/00_dynasty_triggers.txt`
- `common/scripted_effects/00_interaction_effects.txt`
- `common/scripted_effects/00_accolades_scripted_effects.txt`
- `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`
- `events/dlc/tgp/tgp_japan_decision_events.txt`
- `events/dlc/tgp/tgp_mandala_task_contract_events.txt`
- `localization/english/interactions/dynast_interaction_l_english.yml`
- `localization/simp_chinese/interactions/dynast_interaction_l_simp_chinese.yml`
- `docs/research/Lynn_to_Jay_Phase1_Followup.md`
- `docs/research/Lynn_to_Jay_CharacterInteraction_Evidence.md`
- `.agents/skills/ck3-mod-development/references/ck3_vanilla_examples/phase1_create_dynasty_interaction_1_19_0_6.md`

All vanilla paths refer to CK3 `1.19.0.6`. No vanilla file is modified or copied wholesale.

## 11. Validation status and next gate

The implementation passed its earlier static review and has now passed Boss-reported production runtime acceptance for v0.1.0. Production interaction visibility, Simplified Chinese localisation, hostile Dynasty presentation, supported target classes, descendant propagation, save/reload persistence, and absence of observed CK3 runtime errors were accepted.

The individual Character Interaction is `IMPLEMENTED AND RUNTIME-VERIFIED FOR v0.1`. Broadening eligibility, adding consequences, investigating claim behavior, or implementing the Dynasty Decision requires a separate approval and test stage.
