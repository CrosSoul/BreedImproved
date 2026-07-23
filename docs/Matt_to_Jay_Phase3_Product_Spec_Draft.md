# Breed Improved Phase 3 - Dynasty Matchmaking Management Product Specification Draft

Current runtime status (2026-07-23): `PROTOTYPE ACCEPTED — PRODUCTION DESIGN
MAY PROCEED`; 40 mapped matrix cases pass and 116 remain `NOT RUN`. The
checkpoint-era status fields below are retained as design-history context. See
`docs/Matt_to_Jay_Phase3_Prototype_Runtime_Acceptance.md`.

Prepared by Matt (CK3ModDeveloper) for Jay (CK3ModLeader).

- CK3 evidence target: `1.19.0.6 (Scribe)`
- Production compatibility target: `1.19.*`
- Document status: `DRAFT — PROTOTYPE DIRECTION APPROVED; PRODUCT REVIEW CONTINUES`
- Phase 3 isolated prototype:
  `STATIC IMPLEMENTATION COMPLETE — PARTIAL RUNTIME ACCEPTANCE COMPLETE`
- Implementation status: `PRODUCTION NOT APPROVED`
- Approved prototype direction: `WORKFLOW-SCOPED DYNAST OVERRIDE / DIRECT EXECUTION`
- P0 status: `P0 CORRECTED AND CLOSED`
- P1-P5 status: `STATIC COMPLETE`
- P6 status: `40 MAPPED PASS / 0 FAIL / 116 NOT RUN`
- Prototype event allocation: `breedimp_p3_proto_matchmaking.1000-1199`
- CK3 runtime status: `PARTIAL RUNTIME ACCEPTANCE COMPLETE`

This document defines the proposed player-facing contract for Phase 3. It does
not authorize production gameplay. P1-P5 static work is complete, but all
production decisions remain subject to Jay/Boss review and gap closure.
Technical feasibility, vanilla evidence, and approach-specific risks are
recorded separately in:

- `docs/research/Matt_Phase3_Dynasty_Matchmaking_Feasibility.md`; and
- `docs/Matt_to_Jay_Phase3_Technical_Approach_Comparison.md`.

No CK3 script form should be inferred from the product terms used here.

The existing Phase 1/2 production baseline, including v0.2.0, is already
published on Steam Workshop item `3769010534`. GitHub remains the source and
release-record channel; the Workshop item is the player-distribution channel.
The isolated Phase 3 prototype is not part of either published release.

## 1. Requirement status

Every material statement in this specification is identified as one of:

- **Confirmed product requirement** — supplied and fixed by the Boss for this
  design round.
- **Provisional recommendation** — Matt's recommended MVP behavior, subject to
  Ray and Jay/Boss approval.
- **Approved prototype decision** — approved only for the isolated Phase 3
  prototype; it is not a production approval or a claim about vanilla power.
- **Decision required from Ray** — a player-facing choice that is not resolved
  by technical evidence alone.
- **Prototype gate** — intended behavior whose reliable CK3 implementation has
  not yet been demonstrated.

These labels do not replace the technical feasibility classifications in the
research report.

## 2. Product purpose

### Confirmed product requirements

Phase 3 provides a player-initiated workflow for managing marriage and
betrothal planning among eligible unmarried members of the player's current
Dynasty.

For the approved prototype, the initiating player must be the current Dynast.
The resulting authorization exists only inside that one explicitly initiated
workflow, as defined in section 11.

Its goals are to:

- reduce repetitive manual marriage management in a large Dynasty;
- help keep eligible unmarried, divorced, and widowed members within the
  player's Dynasty marriage plan;
- prefer age-compatible, fertile, genetically desirable, and less closely
  related pairings in the approved order;
- let the player inspect and decide each proposed pairing; and
- apply no marriage or betrothal before a separate final confirmation.

The feature must not:

- run automatically, periodically, or in the background;
- search the world or another Dynasty for partners;
- dissolve an existing marriage or betrothal;
- replace an existing spouse;
- modify vanilla genetics or inheritance mechanics;
- simulate a complete genetic-outcome probability;
- make political, military, diplomatic, title, wealth, Prestige, realm-size,
  cultural, religious-spread, or AI-acceptance value part of MVP ranking;
