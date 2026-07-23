# Breed Improved v0.2.0 Phase 2 — Manual Runtime Acceptance Matrix

- First-round end-to-end status: `BOSS-REPORTED PASS — 2026-07-23`
- Fourth-option focused regression: `BOSS-REPORTED PASS — 2026-07-23`
- Final v0.2.0 runtime acceptance: `PASS — USER-CONFIRMED 2026-07-23`
- Latest bilingual display revision: `PASS — USER-CONFIRMED FINAL RC`
- Runtime tester: Ray
- CK3 target: `1.19.0.6`
- Production compatibility target: `1.19.*`
- Build under test: `v0.2.0 final release candidate; not yet published`
- Matt release-preparation static review: `PASS — 2026-07-23; CK3 NOT RUN`
- Release gate: `READY FOR RAY UPLOAD`

Matt did not launch CK3 while preparing this release candidate. Runtime results in this document were supplied and approved by the user after Ray's CK3 testing; Matt's static validation is recorded separately and is not presented as the source of those runtime results.

## First-round end-to-end result record

The Boss reported the following results from the first CK3 end-to-end pass. These results apply to the build tested before the present copy, layout, tooltip, and fourth-option revision:

- Phase 1 individual **Exile from Dynasty** interaction: `PASS — no regression observed`;
- **Manage Dynasty Cleanup** Decision startup: `PASS`;
- Bloodline Cleanup candidate generation and sequential presentation: `PASS`;
- Negative Congenital Trait Cleanup candidate generation and sequential presentation: `PASS`;
- selecting or sparing candidates one by one: `PASS`;
- ending review early while retaining the current list: `PASS`;
- final confirmation presentation: `PASS`;
- final execution for selected branch roots and descendants: `PASS`; and
- after Negative Congenital Trait Cleanup, no member with a target negative congenital trait remained in the test Dynasty: `PASS`.

These observations predate the later UI and fourth-option revisions.

## Latest focused regression record

The Boss reported the following results after the fourth review option was changed to **“Enough. Exile them all.”**:

- the fourth option operates correctly: `PASS`;
- the current and remaining candidates are added correctly: `PASS`;
- characters explicitly spared earlier are not re-added: `PASS`; and
- the workflow reaches final confirmation: `PASS`.

The later candidate-introduction line-break correction, six visible Unicode quotation marks, tooltips, removed technical warnings, and affected option flows were subsequently tested and accepted in CK3.

## 0. Pre-test setup

1. Use a disposable test save or a verified backup; do not use an irreplaceable campaign save.
2. Use the existing CK3 Launcher local Mod entry whose content path resolves directly to this repository's `MyCK3Mod/` production root. Do not test the current public Workshop upload, because Phase 2 has not been uploaded or approved for release.
3. Enable Breed Improved in a controlled playset. Record every other enabled Mod and its load position; for the baseline pass, prefer Breed Improved alone.
4. Confirm the game reports CK3 `1.19.0.6` and record all enabled DLC and game rules.
5. Test English and Simplified Chinese in separate launches or controlled language changes.
6. Preserve the pre-test CK3 error log, then inspect the new log after each suite. Do not treat absence of visible UI problems as proof that the log is clean.
7. Do not select or create a new Workshop item and do not upload the generated `dist/workshop/BreedImproved/` staging directory during this test pass.

## 1. Test environment record

| Field | Result |
| --- | --- |
| Test date | `2026-07-23 — final acceptance confirmed by user` |
| Tester | `Ray` |
| CK3 full version | `Project test target 1.19.0.6; exact runtime build not separately restated in final confirmation` |
| Breed Improved source revision | `Current v0.2.0 final release candidate` |
| Enabled DLC | `Not separately recorded` |
| Game rules | `Not separately recorded` |
| Language | `English and Simplified Chinese` |
| Playset and load order | `Not separately recorded` |
| New game or existing save | `Not separately recorded` |
| Debug mode used | `Not separately recorded` |
| Error-log path reviewed | `Reviewed by Ray; path not separately recorded` |

For each case, record the test character IDs or stable save-visible identifiers, before/after House and Dynasty, screenshots where useful, error-log observations, unexpected effects, and a final `PASS`, `FAIL`, or `BLOCKED` result.

## 2. Entry, permission, and mode-selection tests

