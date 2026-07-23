# Breed Improved Phase 3 — Dynasty Matchmaking Manual Test Matrix

- Status: `PARTIAL RUNTIME ACCEPTANCE COMPLETE`
- CK3 target: `1.19.0.6 (Scribe)`
- Production compatibility target: `1.19.*`
- Build under test:
  `ISOLATED PROTOTYPE — POST-FIX RUNTIME PASS RECORDED FOR MAPPED CASES`
- Runtime approval: `RAY RUNTIME PASS RECORDED FOR THE SUPPLIED TEST SEQUENCES`
- Runtime result:
  `40 PASS / 0 FAIL / 116 NOT RUN / 0 BLOCKED`

This is the manual test specification and partial runtime record for the
isolated Phase 3 Dynasty Matchmaking prototype. Ray executed the supplied
smoke, relationship-path, reservation, batch-safety, ranking-boundary,
capacity-boundary, and tested performance sequences. Only the exact cases
mapped below are `PASS`; all stronger or unreported cases remain `NOT RUN`.
This record does not approve production implementation.

The prototype workflow namespace is `breedimp_p3_proto_matchmaking`. It uses **Approach B: Dynast override + authority limited to the current workflow**. A living player Dynast must explicitly confirm activation. A pre-activation cancellation does not consume the save; once activation occurs, the prototype's permanent one-workflow-per-save lock is consumed and is never cleared, even after completion, cancellation, failure, death, Dynast loss, save/load, or an orphaned visible event. This prevents a second workflow or stale event from being re-authorized in the same save. The lock does not waive any eligibility, marriage-legality, availability, age, kinship, duplicate-pair, or full-prevalidation rule.

The original 111-case matrix is preserved. Sixteen workflow-lock/lifecycle
cases, nine fixed-slot integrity cases, two role-direction age cases, and two
error-log cases first brought the total to 140. Sixteen P6 immediate-reservation
and completion-feedback regression cases bring the total to 156. The current
row totals are 40 `PASS`, 0 `FAIL`, 116 `NOT RUN`, and 0 `BLOCKED`.
Cases covering post-prototype product refinements remain `NOT RUN` as future
coverage; they are not mandatory gates for the first infrastructure prototype
unless its approved implementation scope includes that feature. Approach A is
retained only as deferred comparison coverage and is not the selected
prototype executor. Use a fresh baseline save for every activated workflow
case; do not attempt a second Phase 3 workflow in the same save.

The first runtime pass exposed a blocking accepted-character reservation
defect: accepted participants could reappear in later proposals, although the
final duplicate preflight still stopped the invalid plan. Matt corrected the
reservation path, and Ray's final retest did not reproduce the defect.

Ray also observed that one character from a displayed but unaccepted pair later
appeared with a different partner. This is expected. Displaying, skipping,
replacing, or declining a pair reserves neither character. Only a successfully
accepted and committed pair reserves both participants. An accepted participant
must not appear again as either subject or partner in another accepted plan
record.

### Runtime evidence mapping

The conversational labels "first sequence", "second sequence", and "third
sequence" are not matrix headings. The current evidence maps observations to
existing IDs by matching the tested action and expected result:

| Ray runtime observation | Matching matrix test IDs | Result | Notes |
| --- | --- | --- | --- |
| Entry cancellation, first activation, review/final cancellation, and abnormal-exit/load isolation | `P3-LIFE-01`-`04`, `P3-LIFE-09` | `PASS` | Stronger death, Dynast-loss, multiplayer, repeated-cancel, and other lifecycle variants remain `NOT RUN`. |
| Four direct relationship paths and tested persistence | `P3-B-01`-`04`, `P3-B-10` | `PASS` | This does not establish native-side-effect parity or a clean error log. |
| Valid multi-pair execution and one tested invalid-pair all-or-nothing abort | `P3-B-09`, `P3-VALID-01`, `P3-VALID-02` | `PASS` | Other invalidation causes remain `NOT RUN`. |
| Accepted-person, mirror, and overlapping-pair exclusion | `P3-STATE-01`-`03`, `P3-SLOT-05`, `P3-SLOT-06` | `PASS` | Displayed but unaccepted characters remain eligible. |
| Sixteen-pair boundary and seventeenth-pair non-overwrite behavior | `P3-SLOT-02`, `P3-SLOT-03` | `PASS` | Partial and malformed slot records remain `NOT RUN`. |
| Post-fix accepted-character reservation and duplicate rejection | `P3-RES-01`-`09` | `PASS` | Covers both accepted participants in both later roles, rejected repeat/mirror writes, and count stability. |
| Final duplicate preflight and completion-result timing | `P3-RES-14`, `P3-RES-15` | `PASS` | Final preflight remains defense in depth; mixed-type count-detail case `P3-RES-16` remains `NOT RUN`. |
| Adult fertility boundaries and age priority within the tier | `P3-FERT-02`, `P3-FERT-03`, `P3-FERT-05` | `PASS` | Covers `100/95/94`, `80/75/74`, inclusive absolute `0.05`, and within-tier age priority. |
| Minor age ordering and hard adult-minor boundaries | `P3-AGE-01`, `P3-AGE-04`-`07` | `PASS` | Both-role-direction and post-review birthday variants remain `NOT RUN`. |
| Tested large-Dynasty recommendation generation | `P3-SCALE-01` | `PASS` | Only the reported scenario is mapped; stronger scale and long-duration cases remain `NOT RUN`. |
| Unaccepted character later offered in a different pairing | Observation only | `EXPECTED BEHAVIOR CONFIRMED` | This does not establish every criterion in `P3-STATE-04` or `P3-STATE-05`, so those rows remain `NOT RUN`. |

No explicit CK3 `error.log` observation was supplied. `P3-ERR-01` and
`P3-ERR-02` therefore remain `NOT RUN`.

## 0. Test discipline and environment record

Use a disposable save or a verified backup. Prefer a controlled new game and a test Dynasty whose relevant characters can be identified reliably. Do not alter production scripts merely to make a case pass.

Before each suite:

1. Record the exact CK3 build, Breed Improved revision, enabled DLC, game rules, language, playset, load order, and all other enabled Mods.
2. Preserve a before-state for every involved character: character identifier, age, sex, fertility value or verified test proxy, traits, House, Dynasty, parents, siblings, spouse, betrothed, children, court, liege, titles, government, claims, succession positions, imprisonment, hostage state, activity state, and relevant religious status.
3. Record the proposed pair order, accepted-pair state, skipped/deferred state, and any reserved-character state visible to the tester.
4. Before final confirmation, compare saves or inspect every relevant relationship to ensure no marriage, betrothal, alliance, court, title, government, Prestige, claim, succession, or Dynasty state changed.
5. After execution, save, reload, advance at least one day, and inspect the CK3 error log.
6. Record each case as `PASS`, `FAIL`, or `BLOCKED` only after it is run. Preserve `NOT RUN` for every unmatched or stronger case.

| Environment field | Result |
| --- | --- |
| Test date | `EVIDENCE NOT PROVIDED` |
| Tester | `Ray` |
| CK3 full version | `Target: 1.19.0.6; exact runtime build EVIDENCE NOT PROVIDED` |
| Breed Improved revision | `Post-reservation-fix isolated prototype; exact commit EVIDENCE NOT PROVIDED` |
| Phase 3 approach | `Approach B isolated prototype — Dynast override limited to current workflow` |
| Enabled DLC | `EVIDENCE NOT PROVIDED` |
| Game rules | `EVIDENCE NOT PROVIDED` |
| Language | `EVIDENCE NOT PROVIDED` |
| Playset and load order | `EVIDENCE NOT PROVIDED` |
| Other enabled Mods | `EVIDENCE NOT PROVIDED` |
| New game or existing save | `EVIDENCE NOT PROVIDED` |
| Debug mode | `EVIDENCE NOT PROVIDED` |
| Error-log path reviewed | `EVIDENCE NOT PROVIDED`; log cases remain `NOT RUN` |