- force a character to move court; or
- change any gameplay state merely because the review workflow was opened,
  advanced, or cancelled.

## 3. Product vocabulary

For this specification:

- **Current Dynasty** means the Dynasty shared with the player who starts the
  workflow at the time eligibility is checked.
- **Subject** means the Dynasty member currently being considered for a
  marriage or betrothal.
- **Partner candidate** means another member of the same current Dynasty who
  may legally form a pair with the subject.
- **Proposed pair** means a subject, a partner candidate, the intended
  marriage-or-betrothal outcome, and the selected marriage direction.
- **Accepted pair** means a proposed pair chosen by the player for final
  confirmation. It is not yet a marriage or betrothal.
- **Reserved character** means a character already present in an accepted pair
  during the current workflow.
- **Placeholder partner** means an eligible zero-fertility divorced or widowed
  character offered only when a normal fertile partner is unavailable.
- **Marriage direction** means ordinary or matrilineal marriage/betrothal.

These are design terms, not CK3 script identifiers.

## 4. Candidate scope

### Confirmed product requirements

Both members of every proposed pair must come from the current Dynasty.

Phase 3 must not actively search or recommend:

- members of another Dynasty;
- lowborn characters;
- characters merely present in the same court but outside the current
  Dynasty;
- foreign characters outside the current Dynasty; or
- world-wide candidates.

A character who is married or betrothed is excluded from normal Phase 3
processing. Phase 3 must never divorce the character, cancel the betrothal, or
substitute a different partner.

Membership in the current Dynasty is not, by itself, proof that the player has
vanilla authority to arrange the character's marriage. Authority is a separate
eligibility boundary described in section 11.

## 5. Subject and partner categories

### 5.1 Unmarried minors

**Confirmed product requirement**

An otherwise eligible minor who is neither married nor betrothed enters the
active subject pool. A successfully executed pair involving a minor must
create a betrothal rather than an immediate marriage.

For a minor subject, age proximity is the highest ranking priority.

### 5.2 Never-married adults

**Confirmed product requirement**

An otherwise eligible adult who has never married and is currently neither
married nor betrothed enters the active subject pool. A successfully executed
pair between adults creates a marriage.

For an adult subject, current fertility tier is the highest ranking priority.

### 5.3 Fertile divorced adults

**Confirmed product requirement**

An otherwise eligible divorced adult who is currently unmarried, unbetrothed,
and still fertile enters the active subject pool. The character is ranked and
reviewed under the adult rules.

The product distinguishes this history from widowhood, but reliable CK3
script-level separation of the two histories is `NOT VERIFIED`. Until that
distinction is proven, the technical design must treat both as the broader
**previously married** category rather than guess.

### 5.4 Fertile widowed adults

**Confirmed product requirement**

An otherwise eligible widowed adult who is currently unmarried, unbetrothed,
and still fertile enters the active subject pool. The character is ranked and
reviewed under the adult rules.

The same `NOT VERIFIED` marriage-history limitation described for divorced
adults applies here.

### 5.5 Zero-fertility divorced or widowed adults

**Confirmed product requirement**

A zero-fertility divorced or widowed character:

- does not enter the active subject pool;
- does not receive a dedicated partner-search task;
- may enter the low-priority placeholder-partner pool;
- may be proposed only when the fertile subject has no normal, fertile, legal
  partner available; and
- must still be unmarried, unbetrothed, and otherwise legal for the proposed
  marriage.

The placeholder is intended to reduce the possibility that an unmatched
fertile divorced or widowed subject later marries outside the Dynasty. It is
not represented as a breeding recommendation.

When at least one normal fertile and legal partner is available, a
zero-fertility placeholder must not outrank that partner.

For this product rule, **zero fertility** means a readable current fertility
value less than or equal to zero. It does not mean a particular age, trait, or
marriage-history label.

### 5.6 Categories not yet defined

**Decisions required from Ray**

The current requirements do not define:

- whether a zero-fertility adult who has never married may be an active
  subject, a placeholder partner, or neither;
- whether a character whose fertility is unavailable or cannot be evaluated
  belongs in the active pool;
- whether an otherwise eligible minor with a zero or unavailable current
  fertility value should be treated differently; or