### P2-ENTRY-1 — Player Dynast entry

Setup: use a living player-controlled Dynast.

Expected:

- **Manage Dynasty Cleanup** is visible and can be opened;
- the Decision shows exactly **Bloodline Cleanup** and **Negative Congenital Trait Cleanup**;
- the introduction matches the approved courtly narrative in English and Simplified Chinese;
- each mode remains clearly identifiable and explains its player-facing purpose without exposing internal validation or script flow;
- opening the Decision does not change any character; and
- the candidate scan begins only after choosing one mode and confirming the Decision.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-ENTRY-2 — Authority and AI exclusion

Setup: inspect a player who is not the Dynast, a dead/inapplicable actor where inspection is possible, and AI behavior over a reasonable observation period.

Expected:

- a player who is not the living Dynast cannot start the workflow;
- AI never initiates the Decision; and
- no scan, event, or Dynasty change occurs in the background.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-ENTRY-3 — Exit before scan

Setup: open the Decision and close it without confirming a mode.

Expected: no candidate event, flag change, cost, or Dynasty mutation.

Result: `PASS — USER-CONFIRMED FINAL RC`

## 3. Bloodline Cleanup candidate matrix

Use otherwise eligible, unprotected, living AI members of the actor's Dynasty. Check each case independently.

| Case | Recipient state | Expected candidate result | Runtime result |
| --- | --- | --- | --- |
| P2-BLOOD-1 | Has `bastard` | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-2 | Has `legitimized_bastard` | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-3 | Existing legal father and mother are both outside actor Dynasty | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-4 | Exactly one legal parent is outside actor Dynasty; the other is inside | Excluded unless P2-BLOOD-1/2 also applies | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-5 | One legal parent exists outside actor Dynasty; the other legal parent is missing | Excluded unless P2-BLOOD-1/2 also applies | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-6 | Both legal parents are missing | Excluded unless P2-BLOOD-1/2 also applies | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-7 | Both existing legal parents are inside actor Dynasty | Excluded unless P2-BLOOD-1/2 also applies | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-8 | Save contains hidden biological-parent information but legal parents do not satisfy the rule | Hidden information does not affect candidacy | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-9 | Spouse or descendants are outside actor Dynasty, but recipient has no qualifying reason | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-10 | Both legal parents explicitly exist and each is either lowborn or in a Dynasty outside the actor's Dynasty | Included; an existing lowborn parent counts as outside the actor's Dynasty | `PASS — USER-CONFIRMED FINAL RC` |
| P2-BLOOD-11 | A legal parent changes Dynasty before scan or before final revalidation | Use the parent's current script-visible Dynasty state | `PASS — USER-CONFIRMED FINAL RC` |

For included cases, verify that every matching public reason is displayed. Missing parents must never be presented as proof of outside bloodline.

## 4. Negative Congenital Trait Cleanup matrix

Each exact active trait below must independently make an otherwise eligible character a candidate. Test at least one character per key; where practical, use a controlled save or debug setup that does not alter the production scripts.

| Trait group | Exact keys | Expected | Runtime result |
| --- | --- | --- | --- |
| Negative appearance | `beauty_bad_1`, `beauty_bad_2`, `beauty_bad_3` | Each key includes recipient and displays its own reason | `PASS — USER-CONFIRMED FINAL RC` |
| Negative intellect | `intellect_bad_1`, `intellect_bad_2`, `intellect_bad_3` | Each key includes recipient and displays its own reason | `PASS — USER-CONFIRMED FINAL RC` |
| Negative physique | `physique_bad_1`, `physique_bad_2`, `physique_bad_3` | Each key includes recipient and displays its own reason | `PASS — USER-CONFIRMED FINAL RC` |
| Other fixed negative preset | `clubfooted`, `hunchbacked`, `lisping`, `stuttering`, `dwarf`, `inbred`, `spindly`, `scaly`, `wheezing`, `bleeder`, `infertile` | Each key includes recipient and displays its own reason | `PASS — USER-CONFIRMED FINAL RC` |

### P2-TRAIT-MULTI — Multiple matching negative traits

Setup: one otherwise eligible character with at least two preset traits.

Expected: the candidate appears once and every matching negative trait reason is displayed.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-TRAIT-POSITIVE — Positive warning does not offset candidacy

