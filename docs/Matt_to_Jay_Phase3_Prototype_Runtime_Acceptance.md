# Breed Improved Phase 3 - Prototype Runtime Acceptance

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 target: `1.19.0.6 (Scribe)`
- Prototype: isolated `breedimp_p3_proto_matchmaking` test Mod
- Runtime tester: Ray
- Production implementation: `NOT APPROVED`
- Matrix total: `156`
- Mapped results: `40 PASS / 0 FAIL / 116 NOT RUN / 0 BLOCKED`
- Acceptance status:
  `PROTOTYPE ACCEPTED — PRODUCTION DESIGN MAY PROCEED`

## 1. Scope and evidence rule

Ray completed the supplied smoke and first/second/third functional test
sequences against the post-reservation-fix isolated prototype. The sequence
names were conversational instructions, not headings in the repository's
156-case matrix. Their absence as literal matrix sections is not an evidence
gap.

This report maps each authoritative observation to existing test IDs by:

1. matching the reported test action;
2. matching the reported expected result;
3. marking every directly covered row `PASS`; and
4. leaving every stronger or unreported row `NOT RUN`.

No test ID was created, renamed, or inferred from a sequence label. No clean
CK3 `error.log` result is claimed because that observation was not supplied.

## 2. Evidence mapping

| Ray runtime observation | Matching matrix test ID(s) | Result | Notes |
| --- | --- | --- | --- |
| Entry cancellation, first activation, review/final cancellation, and abnormal-exit/load isolation behaved as expected | `P3-LIFE-01`-`04`, `P3-LIFE-09` | `PASS` | Stronger death, Dynast-loss, multiplayer, repeated-cancel, and stale-event variants remain `NOT RUN`. |
| Ordinary adult marriage executed successfully | `P3-B-01` | `PASS` | Native-side-effect parity is not inferred. |
| Matrilineal adult marriage executed successfully | `P3-B-02` | `PASS` | Selected direction matched the resulting relationship. |
| Ordinary minor betrothal executed successfully | `P3-B-03` | `PASS` | No immediate marriage occurred. |
| Matrilineal minor betrothal executed successfully | `P3-B-04` | `PASS` | Selected direction matched the resulting betrothal. |
| Tested successful direct batch persisted through save/reload and time advance | `P3-B-10` | `PASS` | Broader lifecycle and delayed-side-effect cases remain `NOT RUN`. |
| Multiple accepted pairs executed only after full validation | `P3-B-09`, `P3-VALID-01` | `PASS` | No participant reuse was observed in the valid batch. |
| One tested pair made invalid before final execution stopped the whole batch before mutation | `P3-VALID-02` | `PASS` | Other invalidation causes remain `NOT RUN`. |
| Accepted participants were removed from later subject/partner eligibility | `P3-STATE-01`, `P3-STATE-03`, `P3-RES-01`-`04` | `PASS` | The earlier reservation defect did not reproduce. |
| Mirrored or overlapping accepted plans were prevented | `P3-STATE-02`, `P3-SLOT-05`, `P3-SLOT-06`, `P3-RES-07` | `PASS` | Applies to accepted/committed plan records, not displayed proposals. |
| Same-subject and same-partner duplicate acceptance was rejected before commit | `P3-RES-05`, `P3-RES-06` | `PASS` | Rejection preserved the existing committed pair. |
| Duplicate rejection produced no partial slot and no accepted-count increase | `P3-RES-08`, `P3-RES-09` | `PASS` | Confirms write isolation at the tested acceptance path. |
| Final duplicate preflight still stopped the invalid batch before relationship mutation | `P3-RES-14` | `PASS` | This remains defense in depth after immediate reservation was fixed. |
| Sixteenth pair remained intact; seventeenth pair did not overwrite or wrap slots | `P3-SLOT-02`, `P3-SLOT-03` | `PASS` | Partial/malformed record cases remain `NOT RUN`. |
| Adult fertility examples `100/95/94` and `80/75/74` used an inclusive absolute five-percentage-point boundary | `P3-FERT-02`, `P3-FERT-03` | `PASS` | Confirms absolute `0.05`, not relative five percent, for these examples. |
| Age proximity took priority within the tested adult fertility tier | `P3-FERT-05` | `PASS` | Lower tiers and later tie-breakers remain product/runtime gates. |
| Minor recommendation order prioritized age proximity | `P3-AGE-01` | `PASS` | Genetic and kinship tie-break variants remain `NOT RUN`. |
| Female `29/30` and male `39/40` adult-minor boundaries behaved as specified | `P3-AGE-04`-`07` | `PASS` | Both-role-direction and post-review birthday variants remain `NOT RUN`. |
| Tested large-Dynasty recommendation generation was acceptably responsive | `P3-SCALE-01` | `PASS` | Larger/longer stress variants and a log result are not inferred. |
| Completion feedback appeared after successful execution and not for the tested rejected/aborted paths | `P3-RES-15` | `PASS` | Mixed relationship-type count-detail case `P3-RES-16` remains `NOT RUN`. |
| Displayed pair A+B was not accepted; one participant later appeared in another combination | No full matrix row | `EXPECTED BEHAVIOR CONFIRMED` | This partially exercises `P3-STATE-04`/`05`, but their stronger full criteria remain `NOT RUN`. |