- whether the technically broader **previously married** category is an
  acceptable fallback if divorce and widowhood cannot be distinguished
  reliably.

No implementation may silently choose answers to these questions.

## 6. Hard pairing rules

### Confirmed product requirements

A proposed pair must satisfy all of the following:

- both characters are members of the current Dynasty;
- the characters are distinct;
- neither character is currently married or betrothed;
- neither character has already been reserved by another accepted pair;
- the combination is not a duplicate or mirror of a combination already
  accepted in the current workflow;
- vanilla CK3 permits the relationship under the applicable marriage and
  faith rules;
- the pair satisfies the product-level adult/minor age prohibition below; and
- all approved authority and protection rules pass.

Vanilla-illegal consanguinity or marriage combinations are excluded, not
merely ranked lower.

### 6.1 Adult/minor age prohibition

**Confirmed product requirement**

Phase 3 must never propose or execute:

- a female character aged 30 or older with any minor; or
- a male character aged 40 or older with any minor.

The limits include the boundary ages:

- female age `>= 30`; and
- male age `>= 40`.

This is a hard product exclusion. It must not be overridden by fertility,
congenital traits, kinship rank, candidate scarcity, placeholder status, faith
permission, or any other score or fallback. If no other partner exists, the
subject remains unmatched.

The rule applies whichever member of the proposed pair is the minor; it cannot
be bypassed by swapping which character is presented as the subject.

## 7. Ranking contract

### 7.1 General ordering rule

**Confirmed product requirement**

Ranking is lexicographic, not a weighted sum. A lower-priority dimension cannot
compensate for a worse result in a higher-priority dimension.

The MVP ranking must not include:

- politics or alliance value;
- title or inheritance gain;
- diplomacy or military ability;
- wealth, Prestige, court office, or realm size;
- AI acceptance optimization;
- culture or faith spread;
- court invitation or forced movement value; or
- candidates outside the current Dynasty.

### 7.2 Minor-subject ranking

**Confirmed product requirement**

Eligible partner candidates for a minor subject are compared in this strict
order:

1. smaller absolute age difference;
2. better approved positive congenital-trait result; and
3. lower approved kinship-risk category.

No fertility value may outrank age proximity for a minor subject.

### 7.3 Adult-subject ranking

**Confirmed product requirement**

Eligible partner candidates for an adult subject are compared in this strict
order:

1. current fertility tier;
2. smaller absolute age difference within the same fertility tier;
3. better approved positive congenital-trait result; and
4. lower approved kinship-risk category.

This ordering also causes an older adult to prefer a similarly older partner
when candidates are in the same fertility tier. No separate age-band system or
age-difference threshold has yet been approved.

### 7.4 Dynamic five-percentage-point fertility tier

**Confirmed intended behavior — prototype gate**

For the subject's currently eligible normal partner pool:

1. identify the highest current fertility value;
2. place every candidate no more than five percentage points below that value
   into the highest fertility tier; and
3. rank candidates in that tier by age proximity before considering the lower
   ranking dimensions.

Examples:

- when the best eligible candidate is at 100%, candidates from 95% through
  100% are in the same highest tier; and
- when the best eligible candidate is at 83%, candidates from 78% through 83%
  are in the same highest tier.

The boundary is inclusive. The comparison is a difference of five percentage
points, not a five-percent relative reduction.

Stable calculation and ordering of this dynamic tier in CK3 script are
`REQUIRES PROTOTYPE`. If it cannot be implemented reliably, a fixed-band or
integer approximation must be presented to Ray with its observable differences
before the product rule is changed.

### 7.5 Ranking details that remain open

**Decisions required from Ray**

The product still needs decisions on:

- the exact positive congenital-trait set and ordering;
- whether negative congenital traits affect ranking or are disclosure-only;
- the approved kinship-risk categories and their order;
- how fertility tiers below the highest tier are formed when the player asks
  for additional partner candidates;
- deterministic tie-breaking after all approved dimensions are equal;
- subject-processing order across the active pool;
- how an unavailable or exactly zero fertility value is presented; and
- whether the UI displays an exact fertility value or an understandable band.

No age cap, age band, trait weight, tie-breaker, or numeric genetic score is
approved by this draft.