Use a candidate who has one fixed negative trait plus one of:

- `beauty_good_1`, `beauty_good_2`, `beauty_good_3`;
- `intellect_good_1`, `intellect_good_2`, `intellect_good_3`;
- `physique_good_1`, `physique_good_2`, `physique_good_3`;
- `pure_blooded`; or
- `fecund`.

Expected: the negative trait still creates candidacy and the positive-trait warning is visible. Repeat sufficiently to cover every positive warning key.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-TRAIT-POSITIVE-ONLY — Positive traits alone

Setup: an otherwise eligible character with one or more positive warning traits and none of the 20 fixed negative keys.

Expected: excluded from the trait-mode candidate set.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-TRAIT-EXCLUSIONS — Non-preset conditions

Test representative diseases, injuries, stress traits, education traits, lifestyle traits, commander traits, personality traits, event states, age states, `albino`, `giant`, hidden genetic health variants, and inactive/carrier-only states without an active preset key.

Expected: none creates candidacy by itself.

Result: `PASS — USER-CONFIRMED FINAL RC`

## 5. Shared mandatory exclusions

Run both modes against each state.

| Case | State | Expected | Runtime result |
| --- | --- | --- | --- |
| P2-EXCLUDE-1 | Actor themself | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-2 | Living ancestor of the actor who otherwise matches the mode | Excluded, so descendant propagation cannot move the actor indirectly | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-3 | Any player-controlled recipient | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-4 | Dynast | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-5 | Any House Head | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-6 | Dead character | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-7 | Lowborn character | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-8 | Character outside actor Dynasty | Excluded | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-9 | Otherwise eligible minor | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-10 | Otherwise eligible adult | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-11 | Otherwise eligible unlanded character | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-12 | Otherwise eligible landed ruler | Included | `PASS — USER-CONFIRMED FINAL RC` |
| P2-EXCLUDE-13 | Otherwise eligible current player heir | Included | `PASS — USER-CONFIRMED FINAL RC` |

No test should reveal an extra age, ruler, title, government, marriage, court, or heir restriction.

## 6. Individual bulk-protection tests

### P2-PROTECT-1 — Add protection

Setup: an otherwise manageable, living, highborn AI member of the actor's Dynasty.

Expected:

- **Protect from Bulk Cleanup** is available;
- confirmation adds persistent individual bulk protection;
- the character is excluded from both modes; and
- the ordinary individual **Exile from Dynasty** interaction remains independently available if its own conditions are met.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-PROTECT-2 — Remove protection

Expected:

- **Remove Bulk Cleanup Protection** is shown for the protected character;
- removing protection does not exile or otherwise mutate the character; and
- the character reappears in each mode whose candidate rule they satisfy.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-PROTECT-3 — Persistence and invalid authority

Save and reload after adding protection. Also inspect the interactions after the actor stops being Dynast or the recipient leaves the Dynasty, where practical.

Expected: protection persists across save/reload; invalid actors/recipients cannot manage it.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-PROTECT-4 — Direct protection is not whole-branch protection

Setup: protect a character who is a descendant of a separate eligible ancestor, then select that ancestor.

Expected: the protected character is never offered as a direct candidate, but the review disclosure correctly warns that they still move as part of the selected ancestor's descendant branch. This first implementation intentionally does not claim whole-branch protection.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-PROTECT-5 — Mandatory exclusion inside an affected descendant branch

Setup: prepare an otherwise eligible selected root with a descendant who is either a House Head or, in a controlled multiplayer setup, controlled by another player. Do not select or directly process that descendant.

Expected for the current conservative implementation: the protected descendant never appears as a direct candidate or execution root, but the candidate disclosure warns that the complete descendant branch moves. Record whether CK3 moves that descendant through `spread_to_descendants`, confirm that no target-only stress/opinion/modifier/Hook consequence is applied to the descendant, and flag the result for Boss product-boundary review. The actor remains protected separately by the actor-ancestor exclusion.

Result: `PASS — USER-CONFIRMED FINAL RC`

## 7. Candidate presentation tests

For a minor, adult, landed ruler, unlanded character, current heir, character with children, and character with multiple reasons, verify in both English and Simplified Chinese:

- name and portrait identify the same candidate;
- age is correct;
- relationship to the actor is correct;
- landed/unlanded text is correct;
- primary title is shown only for a landed candidate;
- child/no-child disclosure is correct;
- a candidate with only deceased recorded children receives the inclusive recorded-child disclosure;
- current mode is correct;
- every matching candidate reason is visible;
- positive warning appears only when applicable;
- child or descendant impact information remains visible;
- the former generic red warning about Dynasty replacement, relatives, titles, claims, marriage, court, government, and succession is absent; and
- text fits the event window without broken keys, raw scope names, or severe clipping.

Result: `PASS — USER-CONFIRMED FINAL RC`

## 8. Review and confirmation control flow

### P2-FLOW-1 — Select, spare, and finish early

Setup: at least three candidates.

Action: select one, spare one, then use **“That will do for now.”** before reviewing the rest.

Expected:

- no gameplay state changes before final confirmation;
- only the selected candidate is proposed at final confirmation; and
- a character left unselected is not later made a direct root; unreviewed characters may still move only when they belong to the clearly disclosed descendant branch of a selected root.

Result: `BOSS-REPORTED PASS — select, spare, and early-finish flow`

### P2-FLOW-2 — Add current and remaining candidates

Action: select one candidate, explicitly spare another, then use **“Enough. Exile them all.”** on the next candidate.

Expected:

- earlier selections remain selected;
- the explicitly spared character remains excluded;
- the current and all remaining eligible branch roots are added;
- ancestor-first handling, direct-candidate protection, and duplicate-branch-root collapse remain in force;
- the workflow opens final confirmation; and
- no Dynasty or v0.1 consequence changes occur until final confirmation is accepted.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-FLOW-3 — Cancel from final confirmation

Expected: no selected candidate or descendant changes, including after reaching final confirmation through **“Enough. Exile them all.”**

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-FLOW-4 — No candidates / no selection

Test a mode with zero eligible candidates, then a run in which every candidate is kept.

Expected: the empty final state is understandable, offers no executable confirmation, and closes without effects.

Result: `BOSS-REPORTED PASS — existing zero-candidate and empty-selection handling`

### P2-FLOW-5 — Revalidation

Where a controlled setup can invalidate a selected target between review and final execution without altering production scripts, verify that the invalid target is skipped while other valid selections remain executable.

Expected: no partial consequences are applied to the invalid target.

Result: `BOSS-REPORTED PASS — final safety revalidation at mechanism level; edge-case setup details not separately recorded`

## 9. Execution and v0.1 regression tests

For a minor, adult, unlanded target, landed ruler, and current player heir, record before/after:

- House and Dynasty;
- descendants' House and Dynasty;
- parents and siblings;
- titles and government;
- House Head and Dynast;
- succession and current player heir;
- claims;
- spouse and marriage;
- court, realm, and vassal relationships;
- imprisonment;
- actor's House Head Hook over recipient;
- recipient opinion of actor;
- recipient stress;
- ten-year modifier; and
- permanent exile marker.

Expected for each executed branch root:

- target and all descendants enter one generated replacement Dynasty;
- parents and siblings remain unchanged;
- titles, claims, marriage, court, government, imprisonment, and political status are not directly changed by Breed Improved;
- CK3 may recalculate succession and the player heir;
- an existing actor-held House Head Hook is removed;
- no unrelated Hook is removed;
- recipient receives the exact v0.1 opinion, stress, ten-year modifier, and permanent marker consequences;
- the batch workflow applies no separate Prestige or other resource cost; and
- the individual v0.1 interaction still has its existing 0/100 personal-Prestige behavior.

Result: `BOSS-REPORTED PASS — core Phase 2 execution, descendant propagation, and Phase 1 regression; full per-field record not supplied`

## 10. Branch overlap tests

### P2-BRANCH-1 — Selected ancestor and selected descendant

Setup: an eligible ancestor and eligible descendant both satisfy the selected mode.

Expected: the ancestor is reviewed before the descendant. If the ancestor is selected, the descendant is not later offered as a separate direct candidate; only the highest still-valid selected branch root is directly executed. The descendant moves once through ancestor propagation and does not receive the target-only v0.1 consequences a second time.

Result: `BOSS-REPORTED PASS — ancestor-first review and duplicate branch-root folding at mechanism level`

