# Breed Improved Phase 2 - Multi-Mode Dynasty Cleanup Implementation Plan

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 evidence target: `1.19.0.6`
- Production compatibility target: `1.19.*`
- Implementation status: `IMPLEMENTED — STATIC REVIEW PASSED; MANUAL RUNTIME NOT RUN`
- Runtime status: `NOT RUN`
- Existing release baseline: v0.1.0 individual **Exile from Dynasty**

This document records the conservative implementation decisions used to turn the approved Phase 2 product baseline into a testable CK3 implementation. It does not claim runtime success and does not alter the accepted v0.1.0 individual interaction contract.

## 1. Frozen first-implementation scope

The first Phase 2 implementation contains:

- one player-initiated Dynasty cleanup Decision available to a living player-controlled Dynast;
- two mutually exclusive candidate modes:
  - Bloodline Cleanup;
  - Negative Congenital Trait Cleanup;
- one shared mandatory-protection layer;
- a player-managed individual protection marker shared by both modes;
- sequential candidate review with explicit select, skip, finish, and cancel choices;
- candidate reason, age, landed status, relationship, positive-trait warning, descendant-impact warning, and succession warning disclosure;
- a separate final confirmation step;
- immediate final revalidation;
- ancestor/descendant overlap collapse before mutation; and
- reuse of the runtime-verified `breedimp_exile_dynasty_member` effect.

The implementation intentionally excludes:

- combined-mode scoring or union/intersection modes;
- player-selected arbitrary trait lists;
- accepted-founder-parent-specific UI or save-specific whitelists;
- automatic, scheduled, recurring, or background scans;
- automatic target selection or execution;
- decisions that execute without candidate review and final confirmation;
- marriage, betrothal, claim, title, court, government, imprisonment, or inheritance changes beyond the behavior already produced by the v0.1.0 shared exile effect;
- automatic marriage or breeding assistance; and
- custom GUI or custom graphics.

## 2. Conservative product defaults

### 2.1 Mode selection

Exactly one mode is selected per run. The Decision uses CK3's verified native single-option Decision widget. The implementation does not remember the previous mode.

### 2.2 Bloodline candidate rule

The batch candidate trigger is deliberately separate from `breedimp_recipient_has_blood_impurity_trigger`, which remains the v0.1.0 individual interaction's Prestige-cost rule.

A recipient satisfies the Phase 2 Bloodline Cleanup mode when either:

1. the recipient has `bastard` or `legitimized_bastard`; or
2. both script-visible legal parents explicitly exist and both parents are outside the actor's current Dynasty.

Consequences of this conservative rule:

- one outside-Dynasty parent alone is insufficient;
- a missing father or mother is insufficient for the parent branch;
- an explicitly existing lowborn legal parent counts as outside the actor's Dynasty, following the already verified project helper;
- hidden biological-parent secrets are not read;
- spouses and ancestry beyond the two legal parents are irrelevant; and
- current legal-parent and Dynasty state is used at scan and revalidation time.

### 2.3 Negative congenital trait preset

The first implementation uses an explicit fixed list of 20 CK3 `1.19.0.6` trait keys verified in `common/traits/00_traits.txt`:

- `beauty_bad_1`, `beauty_bad_2`, `beauty_bad_3`;
- `intellect_bad_1`, `intellect_bad_2`, `intellect_bad_3`;
- `physique_bad_1`, `physique_bad_2`, `physique_bad_3`;
- `clubfooted`, `hunchbacked`, `lisping`, `stuttering`, `dwarf`;
- `inbred`, `spindly`, `scaly`, `wheezing`, `bleeder`; and
- `infertile`.

The candidate must have at least one listed active trait. The implementation does not use `num_of_bad_genetic_traits`, trait groups, inactive-carrier checks, illness triggers, injury triggers, or a numerical genetic score. This prevents unrelated or mod-added content from silently entering the fixed preset.

The following fixed positive-trait set is disclosure-only and never cancels candidacy:

- `beauty_good_1`, `beauty_good_2`, `beauty_good_3`;
- `intellect_good_1`, `intellect_good_2`, `intellect_good_3`;
- `physique_good_1`, `physique_good_2`, `physique_good_3`;
- `pure_blooded`; and
- `fecund`.

### 2.4 Player protection

Phase 2 provides one persistent, project-owned individual protection marker. A marked character is excluded as a direct candidate and execution root in both modes.

Protection affects only direct Phase 2 candidate/root selection. It does not prevent the marked character from moving as a descendant of another selected root, and it does not disable or change the v0.1.0 individual **Exile from Dynasty** interaction.