## 8. Review workflow

### 8.1 Entry and candidate generation

**Confirmed product requirement**

The player explicitly starts the Dynasty Matchmaking Management workflow.
Candidate discovery happens only inside that player-initiated flow. It is not
scheduled, repeated in the background, or run by AI.

For the approved prototype, entry must verify that the initiator is the living,
player-controlled current Dynast before creating any workflow authorization or
candidate state.

The isolated prototype permits only one confirmed Phase 3 workflow in each
save. Opening the Decision only dispatches its pre-activation confirmation
event and does not consume that opportunity. Cancelling that event also
consumes nothing. Its explicit activation option writes the permanent lock
before coordinator state or candidate discovery. The lock is not authorization,
is never cleared, and blocks every later Phase 3 prototype workflow in that
save.

The workflow builds its active subjects and potential partners from the
current Dynasty and applies the approved hard eligibility, authority, and
protection rules before showing a proposed pair.

### 8.2 Pair presentation

**Confirmed product requirement**

Each proposed pair should show at least:

- subject and proposed partner;
- both ages and their age difference;
- current fertility or another approved player-readable fertility
  presentation;
- important positive congenital traits;
- important negative congenital traits;
- relationship or approved kinship-risk category;
- whether the result will be a marriage or betrothal;
- the planned ordinary or matrilineal direction; and
- whether the partner is a zero-fertility placeholder.

Technical implementation language, hidden workflow state, and internal ranking
calculations should not be shown as player-facing prose.

### 8.3 Player controls

**Confirmed product requirement**

The review must provide these capabilities:

- **Accept current pair** — reserve both characters and add the proposed pair
  to the final-confirmation list without creating a relationship.
- **Skip current pair** — decline the displayed combination without accepting
  it.
- **View next partner** — keep the same subject under review and display the
  next ranked legal partner candidate.
- **Defer this subject** — stop reviewing the subject for now without creating
  or accepting a pair.
- **Finish review early** — retain accepted pairs and proceed to final
  confirmation without automatically accepting unreviewed proposals.
- **Cancel entire workflow** — discard the working plan and end with no
  gameplay change.

**Provisional recommendation**

Within one workflow, a declined subject/partner combination should not be
shown again unless the player explicitly restarts that subject's review.
Accepted characters should be reserved immediately in workflow state so that
neither can appear in another accepted proposal.

**Decision required from Ray**

The following distinctions require final product wording:

- whether **Skip current pair** advances to the next subject or keeps the
  current subject active;
- whether a deferred subject returns at the end of the same run;
- whether a deferred subject may still appear as someone else's partner; and
- whether the player may revisit and replace an already accepted pair before
  final confirmation.

### 8.4 No accept-all control in the isolated prototype

**Provisional recommendation**

The isolated prototype must not include an **Accept all remaining best pairs**
control. Pair-state storage, ranking completeness, performance, and player
review behavior are not yet proven well enough for an unreviewed mass-accept
action. The control remains a post-prototype option and is not permanently
cancelled.

## 9. Marriage direction and relationship type

### Approved prototype decision

The default direction is ordinary marriage or betrothal.

The isolated prototype uses direct execution (Approach B), not a sequence of
vanilla marriage windows:

- the player must choose ordinary or matrilineal direction during review;
- the final confirmation must display that direction for every accepted pair;
- a pair containing a minor creates a betrothal; and
- a pair containing two adults creates a marriage.

No relationship is created when the player merely selects a direction.

The prototype supports only ordinary and matrilineal marriage or betrothal.
Grand Weddings are not part of the prototype. Native-UI and Grand Wedding
support remain deferred possibilities rather than cancelled features.

## 10. Final confirmation and execution

### Confirmed product requirements

Final confirmation must summarize every accepted pair. For each pair it must
identify:

- both characters;
- marriage or betrothal;
- ordinary or matrilineal direction; and
- placeholder status when applicable.

Before the player confirms:

- no marriage or betrothal exists because of this workflow;
- no existing relationship is dissolved;
- no character changes House or Dynasty;
- no resource is consumed;
- no court movement is forced; and
- cancellation produces no gameplay change.

The player must be able to cancel from final confirmation. Cancellation ends
the workflow without applying any accepted pair.

