# Breed Improved Phase 3 - Production Decision Register

## Status and use

- CK3 target: `1.19.0.6 (Scribe)`
- Decision status: `CLOSED FOR THE FIRST PRODUCTION RUNTIME CANDIDATE`
- CK3 runtime: `NOT RUN`

These decisions were delegated to Matt for the one-shot implementation. A
decision marked "runtime gate" is implemented but must still be observed in
CK3 before release.

| ID | Decision | Selected production behavior | Rationale and consequence | Runtime gate |
| --- | --- | --- | --- | --- |
| P3-D-001 | Authority | Workflow-scoped Dynast override for same-Dynasty AI participants | Preserves the approved product power without changing vanilla interactions or permanent authority. | Other-court, landed-ruler, and lifecycle behavior |
| P3-D-002 | Human participants | Exclude every AI=`no` subject or partner | Avoids unapproved multiplayer coercion. | Multiplayer visibility and exclusion |
| P3-D-003 | Concurrency | One globally active Phase 3 workflow | Prevents two actors from sharing or corrupting global phase state. | Two-player/switch-player attempt |
| P3-D-004 | Repeatability | Remove the prototype permanent lock; allow re-entry after complete cleanup | Phase 3 must be reusable in one save. | Repeat after success and both cancellation stages |
| P3-D-005 | Run isolation | Alternate actor-owned A/B tokens and require owner + Dynasty + phase + token on mutating events | Uses verified flag-valued variables without inventing numeric run-ID syntax. | Stale visible windows, save/load, two-token reuse |
| P3-D-006 | Interrupted workflow | Show an explicit recovery Decision to discard residue | No generic visible-event close callback is verified. Recovery is safer than background continuation. | Abnormal close then recovery |
| P3-D-007 | Load behavior | Additive `on_game_start_after_lobby` cleanup of an active workflow | An interrupted workflow must not execute after load. | Exact load timing and visibility |
| P3-D-008 | Death and Dynast change | Additive death and new-Dynast cleanup hooks plus per-event authority checks | Stops authority once its actor or Dynasty basis is invalid. | Death and transfer timing/coverage |
| P3-D-009 | Pair capacity | 32 fixed committed slots / 64 reserved characters | Doubles the accepted prototype capacity while remaining explicit, bounded, auditable, and safe. | Slot 32/33 boundary and performance |
| P3-D-010 | Overflow | Never wrap or overwrite; open a capacity result after slot 32 | Preserves the complete accepted plan. Remaining candidates require a later run. | Capacity UI and no overwrite |
| P3-D-011 | Rejection capacity | 64 fixed rejected-pair records | Prevents immediate loops without unbounded state. At capacity, "another partner" becomes unavailable. | Rejection 64/65 behavior |
| P3-D-012 | Pair record | Six actor-owned fields; `reservation_id` repeats subject and is written last | Carries subject, partner, direction, type, placeholder, and a commit marker without parallel-list indexing assumptions. | Interrupted/partial write resilience |
| P3-D-013 | Reservation | Reserve both participants only after complete slot commit | Displayed pairs remain reusable; accepted people cannot enter any later role. | Both-role and mirror cases |
| P3-D-014 | Duplicate safety | Acceptance scans all committed slots; final preflight uses a participant list | Prevents role reuse and mirror pairs twice. | Overlap and mirror tests |
| P3-D-015 | Candidate Dynasty | Current recorded Dynasty only, across all Houses/cadet branches | Matches the product scope; House is not an eligibility boundary. | Cadet-branch case |
| P3-D-016 | Landed/external court | Allow otherwise eligible AI rulers and external-court members | This is the intended value of the explicit Dynast override. | Titles, court, realm, liege, government, succession |
| P3-D-017 | Special states | Require `is_available`; exclude travelling, incapable, married, betrothed, imprisoned, hostage, concubine, pregnant, pool guest, and celibate | Conservative first-production supported class using verified CK3 constructs. | Each exclusion and activity edge cases |
| P3-D-018 | Legality | Require mutual `can_marry_character_trigger` and direct-ancestry exclusion | The override bypasses arrangement authority only. | Faith, gender, clergy, holy order, government, kin |
| P3-D-019 | Adult/minor outcome | Adult + adult marries; any minor causes betrothal | Matches verified vanilla examples and settled product behavior. | All four direction/type paths |
| P3-D-020 | Adult-minor age limits | Woman 30+ or man 40+ cannot pair with a minor, in either role | Fixed safety policy; no score or scarcity exception. | 29/30 and 39/40 in both roles |
| P3-D-021 | Subject order | Minors first; then higher fertility and younger age; list order is final exact-tie fallback | Deterministic from verified values without inventing a unique character ID. | Save/reload and exact ties |
| P3-D-022 | Adult fertility tiers | Recompute current best and retain `best - 0.05` inclusive; after rejection, recompute from remaining candidates | Implements an absolute five-percentage-point band without fixed buckets. | 100/95/94, 80/75/74, >1, <0 |
| P3-D-023 | Minor ranking | Age gap, congenital score, kinship score, finite fingerprint, then engine list order | Follows the settled strict hierarchy. | Controlled ties |
| P3-D-024 | Adult within-band ranking | Age gap, congenital score, kinship score, finite fingerprint, then engine list order | Fertility band remains the first adult criterion. | Controlled cross-factor tests |
| P3-D-025 | Congenital scoring | Known vanilla trait groups only; tiered positives, finite negatives, extra matching-negative penalties; ignore unknown traits | Avoids unsupported inheritance-probability claims and remains mod-safe. | Trait ordering examples |
| P3-D-026 | Kinship scoring | Direct ancestry hard-excluded; coarse values 0-4 for close through no detected category | CK3 exposes categories, not a reliable exact coefficient. | Category order and faith prohibitions |
| P3-D-027 | Stable tie | Finite script-visible fertility/skill/level fingerprint; engine list order only for exact ties | No verified global character-ID numeric sort exists. | Identical-fingerprint stability |
| P3-D-028 | Previously married | Fertile adults with a former spouse remain normal subjects | Covers both divorce and widowhood without guessing an unreliable distinction. | Divorced and widowed cases |
| P3-D-029 | Zero-fertility subjects | Never proactive | Prevents two low-value proactive matches and follows the settled fallback intent. | Zero/negative fertility pool |
| P3-D-030 | Placeholder | Adult zero-or-negative-fertility partner only for a fertile adult with a former spouse and only after normal candidates are exhausted | Narrow, visibly labelled fallback. Never used for minors. | Discovery order and presentation |
| P3-D-031 | Placeholder direction | Ordinary appears first; player may explicitly select ordinary or matrilineal | No hidden forced direction. | Both placeholder options |
| P3-D-032 | Review controls | Accept ordinary, accept matrilineal, another partner, skip, defer, finish early, cancel | Matches settled player control; no accept-all. | Each control and no early consequence |
| P3-D-033 | Final editing | Cancellation/restart only; no per-slot edit on final page | Safest bounded first production UI and avoids record surgery. | Final cancel and clean re-entry |
| P3-D-034 | Preflight | Validate the entire plan read-only before the first relationship effect | Prevents known invalid plans from partially executing. | Multiple invalidation causes |
| P3-D-035 | Execution order | Numeric slot order, one of four direct effects per slot | Makes result counts and failure slot reproducible. | Mixed plan order |
| P3-D-036 | Unexpected execution failure | Verify each postcondition; stop later slots, preserve earlier relationships, no rollback | CK3 transaction rollback is not verified. UI reports exact completed count and failing slot. | Safe reproducible postcondition failure if available |
| P3-D-037 | Extra consequences | Add none | Do not guess parity compensation for alliance, Prestige, court, title, government, inheritance, memory, opinion, hook, or stress. | Record actual engine-owned effects |
| P3-D-038 | Completion summary | Show total pairs, marriages, and betrothals before cleanup | Provides auditable outcome without retaining permanent workflow state. | Mixed completion count |
| P3-D-039 | Namespace | `breedimp_dynasty_matchmaking`, allocation `2000-2399` | Separates production from prototype and existing event namespaces. | Static collision check |
| P3-D-040 | Release | No version, descriptor, package, Workshop, or release change | This pass ends at Ray's production runtime gate. | Not applicable |

## Decisions intentionally deferred beyond the first production candidate

- Grand Weddings
- native arrange-marriage-window handoff
- external-Dynasty partners
- automatic acceptance of remaining recommendations
- per-pair editing at final confirmation
- political, alliance, title, and inheritance scoring
- exact genetic probability or relatedness coefficient
- general modded-congenital-trait scoring
- multiple simultaneous player workflows
- direct consent design for other human players
- automatic divorce, invitation, or court movement

These are not implemented implicitly by the Dynast override.