Accepted-founder-parent and whole-descendant-branch protection workflows remain deferred. The first implementation does not create an effectively irreversible inherited protection marker on an ancestor that could later die and become inaccessible to a Character Interaction. No name or save-specific character ID is used.

### 2.5 Batch cost

The first Phase 2 test implementation adds no separate batch resource cost. It does not call or copy the individual interaction's conditional Prestige value and does not manually subtract Prestige. A future batch-cost policy remains a separate balance decision.

## 3. Shared eligibility and protection order

Every mode applies rules in this order:

1. mandatory eligibility;
2. player protection;
3. selected mode's candidate trigger;
4. player selection; and
5. final revalidation immediately before execution.

The mandatory layer excludes:

- the actor;
- any candidate who is an ancestor of the actor, because descendant propagation would otherwise move the actor indirectly;
- all player-controlled characters;
- dead characters;
- lowborn characters;
- characters outside the actor's current Dynasty;
- every House Head;
- the current Dynast; and
- any character failing the accepted v0.1.0 shared eligibility trigger.

No age, landed-status, ruler-status, heir-status, government, title-type, marriage, or court restriction is added. Individual bulk protection excludes the marked character as a candidate root; whole-descendant-branch protection remains deferred and is not implied by this marker.

## 4. Native CK3 workflow

### 4.1 Entry and mode selection

`breedimp_manage_dynasty_cleanup_decision` is shown only to a living player-controlled Dynast. It performs no candidate scan in its visibility checks. Candidate scanning starts only after the player selects a mode and confirms the Decision.

The Decision uses the verified `decision_option_list_controller` with two items. The selected item is exposed to the Decision effect as its named option scope, following CK3 `1.19.0.6` vanilla Decisions.

### 4.2 Candidate review

The Decision translates the selected mode into a saved actor scope, builds an event-context candidate list once, and records reviewed and selected candidates in separate event-context lists. It then saves one valid, not-yet-reviewed member as the current candidate. Candidate selection is ancestor-first: a character is not presented while a still-valid, unreviewed candidate ancestor remains. This prevents a player from declining a descendant and later selecting its ancestor. A character event shows the chosen candidate to the actor.

For each candidate the player can:

- select the candidate for final review;
- leave the candidate unselected and continue;
- finish candidate review early; or
- cancel the complete workflow.

Selecting or skipping changes only event-chain lists. It does not add temporary character flags, call `create_dynasty`, or apply any v0.1.0 exile consequence.

### 4.3 Disclosure

The candidate event identifies:

- the candidate and age;
- whether the candidate is landed;
- the candidate's relationship to the actor;
- the current mode;
- the exact bloodline reason or every exact fixed negative trait detected;
- whether the candidate also has a fixed positive congenital trait;
- that all descendants will move even when they do not share the candidate reason;
- that parents and siblings remain outside the moved branch; and
- that CK3 may recalculate succession and the player heir.

The first implementation discloses the full descendant branch as the impact scope. It does not claim an exact descendant count because no count-display form has been approved for this implementation.

### 4.4 Final confirmation and overlap collapse

After review, a separate confirmation event is shown. Confirming builds an execution snapshot containing only selected characters that:

- still satisfy the shared Phase 2 candidate trigger for the selected mode; and
- do not have another selected character as an ancestor.

This ancestor rule collapses overlapping selections to the highest selected branch root. A selected descendant therefore cannot be processed a second time when a selected ancestor's verified `create_dynasty` operation already moves that descendant.

Each execution-list member is revalidated again immediately before the shared v0.1.0 effect is called. An invalidated member is skipped; there is no unsupported rollback claim. Workflow state uses event-context scopes/lists rather than persistent character variables or workflow flags. Continuity and lifecycle of those lists across the complete Decision/event chain remain explicit runtime tests.

The verified ancestor check does not detect two selected roots that are not ancestors of each other but whose descendant branches converge, for example through an intra-Dynasty marriage. No arbitrary descendant iterator has been verified for this implementation. That topology is therefore a named manual-test case, not a statically solved behavior.

### 4.5 Cancel behavior

Cancel ends the event chain without calling the shared exile effect and therefore does not change Dynasty membership. Reviewed, selected, mode, and execution state uses saved event scopes/lists rather than persistent character flags. Persistent individual protection markers are separate and are not changed by cancellation.

## 5. Production file architecture