### Approved prototype decision — prototype gate

Immediately before execution, prevalidate every accepted pair as one batch.
If any pair has become invalid, abort the entire workflow before creating any
marriage or betrothal. Execute none of the valid pairs, report that the plan
could not be applied, and clean all workflow-scoped authorization and state.

Whether full-batch prevalidation and all-or-nothing execution can be made
reliable in CK3 is `REQUIRES PROTOTYPE`.

Partial execution, skipping only the invalid pair, or creating relationships
before all accepted pairs pass final validation is not an approved fallback.
If the prototype cannot guarantee this pre-mutation abort policy, the prototype
fails its acceptance gate and must return for design review.

## 11. Authority boundary

### 11.1 Verified vanilla constraint

Current-Dynasty membership does not grant the player a verified blanket right
to arrange every member's marriage. Vanilla marriage authority depends on the
relevant matchmaker and character relationship. Landed characters, members of
another court, and independent rulers may therefore fall outside the player's
ordinary authority.

This is a verified vanilla limitation. The approved prototype direction below
must not be described as vanilla Dynast authority.

### 11.2 Approved prototype authority model

The prototype uses the **Dynast-override model with authorization limited to the
current workflow**.

This is an explicit Breed Improved prototype power. While one valid workflow
is active, it may bypass only:

- the ordinary vanilla matchmaker-authority boundary; and
- AI acceptance of the proposed marriage or betrothal.

The override never bypasses:

- vanilla marriage legality;
- faith and consanguinity restrictions;
- an existing marriage or betrothal;
- a verified state that makes a character unable to marry;
- the female-30+/male-40+ minor prohibition;
- approved protection or special-state exclusions;
- same-character, duplicate, mirror-pair, or already-reserved checks;
- the current-Dynasty-only scope; or
- full-batch final validation.

The authorization is not a permanent Dynast privilege, a general-purpose
Character Interaction power, an AI permission, or authority granted to any
other Mod system. Production use remains unapproved until the isolated
prototype passes its full runtime matrix and receives a separate decision.

### 11.3 Authorization lifecycle and cleanup

**Approved prototype decision — prototype gate**

Workflow authorization must:

1. be created only after the living, player-controlled current Dynast
   explicitly starts the workflow and passes entry validation;
2. be associated only with that initiator, that current Dynasty, and that
   single workflow run;
3. remain usable only for candidate review, final validation, and direct
   execution of pairs accepted in that run;
4. grant no relationship or other gameplay consequence before final
   confirmation; and
5. cease to exist as soon as that run completes, aborts, becomes invalid, or is
   abandoned.

The separate permanent lock grants no authority. It records only that the
save's single prototype workflow has been consumed. Active authorization and
temporary plan state are cleaned where an explicit event option or verified
lifecycle hook provides a reachable cleanup path; the permanent lock is never
cleaned.

The prototype must remove or invalidate all workflow authorization,
reservations, rejected-pair records, deferred state, accepted-pair state, and
other temporary run data in every applicable case:

- normal completion after all approved pairs execute;
- explicit cancellation during review;
- explicit cancellation at final confirmation;
- finishing review with no accepted pair;
- zero eligible subjects or zero legal partner combinations;
- skipping or deferring every subject;
- early finish followed by an empty final list;
- full-batch abort because any accepted pair fails final validation;
- the initiator dying, ceasing to be player-controlled, ceasing to be Dynast,
  or changing Dynasty before execution;
- either participant leaving the current Dynasty before execution;
- save/reload during an active workflow, whether the approved behavior is safe
  restoration or safe abortion;
- a queued or instant event failing its trigger; and
- every explicit terminal option in the event chain.

Cleanup must not create, remove, or alter a marriage or betrothal. It must not
run as a periodic or background matchmaking process.

There is no verified generic callback for an unexpectedly closed visible event.
The prototype therefore does not claim immediate cleanup or a detected close.
It schedules no delayed/background continuation and exposes no resume or
reauthorization path. Such a chain is treated as orphaned and permanently
locked: residual temporary state cannot advance, and the permanent lock blocks
every later workflow in that save. A lifecycle cleanup hook may remove residue,
but it must not remove the lock or resume the chain.

