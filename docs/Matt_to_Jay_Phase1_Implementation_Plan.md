# Breed Improved Phase 1 - Implementation Plan

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6`
- Product approval source: Boss direction recorded for Phase 1
- Evidence status: Character Interaction structure is resolved; `create_dynasty` runtime behavior for the approved target class remains untested
- Execution boundary: Stage A and Stage B only, followed by static review

This document plans an isolated technical test. It does not approve production gameplay and does not claim that CK3 runtime behavior has passed.

## 1. Approved scope

The approved prototype tests one player-selected, explicitly confirmed character at a time.

The target must be:

- living;
- adult;
- highborn, represented only by the verified character check `is_lowborn = no`;
- unlanded;
- a non-ruler;
- neither House Head nor Dynast;
- in the actor's Dynasty;
- controlled by AI for this isolated test; and
- outside any untested special-title or leadership state by manual test setup.

The only state-changing operation is a character-scoped `create_dynasty` call. The prototype omits `spread_to_descendants`, custom Dynasty names, coats of arms, and player-selected replacement identity. It leaves claims, inheritance, traits, titles, imprisonment, marriage, parentage, court, realm, and political status untouched by script.

Explicitly excluded:

- every production file under `MyCK3Mod/`;
- a production Character Interaction;
- runtime execution during Stage A or Stage B;
- claims or claim iteration;
- `disinherit_effect` or other inheritance changes;
- `banish`, `move_to_pool`, imprisonment, and adventurer conversion;
- descendant propagation;
- Decisions, events, scans, iterators, recurring actions, and bulk behavior;
- candidate-reason logic for bastard or parent-Dynasty cases; and
- broader actors, rulers, landed characters, children, players, House Heads, Dynasts, or special leadership cases.

## 2. Evidence readiness review

| Construct | Expected scope and context | Exact vanilla evidence | Readiness | Registry action | Remaining uncertainty |
| --- | --- | --- | --- | --- | --- |
| `create_dynasty` | Effect in character scope; called inside the selected recipient's character scope | `common/scripted_effects/00_accolades_scripted_effects.txt`; `common/scripted_effects/10_dlc_tgp_japan_scripted_effects.txt`; `events/dlc/tgp/tgp_japan_decision_events.txt`; `events/dlc/tgp/tgp_mandala_task_contract_events.txt` | Exact `create_dynasty = { save_scope_as = new_dynasty }` form is implementation-ready for an isolated test | Add before harness creation | Runtime behavior on an arbitrary existing highborn unlanded target and the omission of `spread_to_descendants` require T1/T7 |
| Character Interaction definition | Top-level definition in `common/character_interactions/*.txt` | `common/character_interactions/00_choose_favorite_interaction.txt`, `choose_favorite_interaction`; `common/character_interactions/_character_interactions.info` | Implementation-ready for the selected test shape | Add required fields and restrictions | Production policy is not established by this test form |
| `scope:actor`, `scope:recipient` | Character scopes available inside Character Interaction triggers and accepted effects | `common/character_interactions/00_choose_favorite_interaction.txt` | Implementation-ready | Add | None for the isolated scope flow |
| Default actor confirmation | Omit deprecated `needs_confirmation` | `common/character_interactions/_character_interactions.info`; omission in `choose_favorite_interaction` | Implementation-ready | Add | No custom confirmation-localisation suffix is verified or used |
| `auto_accept = yes` | Top-level interaction field | `common/character_interactions/00_choose_favorite_interaction.txt`; `_character_interactions.info` | Implementation-ready | Add | This controls recipient acceptance, not the actor's confirmation window |
| Same-Dynasty comparison | Trigger comparison inside `is_shown` | `common/character_interactions/00_choose_favorite_interaction.txt`; supporting inverse form in `common/character_interactions/00_dynast_interactions.txt` | Implementation-ready | Add | None for this comparison |
| Actor/recipient AI gating | `is_ai` on actor or recipient character scope | `common/character_interactions/00_choose_favorite_interaction.txt` | Implementation-ready | Add | Production multiplayer policy remains deferred |
| Visible failure reasons | `custom_tooltip = { text = <key> <trigger> }` inside `is_valid_showing_failures_only` | `common/character_interactions/00_choose_favorite_interaction.txt`; standard button behavior in `gui/interaction_confirmation.gui` | Implementation-ready | Add | Conditions placed only in `is_shown` are not assumed to display reasons |
| `is_alive` | Character trigger on recipient scope | `common/character_interactions/00_education_interactions.txt`, `offer_ward_interaction` | Implementation-ready | Add | None for the isolated target check |
| `is_lowborn` | Character trigger on recipient scope | `common/character_interactions/06_ep3_scheme_interactions.txt`, `start_challenge_status_interaction` | Implementation-ready | Add | `is_lowborn = no` proves only the script check, not a broader undocumented definition of highborn |
| `is_adult`, `is_landed`, `is_ruler` | Character triggers on the target | `events/relations_events/parent_events.txt`, `parent_1009_valid_new_courtier`; recipient-context support in `common/character_interactions/00_diarch_interactions.txt` and `common/character_interactions/00_fp3_interactions.txt` | Implementation-ready for the isolated combination | Add | Lynn did not find the exact landed/ruler pair together inside one interaction block; both predicates and recipient context are independently verified |
| `is_house_head` | Character trigger negated for the target | `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`; recipient support in `common/character_interactions/10_tgp_japan_interactions.txt` | Implementation-ready | Add | None for the excluded target class |
| `is_dynast` | Character trigger negated for the target | `events/lifestyles/statecraft_lifestyle/diplomacy_family_events.txt`, `diplomacy_family_2300_relative_trigger`; definition in `common/scripted_triggers/00_dynasty_triggers.txt` | Implementation-ready | Add | The verified spelling is `is_dynast`; `is_dynasty_head` is not approved |
| English localisation | `localization/english/*.yml`, `l_english:` header, explicitly referenced keys | `localization/english/interactions/choose_favorite_l_english.yml` | Implementation-ready | Add | UTF-8 BOM is observed in the source file but not asserted as a universal engine requirement |

## 3. Blocking research assessment

The Character Interaction research request from the technical proposal is resolved by `docs/research/Lynn_to_Jay_CharacterInteraction_Evidence.md`.

| Research request | Classification for current work | Assessment |
| --- | --- | --- |
| Exact `every_dynasty_member` evidence | Only blocks later bulk functionality | No iterator is used in Stage A/B. |
| Native bulk selection and preview patterns | Only blocks later bulk functionality | Decisions and bulk management are excluded. |
| Exact Character Interaction confirmation and recipient pattern | Non-blocking; resolved | Lynn verified the selected `choose_favorite_interaction` structure, scopes, default confirmation, failure display, accepted hook, and localisation form. |
| Cross-Dynasty `set_house` call context | Non-blocking | The approved prototype uses only `create_dynasty`. |

No additional Lynn request blocks the isolated harness. The remaining questions are runtime questions for T1/T7 and must be answered by controlled CK3 testing and save inspection, not by inventing script or returning them to research.

## 4. Development stages

### Stage A - Syntax and evidence preparation

1. Register every construct used by the harness in `ck3_syntax_reference.md`.
2. Record concise vanilla provenance with exact paths, enclosing identifiers where Lynn supplied them, minimal excerpts, context, and limitations.
3. Keep unverified behavior clearly separated from verified script form.

### Stage B - Isolated test harness

1. Create a standalone test mod under `tests/phase1_create_dynasty/`.
2. Add one Character Interaction based on the verified `choose_favorite_interaction` structure.
3. Use static recipient checks and exactly one `create_dynasty` effect.
4. Add only the explicitly referenced English localisation keys.
5. Perform static review without launching CK3.

### Stage C - Controlled CK3 tests

Blocked pending separate approval. Run T1 and T7 from clean, recorded baselines; inspect errors, state changes, and save/reload persistence. Do not reinterpret a parser-clean load as behavioral success.

### Stage D - Recorded-result review

Jay reviews complete T1/T7 evidence. A pass must demonstrate the approved target changes affiliation, descendants do not, excluded state remains unchanged, and the result survives save/reload.

### Stage E - Production Character Interaction

Blocked pending Stage D approval. Production code must be designed separately and must not be copied automatically from the test harness.

### Stage F - Production localisation, validation, confirmation, and regression tests

Blocked pending Stage E approval. This stage must add approved actor authority, candidate reasons, production feedback, final revalidation, and regression coverage from verified evidence only.

## 5. Exact repository changes

### Created documentation and evidence

- `docs/Matt_to_Jay_Phase1_Implementation_Plan.md` - this approved implementation/testing plan; development documentation.
- `.agents/skills/ck3-mod-development/references/ck3_vanilla_examples/phase1_create_dynasty_interaction_1_19_0_6.md` - concise CK3 `1.19.0.6` provenance; development evidence.
- `docs/testing/phase1_create_dynasty_t1_t7.md` - T1/T7 protocol and empty result forms; test documentation.

### Modified reference

- `.agents/skills/ck3-mod-development/references/ck3_syntax_reference.md` - register only the exact constructs required by the harness.

### Created test-only files

- `tests/phase1_create_dynasty/BreedImprovedPhase1Test.mod` - portable launcher template with `path="<LOCAL_MOD_PATH>"`.
- `tests/phase1_create_dynasty/BreedImprovedPhase1Test/descriptor.mod` - test content descriptor.
- `tests/phase1_create_dynasty/BreedImprovedPhase1Test/common/character_interactions/breedimp_test_create_dynasty_interaction.txt` - one test-only Character Interaction with ID `breedimp_test_create_dynasty_interaction`.
- `tests/phase1_create_dynasty/BreedImprovedPhase1Test/localization/english/breedimp_test_create_dynasty_l_english.yml` - static English name, description, and failure reasons using `breedimp_test_` keys.

### Left untouched

- every file under `MyCK3Mod/`;
- root production launcher template `MyCK3Mod.mod`;
- installed vanilla CK3 files;
- README, project rules, product designs, technical proposal, and Lynn's research;
- all production event, Decision, scripted trigger, scripted effect, GUI, and gameplay paths.

## 6. Test harness design

The safest available method is a standalone, test-only Character Interaction because Lynn verified its single-recipient scope, explicit player initiation, default confirmation, visible validation failures, and `on_accept` recipient access. It avoids vanilla modification, iteration, scheduled execution, and production-file contamination.

The harness uses:

- a player-only actor;
- one AI recipient selected through the ordinary interaction menu;
- same-Dynasty and non-self visibility gates;
- target-class checks before the interaction can be sent;
- default actor confirmation by omitting deprecated `needs_confirmation`;
- recipient auto-acceptance through `auto_accept = yes`; and
- one recipient-scoped `create_dynasty` operation.

Runtime success requires all of the following:

- the intended target receives a replacement Dynasty and associated House;
- the actor and every non-target character remain unchanged;
- no descendant changes affiliation when `spread_to_descendants` is omitted;
- claims, traits, titles, succession observations, court, imprisonment, marriage, and parentage show no unexpected mutation;
- no relevant parser or runtime error is recorded; and
- the result persists after save/reload.

Runtime failure includes a parser/runtime error, failure to change the target, descendant propagation, any excluded state change, unstable save/reload behavior, or an unexplained side effect. The current runtime status is `NOT RUN`.

## 7. Production Character Interaction plan

Production work is deferred. If T1/T7 pass and Jay authorizes conversion, the production interaction should be planned as follows:

- Visibility: player-authority policy, same managed Dynasty, non-self, and any cheap identity gates.
- Availability: shared production eligibility with exact player-readable failures.
- Scopes: verified `scope:actor` and `scope:recipient` only, with every additional scope link separately evidenced.
- Final revalidation: repeat all mutable safety and eligibility checks immediately before mutation using a verified execution pattern.
- Confirmation: preserve default confirmation or adopt another verified CK3 pattern only after review.
- Mutation: exactly one approved recipient-scoped affiliation operation.
- Feedback: add only a verified success/failure presentation form.
- Localisation: production `breedimp_` keys, verified explicit references, verified dynamic text only if later evidence supports it.

Still unresolved for production: actor authority, bastard/parent-Dynasty candidate reasons, special-title exclusions expressible in script, final-revalidation architecture, success feedback, dynamic target/Dynasty text, and production naming. The test harness does not decide those policies.

## 8. Risk controls

- Unsupported targets are hidden or disabled by the narrow verified target checks and by manual T1/T7 setup restrictions.
- Descendant propagation is prevented in script by omitting `spread_to_descendants`; T7 must verify the runtime default before production.
- Repeated automatic execution is impossible because the harness has no event, Decision, pulse, on_action, iterator, scan, or background process.
- Partial feature composition is prevented by allowing exactly one state-changing operation.
- Claims and inheritance cannot be modified because no related constructs appear in the test mod.
- Political exile cannot be triggered because the test mod contains no court movement, banishment, imprisonment, title, government, or adventurer operation.
- Test scripts are isolated under `tests/` and have test-only metadata and identifiers; production conversion requires a new approval and implementation pass.
- Unverified syntax is kept out of runnable files. Every game-defined token in the harness is registered with versioned evidence and restrictions.

## 9. Approval gates

- Test-harness creation: approved only for the Stage A/B files listed above.
- CK3 launch and T1/T7 execution: requires new Jay approval after static review.
- Recording runtime or save/reload results: requires the same runtime approval and actual observed evidence.
- Production conversion: requires T1/T7 review and explicit Jay approval.
- Broader eligibility: requires separate evidence, tests, and Boss approval for affected player-facing behavior.
- Optional claims, inheritance, political, court, descendant, or identity consequences: require separate Boss product approval and technical verification.
- Dynasty Decision or bulk management: requires later Lynn evidence, architecture review, and explicit approval.

## 10. Immediate next action

Complete Stage A evidence registration and create the isolated Stage B test harness, then stop after static review with runtime status `NOT RUN`.