| Responsibility | Planned production file |
| --- | --- |
| Decision entry and mode widget | `MyCK3Mod/common/decisions/breedimp_dynasty_cleanup_decisions.txt` |
| Candidate, protection, warning, and revalidation triggers | `MyCK3Mod/common/scripted_triggers/breedimp_dynasty_cleanup_triggers.txt` |
| Workflow state, candidate continuation, overlap collapse, guarded execution, and cleanup | `MyCK3Mod/common/scripted_effects/breedimp_dynasty_cleanup_effects.txt` |
| Individual protection Character Interactions | `MyCK3Mod/common/character_interactions/breedimp_dynasty_cleanup_protection_interactions.txt` |
| Candidate review and final confirmation | `MyCK3Mod/events/breedimp_dynasty_cleanup_events.txt` |
| English text | `MyCK3Mod/localization/english/breedimp_dynasty_cleanup_l_english.yml` |
| Simplified Chinese text | `MyCK3Mod/localization/simp_chinese/breedimp_dynasty_cleanup_l_simp_chinese.yml` |

The event namespace is `breedimp_dynasty_cleanup`; the initial allocation is `breedimp_dynasty_cleanup.1000`–`.1099`.

## 6. Safeguards

- The existing `breedimp_exile_dynasty_member` effect remains the single mutation primitive; Phase 2 does not copy its consequences.
- The existing individual interaction, eligibility trigger, and Prestige-cost value remain unchanged.
- Every candidate and final target uses project-prefixed identifiers.
- Temporary workflow state uses event-context lists/scopes; only the player-managed individual protection uses a persistent character flag.
- No `on_action`, pulse, scheduled event, recurring event, or AI Decision execution is added.
- No candidate scan occurs before explicit player confirmation of a mode.
- No save-specific name or character ID is stored.
- No vanilla file is modified or copied wholesale.

## 7. Validation gates

### Static gate

Before handoff, static review must confirm:

- balanced braces and quotes;
- exact event namespace and caller consistency;
- every project localisation key exists in English and Simplified Chinese;
- UTF-8 BOM on both production localisation files;
- no unknown trait key outside the approved fixed sets;
- no age, landed, ruler, heir, government, marriage, court, or title eligibility restriction;
- no automatic or recurring entry point;
- no v0.1.0 gameplay regression;
- no duplicate copy of the shared exile consequences;
- no test-only identifier in production;
- Workshop staging includes every new production file and preserves the Workshop item ID; and
- `git diff --check` passes.

### Manual CK3 gate for Ray

Runtime approval is required for:

- both Decision mode options and their descriptions;
- candidate discovery and no-candidate behavior;
- select, skip, early finish, cancel, and final confirm paths;
- each bloodline rule branch;
- the fixed negative-trait preset and positive-trait warning;
- individual protection and its removal;
- minors, adults, unlanded characters, landed rulers, and current player heirs;
- ancestor/descendant overlap collapse;
- converging descendant branches from non-ancestor selected roots;
- target and all-descendant propagation through the unchanged shared effect;
- invalidation between review and confirm where practical;
- English and Simplified Chinese presentation;
- save/reload persistence of the individual protection marker; and
- CK3 error-log review.

Until those tests pass, Phase 2 remains a development implementation and must not be described as runtime-verified or released.

## 8. Static review result

Status: `PASS` on 2026-07-22.

Confirmed without launching CK3:

- braces and quotes are balanced in every new runnable script;
- event namespace, IDs, callers, and the allocated `1000`–`1099` range are consistent;
- the fixed trait union is exactly 20 negative keys, 11 positive warning keys, and the two approved public bastard-state keys;
- English and Simplified Chinese each contain 59 unique, matching keys with no missing or orphaned Phase 2 reference;
- both localisation files retain UTF-8 BOM;
- no age, landed, ruler, heir, government, title, marriage, or court eligibility restriction was added;
- no cost, automatic entry point, recurring action, claim/title/court mutation, descendant iterator, or copied `create_dynasty` block was added;
- Phase 2 calls the unchanged v0.1.0 mutation effect exactly once from its guarded execution path;
- all tracked v0.1.0 gameplay, localisation, and descriptor files are unchanged from `HEAD`;
- Workshop staging contains all 16 production files plus the separately classified thumbnail, with source/staging hashes matching;
- the staged descriptor contains exactly one `remote_file_id="3769010534"` and no local path;
- no `breedimp_test_` identifier or local absolute path appears in production or staging; and
- `git diff --check` passes.

This is a static result only. Runtime behavior, UI layout, list continuity, large-Dynasty performance, repeated Dynasty replacement, save/reload, and the named branch-topology cases remain `NOT RUN` pending Ray's manual matrix.