### P2-BRANCH-1B — Declined ancestor unlocks descendant

Setup: an eligible ancestor and eligible descendant both satisfy the selected mode. Leave the ancestor unselected and continue.

Expected: the descendant can then be reviewed and independently selected or left unselected. A descendant left unselected must not later be moved by a qualifying ancestor, because all such candidate ancestors were reviewed first.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-BRANCH-2 — Selected ancestor becomes invalid

Setup: select an eligible ancestor, which prevents its candidate descendants from being offered in that run. Where a safe controlled setup is possible, invalidate the selected ancestor before final execution.

Expected: the invalid selected ancestor is skipped with no partial consequences. Its unselected descendants are not executed implicitly as replacement roots. A later new run may review a still-eligible descendant normally.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-BRANCH-3 — Converging branches from non-ancestor roots

Setup: two eligible selected roots are not ancestors of each other but share a descendant, for example through an intra-Dynasty marriage.

Expected inspection: record whether the shared descendant is moved more than once, which final Dynasty they occupy, whether any duplicate or unexpected consequence occurs, and all error-log output.

Pass criterion: no corrupt or contradictory state, no duplicate target-only consequences on the shared descendant, and a result acceptable to Jay/Boss. Static evidence does not prove this case; a failure requires a new design/implementation decision rather than an invented descendant iterator.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-BRANCH-4 — Multiple independent selected roots

Setup: select at least two eligible roots that are not ancestors of each other and have no shared descendants.

Expected: the final execution snapshot remains stable while multiple `create_dynasty` operations run; each root receives the v0.1 target-only consequences exactly once, each separate descendant branch moves once, and neither branch is skipped or duplicated.

Result: `PASS — USER-CONFIRMED FINAL RC`

## 11. Scale, continuity, and save/reload

### P2-SCALE-1 — Large Dynasty

Run both modes on a large Dynasty with many candidates. Record candidate count if manually observable, review duration, UI responsiveness, repeated/missing candidates, and error-log output.

Expected: each candidate is reviewed at most once in one run, the chain reaches final confirmation, and the game remains responsive.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-SAVE-1 — Save/reload during review

Attempt save/reload with the candidate event open or between review steps where CK3 permits it.

Expected inspection: record whether the event context, selected list, reviewed list, mode, and current candidate survive consistently. This is an observation gate; static evidence does not claim persistence across save/reload mid-flow.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-SAVE-2 — Save/reload after execution

After a multi-target confirmation, save, reload, advance time, and inspect every executed root and affected descendant again.

Expected: Dynasty changes, v0.1 consequences, political state, and individual protection markers remain consistent; no delayed background cleanup occurs.

Result: `PASS — USER-CONFIRMED FINAL RC`

### P2-CONTEXT-1 — Consecutive independent runs

Complete one Bloodline Cleanup run, then immediately start a new Negative Congenital Trait Cleanup run, and repeat in the opposite order where practical.

Expected: mode scope, candidates, reviewed characters, selections, and execution roots from the first run do not leak into the second run. Each run displays only its own mode and current qualifying candidates.

Result: `PASS — USER-CONFIRMED FINAL RC`

## 12. Focused first-round revision regression matrix

All cases in this section apply to the post-first-round revision. The user confirmed the final English and Simplified Chinese presentation and all six option flows as passing in CK3.