## 1. Candidate scope and marital-history groups

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-SCOPE-01 | Living highborn, never-married adult in the actor's current Dynasty; not married or betrothed; otherwise eligible. | Start matchmaking and review candidates. | Candidate inclusion, displayed marital-history group, proposed spouse, and proposed marriage type. | Character is eligible as a never-married adult and is considered for marriage, not betrothal. | `NOT RUN` |
| P3-SCOPE-02 | Living fertile divorced adult in the actor's Dynasty; no current spouse or betrothal. | Start matchmaking and review candidates. | Candidate inclusion and divorced-history classification. | Character is eligible for remarriage without any former relationship being recreated or modified. | `NOT RUN` |
| P3-SCOPE-03 | Living fertile widowed adult in the actor's Dynasty; no current spouse or betrothal. | Start matchmaking and review candidates. | Candidate inclusion and widowed-history classification. | Character is eligible for remarriage and the deceased spouse relationship remains historical. | `NOT RUN` |
| P3-SCOPE-04 | Living adult with a current spouse. | Start matchmaking and inspect all proposals. | Candidate and spouse-list presence. | Character is never an active target or proposed spouse; the existing marriage remains unchanged. | `NOT RUN` |
| P3-SCOPE-05 | Living character with a current betrothal. | Start matchmaking and inspect all proposals. | Candidate and spouse-list presence. | Character is never an active target or proposed spouse; the existing betrothal remains unchanged. | `NOT RUN` |
| P3-SCOPE-06 | Unmarried, unbetrothed minor in the actor's Dynasty; otherwise eligible. | Start matchmaking and review candidates. | Candidate inclusion and proposed relationship type. | Character is eligible only for a betrothal proposal. | `NOT RUN` |
| P3-SCOPE-07 | Fertility-zero or negative divorced/widowed adult plus at least one normal active target. | Start matchmaking and inspect active targets. | Whether the zero/negative-fertility character becomes an active target. | Character is not an active target solely because they are divorced or widowed. | `NOT RUN` |
| P3-SCOPE-08 | Same-Dynasty active target with no normal spouse candidate and one legal fertility-zero divorced/widowed character. | Exhaust normal spouse options. | Placeholder label, ranking position, and whether the placeholder is proposed only after normal options are exhausted. | Zero-fertility character is used only as a clearly identified last-resort placeholder and never outranks a normal legal match. | `NOT RUN` |
| P3-SCOPE-09 | Otherwise attractive unmarried character outside the actor's Dynasty. | Start matchmaking and inspect all proposals. | Candidate and proposed-spouse presence. | Character never appears as an active target or spouse candidate. | `NOT RUN` |
| P3-SCOPE-10 | Otherwise attractive lowborn character. | Start matchmaking and inspect all proposals. | Candidate and proposed-spouse presence. | Character never appears as an active target or spouse candidate. | `NOT RUN` |
| P3-SCOPE-11 | Same-Dynasty member who is dead. | Start matchmaking and inspect all proposals. | Candidate and proposed-spouse presence. | Dead character is excluded from every matchmaking role. | `NOT RUN` |

## 2. Adult fertility ranking and five-point tiers

Use controlled characters whose evaluated fertility values are known through a verified test method. Record raw values and displayed values; do not infer percentages from UI wording alone.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-FERT-01 | Adult target with legal candidates at negative, zero, ordinary positive, and greater-than-1.0 fertility values. Keep other factors as equal as possible. | Cycle through spouse recommendations. | Raw evaluated values, ordering, clamping or display behavior, and errors. | Ordering remains deterministic across negative, zero, ordinary, and greater-than-1.0 values; no overflow, wraparound, or invalid display occurs. | `NOT RUN` |
| P3-FERT-02 | Best candidate at 100% and comparison candidates at exactly 95% and 94%, with age/genetics arranged so the tier boundary is observable. | Request the best and next alternatives. | Tier membership and within-tier order. | 95% is in the best candidate's five-point tier; 94% is outside it. Age proximity can reorder 100% and 95% within the tier but cannot promote 94% into it. | `PASS` |
| P3-FERT-03 | Best candidate at 80% and comparison candidates at exactly 75% and 74%. | Request the best and next alternatives. | Tier membership and within-tier order. | The exact five-percentage-point boundary is inclusive: 75% shares the tier and 74% does not. | `PASS` |
| P3-FERT-04 | Best candidate at 6%, comparison candidates at 1% and 0%, with otherwise controlled factors. | Request the best and alternatives. | Low-value arithmetic and tier membership. | 1% shares the tier with 6%; 0% is outside a five-point-inclusive tier if the implementation uses exact percentage-point comparison. No negative or zero special case silently changes the boundary. | `NOT RUN` |
| P3-FERT-05 | Two candidates inside the same five-point tier: one closer in age but with weaker positive genetics; one farther in age with stronger genetics. | Review ordering. | Fertility tier, age gap, genetic indicators, and order. | Within one adult fertility tier, age proximity outranks beneficial genetics. | `PASS` |
| P3-FERT-06 | One candidate in a better fertility tier but with a worse age gap and weaker genetics than a lower-tier candidate. | Review ordering. | Tier assignment and order. | Better fertility tier remains the first adult ranking criterion. | `NOT RUN` |
| P3-FERT-07 | Candidates equal in fertility tier and age gap but different in beneficial genetics and kinship distance. | Review ordering. | Genetic score/reasons, kinship warning, and order. | Beneficial genetics breaks the tie before lower consanguinity; lower consanguinity breaks only a remaining tie. | `NOT RUN` |
| P3-FERT-08 | Same controlled adult pool tested before and after save/reload without changing character state. | Generate recommendations, save/reload, and regenerate. | Exact ordering and values before/after. | Identical state yields identical tier membership and ordering. | `NOT RUN` |

If an approved implementation replaces the dynamic comparison with fixed buckets, repeat P3-FERT-02 through P3-FERT-04 at every bucket edge and record the approved equivalence. A bucket implementation must not be accepted merely because it is close; Ray/Jay/Boss must approve any observable deviation from the five-percentage-point rule.

## 3. Minor ranking and hard adult–minor age exclusions

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-AGE-01 | Minor target with several legal minor candidates of different ages, while genetics and kinship are controlled. | Cycle recommendations. | Ages, absolute age gaps, and order. | Smallest age gap ranks first. | `PASS` |
| P3-AGE-02 | Minor candidates with equal age gap but different beneficial congenital traits. | Cycle recommendations. | Trait reasons and order. | Beneficial genetics breaks the age-gap tie. | `NOT RUN` |
| P3-AGE-03 | Minor candidates with equal age gap and equal beneficial genetics but different legal kinship distance. | Cycle recommendations. | Kinship classification and order. | More distant legal kin ranks first. | `NOT RUN` |
| P3-AGE-04 | Female age 29 paired with a minor; all other eligibility and doctrine checks pass. | Generate and attempt to accept the pair. | Whether the pair is proposed and accepted. | The Phase 3 hard threshold does not exclude age 29 by itself. | `PASS` |
| P3-AGE-05 | Female age exactly 30 paired with a minor; otherwise identical to P3-AGE-04. | Generate recommendations and search every alternative. | Candidate presence, warning text, and final-list presence. | Pair is never proposed, accepted, or executable. No fertility, trait, kinship, scarcity, or placeholder condition overrides the exclusion. | `PASS` |
| P3-AGE-06 | Male age 39 paired with a minor; all other eligibility and doctrine checks pass. | Generate and attempt to accept the pair. | Whether the pair is proposed and accepted. | The Phase 3 hard threshold does not exclude age 39 by itself. | `PASS` |
| P3-AGE-07 | Male age exactly 40 paired with a minor; otherwise identical to P3-AGE-06. | Generate recommendations and search every alternative. | Candidate presence, warning text, and final-list presence. | Pair is never proposed, accepted, or executable. No other factor overrides the exclusion. | `PASS` |
| P3-AGE-08 | Age-30 female/minor and age-40 male/minor pairs where both have exceptional congenital traits or `pure_blooded`. | Generate recommendations. | Pair presence and exclusion reason. | Both hard exclusions remain absolute. | `NOT RUN` |
| P3-AGE-09 | Age-threshold pair becomes invalid because one participant has a birthday after review but before final confirmation. | Accept before the birthday, advance time where the test harness permits, then open final confirmation. | Revalidation result and relationship state. | Invalid pair cannot execute; no other pair has mutated before full validation completes. | `NOT RUN` |
| P3-AGE-10 | Woman age 30 or older and a minor, tested once as subject and once as proposed partner. | Generate, search alternatives, and attempt acceptance in both role directions. | Candidate presence, role assignment, warning/failure text, stored direction/type, and final-list presence. | The female-30-plus/minor exclusion applies identically in both roles; neither ordinary nor matrilineal direction bypasses it. | `NOT RUN` |
| P3-AGE-11 | Man age 40 or older and a minor, tested once as subject and once as proposed partner. | Generate, search alternatives, and attempt acceptance in both role directions. | Candidate presence, role assignment, warning/failure text, stored direction/type, and final-list presence. | The male-40-plus/minor exclusion applies identically in both roles; neither ordinary nor matrilineal direction bypasses it. | `NOT RUN` |

