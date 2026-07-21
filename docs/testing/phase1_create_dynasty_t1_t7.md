# Breed Improved Phase 1 - Controlled Runtime Test Record

## Status

- CK3 target: `1.19.0.6`
- Standalone harness: Boss-approved runtime testing completed for the scenarios recorded below
- Production approval: v0.1 Character Interaction authorized from the approved harness results
- Production runtime status: `NOT RUN`
- Matt execution status for the production task: static review `PASSED`; CK3 was not launched
- Test mod: `tests/phase1_create_dynasty/BreedImprovedPhase1Test/`
- Save/reload detail: not separately supplied for every scenario; no missing observation is inferred

This document records the approved test-harness observations supplied to Matt. It distinguishes those observations from the new production implementation, which has not been launched in CK3.

## 1. Tested operation

The standalone harness performed one recipient-scoped state-changing operation:

```text
create_dynasty = {
    spread_to_descendants = yes
    save_scope_as = breedimp_test_new_dynasty
}
```

The harness did not directly alter claims, inheritance traits, marriage, betrothal, titles, government, court, realm, imprisonment, or political status.

## 2. Final tested eligibility boundary

The approved harness allowed a recipient when the recipient was:

- AI-controlled;
- alive;
- not lowborn;
- in the actor's Dynasty;
- not the actor;
- not House Head; and
- not Dynast.

The final harness had no age, landed, ruler, heir, marriage, or betrothal restriction.

The actor was player-controlled and in the same Dynasty. The production implementation adds the approved requirement that the actor must also be alive and the current Dynast.

## 3. Runtime result summary

| Test | Status | Approved observation |
| --- | --- | --- |
| T-Age | `PASS` | Both minor and adult eligible recipients could use the interaction |
| T1 - ordinary highborn target | `PASS` | Dynasty replacement worked for the approved unlanded target class |
| T7 - descendant propagation | `PASS` | Recipient and descendants moved; parents and siblings remained unchanged |
| T-Ruler-1 | `PASS` | A landed ruler retained titles and government after Dynasty replacement |
| T-Ruler-2 | `PASS` | A ruler with children and descendants moved to the new Dynasty without the reported title/government disruption |
| T-Heir | `PASS` | The current player heir could be exiled; CK3 selected a new player heir |
| Runtime error check | `PASS` | No CK3 runtime error was reported for the tested harness |

## 4. T-Age record

### Setup

Use one living minor and one living adult who otherwise satisfy the same recipient rules.

### Action

Execute the harness interaction separately on each target.

### Pass criteria

- Both targets can see and execute the interaction.
- No adulthood, childhood, minimum-age, or maximum-age validation appears.
- Each target receives a generated replacement Dynasty.

### Recorded result

`PASS` — both minors and adults executed successfully after all age gates were removed.

## 5. T1 - ordinary highborn target

### Setup

Use a living, highborn, AI-controlled member of the actor's Dynasty who is neither House Head nor Dynast. The approved case included an unlanded character.

### Pass criteria

- The target receives a generated replacement Dynasty and leaves the actor's Dynasty.
- With descendant propagation enabled, descendants follow the target.
- No excluded state is directly changed by the harness script.

### Recorded result

`PASS` — Dynasty replacement worked for the approved ordinary target class.

## 6. T7 - descendant propagation

### Setup

Use an eligible target with at least one existing descendant. Record the Dynasty and House of the target, descendants, parents, and siblings.

### Pass criteria

- The target receives the replacement Dynasty.
- Descendants move with the target.
- Parents and siblings remain unchanged.

### Recorded result

`PASS` — descendants moved with the target as intended; parents and siblings remained unchanged.

This result applies to the tested family structures. It is not evidence for every possible adoption, historical parentage, special title, or modded genealogy state.

## 7. T-Ruler-1 - landed ruler

### Setup

Use a landed AI ruler who:

- is alive and not lowborn;
- belongs to the actor's Dynasty;
- is not the actor;
- is not House Head; and
- is not Dynast.

The review record should cover titles, government, House, Dynasty, succession, claims, spouse, children, court, realm, and vassal relationships.

### Pass criteria

- The ruler receives a generated replacement Dynasty.
- Titles and government remain stable.
- No direct title, claim, marriage, court, realm, or vassal effect is executed by the harness.
- No CK3 runtime error is produced by the tested operation.

### Recorded result

`PASS` — the tested landed ruler changed Dynasty while retaining titles and government; no runtime error was reported.

Save/reload observations and every secondary political field were not separately supplied to Matt and are therefore not fabricated here.

## 8. T-Ruler-2 - ruler with descendants

### Setup

Use an otherwise eligible landed ruler with existing children or further descendants. Record the ruler, descendants, parents, siblings, titles, government, and succession state.

### Pass criteria

- The ruler receives the replacement Dynasty.
- Descendants move as requested by `spread_to_descendants = yes`.
- Parents and siblings remain unchanged.
- Titles and government remain stable.
- No unexpected runtime error occurs.

### Recorded result

`PASS` — the ruler and descendants moved as approved; parents and siblings remained unchanged, and the tested ruler's titles and government remained stable.

## 9. T-Heir - current player heir

### Setup

Use an eligible AI recipient who is the actor's current player heir. Record the player-heir designation and relevant succession order before execution.

### Pass criteria

- The interaction can execute without a special heir restriction.
- The target receives the replacement Dynasty.
- CK3 recalculates player-heir state without a scripted inheritance or title mutation.

### Recorded result

`PASS` — the current player heir was exiled successfully, and CK3 selected a new player heir.

This observation supports omitting an heir restriction. It does not guarantee a particular successor or succession outcome in every realm configuration.

## 10. Married-target time-advance observation

### Observed result

A married target later gained spouse-related strong claims after game time advanced.

### Interpretation boundary

- The observation is real and must remain visible in project documentation.
- The supplied result does not establish that `create_dynasty` directly granted those claims.
- The current product direction does not authorize divorce, claim removal, or a marriage restriction.
- v0.1 therefore leaves claims and marriage untouched by script.

### Deferred investigation

A future controlled test should record exact claim identifiers and sources immediately before the interaction, immediately after it, and after the relevant time advance. A comparison character should be observed over the same interval. Save inspection and error/game logs should be retained. Only then should Jay and the Boss consider a claim or marriage policy.

## 11. Production verification boundary

The standalone harness remains preserved as the runtime evidence instrument. Production uses distinct `breedimp_` identifiers, shared validation/effect wrappers, hostile Dynasty-interaction presentation, and bilingual localisation.

The following remain required before anyone may claim that production v0.1 passed runtime testing:

- enable the production mod rather than the standalone harness;
- confirm the interaction appears only for the approved actor and recipient classes;
- inspect both English and Simplified Chinese interaction text and confirmation presentation;
- repeat representative age, unlanded, ruler, descendant, and heir cases;
- inspect the CK3 error log;
- save, reload, and re-inspect Dynasty, House, titles, government, and succession; and
- record any unexpected side effect.

Until a separately approved production test is run and recorded, production runtime status remains `NOT RUN`.

## 12. Forbidden expansion during v0.1 validation

Do not add any of the following while validating the approved production interaction:

- claim removal;
- `disinherit_effect` or other inheritance-trait changes;
- divorce or betrothal changes;
- banishment, imprisonment, or court movement;
- title removal or government changes;
- adventurer conversion;
- events or Decisions;
- scans, iteration, recurring execution, or bulk processing; or
- automatic cleanup.
