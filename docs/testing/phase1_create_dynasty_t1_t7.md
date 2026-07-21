# Breed Improved Phase 1 - T1/T7 Controlled Test Record

## Status

- Status: `NOT RUN`
- CK3 target: `1.19.0.6`
- Runtime result: `NOT RUN`; no runtime behavior is claimed
- Save/reload result: `NOT RUN`
- Approval requirement: obtain Jay's approval before launching CK3 or recording runtime results
- Test mod: `tests/phase1_create_dynasty/BreedImprovedPhase1Test/`
- Production status: test-only; not approved for `MyCK3Mod/`

## Test boundaries

The test harness contains one explicitly selected and confirmed Character Interaction. Its only game-state mutation is a recipient-scoped `create_dynasty` call. It intentionally omits `spread_to_descendants`.

Do not add or exercise:

- claims or claim removal;
- inheritance changes or `disinherit_effect`;
- court movement, banishment, imprisonment, or adventurer conversion;
- title or government changes;
- Decisions, events, scans, iteration, recurring execution, or bulk behavior; or
- production files.

For local testing after approval, copy `BreedImprovedPhase1Test.mod` to the CK3 launcher mod directory and replace `path="<LOCAL_MOD_PATH>"` in that copy only with the absolute path to `tests/phase1_create_dynasty/BreedImprovedPhase1Test/`, using forward slashes. Keep the repository template portable.

## Shared environment record

Complete these fields before either test begins.

| Field | Recorded value |
| --- | --- |
| Tester | `NOT RUN` |
| Test date and time | `NOT RUN` |
| Reviewer | `NOT RUN` |
| CK3 executable/build identification | `NOT RUN` |
| Enabled DLC | `NOT RUN` |
| Game rules | `NOT RUN` |
| Game language | `NOT RUN` |
| Playset/load order | `NOT RUN` |
| Save or start identifier | `NOT RUN` |
| Baseline backup identifier | `NOT RUN` |
| Exact error-log source inspected | `NOT RUN` |

## Shared observation inventory

Record each item before execution, immediately after execution, and after save/reload.

| State category | Before | Immediate after | After save/reload |
| --- | --- | --- | --- |
| Character identifier | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Alive/dead state | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| House | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Dynasty | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| House Head / Dynast status | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Descendants and their Houses/Dynasties | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Claims | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Traits | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Court and realm | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Titles and ruler/landed status | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Imprisonment | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Marriage | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Legal and biological parentage shown | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Succession position observations | `NOT RUN` | `NOT RUN` | `NOT RUN` |
| Generated Dynasty/House presentation | `NOT RUN` | `NOT RUN` | `NOT RUN` |

## T1 - Ordinary highborn unlanded courtier

### Setup

Select one character who is manually confirmed to be:

- living and adult;
- highborn (`is_lowborn = no` in the harness);
- AI-controlled;
- unlanded and a non-ruler;
- neither House Head nor Dynast;
- in the player actor's Dynasty;
- not the actor;
- an ordinary courtier with no known special title or untested leadership state.

| Setup field | Recorded value |
| --- | --- |
| Actor identifier | `NOT RUN` |
| Recipient identifier | `NOT RUN` |
| Recipient court/realm | `NOT RUN` |
| Eligibility checklist completed by | `NOT RUN` |
| Special-title/leadership review | `NOT RUN` |

### Action

1. Record the complete shared observation inventory.
2. Open `TEST: Create Replacement Dynasty` on the selected recipient.
3. Confirm that the standard actor confirmation window appears.
4. Confirm the action exactly once.
5. Record immediate observations and the first relevant error-log entries, if any.
6. Save under a new test identifier, reload, locate the same character, and record the final observations.

Action status: `NOT RUN`

### Expected result for a future pass

- The selected target alone receives a replacement Dynasty and associated House.
- The target remains alive, unlanded, a non-ruler, and in the same court/realm.
- Claims, traits, titles, imprisonment, marriage, and parentage remain unchanged.
- No other character changes Dynasty or House.
- Generated Dynasty/House state is valid and visible.
- No relevant parser/runtime error occurs.
- The observed result persists after save/reload.