Reliable lifecycle isolation, every cleanup path, and save/reload handling are
`REQUIRES PROTOTYPE`. Any residual authorization usable outside its originating
run is a prototype failure.

### 11.4 Deferred authority alternatives

The vanilla-authority and advisory/native-UI models remain documented
post-prototype alternatives. Approval of the workflow-scoped override for the
prototype does not cancel them or predetermine the production authority model.

## 12. Protection and special-state policy

### Confirmed boundary

Vanilla-illegal relationships and characters who cannot legally marry are hard
exclusions. Already married and betrothed characters are hard exclusions.
The product-level adult/minor age rule is a hard exclusion.

### Provisional four-category policy

Subject to verified CK3 behavior, the first product review should classify
special states as follows:

1. **Vanilla hard prohibition**
   - the relationship is illegal under the applicable faith or marriage rules;
   - a participant has a verified `can_not_marry` state or is clergy whose
     faith does not permit marriage;
   - the native interaction rejects a prisoner, hostage, active
     guardian/ward transfer, mercenary-company holder, peasant/populist
     faction leader, herder-government character, or another verified
     unavailable class; or
   - another verified legality or safety restriction applies.

2. **Recommended hard product exclusion**
   - the player-controlled character;
   - another player-controlled character;
   - anyone already married or betrothed, even when vanilla could permit an
     additional spouse or complete an existing betrothal;
   - an existing concubine relationship pending a separate product decision;
   - every direct ancestor–descendant pair;
   - a pregnant character until paternity and transient-state behavior are
     tested;
   - a pair violating the female-30+/male-40+ minor prohibition; or
   - a character whose special state cannot be handled safely by the approved
     execution approach.

3. **Visible with warning**
   - a landed ruler;
   - an heir;
   - a character with `celibate`, who may be legally marriageable but is not a
     fertile active subject;
   - a character with a lover;
   - a character participating in an ordinary war or activity where vanilla
     does not impose a blanket participant prohibition;
   - a landless adventurer or other context-limited character; or
   - a House Head or the Dynast, if not excluded by final policy.

4. **Normal processing**
   - an otherwise eligible same-Dynasty character covered by the active
     workflow-scoped Dynast override and without a relevant warning state;
   - an eligible divorced or widowed character; or
   - an otherwise legal former spouse of someone other than the exact
     recent-divorce pairing blocked by vanilla.

The lists above are product proposals, not claims that CK3 exposes or enforces
each state in a particular script context.

### Decisions required from Ray

Ray must approve the final handling of:

- the player character and other player-controlled characters;
- the Dynast and House Heads;
- landed rulers and characters in other courts;
- current heirs;
- characters under vows, religious restrictions, or monastic status;
- prisoners and pregnant characters;
- lovers, concubines, and other relationship states;
- characters in activities or wars;
- special governments; and
- out-of-court or independent characters whose ordinary matchmaker differs
  from the initiating Dynast but who would otherwise be covered by the
  workflow-scoped override.

Technical research may move a character into **vanilla hard prohibition**, but
it cannot decide whether a technically valid special-state character should be
excluded, warned, or processed normally.

## 13. Kinship and genetic presentation

### Confirmed product requirements

- Vanilla-illegal kinship combinations are excluded.
- Vanilla-legal combinations may enter the candidate pool.
- Within otherwise equal approved dimensions, less close kinship ranks higher.
- The MVP does not simulate complete genetic inheritance probabilities.
- A positive congenital-trait comparison is lower priority than age proximity
  for minors and lower than fertility tier plus age proximity for adults.

### Technical limitation affecting wording

No verified script interface currently provides an exact general kinship
coefficient or CK3's internal genetic-risk value for arbitrary pairs. The MVP
must therefore use only relationship categories proven available during
technical design. Its lowest observable risk category should be described as
**no close or extended relationship detected**, never **unrelated** or **no
inbreeding risk**.

### Decisions required from Ray

Ray must approve:

- the player-facing kinship-risk labels;
- the treatment of cousins, uncles/aunts with nieces/nephews, half-siblings,
  grandparents with grandchildren, and other supported categories;
- the positive congenital-trait set and comparison order;
- whether negative congenital traits change ranking; and
- whether a trait warning may be shown without affecting rank.