## 4. High-age and placeholder behavior

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-HIGH-01 | High-age fertile divorced/widowed target with both similarly high-age and much younger legal candidates in the same fertility tier. | Review recommendations. | Ages, fertility tiers, and order. | Similarly high-age candidate is preferred through the approved age-proximity rule. | `NOT RUN` |
| P3-HIGH-02 | High-age target with a normal positive-fertility candidate and a closer-age zero-fertility placeholder. | Review recommendations. | Placeholder marker and order. | Normal candidate ranks before the placeholder despite the placeholder's closer age. | `NOT RUN` |
| P3-HIGH-03 | High-age target with no normal legal candidate and more than one zero-fertility placeholder. | Exhaust normal options and cycle placeholders. | Placeholder ordering, legal checks, and labels. | A placeholder may be proposed only after normal exhaustion; ordering is deterministic and every placeholder is clearly marked. | `NOT RUN` |

## 5. Doctrine, legality, and kinship

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-KIN-01 | Pair prohibited by the participants' current faith consanguinity rules. | Generate, search alternatives, and attempt final revalidation if the pair can be staged. | Pair presence and failure reason. | Pair is never executable and cannot be forced by score, scarcity, `pure_blooded`, or placeholder status. | `NOT RUN` |
| P3-KIN-02 | Two legal candidates: one closer cousin and one more distant relative, with preceding ranking factors equal. | Review recommendations. | Kinship labels/warnings and order. | More distant legal relative ranks first. | `NOT RUN` |
| P3-KIN-03 | Aunt/uncle–niece/nephew pair under a doctrine that prohibits it, then under a controlled doctrine that permits it. | Repeat generation under each doctrine. | Eligibility and warning under each faith configuration. | Eligibility follows the current verified vanilla legality result; legal-but-close pairing is visibly warned and ranked below a more distant equal candidate. | `NOT RUN` |
| P3-KIN-04 | Half-sibling pair and full-sibling pair under representative doctrine/game-rule configurations. | Generate recommendations. | Eligibility and kinship classification. | Vanilla-illegal pair is excluded; no implementation shortcut treats half siblings as unrelated. | `NOT RUN` |
| P3-KIN-05 | Ancestor–descendant pair. | Generate and search all alternatives. | Pair presence. | Pair is never proposed or executable. | `NOT RUN` |
| P3-KIN-06 | Legal close-kin pair with `pure_blooded` on one or both characters and a more distant otherwise equal candidate. | Review recommendations. | Legality, genetic indicator, kinship warning, and order. | `pure_blooded` may affect an approved genetic score but never overrides vanilla legality or the absolute adult–minor age exclusions. | `NOT RUN` |
| P3-KIN-07 | Pair legal during review; change faith/doctrine or another legality-relevant state before final confirmation. | Accept, change state through normal gameplay or a controlled test save, and confirm. | Full revalidation and before/after relationships. | Pair does not execute after becoming illegal; no partial batch mutation occurs. | `NOT RUN` |
| P3-KIN-08 | Actor's faith uses the exact vanilla `doctrine_consanguinity_dynastic` doctrine and the candidate pool contains only members of the actor's Dynasty. | Generate recommendations and exhaust every active target. | Candidate count, pair count, failure/empty-state presentation, and error log. | No same-Dynasty legal pair is produced. The workflow reports a clean zero-pair outcome and does not fall back to an outside-Dynasty or lowborn spouse. | `NOT RUN` |
| P3-KIN-09 | Mixed-faith pair where one character is the other's courtier, plus an otherwise comparable mixed-faith pair without that courtier relationship. | Compare the native legality result and Breed Improved recommendation/final validation for both pairs. | Each faith, courtier relationship, vanilla eligibility, Mod eligibility, and any failure reason. | Breed Improved follows the verified vanilla courtier exception in `can_marry_character_trigger`; it neither invents a stricter mixed-faith ban nor broadens the exception beyond the relationship CK3 recognizes. | `NOT RUN` |
| P3-KIN-10 | Separate parent–child, grandparent–grandchild, great-grandparent–great-grandchild, and deeper known direct-ancestor pairs, all represented by script-visible legal family links. | Generate recommendations and search all alternatives for every depth. | Family-link depth, pair presence, warning, and final-list presence. | Every direct ancestor–descendant pair is excluded; implementation is not limited to a shallow fixed depth. | `NOT RUN` |
| P3-KIN-11 | Verified half siblings sharing exactly one script-visible legal parent; include comparison cases with incomplete legal parent data and hidden biological information where safely observable. | Generate recommendations and compare kinship classification. | Shared legal parent, missing parent links, hidden information, displayed kinship, legality, and ordering. | Known legal half siblings are not treated as unrelated. Missing or hidden parent data is not fabricated, and the UI does not claim a relationship that script-visible family data cannot establish. | `NOT RUN` |

## 6. Authority, matchmakers, rulers, and special states