## 3. Results by functional area

| Functional area | Runtime status | Evidence boundary |
| --- | --- | --- |
| Mod load and Decision entry | `PASS` | Smoke sequence reached the valid Dynast Decision flow. No standalone matrix row exists for load alone. |
| Pre-activation cancellation | `PASS` | `P3-LIFE-01`. |
| First activation and permanent save lock | `PASS` | `P3-LIFE-02`; mapped cancellation paths also retained the consumed lock. |
| Review controls | `PARTIAL PASS` | Reported smoke/review behavior worked. Full deterministic cycling, skip, defer, early-finish, and all UI variants remain `NOT RUN`. |
| Unaccepted-character reuse | `EXPECTED BEHAVIOR CONFIRMED` | Displayed/unaccepted participants are not reserved and may be offered in another combination. |
| Accepted-character reservation | `PASS — DEFECT CLOSED` | `P3-STATE-01`-`03`, `P3-SLOT-05`-`06`, and `P3-RES-01`-`09`. |
| Ordinary marriage | `PASS` | `P3-B-01`. |
| Matrilineal marriage | `PASS` | `P3-B-02`. |
| Ordinary betrothal | `PASS` | `P3-B-03`. |
| Matrilineal betrothal | `PASS` | `P3-B-04`. |
| Final preflight | `PARTIAL PASS` | Valid batch, one invalid-pair abort, and duplicate defense passed; other invalidation causes remain `NOT RUN`. |
| All-or-nothing behavior | `PASS` for the tested invalidation | `P3-VALID-02`; no transactional rollback is established for an engine failure after execution starts. |
| Slot capacity | `PASS` at tested 16/17 boundary | `P3-SLOT-02`, `P3-SLOT-03`; malformed and partial records remain `NOT RUN`. |
| Fertility tier | `PASS` at tested boundaries | `P3-FERT-02`, `P3-FERT-03`, `P3-FERT-05`. |
| Age hard limits | `PASS` at tested boundaries | `P3-AGE-04`-`07`; stronger direction/timing variants remain `NOT RUN`. |
| Save/reload behavior | `PARTIAL PASS` | Tested abnormal/locked-state isolation and successful-batch persistence passed; other save timings remain `NOT RUN`. |
| Abnormal-close behavior | `PASS` for the tested path | `P3-LIFE-09`; additional stale-event and actor-state variants remain `NOT RUN`. |
| Success feedback | `PASS` for tested timing | `P3-RES-15`; detailed mixed-type count audit remains `NOT RUN`. |
| Direct-effect side effects | `EVIDENCE NOT PROVIDED` | Do not infer alliance, Prestige, court, title, succession, memory, or native-parity results. |
| Large-Dynasty behavior | `PASS` for one reported scenario | `P3-SCALE-01`; stronger scale variants remain `NOT RUN`. |
| Phase 1/2 regression | `NOT RUN` | `P3-REG-01`-`04` remain unexecuted in this record. |
| CK3 `error.log` | `EVIDENCE NOT PROVIDED` | `P3-ERR-01` and `P3-ERR-02` remain `NOT RUN`. |

