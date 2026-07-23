# Breed Improved Phase 3 Prototype - Static Review

- Status: `STATIC REVIEW PASSED — RESERVATION FIX RETEST REQUIRED`
- CK3 target: `1.19.0.6 (Scribe)`
- Prototype namespace: `breedimp_p3_proto_matchmaking`
- Runtime status:
  `PRE-FIX BLOCKER OBSERVED; POST-FIX RETEST NOT RUN`

This report records the post-fix static inspection and distinguishes it from
Ray's pre-fix P6 observation. It does not establish that CK3 can load, parse,
display, persist, or execute the corrected prototype.

## Scope and packaging isolation

- [x] Confirm changes are limited to `tests/phase3_dynasty_matchmaking/` and
      explicitly approved Phase 3 documentation.
- [x] Confirm no file under `MyCK3Mod/`, `dist/`, Workshop staging, production
      descriptors, publishing/release documentation, assets, or scripts changed.
- [x] Confirm the test Mod is self-contained and imports no production script,
      localisation, or Workshop metadata.
- [x] Confirm the outer `.mod` contains only the established test metadata and
      `path="<LOCAL_MOD_PATH>"`.
- [x] Confirm the inner `descriptor.mod` contains no `path`, `remote_file_id`,
      local absolute path, or production/Workshop metadata.

## CK3 structure and identifiers

- [x] Check balanced braces, quotes, nesting, and valid file placement.
- [x] Confirm one event namespace declaration:
      `breedimp_p3_proto_matchmaking`.
- [x] Confirm every event ID is unique and in `1000-1199`, with the allocated
      entry/lifecycle, review, preflight, failure, and reserve subranges.
- [x] Confirm every non-event prototype identifier begins
      `breedimp_p3_proto_`.
- [x] Confirm no production identifier, `breedimp_test_` identifier,
      runtime-indexed variable construction, embedded parameterized flag name,
      or duplicate definition entered the test Mod. Fixed slot helpers use
      only explicit integer `1`-`16` call sites.
- [x] Confirm every referenced event, scripted trigger/effect/value, scope,
      localisation key, and file path resolves within the test Mod or to an
      exact registered vanilla CK3 `1.19.0.6` construct.

## Workflow and record guards

- [x] Confirm pre-activation cancel creates no permanent lock, candidate state,
      slot state, or relationship change.
- [x] Confirm activation is the only path that sets the permanent
      one-workflow-per-save lock.
- [x] Confirm no code clears or reuses that lock after activation.
- [x] Confirm old, orphaned, canceled, failed, death, Dynast-loss, and
      save/load paths cannot enter relationship execution.
- [x] Confirm no generic event-close callback, numeric run-identity comparison,
      or unverified logging syntax is used.
- [x] Confirm the 16 explicit slots each define exactly `subject`, `partner`,
      `direction`, `relationship_type`, `placeholder`, and `reservation_id`.
- [x] Confirm `reservation_id` is written last as a second subject reference,
      and partial records or records whose marker differs from their subject
      cannot reserve, display, or execute.
- [x] Confirm a character cannot occur in more than one pair, including a
      mirrored pair, and that preflight repeats the full integrity check.
- [x] Confirm the capacity is 16 pairs / 32 characters; a seventeenth pair is
      rejected without overwriting state; documentation accounts for 120
      unordered slot comparisons and at most 480 role comparisons.

## P6 reservation blocker and correction

Pre-fix runtime observation:

- accepting a pair produced a committed slot;
- accepted subjects and partners could reappear in later proposals;
- the same character could enter multiple committed records; and
- the final duplicate preflight still detected the invalid plan and stopped
  execution.

The blocker was traced to textual scripted-trigger parameter scope. The
unreserved-character trigger received the proposed character as `this`, then
entered the actor scope before forwarding the parameter. Because the parameter
was not a captured scope, `this` then denoted the actor. Reservation checks
therefore tested the actor instead of the proposed subject or partner.

Post-fix static checks:

- [x] Confirm the proposed character is captured with
      `save_temporary_scope_as` before entering the actor-owned slot scope.
- [x] Confirm all 16 reservation checks receive that explicit saved character.
- [x] Confirm a slot reserves the character when either its committed subject
      or committed partner equals the saved character.
- [x] Confirm subject selection calls the shared unreserved-character trigger.
- [x] Confirm partner eligibility calls the same trigger for both subject and
      partner roles.
- [x] Confirm partner-list construction, ordered ranking, next-partner review,
      skip/defer advancement, and post-acceptance advancement re-evaluate the
      shared candidate/pair guards rather than trusting an earlier pool alone.
- [x] Confirm ordinary and matrilineal acceptance options call the same
      acceptance effect; its relationship type is still derived as marriage
      or betrothal from participant ages.
- [x] Confirm the shared acceptance effect runs the complete current-pair
      commit guard before selecting a slot or invoking the first slot write.