These cases must be evaluated separately for the chosen execution approach. A result under the native UI does not prove that a direct effect respects the same authority.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-AUTH-01 | Eligible same-Dynasty AI unlanded courtier in the player's court. | Enter the confirmed active workflow, accept a legal pair, and execute through Approach B. | Workflow authority state, absence of matchmaker/AI-acceptance gating, and resulting relationship. | Pair can execute only inside the active override workflow without unrelated consent; every non-authority legality rule still passes. | `NOT RUN` |
| P3-AUTH-02 | Eligible same-Dynasty AI unlanded character in another ruler's court. | Enter the confirmed active workflow, accept a legal pair, and execute through Approach B. | Court and liege, absence of vanilla matchmaker redirection or AI-acceptance gating, resulting relationship, and all other legality checks. | External-court recipient is testable under the temporary Dynast override without matchmaker or AI acceptance; court membership does not waive any other eligibility or legality rule. | `NOT RUN` |
| P3-AUTH-03 | Eligible landed AI ruler in the actor's Dynasty. | Enter the confirmed active workflow, accept a legal pair, and execute through Approach B. | Absence of vanilla matchmaker/AI-acceptance gating, titles, government, court/realm, lieges/vassals, succession, and resulting relationship. | Landed ruler is testable under the temporary Dynast override; no title, government, realm, or political state is directly changed, and all non-authority legality remains enforced. | `NOT RUN` |
| P3-AUTH-04 | Eligible landed AI child whose liege is a parent. | Enter the confirmed active workflow and execute an otherwise legal pair through Approach B. | Parent-liege relationship, absence of matchmaker/AI-acceptance gating, titles, government, and resulting relationship. | The temporary override permits execution without parent-liege acceptance only during the active workflow; all other legality and final-prevalidation rules remain mandatory. | `NOT RUN` |
| P3-AUTH-05 | Eligible same-Dynasty AI minor in another court. | Enter the confirmed active workflow and execute an otherwise legal betrothal through Approach B. | Court and liege, absence of matchmaker/AI-acceptance gating, betrothal direction, resulting matchmaker/owner state, and all hard age/legality checks. | External-court minor can receive only a legal betrothal under the active override; no direct marriage occurs and no non-authority safeguard is bypassed. | `NOT RUN` |
| P3-AUTH-06 | Player-controlled Dynasty member in multiplayer. | Generate recommendations. | Candidate/proposed-spouse presence and any consent UI. | Other player-controlled characters are excluded from the isolated prototype and are never silently forced; broader multiplayer authorization requires a separately approved consent design. | `NOT RUN` |
| P3-AUTH-07 | Imprisoned candidate or proposed spouse. | Generate recommendations and attempt both approaches where possible. | Eligibility, native failure reason, and any direct-effect bypass. | Character is excluded unless a separately approved policy exists; direct effects must not bypass the standard restriction accidentally. | `NOT RUN` |
| P3-AUTH-08 | Hostage or ward/guardian currently traveling. | Generate recommendations. | Eligibility and failure reason. | Character is excluded while CK3 standard-interaction availability rejects the state. | `NOT RUN` |
| P3-AUTH-09 | Clergy, monk/nun, vowed character, or character with a verified cannot-marry state. | Generate recommendations under faiths that permit or forbid clergy marriage where applicable. | Exact eligibility per state and doctrine. | Current vanilla marriage legality is respected; no guessed exception is introduced. | `NOT RUN` |
| P3-AUTH-10 | Pregnant, lover, concubine, or other special relationship-state character who is otherwise unmarried. | Generate recommendations. | Eligibility, current relationships, pregnancy, and side effects. | Behavior matches the approved policy; no lover, concubine, pregnancy, or parentage state changes before or because of review. | `NOT RUN` |
| P3-AUTH-11 | Character traveling, participating in an activity, commanding, at war, serving as regent/diarch, or holding a special leadership state. | Generate recommendations and attempt execution. | Availability, warnings, event interruption, and state after execution. | Every supported state is explicitly approved and runtime-stable; unsupported states are excluded rather than guessed. | `NOT RUN` |
| P3-AUTH-12 | Representative feudal, clan, tribal, administrative, nomadic, landless-adventurer, republic, and theocratic characters where setup is possible. | Generate recommendations and attempt only approved cases. | Eligibility, authority, court movement, titles, and government. | No government is changed by Breed Improved; unsupported government combinations are excluded with no parser/runtime errors. | `NOT RUN` |

## 7. Temporary authority lifecycle

Every case in this suite must inspect both player-visible behavior and the implementation's approved workflow-authority state. The exact storage mechanism is an implementation detail; the acceptance rule is behavioral: no usable override before entry, outside the active workflow, or after any terminal/invalid state.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-LIFE-01 | Living player-controlled Dynast at the entry confirmation. | Cancel before activation, then reopen the Decision in the same save. | Lock state, authority state, candidates, relationships, and Decision availability. | Pre-activation cancellation consumes neither authority nor the one-workflow-per-save lock; no scan, reservation, or relationship change occurs. | `PASS` |
| P3-LIFE-02 | Living player-controlled Dynast with at least one otherwise eligible same-Dynasty AI pair. | Confirm activation and enter the first review state. | Permanent lock, authority state, candidate state, and relationship state. | The lock is set only after confirmation; the workflow becomes usable once and no relationship changes before final confirmation. | `PASS` |
| P3-LIFE-03 | Active workflow during candidate review. | Cancel before final confirmation, then attempt the Decision again in the same save. | Relationships, temporary plan cleanup, permanent lock, and new-entry result. | No relationship changes; reachable temporary state is cleaned, but the permanent lock remains and rejects every later Phase 3 entry. | `PASS` |
| P3-LIFE-04 | Active workflow with accepted pairs on final confirmation. | Cancel final confirmation, then attempt a new entry. | Every proposed relationship, temporary state, permanent lock, and new-entry result. | No pair executes; temporary state is cleaned where reachable; the consumed lock remains and a second workflow is rejected. | `PASS` |
| P3-LIFE-05 | Living player Dynast whose Dynasty yields zero eligible targets or zero legal pairs. | Confirm activation, observe the empty result, then attempt a new entry. | Empty-state handling, relationships, temporary state, permanent lock, and entry result. | No relationship changes; the lock remains consumed after activation and rejects a later workflow in the same save. | `NOT RUN` |
| P3-LIFE-06 | Active workflow owned by a living player Dynast; use an isolated setup capable of making the actor die before confirmation. | Cause actor death, then attempt to continue, save/reload, advance one day, or invoke a stale event. | Actor validity, lock, authority state, relationships, pending events, and error log. | Workflow is inert and executes no pair; reachable state is cleaned without scope errors, and the permanent lock prevents reauthorization in that save. | `NOT RUN` |
| P3-LIFE-07 | Active workflow; use an isolated setup capable of transferring Dynast status away from the actor before confirmation. | Remove the actor's Dynast status and attempt to continue, save/reload, or invoke a stale event. | Current Dynast, lock, authority state, relationships, UI handling, and error log. | The workflow becomes invalid and executes zero pairs; no later Dynast may reuse the consumed lock in that save. | `NOT RUN` |
| P3-LIFE-08 | Any terminal activated workflow: completed, review-canceled, final-canceled, no-candidate, or preflight-failed. | Attempt to start the Decision again with the original actor and with another eligible Dynast. | Lock value, entry visibility/validity, relationships, and error log. | The permanent one-workflow-per-save lock rejects all second workflows without clearing, replacing, or reauthorizing old state. | `NOT RUN` |
| P3-LIFE-09 | Active workflow at review, final confirmation, and immediately before execution. | Close the visible event abnormally where possible; save/reload and advance one day without resuming. | Orphaned event/state, permanent lock, relationships, recurring behavior, and error log. | No relationship operation is reachable from the orphaned/old event; no automatic or delayed matchmaking occurs; the lock remains consumed. | `PASS` |
| P3-LIFE-10 | No active confirmed workflow, plus an isolated test-only way to invoke the internal final execution entry point or preserved stale pair data. | Attempt internal execution before activation and after an activated terminal/orphaned workflow. | Guard result, lock, all relationships, authority state, and error log. | Internal execution is rejected with zero mutations whenever live activation authority is absent, stale, invalid, or already terminal. | `NOT RUN` |
| P3-LIFE-11 | One active workflow owned by player Dynast A, plus a second eligible player Dynast B in an isolated multiplayer or equivalent setup. | Attempt B's first entry while A is active, then after A reaches a terminal state. | Entry availability, global lock, both actors' slots, relationships, and error log. | The permanent lock rejects B in both cases; A's state is never replaced or contaminated. | `NOT RUN` |
| P3-LIFE-12 | Active workflow with one committed pair and one uncommitted review state. | Save, reload, inspect immediately, advance one day, then attempt resume, stale-event use, cancellation, and new entry. | Lock, saved Dynasty, committed fields, partial state, UI reachability, relationships, and error log. | Load cleanup may remove reachable temporary residue, but the permanent lock remains; neither resume nor a new workflow can create a relationship without live authority. | `NOT RUN` |
| P3-LIFE-13 | Fresh baseline save before any Decision confirmation. | Open and cancel the entry confirmation twice without activating. | Lock state, candidate generation, and all relationships. | Repeated pre-activation cancellations leave the save eligible for its first activation and create no hidden state. | `NOT RUN` |
| P3-LIFE-14 | Fresh baseline save with a confirmed activation and no final execution. | Save immediately after activation, reload, and inspect before any option is selected. | Lock persistence, authority/event reachability, candidate state, relationships, and error log. | The lock persists across save/load; no automatic resume or delayed relationship change is observed. | `NOT RUN` |
| P3-LIFE-15 | Activated workflow that reaches full-preflight failure. | Dismiss the failure result, reload, and attempt the Decision again. | Zero-effect abort, lock persistence, entry result, and error log. | The failed batch creates no relationship and still consumes the one permitted workflow for that save. | `NOT RUN` |
| P3-LIFE-16 | Activated workflow with an older queued or copied event reference retained by a diagnostic setup. | Invoke the old event after cancellation, failure, or load cleanup. | Guard failure, lock, all relationship fields, and error log. | The old event cannot resume, reauthorize, rebuild candidates, or execute a relationship. | `NOT RUN` |