## 4. Defect closure and expected non-defect

### Accepted-character reservation defect

The pre-fix prototype could commit A+B and later offer A or B in another plan
record. That violated the invariant that one character may belong to at most
one accepted pair. Matt corrected the reservation path. Ray's final retest did
not reproduce the defect across the mapped subject, partner, duplicate, mirror,
write-isolation, and count-stability cases.

Status: `CLOSED BY POST-FIX RUNTIME RETEST`.

Final duplicate preflight remains active as defense in depth; it is not the
primary reservation mechanism.

### Unaccepted-character reuse

A displayed proposal reserves nobody until the pair is accepted and committed.
Therefore:

- displaying A+B and declining, skipping, or replacing it leaves A and B
  eligible;
- a later B+C proposal is valid and expected; and
- after D+E is accepted and committed, neither D nor E may enter another
  accepted plan record.

Smoke 3 confirmed this contract. It is not a defect.

## 5. Prototype limitations

- The prototype permits only one confirmed workflow activation per save.
- Pair storage is fixed at 16 accepted pairs.
- Test namespace, event IDs, localisation, diagnostics, and UI are not
  production assets.
- The isolated workflow uses a Mod-owned Dynast override; it is not vanilla
  Dynast marriage authority.
- There is no verified rollback if a relationship effect fails after an
  earlier relationship in the validated batch has executed.
- 116 matrix cases remain `NOT RUN`.
- A clean CK3 error log is not evidenced.
- Deferred product features remain deferred, including Grand Weddings, a
  repeatable production workflow, final congenital-trait scoring, negative
  trait policy, final kinship ranking, lower fertility tiers, final
  tie-breaking, divorced/widowed distinctions, zero-fertility policy, editable
  accepted pairs, and final completion-summary design.

## 6. Remaining gates before production code

Production design and gap-closure planning may begin. Production coding should
not begin until Jay/Boss reviews and explicitly resolves:

1. a repeatable production run-isolation and cleanup design;
2. production capacity and pair-record storage;
3. the residual mid-batch relationship-effect failure policy;
4. actor death, Dynast loss, stale-event, and additional save/load gates;
5. partial/malformed slot and additional invalidation cases;
6. direct-effect alliance, Prestige, court, title, government, succession,
   memory, and other side effects;
7. external-court, landed-ruler, special-state, faith, kinship, and multiplayer
   policy;
8. remaining fertility, placeholder, scoring, tie-breaking, and scale cases;
9. Phase 1 and Phase 2 regression coverage;
10. English/Simplified Chinese production UI and localisation design; and
11. CK3 `error.log` review for the approved production candidate.

Another broad prototype pass is not required before writing the production
design specification. Targeted Ray runtime passes remain necessary for the
unresolved integration gates before production approval and release.

## 7. Recommendation to Jay/Boss

The isolated prototype has demonstrated enough of the selected architecture to
proceed to product-level production design:

- explicit Dynast-initiated workflow and permanent prototype lock;
- direct ordinary/matrilineal marriage and betrothal paths;
- accepted-pair reservation, duplicate/mirror rejection, and final duplicate
  defense;
- fixed-slot capacity behavior;
- tested all-or-nothing preflight;
- tested fertility and age boundaries;
- tested persistence, completion feedback, and one large-Dynasty scenario.

These results do not approve production code, integration, release, or Workshop
publication.

Recommended next authorized task:

`Phase 3 production implementation design and gap-closure specification`

Final status:
`PROTOTYPE ACCEPTED — PRODUCTION DESIGN MAY PROCEED`

Stop state:
`AWAITING JAY/BOSS PRODUCTION-DESIGN APPROVAL`