These are pass criteria, not claimed CK3 behavior.

### T1 result

| Check | Result | Evidence/notes |
| --- | --- | --- |
| Interaction appeared only for the intended valid target | `NOT RUN` | `NOT RUN` |
| Standard actor confirmation appeared | `NOT RUN` | `NOT RUN` |
| Target received a replacement Dynasty | `NOT RUN` | `NOT RUN` |
| Target received an associated House | `NOT RUN` | `NOT RUN` |
| Target remained in the same court/realm | `NOT RUN` | `NOT RUN` |
| Claims remained unchanged | `NOT RUN` | `NOT RUN` |
| Traits remained unchanged | `NOT RUN` | `NOT RUN` |
| Titles and ruler/landed state remained unchanged | `NOT RUN` | `NOT RUN` |
| Imprisonment remained unchanged | `NOT RUN` | `NOT RUN` |
| Marriage and parentage remained unchanged | `NOT RUN` | `NOT RUN` |
| No non-target affiliation changed | `NOT RUN` | `NOT RUN` |
| No relevant error was observed | `NOT RUN` | `NOT RUN` |
| Result persisted after save/reload | `NOT RUN` | `NOT RUN` |
| Unexpected side effects | `NOT RUN` | `NOT RUN` |
| Final T1 verdict | `NOT RUN` | `PASS` or `FAIL` only after review |

## T7 - Omitted `spread_to_descendants` with an existing child

### Setup

Use the same target class as T1, but select a target with at least one existing child. Record every known descendant's identifier, generation, House, Dynasty, court/realm, titles, marriage, and head status before execution.

| Setup field | Recorded value |
| --- | --- |
| Actor identifier | `NOT RUN` |
| Recipient identifier | `NOT RUN` |
| Direct child identifiers | `NOT RUN` |
| Later descendant identifiers | `NOT RUN` |
| Descendant affiliation inventory completed by | `NOT RUN` |
| Special-title/leadership review | `NOT RUN` |

### Action

1. Record the shared inventory and the full descendant affiliation inventory.
2. Open `TEST: Create Replacement Dynasty` on the selected recipient.
3. Confirm that the standard actor confirmation window appears.
4. Confirm the action exactly once.
5. Compare the target and every descendant immediately after execution.
6. Record the first relevant error-log entries, if any.
7. Save under a new test identifier, reload, and compare every recorded descendant again.

Action status: `NOT RUN`

### Expected result for a future pass

- The selected target receives a replacement Dynasty and associated House.
- Every existing child and later descendant retains the exact pre-test House and Dynasty.
- No descendant experiences any other unexpected state change.
- No delayed or reload-time propagation occurs.
- All T1 non-propagation and excluded-state criteria also pass.

These are pass criteria, not claimed CK3 behavior.

### Descendant comparison

| Descendant identifier | Relationship/generation | House before | Dynasty before | House after | Dynasty after | After reload | Unexpected effects |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `NOT RUN` | `NOT RUN` | `NOT RUN` | `NOT RUN` | `NOT RUN` | `NOT RUN` | `NOT RUN` | `NOT RUN` |

### T7 result

| Check | Result | Evidence/notes |
| --- | --- | --- |
| Target received a replacement Dynasty and House | `NOT RUN` | `NOT RUN` |
| Every direct child retained House and Dynasty | `NOT RUN` | `NOT RUN` |
| Every later descendant retained House and Dynasty | `NOT RUN` | `NOT RUN` |
| No delayed propagation was observed | `NOT RUN` | `NOT RUN` |
| No reload-time propagation was observed | `NOT RUN` | `NOT RUN` |
| All T1 excluded-state checks passed | `NOT RUN` | `NOT RUN` |
| No relevant error was observed | `NOT RUN` | `NOT RUN` |
| Unexpected side effects | `NOT RUN` | `NOT RUN` |
| Final T7 verdict | `NOT RUN` | `PASS` or `FAIL` only after review |

## Review gate

Do not convert this harness into production code from a static pass alone. Jay must review actual T1/T7 observations, errors, and save/reload evidence before approving production Character Interaction work.