## 14. State and consistency contract

### Confirmed product requirements

During one run:

- a character cannot be present in two accepted pairs;
- an accepted character cannot be proposed again;
- a pair cannot be generated again in reversed order;
- declined or protected combinations must not be re-added contrary to the
  player's recorded choice;
- an invalid combination cannot reach final execution; and
- cancellation must clear workflow-only state and authorization without
  changing gameplay, while retaining the permanent one-workflow-per-save lock.

### Prototype gate

Phase 2's sequential review and final-confirmation concept is suitable as a
product model, but Phase 3 must store a pair, direction, outcome type, and
placeholder status rather than one character. The required pair-state model,
save/reload continuity, explicit cleanup plus orphaned-close behavior, and final
summary are `REQUIRES PROTOTYPE`.

The product must not promise an unlimited number of accepted pairs until the
state and UI limits are measured.

The state model must also make workflow authorization inseparable from its
originating run. No residual pair record may be executable after active
authorization is cleaned or orphaned. The permanent lock is intentionally
separate: it grants nothing and survives every terminal path. Abnormal-close
residue is acceptable only if it is unreachable, cannot resume, and cannot be
used by another run.

## 15. Approved isolated prototype direction

### Approved prototype decision

The isolated Phase 3 prototype must demonstrate:

- one explicitly player-initiated workflow;
- a living, player-controlled Dynast as initiator;
- current-Dynasty candidates only;
- the Dynast-override model limited to the current workflow;
- bypass of matchmaker authority and AI acceptance only;
- unmarried and unbetrothed minors and adults in the approved active
  categories;
- zero-fertility divorced/widowed adults only as last-resort placeholders;
- the hard female-30+/male-40+ minor exclusion;
- lexicographic minor and adult ranking;
- the dynamic five-percentage-point adult fertility tier;
- one accepted pair per character;
- ordinary and matrilineal direction selected during review;
- direct Approach B execution;
- marriage for two adults and betrothal for any pair containing a minor;
- no Grand Wedding;
- no **Accept all remaining** action;
- a complete final summary;
- full-batch prevalidation;
- direct execution only after explicit final confirmation;
- full-batch abort before any relationship if one pair is invalid; and
- explicit authorization and workflow-state cleanup on every reachable terminal
  or lifecycle-hook path, with abnormal closure becoming orphaned and
  permanently locked rather than claiming an unavailable close callback.

This approves an isolated, workflow-authorized direct-execution prototype for
technical evaluation. It does not approve that approach for production. The
prototype must specifically measure the marriage/betrothal, alliance,
Prestige, court, House, Dynasty, inheritance, and save/reload consequences
against equivalent vanilla actions.

The native marriage interface remains a potential later assistant. It should
not be used as the main batch executor unless continuation, cancellation, and
state restoration are independently verified.

## 16. Explicit isolated-prototype exclusions

The first isolated prototype excludes the following items. These are prototype
scope boundaries, not permanent product cancellations:

- candidates outside the current Dynasty;
- automatic, scheduled, recurring, or background matchmaking;
- automatic acceptance of unreviewed pairs;
- **Accept all remaining best pairs**;
- divorce, betrothal cancellation, spouse replacement, or polygamous-slot
  management;
- grand-wedding orchestration;
- political, title, alliance-value, inheritance-value, military, diplomacy,
  wealth, Prestige, court-position, realm-size, cultural, religious-spread, or
  AI-acceptance ranking;
- forced court invitations or movement;
- a complete genetic-probability simulation;
- claims that the least-related observable category is genetically unrelated;
- unapproved fertility approximations, age bands, trait weights, or
  tie-breakers; and
- any persistent, general-purpose, AI-usable, or cross-workflow Dynast marriage
  authority.

## 17. Resolved and remaining decisions

### 17.1 Resolved for the isolated prototype

The following are fixed for the prototype:

- authority model: Breed Improved Dynast override, scoped to one
  player-initiated workflow;
- execution model: direct Approach B;
- overridden vanilla boundaries: ordinary matchmaker authority and AI
  acceptance only;
- relationship type: adults marry; any pair containing a minor is betrothed;
- supported directions: ordinary and matrilineal;
- Grand Wedding: not supported in the prototype;
- invalidation policy: prevalidate the complete batch and abort before any
  relationship if one pair is invalid; and