## 8. Review workflow and pair-state integrity

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-STATE-01 | At least four eligible targets and several possible spouses. | Accept the first proposed pair and continue. | Accepted list and availability of both participants in later recommendations. | Both participants become reserved and neither is proposed again. | `PASS` |
| P3-STATE-02 | Candidate pool where A–B and B–A would otherwise both score highly. | Accept A–B and continue. | Later pair list. | Mirrored B–A is never proposed or stored. | `PASS` |
| P3-STATE-03 | Candidate pool where A–B, B–C, and C–A could form an overlapping cycle. | Accept one pair, then continue through all remaining proposals. | Participant reservation and final list. | No character appears in two accepted pairs and no overlapping cycle is created. | `PASS` |
| P3-STATE-04 | One target with at least three ranked spouse options. | Use **next candidate for this person** repeatedly. | Candidate order, wrap/end behavior, and state of rejected alternatives. | Alternatives appear in deterministic order without duplicates; cycling does not reserve or mutate anyone. | `NOT RUN` |
| P3-STATE-05 | One proposed pair followed by other candidates. | Skip the pair and continue. | Skipped-pair state and later proposals. | Exact skipped pair is not re-proposed in the same run; both people may remain eligible for different partners if the approved design allows it. | `NOT RUN` |
| P3-STATE-06 | One active target followed by other candidates. | Defer the person and continue. | Deferred-person state and later proposals. | Deferred person is not shown again in the same run and is not silently accepted. | `NOT RUN` |
| P3-STATE-07 | Accept at least one pair, then finish review early. | Select the finish-early option. | Final summary and unreviewed candidates. | Accepted pairs remain; unreviewed pairs are not added; no relationship changes before final confirmation. | `NOT RUN` |
| P3-STATE-08 | Accept, skip, and defer different cases. | Cancel the review before final confirmation. | Every relationship and temporary workflow state. | No marriage, betrothal, alliance, cost, court move, title change, or persistent matchmaking state remains. | `NOT RUN` |
| P3-STATE-09 | Accepted list containing several pairs. | Open final summary without confirming. | Pair identities, ages, age gaps, fertility information, genetics, kinship, relationship type, direction, placeholder markers, and state changes. | Summary matches the accepted list exactly and no gameplay consequence exists yet. | `NOT RUN` |
| P3-STATE-10 | Accepted list containing ordinary, matrilineal, marriage, and betrothal entries where supported. | Cancel from final confirmation. | Relationship, alliance, Prestige, court, title, government, succession, temporary state, and permanent lock. | Entire operation ends with no gameplay changes; temporary state is cleaned where reachable and no later Phase 3 run is permitted in that save. | `NOT RUN` |
| P3-STATE-11 | Same candidate state in two separate fresh baseline saves. | Cancel one activated workflow in the first save and independently activate the other. | Skipped, deferred, accepted, reserved, current-person state, and permanent lock per save. | No temporary state crosses save boundaries; each save permits only its first confirmed activation. | `NOT RUN` |
| P3-STATE-12 | Accept the same logical set in different review orders on separate fresh baseline saves. | Reach final confirmation in both controlled saves. | Normalized pair set, execution order, and permanent lock state. | No duplicate, mirror, or person reuse appears; deterministic rules yield an equivalent valid pair set where tie-break state is identical. | `NOT RUN` |

### 8.1 Fixed-slot storage checkpoint

These cases validate the P0-selected actor-owned capacity. They do not approve
the combined lifecycle before P1.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-SLOT-01 | Clean workflow with one eligible accepted pair. | Commit the first pair to slot 01 and open the review/final summary path without executing it. | Slot 01 `subject`, `partner`, `direction`, `relationship_type`, `placeholder`, `reservation_id`, display identity, and relationship state. | All six fields preserve their intended values; the slot-specific marker is present only after the five payload fields; the pair is readable but causes no relationship change. | `NOT RUN` |
| P3-SLOT-02 | Fifteen valid committed pairs and one additional eligible pair. | Commit the sixteenth pair to slot 16 and reach final preflight without execution. | Every field in slots 01-16, especially slot 16, summary count, reservations, comparison result, and error log. | Slot 16 behaves identically to slot 01; all 16 pairs remain distinct and intact; no field wraps to another slot. | `PASS` |
| P3-SLOT-03 | Sixteen valid committed pairs and a seventeenth eligible proposal. | Attempt to accept pair 17. | Capacity presentation/result, all 96 existing fields, summary, reservations, and relationships. | The seventeenth pair is rejected or routed through the approved capacity path; slots 01-16 remain byte-for-byte/logically unchanged; nothing is overwritten, truncated, wrapped, or executed. | `PASS` |
| P3-SLOT-04 | Separately approved diagnostic setup with payload fields in one slot but its `reservation_id` absent; repeat with other required fields missing. | Enter review, summary, preflight, cancellation, and cleanup paths. | Whether the partial slot reserves either character, appears in UI, reaches execution, and whether every existing field is guardedly removed. | An uncommitted/partial slot is ignored for reservation, summary, and execution; preflight never treats it as valid; cleanup removes each existing field without errors. | `NOT RUN` |
| P3-SLOT-05 | One committed `A-B` pair and proposals reusing A or B in either subject/partner position. | Attempt `A-C`, `C-A`, `B-C`, and `C-B`. | Identity comparisons against both roles, accepted count, stored fields, and errors. | Every reused-character proposal is rejected before commit; one character appears in at most one accepted pair. | `PASS` |
| P3-SLOT-06 | One committed `A-B` pair with `B-A` otherwise legal and highly ranked. | Attempt to propose, accept, or inject the mirrored pair. | Candidate presentation, role comparisons, committed slots, final preflight, and errors. | `B-A` is neither committed nor executable. Mirror prevention follows from the same two-role character reservation invariant. | `PASS` |
| P3-SLOT-07 | Separately approved diagnostic setup with all five payload fields present but a missing `reservation_id` or one that references a character other than that slot's subject. | Enter summary and final preflight, then cancel/clean. | Subject-to-marker comparison, plan validity, relationship state, field cleanup, and error log. | The slot is not committed; no relationship operation is reachable; the whole plan follows the approved failure path; guarded cleanup removes residue without touching another slot. | `NOT RUN` |
| P3-SLOT-08 | Sixteen committed, pairwise-distinct slots. | Run the complete reservation and preflight integrity pass without executing relationships. | All unordered slot-pair checks, all subject/partner role comparisons, committed-slot count, and error log. | Exactly 120 unordered slot-pair comparisons and at most 480 role-to-role character-reference comparisons cover the 16 slots; no duplicate or mirror pair passes. | `NOT RUN` |
| P3-SLOT-09 | One valid committed slot plus diagnostic records with swapped direction/type flags, an invalid placeholder enum, and a reservation reference copied from a slot with a different subject. | Open summary, invoke preflight, then cancel. | Enum validation, reservation-to-subject equality, summary visibility, relationship state, and guarded cleanup. | Only a record whose five payload values are valid and whose final reservation reference equals its subject is committed; every malformed record is non-executable and is cleaned without affecting valid slots. | `NOT RUN` |

### 8.2 P6 immediate-reservation and completion-feedback regression