- [x] Confirm failed commit eligibility routes to recovery without invoking a
      slot commit, writing any payload/marker field, or increasing
      `accepted_pair_count`.
- [x] Confirm `reservation_id` remains the final slot-field write and the
      accepted-pair counter changes only after that marker write.
- [x] Confirm the final defense-in-depth preflight still contains all 120
      unordered slot comparisons and all four role comparisons per slot pair.

Runtime status for every post-fix reservation behavior remains `NOT RUN`.

## Mutation, automation, and localisation

- [x] Confirm candidate review, plan storage, cancellation, and preflight
      failure paths contain no relationship-changing operation.
- [x] Confirm the four P4 operations appear only in the isolated
      relationship-effect path and only after full preflight.
- [x] Confirm no claim, inheritance, divorce, imprisonment, banishment, court
      movement, title, government, Prestige, or compensating state effect was
      added outside approved prototype behavior.
- [x] Confirm no automatic scan, recurring event, pulse, scheduled action, or
      background matchmaking path exists.
- [x] Confirm the test-only completion event is dispatched only after the
      validated relationship-operation path is reached.
- [x] Confirm execution diagnostics separately count reached pair, marriage,
      and betrothal operation branches and display all committed slot details.
- [x] Confirm completion-result acknowledgement performs workflow cleanup,
      while no pre-execution notification claims success.
- [x] Confirm these diagnostics add no alliance, Prestige, court, title,
      inheritance, memory, opinion, or compensation effect.
- [x] Confirm English and Simplified Chinese key sets match, keys are unique,
      values are non-empty, headers are `l_english:` and `l_simp_chinese:`, and
      both files are UTF-8 with BOM.

## Required commands and recorded outcome

- [x] Run `git diff --check`.
- [x] Run a trailing-whitespace scan including untracked prototype files.
- [x] Scan for absolute paths, `remote_file_id`, test identifiers outside the
      prototype root, and prototype content in production/Workshop paths.
- [x] Scan all 16 committed-slot reservation calls for the explicit saved
      candidate scope and both subject/partner role comparisons.
- [x] Trace subject discovery, partner discovery/ranking, next-partner, and
      every acceptance path to the shared reservation guard.
- [x] Confirm duplicate rejection has no control-flow route to any slot-field,
      marker, or accepted-count write.
- [x] Recount all final cross-slot comparisons after the reservation fix.
- [x] Trace the completion event, execution counters, fixed-slot detail lines,
      and acknowledgement-time cleanup ordering.
- [x] Review the complete diff and record the actual result here before any
      CK3 runtime test is requested.

## Recorded static results

- Review date: `2026-07-23`
- `git diff --check`: `PASS`
- Allowed changed-file scope: `PASS`
- Balanced braces and quotes: `PASS`
- Namespace and unique event IDs: `PASS`
- Custom definition/call resolution: `PASS`
- Exact vanilla citation paths: `PASS` (`107` unique paths checked across the
  registered evidence and Phase 3 design documents)
- Fixed slots: `PASS` (`16` commit call sites; no slot `17`)
- Cross-slot integrity: `PASS` (`120` trigger comparisons and `120`
  preflight comparisons)
- Relationship-operation confinement: `PASS` (exactly the four approved
  operations, each in the relationship-effect file)
- English/Simplified Chinese key parity: `PASS` (`97` content keys each)
- Duplicate/empty localisation keys: `PASS`
- Localisation headers and UTF-8 BOM: `PASS`
- Descriptor and path isolation: `PASS`
- Workshop metadata leakage: `PASS`
- Pre-fix P6 reservation behavior: `BLOCKED` (committed participants could be
  accepted again; final preflight remained an effective late safety net)
- Saved-candidate reservation identity: `PASS` (`16` explicit committed-slot
  calls use the captured character after entering actor scope)
- Subject/partner reservation coverage: `PASS` (subject selection and both
  pair roles use the shared trigger; candidate and ranking paths re-evaluate
  it)
- Shared acceptance-time guard: `PASS` (ordinary/matrilineal and
  marriage/betrothal paths converge before any slot write)
- Duplicate-rejection write isolation: `PASS` (no payload, marker, or
  accepted-count write is reachable from the rejection branch)
- Final duplicate preflight retention: `PASS` (`120` trigger comparisons and
  `120` preflight comparisons remain)
- Test-only completion feedback: `PASS` (validated execution dispatches event
  `1144`; counts and 16 conditional slot-detail lines remain available until
  acknowledgement cleanup)
- Phase 3 manual matrix: `PASS` (`156` unique cases, all `NOT RUN`)
- Independent adversarial static review: `PASS` (no static blocker)

Result:
`STATIC REVIEW PASSED — RESERVATION FIX RETEST REQUIRED`

Runtime:
`PRE-FIX BLOCKER OBSERVED; POST-FIX RETEST NOT RUN`

Stop state: `AWAITING RAY RESERVATION-REGRESSION RETEST`