- run-identity policy: numeric run identity remains unverified, so the prototype
  permits one confirmed workflow per save and keeps its permanent lock forever;
- lifecycle policy: clean active authorization and temporary state on every
  explicit completion, cancellation, abort, invalidation, and verified
  lifecycle-hook path; and
- abnormal-close policy: no close callback, delayed/background continuation,
  resume, or reauthorization is claimed; the run becomes orphaned and the save
  remains locked.

These decisions do not approve production gameplay.

### 17.2 Decisions still required before a complete prototype specification

Ray and Jay/Boss must resolve:

1. the final four-category protection policy;
2. whether zero-fertility never-married adults can be subjects or placeholders;
3. treatment of unavailable fertility and uncertain marriage-history state;
4. positive and negative congenital-trait ranking policy;
5. kinship-risk categories and player-facing labels;
6. ordering below the highest dynamic fertility tier;
7. deterministic tie-breaking and subject-processing order;
8. exact fertility presentation;
9. **Skip**, **Next partner**, and **Defer** state transitions;
10. whether accepted pairs may be revised before confirmation; and
11. the default direction presented for ordinary/matrilineal selection.

Technical evidence and an isolated prototype must resolve:

- stable access to the required fertility and history state;
- the dynamic five-percentage-point tier;
- pair-state continuity and cleanup;
- final summary capacity;
- full-batch prevalidation without partial execution;
- direct-effect parity and side effects;
- performance on large Dynasties; and
- save/reload behavior.

### 17.3 Deferred after the prototype — not cancelled

The following remain available for later evaluation and were not cancelled by
the approved prototype direction:

- a vanilla-authority production model;
- an advisory or native-marriage-UI handoff;
- Grand Wedding support through a separately verified workflow;
- **Accept all remaining best pairs** after ranking and state safety are
  runtime-verified;
- richer protection controls and warnings;
- revision or replacement of accepted pairs before final confirmation; and
- broader presentation and quality-of-life improvements.

Each deferred item requires separate evidence, product approval, and runtime
testing. None is part of the isolated prototype.

## 18. Product acceptance criteria

Phase 3 cannot be approved for production until an implementation candidate
demonstrates all approved criteria below in CK3:

- only a living, player-controlled current Dynast can start the prototype
  workflow;
- the permanent lock is set only by the entry event's explicit activation option, survives
  every outcome and save/reload, and blocks every second workflow in the save;
- workflow authorization is limited to its originating run and is removed or
  made unreachable on every required completion, cancellation, abort,
  interruption, and save/reload path;
- an abnormally closed visible event never resumes, reauthorizes, schedules
  delayed/background execution, or reaches a relationship operation;
- the override bypasses only ordinary matchmaker authority and AI acceptance,
  never vanilla legality, faith, consanguinity, marriage status, safety,
  protection, or product-level hard exclusions;
- only eligible current-Dynasty characters are proposed;
- minors and adult categories follow their distinct ranking orders;
- the hard adult/minor age prohibitions hold at and beyond the boundary ages;
- placeholder partners never outrank a normal fertile legal partner;
- no married or betrothed relationship is broken or replaced;
- no character appears in more than one accepted pair;
- mirror and repeated proposals are prevented as designed;
- all review controls follow their approved state transitions;
- the final page accurately represents every accepted pair and direction;
- no relationship, resource, or other gameplay state changes before final
  confirmation;
- cancellation from every supported point causes no gameplay change;
- one invalid pair causes full-batch abort before any marriage or betrothal,
  with no hidden partial execution;
- adults marry and pairs containing a minor become betrothed;
- ordinary and matrilineal directions produce their approved vanilla
  consequences;
- the prototype never initiates a Grand Wedding;
- authority and special-state rules match the approved product model;
- the workflow remains stable across save/reload where supported;
- Phase 1 and Phase 2 behavior does not regress; and
- the CK3 error log contains no blocking Breed Improved error from the
  workflow.

The detailed scenario matrix belongs in
`docs/testing/phase3_dynasty_matchmaking_manual.md`. Until those tests are
approved and run, Phase 3 runtime status remains `NOT RUN`.