These cases target the runtime blocker observed in the pre-correction build.
They supplement rather than replace the existing state, slot, preflight, and
relationship-path cases. Use a fresh baseline save for every confirmed
activation. If an acceptance-time duplicate attempt is not naturally reachable
through the test UI or an already approved test setup, record that part as
`BLOCKED`; do not invent or assume a diagnostic invocation.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-RES-01 | At least four eligible characters; accept displayed pair A (subject) and B (partner). | Continue review and inspect every later active-subject proposal. | Slot containing A-B, next-proposal timing, and every later subject identity. | A is unavailable as a subject before the next proposal is selected and never reappears in that role. | `PASS` |
| P3-RES-02 | Committed A-B plus another eligible subject C with several possible partners. | Continue with C and exhaust the partner alternatives available through normal review. | Every later partner identity and the committed A-B slot. | A is unavailable as a partner immediately after A-B commits and never reappears in that role. | `PASS` |
| P3-RES-03 | At least four eligible characters; accept displayed pair A (subject) and B (partner). | Continue review and inspect every later active-subject proposal. | Slot containing A-B, next-proposal timing, and every later subject identity. | B is unavailable as a subject before the next proposal is selected and never reappears in that role. | `PASS` |
| P3-RES-04 | Committed A-B plus another eligible subject C with several possible partners. | Continue with C and exhaust the partner alternatives available through normal review. | Every later partner identity and the committed A-B slot. | B is unavailable as a partner immediately after A-B commits and never reappears in that role. | `PASS` |
| P3-RES-05 | Committed A-B and a naturally reachable or already approved retained proposal A-C. | Attempt to accept A-C. If no such proposal can be reached safely, record the case as `BLOCKED`. | Failure/recovery presentation, accepted count, existing slot, next empty slot, and all relationships. | The same subject cannot be accepted twice; rejection occurs before any slot field or count changes. | `PASS` |
| P3-RES-06 | Committed A-B and a naturally reachable or already approved retained proposal C-B. | Attempt to accept C-B. If no such proposal can be reached safely, record the case as `BLOCKED`. | Failure/recovery presentation, accepted count, existing slot, next empty slot, and all relationships. | The same partner cannot be accepted twice; rejection occurs before any slot field or count changes. | `PASS` |
| P3-RES-07 | Committed A-B with a naturally reachable or already approved retained mirror proposal B-A. | Attempt to accept B-A. If no such proposal can be reached safely, record the case as `BLOCKED`. | Failure/recovery presentation, accepted count, committed slots, and all relationships. | The mirror pair cannot be accepted; A-B remains the only committed record involving either character. | `PASS` |
| P3-RES-08 | Committed A-B and any safely reachable repeated-character proposal from P3-RES-05 through P3-RES-07. | Record all six fields of the next empty slot, attempt duplicate acceptance, then inspect the same slot again. | `subject`, `partner`, `direction`, `relationship_type`, `placeholder`, `reservation_id`, prior committed slots, and errors. | Rejected duplicate acceptance writes none of the six fields and does not alter any earlier slot. | `PASS` |
| P3-RES-09 | Same controlled duplicate attempt as P3-RES-08. | Record accepted-pair and summary counts before and after the rejected attempt. | Stored count, displayed count, committed-slot count, and next proposal. | No accepted-pair, summary, or committed-slot count increases after rejection. | `PASS` |
| P3-RES-10 | Four or more legal adults; accept A-B as an ordinary marriage plan. | Continue review, inspect both later roles, and attempt a repeated-character acceptance only if safely reachable. | Stored direction/type, subject and partner pools, duplicate guard, slot writes, and count. | The ordinary adult-marriage path uses the shared immediate-reservation and pre-write duplicate contract for both A and B. | `NOT RUN` |
| P3-RES-11 | Four or more legal adults; accept A-B as a matrilineal marriage plan. | Repeat P3-RES-10. | Same fields and role checks as P3-RES-10. | The matrilineal adult-marriage path uses the same reservation and duplicate contract as the ordinary path. | `NOT RUN` |
| P3-RES-12 | A legal pair with at least one minor; accept A-B as an ordinary betrothal plan. | Repeat P3-RES-10 using the betrothal path. | Stored direction/type, subject and partner pools, duplicate guard, slot writes, and count. | The ordinary betrothal path immediately reserves both characters and uses the same pre-write duplicate contract. | `NOT RUN` |
| P3-RES-13 | A legal pair with at least one minor; accept A-B as a matrilineal betrothal plan. | Repeat P3-RES-12 using matrilineal direction. | Same fields and role checks as P3-RES-12. | The matrilineal betrothal path uses the same reservation and duplicate contract as the other three acceptance paths. | `NOT RUN` |
| P3-RES-14 | A duplicated committed plan created only through an already approved test setup; otherwise record `BLOCKED`. | Attempt final confirmation. | Full-plan duplicate failure, every relationship before/after, accepted records, and error log. | Final duplicate preflight remains active as defense in depth and aborts before any marriage or betrothal mutation. | `PASS` |
| P3-RES-15 | Fresh baseline copies supporting one successful valid batch and one preflight-abort comparison. | Final-confirm the valid batch; separately exercise the abort path. | Timing and visibility of the completion result, total/marriage/betrothal counts, relationships, and errors. | A visible completion result appears only after the relationship-execution path is reached successfully; no success result appears before execution or after duplicate rejection or preflight abort. | `PASS` |
| P3-RES-16 | Valid batch containing a controlled mix of marriage and betrothal records, using distinct characters. | Record the accepted plan, final-confirm, then compare the completion result with every actual relationship. | Accepted/executed total, marriage count, betrothal count, each relationship and direction, and any pair details displayed. | Completion totals match the relationships actually established; marriage plus betrothal counts equal the executed total, with no duplicated character or false success. | `NOT RUN` |

## 9. Final prevalidation and invalidation safety

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-VALID-01 | Several accepted pairs, all still legal. | Confirm the final batch. | Validation log/UI, execution count, and every before/after relationship. | All pairs are validated before the first relationship mutation, then each executes exactly once. | `PASS` |
| P3-VALID-02 | Invalidate one accepted pair by marriage or betrothal before final confirmation. | Confirm the final batch. | Whether any earlier pair executes, invalid-pair reason, and final state. | Mandatory all-or-nothing validation aborts the entire batch before mutation; zero accepted pairs change. | `PASS` |
| P3-VALID-03 | One accepted participant dies before final confirmation. | Confirm. | All accepted pairs and error log. | Entire batch aborts before mutation; zero pairs change and no invalid scope/effect error occurs. | `NOT RUN` |
| P3-VALID-04 | One participant leaves the actor's Dynasty before final confirmation. | Confirm. | Dynasty membership, final list, and all relationships. | Full prevalidation aborts the entire batch before mutation; zero pairs change. | `NOT RUN` |
| P3-VALID-05 | One participant becomes imprisoned, a hostage, clergy unable to marry, or otherwise unavailable before final confirmation. | Confirm. | Failure reason and complete batch state. | Approved availability failure aborts the entire batch before mutation; zero pairs change. | `NOT RUN` |
| P3-VALID-06 | One participant's age crosses an absolute adult–minor threshold before final confirmation. | Confirm. | Age, relationship state, and entire batch. | Hard threshold is rechecked and the entire batch aborts before mutation; zero pairs change. | `NOT RUN` |
| P3-VALID-07 | Faith or kinship legality changes before final confirmation. | Confirm. | Current faith/doctrine, legality result, and all relationships. | Current CK3 legality is used and the entire batch aborts before mutation; zero stale or otherwise valid pairs execute. | `NOT RUN` |
| P3-VALID-08 | Corrupt or intentionally duplicated accepted-pair state in a test-only harness, if such a harness is separately approved. | Attempt final confirmation. | Duplicate detection and error log. | Entire batch aborts safely before mutation; zero characters are married or betrothed. | `NOT RUN` |

## 10. Approach A — native marriage-window prototype (non-selected and deferred)