| Case | Check | Pass criteria | Result |
| --- | --- | --- | --- |
| P2-REV-01 | Manage Dynasty Cleanup introduction | The approved English and Simplified Chinese narrative appears exactly, with the paragraph break intact. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-02 | Bloodline candidate introduction | Narration and quoted dialogue are on adjacent lines, followed by one blank line before candidate-specific information. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-03 | Negative-trait candidate introduction | Narration and quoted dialogue are on adjacent lines, followed by one blank line before candidate-specific information. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-04 | Candidate generic warning removal | No generic red warning about Dynasty replacement, relatives, titles, claims, marriage, court, government, succession, or player heir appears on the candidate page. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-05 | Final technical explanation removal | The final page contains no text about revalidation, branch roots, folding selected descendants, or applying an existing effect. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-06 | Final red warning removal | The former red generated-Dynasty and no-rollback warning is absent. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-07 | Four review labels | All four review labels show the approved text with visible Unicode curly double quotation marks. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-08 | Two final labels | Both final labels show the approved text with visible Unicode curly double quotation marks. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-09 | Six option tooltips | Every review and final option has the approved, non-empty tooltip; no raw localisation key appears. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-10 | Option 1 | **“Get out of my dynasty!”** adds only the current candidate to the final list, continues review, and does not exile immediately. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-11 | Option 2 | **“Very well. I’ll spare you.”** records the current candidate as reviewed but unselected, then continues. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-12 | Option 3 | **“That will do for now.”** retains the current list, skips all remaining candidates, and opens final confirmation without exiling anyone. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-13 | Option 4 bulk addition | **“Enough. Exile them all.”** adds the current candidate and every remaining eligible branch root, then opens final confirmation. | `BOSS-REPORTED PASS` |
| P2-REV-14 | Option 4 respects prior mercy | A candidate explicitly spared earlier in the same review remains absent from the final list. | `BOSS-REPORTED PASS` |
| P2-REV-15 | Option 4 branch handling | Existing ancestor-first ordering, direct-candidate protection, and duplicate branch-root collapse still apply; no branch root is added twice. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-16 | Option 4 has no immediate consequence | Before final confirmation, House, Dynasty, descendants, stress, opinion, modifiers, flags, Hooks, titles, and all other gameplay state remain unchanged. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-17 | Cancel after Option 4 | **“I’ll think on it.”** ends the workflow after bulk addition with no character or Dynasty changes and no leaked workflow state. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-18 | Final execution regression | **“So be it!”** still exiles every listed valid branch root and its descendants through the existing execution effect. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-19 | Phase 1 regression | The individual Exile from Dynasty interaction retains its verified eligibility, cost, and consequences. | `PASS — USER-CONFIRMED FINAL RC` |
| P2-REV-20 | English UI integrity | English shows no Chinese text, missing/raw key, removed technical copy, or obsolete option text; layout remains readable. | `PASS — USER-CONFIRMED FINAL RC` |

The user confirmed the equivalent Simplified Chinese UI integrity check as part of final v0.2.0 acceptance.

## 13. Error-log and final acceptance record

After every suite, inspect CK3 logs for:

- unknown trigger/effect/scope errors;
- invalid event or Decision fields;
- missing localisation;
- invalid trait or asset keys;
- event-target-list or saved-scope errors;
- invalid Dynasty operations; and
- repeated-event or performance warnings attributable to Breed Improved.

| Gate | Result |
| --- | --- |
| Both modes render and transfer correctly | `PASS — USER-CONFIRMED FINAL RC` |
| Bloodline matrix passes | `PASS — USER-CONFIRMED FINAL RC` |
| Exact trait preset and warnings pass | `PASS — USER-CONFIRMED FINAL RC` |
| Shared exclusions pass | `PASS — USER-CONFIRMED FINAL RC` |
| Individual protection passes | `PASS — USER-CONFIRMED FINAL RC` |
| Review/cancel/final-confirm flow passes | `PASS — USER-CONFIRMED FINAL RC` |
| v0.1 behavior remains unchanged | `BOSS-REPORTED PASS` |
| Ancestor/descendant collapse passes | `BOSS-REPORTED PASS — mechanism level` |
| Converging-branch behavior accepted | `PASS — USER-CONFIRMED FINAL RC` |
| English localisation passes | `PASS — USER-CONFIRMED FINAL RC` |
| Simplified Chinese localisation passes | `PASS — USER-CONFIRMED FINAL RC` |
| Large-Dynasty test passes | `PASS — USER-CONFIRMED FINAL RC` |
| Save/reload tests pass | `PASS — USER-CONFIRMED FINAL RC` |
| CK3 error log contains no Phase 2 errors | `PASS — USER-CONFIRMED FINAL RC` |
| Focused first-round revision passes | `PASS — USER-CONFIRMED FINAL RC` |
| Ray recommendation | `PASS — USER-CONFIRMED FINAL RC` |
| Jay/Boss runtime approval | `PASS — USER-CONFIRMED FINAL RC` |

Phase 2 is implemented and runtime-accepted for v0.2.0. Ray recommended release, and Jay/Boss approved the final release artifact. The repository is ready for Ray's manual update of the existing Workshop item; this document does not claim that upload or publication has occurred.
