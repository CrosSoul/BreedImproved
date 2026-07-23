# Breed Improved Phase 3 - Production Gap Matrix

## Status

- Target: CK3 `1.19.0.6 (Scribe)`
- Production candidate: `IMPLEMENTED IN SOURCE`
- Static result: see `phase3_production_static_review.md`
- CK3 runtime: `NOT RUN`

`Implemented` means a code path exists. It does not mean CK3 has loaded or
executed it. Every runtime result below remains `NOT RUN` until Ray records an
observation.

| ID | Gap or required behavior | Production resolution | Static evidence path | Runtime result |
| --- | --- | --- | --- | --- |
| P3-GAP-001 | Repeat use in one save | Prototype permanent lock removed; centralized cleanup permits a new run | lifecycle triggers/effects, Decisions | `NOT RUN` |
| P3-GAP-002 | Concurrent workflows | One global active-actor owner and global phase | lifecycle triggers/effects | `NOT RUN` |
| P3-GAP-003 | Immediately stale event | Alternating A/B token plus owner/phase/Dynasty checks | lifecycle triggers, A/B events | `NOT RUN` |
| P3-GAP-004 | Abnormal visible-event close | No invented close callback; explicit recovery Decision discards state | recovery Decision, event `2190` | `NOT RUN` |
| P3-GAP-005 | Actor death | Additive `on_death` child cleanup | production on-action file | `NOT RUN` |
| P3-GAP-006 | Dynast loss | Per-event authority guard plus additive new-Dynast cleanup child | lifecycle triggers, on-action file | `NOT RUN` |
| P3-GAP-007 | Save/load during active workflow | Additive `on_game_start_after_lobby` cleanup | production on-action file | `NOT RUN` |
| P3-GAP-008 | Clean review cancel | Central cleanup; no relationship call | review events | `NOT RUN` |
| P3-GAP-009 | Clean final cancel | Central cleanup; no relationship call | final events | `NOT RUN` |
| P3-GAP-010 | No eligible candidate | Cleanup followed by visible no-candidate result | candidate effects, event `2180` | `NOT RUN` |
| P3-GAP-011 | Empty accepted plan | Cleanup followed by visible empty-plan result | candidate effects, event `2181` | `NOT RUN` |
| P3-GAP-012 | Production capacity | 32 fixed six-field slots / 64 characters | plan triggers/effects, lifecycle cleanup | `NOT RUN` |
| P3-GAP-013 | Overflow | Slot 33 does not exist; capacity event after slot 32 | acceptance effect, events `2140/2141` | `NOT RUN` |
| P3-GAP-014 | Rejected-pair cycling | 64 fixed subject/partner/marker records | candidate triggers/effects | `NOT RUN` |
| P3-GAP-015 | Partial slot | Marker written last; incomplete record is neither committed nor executable | slot commit and slot triggers | `NOT RUN` |
| P3-GAP-016 | Accepted-character reuse | Both roles checked in all committed slots | reservation triggers | `NOT RUN` |
| P3-GAP-017 | Mirror pair | One-character-one-slot invariant plus final participant list | reservation and preflight | `NOT RUN` |
| P3-GAP-018 | Displayed but unaccepted reuse | Reservation starts only after a complete accepted commit | acceptance effect | `NOT RUN` |
| P3-GAP-019 | Player actor | Decision requires living AI=`no` Dynast | Decision and lifecycle triggers | `NOT RUN` |
| P3-GAP-020 | Other human participants | Candidate requires AI=`yes` | shared candidate trigger | `NOT RUN` |
| P3-GAP-021 | Current Dynasty only | Managed Dynasty saved at activation and rechecked | lifecycle and candidate triggers | `NOT RUN` |
| P3-GAP-022 | House/cadet branches | House is not an exclusion; current Dynasty equality controls | candidate trigger | `NOT RUN` |
| P3-GAP-023 | Landed ruler | No landed/ruler exclusion; all safety guards remain | shared candidate trigger | `NOT RUN` |
| P3-GAP-024 | External court | No actor-court restriction; pool guests excluded | shared candidate trigger | `NOT RUN` |
| P3-GAP-025 | Dead/married/betrothed | Explicitly excluded and revalidated | candidate and slot triggers | `NOT RUN` |
| P3-GAP-026 | Prisoner/hostage | Explicitly excluded and revalidated | shared candidate trigger | `NOT RUN` |
| P3-GAP-027 | Incapable/travelling | Explicitly excluded and revalidated | shared candidate trigger | `NOT RUN` |
| P3-GAP-028 | Concubine/pregnancy | Explicitly excluded and revalidated | shared candidate trigger | `NOT RUN` |
| P3-GAP-029 | Pool guest/availability | Require available; exclude pool guest | shared candidate trigger | `NOT RUN` |
| P3-GAP-030 | Celibacy | Vanilla `celibate` excluded | shared candidate trigger | `NOT RUN` |
| P3-GAP-031 | Clergy, holy order, faith, gender, government | Mutual `can_marry_character_trigger` remains mandatory | pair-core trigger | `NOT RUN` |
| P3-GAP-032 | Direct ancestry | Independently excluded in both directions | ancestry trigger | `NOT RUN` |
| P3-GAP-033 | Adult relationship | Both adults store and execute marriage | commit, slot, relationship effects | `NOT RUN` |
| P3-GAP-034 | Minor relationship | Either minor stores and executes betrothal | commit, slot, relationship effects | `NOT RUN` |
| P3-GAP-035 | Female 30+/minor | Excluded in both role directions | age-policy trigger | `NOT RUN` |
| P3-GAP-036 | Male 40+/minor | Excluded in both role directions | age-policy trigger | `NOT RUN` |
| P3-GAP-037 | Ordinary/matrilineal parity | Shared accept and preflight paths; direction selects one of four effects | review events, plan effects | `NOT RUN` |
| P3-GAP-038 | Adult fertility band | Current best; inclusive best-minus-0.05 filter | candidate effect | `NOT RUN` |
| P3-GAP-039 | Adult within-band order | Age, congenital, kinship, finite tie value | script values and ordered list | `NOT RUN` |
| P3-GAP-040 | Minor order | Age, congenital, kinship, finite tie value | script values and ordered list | `NOT RUN` |
| P3-GAP-041 | Subject order | Minors, fertility, age, final list-order fallback | subject script value | `NOT RUN` |
| P3-GAP-042 | Positive congenital tiers | Known vanilla good groups weighted 10/20/30; `fecund` and `pure_blooded` included | congenital script value | `NOT RUN` |
| P3-GAP-043 | Negative reinforcement | Known bad traits penalized; matching tier traits and `inbred` penalized again | congenital script value | `NOT RUN` |
| P3-GAP-044 | Modded unknown traits | Safely ignored | finite explicit trait list | `NOT RUN` |
| P3-GAP-045 | Kinship preference | Coarse 0-4 category score; no exact coefficient claim | kinship script value | `NOT RUN` |
| P3-GAP-046 | Fertile divorce/widow | Positive-fertility adults with former spouse remain normal candidates | subject/partner triggers | `NOT RUN` |
| P3-GAP-047 | Zero-fertility proactive subject | Excluded | subject trigger | `NOT RUN` |
| P3-GAP-048 | Placeholder | Adult non-positive partner only after normal exhaustion for fertile formerly married adult | placeholder triggers/effects | `NOT RUN` |
| P3-GAP-049 | Minor placeholder | Prohibited | placeholder triggers and slot preflight | `NOT RUN` |
| P3-GAP-050 | Pre-confirmation mutation | Review writes variables/lists only | candidate/plan separation | `NOT RUN` |
| P3-GAP-051 | Whole-plan preflight | All 32 slots, counts, enums, legality, uniqueness, type, and placeholder policy | plan triggers/effects | `NOT RUN` |
| P3-GAP-052 | Preflight failure | Zero relationship effects; visible failure slot | plan effect, events `2150/2151` | `NOT RUN` |
| P3-GAP-053 | Direct operations only | Four isolated relationship effects | relationship effects file | `NOT RUN` |
| P3-GAP-054 | Unexpected effect failure | Postcondition check; stop later slots; no rollback | execute-slot effect | `NOT RUN` |
| P3-GAP-055 | Completion counts | Total, marriage, and betrothal counts shown before cleanup | plan effect, success events | `NOT RUN` |
| P3-GAP-056 | Partial completion counts | Completed count and first failure slot shown | plan effect, partial events | `NOT RUN` |
| P3-GAP-057 | Final editing | Cancel/restart only; no record-edit path | final events | `NOT RUN` |
| P3-GAP-058 | English/Chinese parity | Dedicated matching production localisation files | EN/ZH YML | `NOT RUN` |
| P3-GAP-059 | Phase 1 integration | No Phase 1 file or identifier changed/called | final diff and regression test | `NOT RUN` |
| P3-GAP-060 | Phase 2 integration | No Phase 2 file or identifier changed/called | final diff and regression test | `NOT RUN` |
| P3-GAP-061 | Background execution | No timed/recurring candidate or relationship path; lifecycle hooks cleanup only | Decisions, on-actions, events | `NOT RUN` |
| P3-GAP-062 | Namespace isolation | Production namespace `breedimp_dynasty_matchmaking`, IDs `2000-2190` within `2000-2399` | event file and registry | `NOT RUN` |
| P3-GAP-063 | Release isolation | No descriptor, version, package, or Workshop change | final allowed-scope check | `NOT RUN` |
| P3-GAP-064 | CK3 error log | No blocking errors | Ray log review | `NOT RUN` |

## Static-only limitations that remain runtime gaps

- An alternating two-token model is not an unbounded numeric run identity.
- `on_game_start_after_lobby` and Dynasty-head transfer ordering cannot be
  proved by file inspection alone.
- CK3 does not expose transaction rollback for direct relationship effects.
- The finite tie fingerprint can still tie; engine list order is the final
  fallback.
- `any_former_spouse` does not reliably distinguish every divorce and widow
  history.
- No exact genetic probability or relatedness coefficient is claimed.