Approach A is not selected for the approved isolated prototype. Do not run this section during the Approach B prototype pass. Preserve it only as a deferred comparison suite if a native-window fallback later receives separate approval. Passing these cases would not approve Approach A for production.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-A-01 | Accepted adult pair whose matchmakers permit a vanilla proposal. | Open the vanilla arrange-marriage window from the Phase 3 flow. | Primary actor/recipient and both secondary participants. | Intended pair is prefilled correctly and vanilla legality/acceptance information renders without raw keys or scope errors. | `NOT RUN` |
| P3-A-02 | Same setup as P3-A-01. | Attempt to change either prefilled spouse. | Whether each participant is mutable and how the Phase 3 state responds. | Observed mutability matches the approved design; a changed pair can never be recorded as though the original pair executed. | `NOT RUN` |
| P3-A-03 | Prefilled adult pair. | Send an ordinary proposal and accept it where control permits. | Marriage, direction, alliances, Prestige, court movement, titles, government, succession, and Phase 3 continuation state. | Vanilla result is correct and the Phase 3 flow records the actual pair and outcome exactly once. | `NOT RUN` |
| P3-A-04 | Prefilled minor pair or adult/minor pair that is legal and not barred by the hard thresholds. | Send the proposal. | Betrothal, direction, matchmaker ownership, alliances if any, and continuation state. | Vanilla creates a betrothal rather than a marriage and Phase 3 records the actual outcome exactly once. | `NOT RUN` |
| P3-A-05 | Prefilled pair with matrilineal option available. | Enable matrilineal and send. | Direction, House/Dynasty implications, and recorded pair state. | Actual matrilineal result matches the Phase 3 summary and no stale ordinary-direction record remains. | `NOT RUN` |
| P3-A-06 | Prefilled pair. | Close the setup window without sending. | Relationship state, reserved state, accepted list, and visible way to resume or cancel. | No relationship changes; Phase 3 can recover without falsely marking success, leaking reservation, or trapping the player. | `NOT RUN` |
| P3-A-07 | Proposal requiring AI or another player response. | Send, receive acceptance or rejection, and reopen Phase 3. | Pending state, outcome detection, rejection handling, and duplicate prevention. | Phase 3 distinguishes pending, accepted, rejected, and canceled outcomes without guessing. | `NOT RUN` |
| P3-A-08 | Start with multiple accepted Phase 3 pairs. | Complete or close one vanilla marriage window, save/reload, and attempt to resume. | Remaining queue, actual completed pairs, skipped pairs, and state persistence. | No pair is lost, duplicated, or assumed complete; resume behavior is explicit and stable. | `NOT RUN` |
| P3-A-09 | Pair outside diplomatic range, at war with the relevant matchmaker, imprisoned, hostage, or otherwise vanilla-invalid. | Open the native window. | Native failure display and Phase 3 response. | Pair cannot be sent; Phase 3 returns safely without mutation or false success. | `NOT RUN` |
| P3-A-10 | Grand Wedding-capable pair with required DLC, then the same case without the required DLC. | Inspect native options without promising or executing unsupported content. | Option visibility, direction constraints, cost, and Phase 3 state. | Native availability follows DLC and vanilla requirements; Phase 3 never claims Grand Wedding support unless separately approved. | `NOT RUN` |

## 11. Approach B — selected isolated prototype

Run this section only after explicit P6 runtime approval for the existing isolated prototype. Passing syntax parsing alone is not sufficient.

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-B-01 | Legal adult opposite-sex pair, ordinary direction, both unmarried and unbetrothed. | Final-confirm and execute only this pair. | Spouse relation, direction, alliances, Prestige, court, titles, claims, government, succession, memories/on-actions, and error log. | Exactly one ordinary marriage is created; no unapproved state changes occur. | `PASS` |
| P3-B-02 | Legal adult pair approved for matrilineal direction. | Final-confirm and execute. | Matrilineal state, children-Dynasty implications where observable, and all P3-B-01 fields. | Exactly one matrilineal marriage is created and the direction matches the summary. | `PASS` |
| P3-B-03 | Legal minor pair. | Final-confirm an ordinary betrothal. | Betrothed relation, matchmaker, alliance, maturation behavior, and error log. | Exactly one ordinary betrothal is created; no immediate marriage occurs. | `PASS` |
| P3-B-04 | Legal pair with at least one minor and approved matrilineal direction. | Final-confirm. | Betrothal direction, matchmaker, House/Dynasty implications after eventual marriage, and error log. | Exactly one matrilineal betrothal is created and no hard age rule is bypassed. | `PASS` |
| P3-B-05 | Same adult pair in two controlled saves: one through vanilla UI, one through direct effect. | Execute each path. | Alliances, Prestige, court movement, memories, opinions, House relations, and other side effects. | Every intended difference is documented and approved; no missing vanilla consequence is misrepresented as equivalent behavior. | `NOT RUN` |
| P3-B-06 | Same-Dynasty unlanded characters from different courts. | Direct-confirm the pair under the approved authority policy. | Courts, lieges, relocation, matchmaker state, and acceptance bypass. | Behavior matches the explicit product authority decision and produces no invalid court state. | `NOT RUN` |
| P3-B-07 | Landed ruler pair. | Direct-confirm. | Titles, government, capital/court, lieges/vassals, alliances, succession, heirs, and claims. | Marriage/betrothal is created without direct title, government, or realm corruption. | `NOT RUN` |
| P3-B-08 | Current player heir paired under ordinary and matrilineal directions in separate saves. | Direct-confirm and advance time. | Player heir, succession order, Dynasty, titles, and government. | CK3 recalculation is stable and no unapproved succession mutation is scripted directly. | `NOT RUN` |
| P3-B-09 | Multiple independent valid adult and minor pairs. | Final-confirm the whole batch. | Execution count/order, duplicates, alliances, Prestige, courts, and errors. | Every pair is validated before the first mutation and then executes exactly once; if any pair fails validation, mandatory all-or-nothing behavior executes zero pairs. No participant is reused. | `PASS` |
| P3-B-10 | Successful direct batch. | Save, reload, advance time, and inspect again. | Marriage/betrothal direction, matchmaker, courts, titles, governments, alliances, succession, and delayed errors. | All relationships persist and no delayed duplicate or background execution occurs. | `PASS` |
| P3-B-11 | Pair eligible for a Grand Wedding under vanilla UI. | Inspect the direct prototype. | Effects and options offered. | Direct MVP does not create Grand Wedding promise state unless that separate feature is approved and tested. | `NOT RUN` |
| P3-B-12 | Standard-UI-invalid prisoner, hostage, illegal-kin, cannot-marry, or unavailable pair. | Attempt to stage and final-confirm. | Prevalidation and relationship state. | Direct effects never bypass the approved legality and availability gates. | `NOT RUN` |

## 12. Large-Dynasty performance and determinism

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-SCALE-01 | Large Dynasty with hundreds of living members across ages, courts, marital histories, and ruler states. | Start matchmaking and reach the first proposal. | Candidate-build time, frame responsiveness, event/UI delay, and error log. | Game remains responsive; candidate construction occurs only after player initiation and completes without recurring background work. | `PASS` |
| P3-SCALE-02 | Same large Dynasty. | Review at least 50 proposals using accept, skip, next, and defer. | Response time, duplicate persons, mirrored pairs, cycles, missing candidates, and state continuity. | Review remains usable and pair-state invariants hold throughout. | `NOT RUN` |
| P3-SCALE-03 | Two fresh copies of the same unchanged baseline save and configuration. | Activate one workflow in each copy and compare the first generated recommendations. | Initial candidate set, ordering, permanent-lock state, and error log. | Deterministic inputs produce deterministic recommendations, subject only to explicitly documented CK3 randomness; neither copy attempts a second activated workflow. | `NOT RUN` |
| P3-SCALE-04 | Large accepted list near the approved maximum. | Open final summary, cancel in one save, execute in another. | Summary responsiveness, full validation time, no-preconfirm state, execution time, and errors. | Cancel is consequence-free; execution validates fully before mutation and finishes without duplicate or partial pair state. | `NOT RUN` |
| P3-SCALE-05 | Observe the campaign after canceling or completing Phase 3. | Advance one year without initiating the workflow again. | Events, CPU/UI behavior, relationships, and error log. | No automatic scan, recurring event, background matchmaking, or unprompted relationship change occurs. | `NOT RUN` |

