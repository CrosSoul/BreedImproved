# Breed Improved Phase 1 - v0.1.0 Implementation Record

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6`
- Final v0.1.0 product state: `IMPLEMENTED AND RUNTIME-VERIFIED FOR v0.1.0`
- Runtime evidence sources: the earlier standalone Phase 1 test harness and Boss-confirmed production release-candidate acceptance
- Feature: player-initiated Character Interaction, **Exile from Dynasty** / **逐出宗族**

This document records the frozen v0.1.0 implementation boundary and the Boss-confirmed production runtime acceptance result.

## RC2 implementation delta

RC2 adds:

- reusable public-trait and legal-parent-only blood-impurity triggers;
- a native personal-Prestige interaction cost of `0` for blood-impurity cases and `100` otherwise;
- a decaying recipient opinion modifier toward the actor;
- `60` base recipient stress;
- a visible ten-year recipient character modifier;
- an untimed recipient character flag; and
- confirmation text describing the recipient consequences while leaving native Prestige cost presentation to the bottom cost area.

The final implementation uses the exact vanilla `denounce_effect` pattern for conditionally removing only an actor-held `house_head_hook` over the recipient. This is a genuine actor-scoped effect only when that hook exists. The ten-year modifier applies `diplomacy = -1`, `stress_gain_mult = 0.2`, and `monthly_prestige = -0.25`.

The recipient consequences execute before the existing `create_dynasty` operation. Descendants still receive only Dynasty propagation. RC2 does not add claim, inheritance, marriage, title, court, government, imprisonment, event, Decision, scan, recurring, or bulk effects.

Production acceptance verifies the standard confirmation flow, supported target classes, free and paid native cost paths, conditional House Head Hook removal, opinion, stress, visible modifier, permanent marker, Dynasty exile, descendant propagation, and save/reload persistence for the frozen v0.1.0 scope.

The current RC2 product rule checks the recipient's public `bastard` and `legitimized_bastard` traits plus existing script-visible legal parents only. Grandparents are permanently outside this rule. Missing parent relations, spouses, descendants, and hidden biological-parent secrets do not qualify by themselves.

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

The Boss confirmed the following results for the final v0.1.0 production release candidate:

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
| Free impurity-cost case | `PASS` |
| Paid 100-personal-Prestige case | `PASS` |
| Conditional House Head Hook removal | `PASS` |
| Recipient opinion: `-60`, monthly recovery `0.5` | `PASS` |
| Recipient base stress: `60` | `PASS` |
| Ten-year modifier: `diplomacy = -1`, `stress_gain_mult = 0.2`, `monthly_prestige = -0.25` | `PASS` |
| Permanent exile marker | `PASS` |
| Save and reload persistence | `PASS` |
| CK3 runtime errors | None observed |
| Other abnormalities | None observed |

The accepted behavior is that the target receives a generated replacement Dynasty, descendants move with the target, and parents and siblings remain unchanged. Titles and political status are not directly modified by Breed Improved. CK3 recalculates the player heir when necessary.

The earlier standalone harness remains development evidence for the narrow Dynasty-replacement operation. Final production acceptance supersedes its earlier iterative statuses, but does not establish behavior for every government, title arrangement, special character state, multiplayer configuration, mod combination, or CK3 version outside `1.19.*`.

## 4. Production architecture

| Layer | Production identifier | File |
| --- | --- | --- |
| Character Interaction | `breedimp_exile_from_dynasty_interaction` | `MyCK3Mod/common/character_interactions/breedimp_exile_from_dynasty_interaction.txt` |
| Shared validation trigger | `breedimp_can_exile_dynasty_member` | `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_exile_triggers.txt` |
| Parent classification trigger | `breedimp_ancestor_outside_actor_dynasty_trigger` | `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_exile_triggers.txt` |
| Blood-impurity trigger | `breedimp_recipient_has_blood_impurity_trigger` | `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_exile_triggers.txt` |
| Conditional personal-Prestige value | `breedimp_exile_prestige_cost_value` | `MyCK3Mod/common/script_values/breedimp_dynasty_exile_values.txt` |
| Shared state-changing effect | `breedimp_exile_dynasty_member` | `MyCK3Mod/common/scripted_effects/breedimp_dynasty_exile_effects.txt` |
| Decaying opinion modifier | `breedimp_exiled_me_from_dynasty_opinion` | `MyCK3Mod/common/opinion_modifiers/breedimp_dynasty_exile_opinions.txt` |
| Ten-year character modifier | `breedimp_exiled_from_dynasty_modifier` | `MyCK3Mod/common/modifiers/breedimp_dynasty_exile_modifiers.txt` |
| Untimed character flag | `breedimp_was_exiled_from_dynasty` | applied inside `breedimp_exile_dynasty_member` |
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
- native `cost.prestige` using `breedimp_exile_prestige_cost_value`;
- default actor confirmation by omitting deprecated `needs_confirmation`;
- `auto_accept = yes` so an eligible AI recipient does not separately accept or reject;
- `is_shown` for stable visibility constraints; and
- `is_valid_showing_failures_only` plus a static `custom_tooltip.text` failure key for mutable recipient validation.

The interaction enters `scope:recipient` before calling the shared effect. No target argument is guessed for `create_dynasty`.

## 6. Shared effect and mutation boundary

RC2 performs this ordered transaction from recipient scope:

1. add `breedimp_exiled_me_from_dynasty_opinion` toward `scope:actor`;
2. add `60` base stress;
3. add `breedimp_exiled_from_dynasty_modifier` for ten years;
4. add the untimed `breedimp_was_exiled_from_dynasty` flag;
5. if the actor holds `house_head_hook` over the recipient, enter actor scope and remove only that hook; and
6. execute the existing Dynasty replacement as the final operation:

```text
create_dynasty = {
    spread_to_descendants = yes
    save_scope_as = breedimp_new_dynasty
}
```

The Dynasty form is supported by Lynn's verified `create_dynasty` sources and by the approved pre-RC2 runtime harness. Opinion, stress, modifier, and flag apply only to the selected recipient; the conditional hook removal applies only to the actor's exact `house_head_hook` over that recipient. Descendant propagation belongs only to `create_dynasty`.

The saved scope is retained from the verified harness form for traceability and possible diagnostic inspection. No further effect consumes it in v0.1.

## 7. Localisation and confirmation disclosure

English and Simplified Chinese provide explicit keys for:

- interaction name;
- description;
- confirmation prompt; and
- validation failure text;
- the opinion modifier; and
- the visible character modifier name and description.

The English name is **Exile from Dynasty**. The Simplified Chinese name is **逐出宗族**.

The description and prompt state that:

- the recipient and descendants enter a newly generated Dynasty;
- they leave the actor's Dynasty;
- the recipient's opinion of the actor decreases;
- the recipient gains stress and the ten-year Exiled from Dynasty modifier;
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
- scans, ancestor iteration beyond the recipient's legal parents, recurring execution, or bulk processing; or
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

## 11. Validation status and release gate

The frozen v0.1.0 production implementation is Boss-confirmed as runtime-verified. Production interaction visibility, English and Simplified Chinese localisation, hostile Dynasty presentation, supported target classes, native free/paid cost handling, House Head Hook removal, recipient consequences, descendant propagation, save/reload persistence, and absence of observed CK3 runtime errors are accepted for the release candidate.

The next required gate is restricted/private Steam Workshop upload and subscribe/download regression testing with the repository development path disabled. Investigating deferred claim behavior or implementing Phase 2 bulk Dynasty cleanup requires separate approval and testing.