## 13. Localisation, UI, and player-control acceptance

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-UI-01 | English language. | Complete entry, pair review, alternatives, summary, cancel, and confirmation flows. | Titles, descriptions, option labels, tooltips, character names, values, warnings, and raw keys. | English is complete and readable; no Simplified Chinese, raw localisation key, scope token, or developer-facing implementation text appears. | `NOT RUN` |
| P3-UI-02 | Simplified Chinese language. | Repeat P3-UI-01. | Same fields and line wrapping. | Simplified Chinese is complete and readable; no English fallback key, raw scope token, or missing tooltip appears. | `NOT RUN` |
| P3-UI-03 | Adult, minor, high-age, placeholder, close-kin, ruler, and external-court proposals. | Review each proposal type. | Required displayed people, ages, age difference, fertility information, genetics, kinship risk, marriage/betrothal, direction, placeholder, and authority warning. | Every approved player-relevant fact is accurate and no unverified hidden value is presented as fact. | `NOT RUN` |
| P3-UI-04 | Accepted list with mixed pair types. | Open final confirmation. | Pair count, identity, direction, relationship type, warnings, and cancel option. | Summary is complete, no pair is duplicated, and final consequences are understandable before confirmation. | `NOT RUN` |
| P3-UI-05 | Review and final confirmation. | Inspect state before every option and after cancel. | Costs and every relationship/political field. | No cost and no gameplay mutation occurs before final confirmation. | `NOT RUN` |

## 14. Phase 1 and Phase 2 regression

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-REG-01 | Character eligible for the Phase 1 individual **Exile from Dynasty** interaction. | Execute the existing interaction in a disposable save. | Eligibility, 0/100 Prestige cost, consequences, descendant propagation, localisation, and errors. | Phase 1 behavior remains identical to the currently approved release behavior. | `NOT RUN` |
| P3-REG-02 | Dynasty with Phase 2 Bloodline Cleanup candidates. | Complete a representative review, cancel one run, and execute another. | Candidate rules, protection, branch folding, consequences, and errors. | Phase 2 Bloodline Cleanup remains unchanged. | `NOT RUN` |
| P3-REG-03 | Dynasty with Phase 2 Negative Congenital Trait Cleanup candidates. | Repeat P3-REG-02. | Trait set, warnings, review options, branch behavior, and errors. | Phase 2 Negative Congenital Trait Cleanup remains unchanged. | `NOT RUN` |
| P3-REG-04 | Complete Phase 2, then one Phase 3 activation; repeat the opposite order from a separate fresh baseline save. | Compare the two ordered workflows without starting Phase 3 twice in either save. | Saved scopes/lists/variables, candidates, selected pairs, temporary state, permanent lock, and Phase 1/2 behavior. | No Phase 2/Phase 3 workflow state leaks across systems; each save retains the Phase 3 permanent lock after its only activation. | `NOT RUN` |
| P3-REG-05 | Ordinary campaign observation with no Breed Improved workflow initiated. | Advance time. | Events, decisions, interactions, relationships, and errors. | Phase 3 adds no automatic scanning, background pairing, recurring execution, or spontaneous marriage/betrothal. | `NOT RUN` |

## 15. Error-log gate and acceptance record

| ID | Setup | Action | Required observations | Pass criteria | Result |
| --- | --- | --- | --- | --- | --- |
| P3-ERR-01 | Fresh baseline save with a successful smoke-gate workflow, where runtime approval permits. | Exit CK3 cleanly and inspect `Documents/Paradox Interactive/Crusader Kings III/logs/error.log`. | New lines attributable to the prototype namespace, identifiers, localisation, scopes, variables, events, triggers, effects, or on-actions. | No blocking Phase 3 prototype error is present; every observation is recorded without inferring a cause. | `NOT RUN` |
| P3-ERR-02 | Fresh baseline saves covering activation, pre-activation cancel, final cancel, full-preflight abort, actor death, Dynast loss, orphaned event, and load cleanup. | Inspect the error log after each scenario and again after one in-game day. | Parser/runtime errors, repeated messages, stale-scope reports, background activity, and Phase 1/2 regressions. | No blocker is attributed to the prototype; any non-blocking message is captured verbatim for review and does not become a fabricated pass. | `NOT RUN` |

Inspect the CK3 error log after every suite for:

- unknown trigger, effect, value, scope, iterator, interaction, event, Decision, or localisation identifiers;
- invalid marriage/betrothal effects or scope types;
- missing or stale saved scopes, event-target lists, variables, or pair records;
- repeated-character, duplicate-pair, or invalid relationship errors;
- invalid fertility arithmetic or value conversion;
- invalid faith, doctrine, kinship, matchmaker, court, ruler, government, or activity checks;
- missing English or Simplified Chinese localisation;
- event-loop, performance, or recurring-execution warnings attributable to Breed Improved; and
- regressions in Phase 1 or Phase 2 files.

| Final gate | Result |
| --- | --- |
| Adult marriage cases | `PASS` for the tested ordinary and matrilineal paths; stronger side-effect cases remain `NOT RUN` |
| Minor betrothal cases | `PASS` for the tested ordinary and matrilineal paths; maturation and broader authority cases remain `NOT RUN` |
| Ordinary and matrilineal direction | `PASS` for the four tested relationship paths |
| Fertility tiers and five-point boundaries | `PASS` for `100/95/94`, `80/75/74`, absolute inclusive `0.05`, and tested within-tier age priority |
| Hard adult–minor age exclusions | `PASS` for female `29/30` and male `39/40`; stronger role-direction and birthday variants remain `NOT RUN` |
| Marital-history groups and placeholders | `NOT RUN` |
| Doctrine and kinship legality | `NOT RUN` |
| Authority, matchmaker, ruler, and external-court cases | `NOT RUN` |
| Workflow-scoped authorization lifecycle and cleanup | `PARTIAL PASS`; mapped entry, cancel, and abnormal-exit cases pass; death and Dynast-loss variants remain `NOT RUN` |
| Permanent one-workflow-per-save lock | `PASS` in the mapped smoke/cancel paths; stronger multiplayer and stale-event variants remain `NOT RUN` |
| Out-of-workflow and stale-authorization execution guards | `NOT RUN` |
| Special-state exclusions | `NOT RUN` |
| Pair-state and duplicate protection | `PASS` for the mapped reservation, mirror, overlap, and final-preflight cases |
| Immediate reservation in all four subject/partner roles | `PASS` |
| Duplicate rejection with zero slot writes and zero count increase | `PASS` |
| Shared reservation contract across all four acceptance paths | `NOT RUN` |
| Fixed slots 01/16 and seventeenth-pair capacity boundary | `PARTIAL PASS`; slot 16 and pair 17 pass, while the full slot-01 field audit remains `NOT RUN` |
| Partial records and reservation-marker integrity | `NOT RUN` |
| Cancel and no-preconfirmation consequences | `PASS` for mapped review/final cancel paths; stronger state audits remain `NOT RUN` |
| Full prevalidation and invalidation safety | `PARTIAL PASS`; valid multi-pair and one invalid-pair abort pass; other invalidation causes remain `NOT RUN` |
| Approach A advisory comparison (deferred, not selected) | `NOT RUN` |
| Approach B isolated prototype | `PARTIAL PASS`; four relationship paths, tested batch execution, and persistence pass |
| Final duplicate preflight defense in depth | `PASS` |
| Completion-result visibility and count accuracy | `PARTIAL PASS`; timing passes, mixed-type count-detail case remains `NOT RUN` |
| Large-Dynasty performance | `PASS` for the reported recommendation-generation scenario; stronger scale cases remain `NOT RUN` |
| English localisation | `NOT RUN` |
| Simplified Chinese localisation | `NOT RUN` |
| Phase 1 regression | `NOT RUN` |
| Phase 2 regression | `NOT RUN` |
| Save/reload cleanup with lock retained | `PARTIAL PASS`; mapped abnormal/locked-state and successful-batch persistence pass |
| CK3 error log clean | `NOT RUN` |
| Ray recommendation | `PROTOTYPE ACCEPTED FOR PRODUCTION DESIGN` |
| Jay/Boss approval | `PENDING` |

The repaired accepted-character reservation regression is closed by Ray's
post-fix retest. Smoke 3's unaccepted-character reuse is expected behavior.
The formal status is `PROTOTYPE ACCEPTED — PRODUCTION DESIGN MAY PROCEED`.
Production implementation and release remain unapproved; 116 stronger or
unreported matrix cases remain `NOT RUN`.
