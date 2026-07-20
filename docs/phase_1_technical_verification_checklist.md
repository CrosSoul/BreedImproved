# Phase 1 Technical Verification Checklist

## Purpose

Determine whether Crusader Kings III `1.19.0.6` supports the mechanics required for Breed Improved's player-facing **Exile from Dynasty** action.

This is a research checklist, not an implementation specification. It does not authorize gameplay files, test scripts, events, decisions, interactions, scripted triggers, scripted effects, or changes to the installed game.

## Current Evidence Status

- Target build: CK3 `1.19.0.6`
- Project syntax registry: no verified CK3 constructs currently recorded
- Project vanilla-example library: no sourced examples currently recorded for this feature
- Overall result: **NOT VERIFIED — IMPLEMENTATION BLOCKED**

All mechanics in this checklist remain `UNVERIFIED CK3 SYNTAX` until the required evidence is collected and recorded.

## Verification Rules

- Use only evidence from CK3 `1.19.0.6` or an authoritative source explicitly matching that version.
- Record the exact source path, game version, enclosing block, construct category, input scope, arguments, output state, and known side effects.
- Verify definitions and real call sites. A matching English name or token-like string is not sufficient.
- Verify a construct in the same file family and scope context planned for Breed Improved.
- Do not infer commands from prefixes such as `set_`, `remove_`, `clear_`, `create_`, or `change_`.
- Do not use syntax from Stellaris, EU4, Victoria 3, HOI4, or another Paradox title.
- Treat save-game numeric trait identifiers as serialization references only. They are never valid evidence for mod script identifiers.
- Treat observed save data as supporting behavioral evidence, not proof that a script API exists.
- Distinguish these findings: a character can exist in a state, script can create that state, and the state remains safe after save/reload. Each requires separate evidence.
- If evidence is incomplete, record `UNVERIFIED CK3 SYNTAX: <specific uncertainty>` and leave the implementation gate closed.

`<CK3_1_19_0_6_GAME_ROOT>` below is a documentation placeholder for the verified local installation root. Do not copy it literally into scripts or configuration.

## Acceptable Source Categories

Use sources in this order:

1. Existing project evidence with the same CK3 version and usage context.
2. User-provided CK3 `1.19.0.6` references.
3. Installed vanilla CK3 `1.19.0.6` definitions and call sites under `<CK3_1_19_0_6_GAME_ROOT>`.
4. Official, version-matched CK3 documentation.
5. Game-generated script documentation or diagnostic output only if its generation method and version are verified.
6. Controlled in-game observation as behavioral confirmation after a construct has source evidence and a separate test is authorized.

Community material may identify search leads but cannot establish support without corroboration from a higher-priority source.

## Evidence Record Template

Create one record for every candidate construct or behavior:

```text
Research question:
Status: UNVERIFIED | VERIFIED | UNSUPPORTED FOR TESTED CONTEXT
CK3 build:
Exact construct or behavior:
Category:
Definition source path:
Call-site source path:
Enclosing file family and block:
Input scope:
Arguments and value types:
Output scope or state change:
Observed side effects:
DLC or feature dependencies:
Minimal evidence pointer:
Runtime test status:
Save/reload test status:
Conclusion and limitations:
Reviewer:
Date:
```

Do not mark a candidate `VERIFIED` when any required field is unknown.

## 1. Dynasty Manipulation

### 1.1 Can Script Change a Character's Dynasty Affiliation?

Possible sources to check:

- [ ] Search installed CK3 `1.19.0.6` vanilla script definitions for character-to-dynasty or character-to-house state changes.
- [ ] Search all vanilla callers of each candidate construct, not only its definition.
- [ ] Search vanilla events, decisions, interactions, history, and character-creation flows after confirming their actual target-version locations.
- [ ] Check version-matched official documentation for character, house, and dynasty effects and scopes.
- [ ] Check verified game-generated script documentation, if available for this exact build.

Evidence required before implementation:

- [ ] Exact effect or workflow name and proof that it is a CK3 effect or other callable mechanism.
- [ ] Exact valid file family and enclosing execution context.
- [ ] Required input scope and the type of every supplied value.
- [ ] Whether the destination is a dynasty, house, no affiliation, or another state.
- [ ] At least one CK3 `1.19.0.6` vanilla call site using the construct for the same purpose and compatible scope.
- [ ] Documented behavior for the character's house and dynasty after execution.
- [ ] Evidence that the character is not deleted, killed, automatically imprisoned, or merely made landless.
- [ ] Evidence that the result survives save and reload without parser, runtime, or state-consistency errors.
- [ ] Known side effects on relatives, descendants, dynasty display, house display, renown, claims, succession, and inheritance are recorded.

Decision gate:

- [ ] **PASS:** A supported, scoped, and reproducible CK3 `1.19.0.6` mechanism is verified.
- [ ] **FAIL:** No supported mechanism is found after the searched sources and search coverage are documented.
- [ ] **BLOCKED:** A plausible candidate exists, but its role, scope, arguments, or consequences remain uncertain.

Current status: `UNVERIFIED CK3 SYNTAX: no dynasty-affiliation mutation mechanism has been verified.`

### 1.2 Can a Character Exist Without a Dynasty?

Possible sources to check:

- [ ] Search vanilla character definitions and creation flows for characters with no dynasty or house after verifying the relevant file locations.
- [ ] Identify naturally occurring CK3 `1.19.0.6` characters without a dynasty, if any, and record how they were created.
- [ ] Inspect vanilla-produced save state for such characters as behavioral evidence only.
- [ ] Check official or game-generated documentation for required character, house, and dynasty relationships.
- [ ] Observe relevant vanilla UI and logs in a controlled game state if a separate test is authorized.

Evidence required before implementation:

- [ ] A reproducible CK3 `1.19.0.6` example of a valid character with no dynasty is recorded.
- [ ] The example identifies whether the character also lacks a house.
- [ ] The example remains valid after save/reload and normal game progression.
- [ ] The applicable limits are documented: living/dead, landed/landless, ruler/non-ruler, adult/child, generated/historical, and player/AI character.
- [ ] It is determined whether the game automatically assigns an affiliation later.
- [ ] It is explicitly documented that existence of a dynastyless character does not prove script can remove an existing dynasty affiliation.

Decision gate:

- [ ] **PASS:** Dynastyless existence is valid for Breed Improved's target character contexts, and a separate verified transition mechanism can produce it safely.
- [ ] **LIMITED:** Dynastyless characters exist, but not for the required contexts or not through script.
- [ ] **FAIL:** The state is unsupported or becomes invalid.
- [ ] **BLOCKED:** Examples exist but their origin or constraints cannot be established.

Current status: `UNVERIFIED CK3 SYNTAX: dynastyless character validity and script reachability are unknown.`

### 1.3 Are There Vanilla Dynasty-Change Examples?

Possible sources to check:

- [ ] Search target-version vanilla files by concepts related to dynasty, house, lineage, founding, assignment, and affiliation.
- [ ] Trace candidate scripted definitions to every vanilla caller.
- [ ] Compare examples that change house membership with examples that change dynasty membership; do not treat them as equivalent without evidence.
- [ ] Check whether examples are initial setup only, runtime behavior, engine-only behavior, or callable script.

Evidence required before implementation:

- [ ] Exact source paths and precise pointers are recorded.
- [ ] Each example's CK3 version and DLC dependency are recorded.
- [ ] The initial and final house/dynasty states are known.
- [ ] The example runs at gameplay time rather than only during database initialization, unless initialization is the intended context.
- [ ] The actor, target, and destination scopes match the planned use or differences are documented.
- [ ] All automatic consequences and restrictions are documented.
- [ ] A small, properly attributed excerpt or reference note is added to the project vanilla-example library when distribution permits.

Current status: `UNVERIFIED CK3 SYNTAX: no same-version vanilla dynasty-change example is recorded.`

## 2. House Handling

### 2.1 What State Follows Dynasty Separation?

Possible sources to check:

- [ ] Vanilla definitions and call sites that assign, create, change, or clear houses or dynasties, if such constructs exist.
- [ ] Vanilla character creation and house-founding workflows after confirming exact paths.
- [ ] Same-version character, house, dynasty, and family-tree UI behavior.
- [ ] Save data before and after a verified vanilla affiliation change as behavioral evidence only.
- [ ] Version-matched official documentation describing house/dynasty relationships.

Evidence required before implementation:

- [ ] Determine whether house membership always implies dynasty membership in the required context.
- [ ] Determine whether dynasty separation automatically clears, preserves, or changes house membership.
- [ ] Determine whether the target must be assigned to another house or dynasty.
- [ ] Determine whether a new house/dynasty can and should be created, and record all costs, ownership, naming, coat-of-arms, persistence, and compatibility consequences.
- [ ] Determine whether an existing destination affiliation can be used safely.
- [ ] Determine whether the resulting state is visible and understandable in the dynasty, house, character, and family-tree interfaces.
- [ ] Confirm the state persists after save/reload.
- [ ] Confirm the state does not require killing, automatic imprisonment, or landlessness as a substitute for lineage separation.

Decision gate:

- [ ] **NO AFFILIATION:** Verified safe state with neither required replacement house nor dynasty.
- [ ] **REASSIGNMENT REQUIRED:** Verified safe state requires an existing or newly created destination affiliation.
- [ ] **UNSUPPORTED:** No safe state satisfies Exile from Dynasty.
- [ ] **BLOCKED:** House/dynasty invariants remain unclear.

Current status: `UNVERIFIED CK3 SYNTAX: the required post-exile house/dynasty state is unknown.`

### 2.2 Is New House or Dynasty Creation Required?

Possible sources to check:

- [ ] Vanilla workflows that create cadet houses, dynasties, or other affiliations, without assuming they apply to this use case.
- [ ] Exact definitions and callers of any candidate creation mechanism.
- [ ] Target-version rules for ownership, founders, naming, coat of arms, and dynasty linkage.
- [ ] Save/reload and UI behavior of vanilla-created houses or dynasties.

Evidence required before implementation:

- [ ] Proof that creation is technically necessary rather than merely available.
- [ ] Exact supported creation mechanism, context, required arguments, and resulting relationships.
- [ ] Whether one shared destination can be reused or each exiled character requires a separate affiliation.
- [ ] Consequences for descendants, marriage, renown, succession, claims, and compatibility are documented.
- [ ] Performance and save-growth implications for bulk exile are measured before approval.
- [ ] Product approval is obtained before adding new houses or dynasties as a Phase 1 consequence.

Current status: `UNVERIFIED CK3 SYNTAX: no house/dynasty creation requirement or mechanism is verified.`

## 3. Claims and Inheritance

### 3.1 How Can Claims Be Removed Safely?

First define the product term "claims controlled by the removed lineage." Do not assume all claims held by the character came from, belong to, or should be removed with that lineage.

Possible sources to check:

- [ ] Vanilla definitions and call sites that remove or invalidate claims, if such constructs exist.
- [ ] Version-matched official or verified game-generated documentation for claim types, claim scopes, and claim mutation.
- [ ] Vanilla workflows that revoke, consume, invalidate, or otherwise change claims, while distinguishing their exact contexts and side effects.
- [ ] Succession and inheritance examples that create claims, to establish provenance and determine whether lineage-controlled claims are identifiable.
- [ ] Controlled before/after claim inventories in a separately authorized test.

Evidence required before implementation:

- [ ] Exact claim-removal mechanism and proof that it is supported in CK3 `1.19.0.6`.
- [ ] Required character/title scopes, argument types, and valid effect context.
- [ ] The claim categories and title relationships affected by the mechanism.
- [ ] A reliable rule for identifying only claims covered by the approved product definition.
- [ ] Evidence that unrelated claims in every applicable target-version claim category are not removed unintentionally; record only categories verified from CK3 `1.19.0.6` sources.
- [ ] Behavior for claims that change between candidate display and confirmation.
- [ ] Save/reload persistence and UI consistency.
- [ ] Failure behavior when a claim cannot be removed.

Safety gate:

- [ ] Claim handling is scoped per verified title/claim relationship; there is no unreviewed blanket clear.
- [ ] The pre-confirmation summary can accurately disclose affected claims.
- [ ] If safe identification or removal cannot be verified, claim removal remains disabled and the design returns for review.

Current status: `UNVERIFIED CK3 SYNTAX: no safe lineage-scoped claim-removal mechanism is verified.`

### 3.2 How Can Inheritance Relevance Be Removed?

"Inheritance relevance" must be defined as an observable product outcome before a technical mechanism is selected. Dynasty membership, title succession, claims, family relationships, and eligibility under a succession system may be independent concerns.

Possible sources to check:

- [ ] Target-version vanilla succession and inheritance definitions after confirming their exact file locations.
- [ ] Same-version title, law, family, dynasty, and house logic used by actual succession calculations.
- [ ] Version-matched official documentation describing succession eligibility and dynasty-related outcomes.
- [ ] Vanilla UI explanations and succession previews as behavioral evidence.
- [ ] Controlled before/after succession scenarios in a separately authorized test.

Evidence required before implementation:

- [ ] Product definition specifies which inheritance or succession result must change.
- [ ] Determine whether the result is derived from dynasty, house, blood relationship, marriage, title law, faith, government, claims, or another verified factor.
- [ ] Identify whether any supported script mechanism can change the relevant factor safely.
- [ ] Confirm that dynasty exile alone produces the intended result; if not, document every additional required operation.
- [ ] Verify the result across each supported title, law, government, faith, and DLC context selected for Phase 1.
- [ ] Confirm vanilla inheritance rules are not globally overridden or modified.
- [ ] Confirm unrelated characters and titles are unaffected.
- [ ] Confirm behavior after save/reload and succession recalculation.

Decision gate:

- [ ] **PASS:** The approved inheritance outcome follows from verified, scoped changes.
- [ ] **PARTIAL:** Dynasty exile is supported, but the requested inheritance outcome cannot be guaranteed in all approved contexts.
- [ ] **FAIL:** Achieving the outcome requires unsafe or global inheritance changes.
- [ ] **BLOCKED:** The product meaning or engine behavior remains undefined.

Current status: `UNVERIFIED CK3 SYNTAX: inheritance relevance is not yet mapped to a verified CK3 mechanism.`

## 4. Trait and Status Verification

### 4.1 Where Must Vanilla Keys Be Verified?

Possible sources to check:

- [ ] Locate the actual trait and status definition directories inside `<CK3_1_19_0_6_GAME_ROOT>`; do not assume a path from another CK3 version or Paradox game.
- [ ] Inspect the defining vanilla file for every bastard-related concept.
- [ ] Trace each candidate key to target-version vanilla trigger usage and real callers.
- [ ] Inspect associated target-version localisation only to confirm player-facing meaning; localisation alone does not prove script identity or category.
- [ ] Check version-matched official or verified game-generated documentation for trait/status detection and valid scopes.
- [ ] Record DLC or feature dependencies.

Evidence required before implementation:

- [ ] Exact script key is taken from a CK3 `1.19.0.6` definition, not a save-game number.
- [ ] The construct's category is established: trait, status, flag, secret, relationship, or another verified CK3 type.
- [ ] Definition path and precise source pointer are recorded.
- [ ] At least one same-version vanilla usage demonstrates the exact detection method.
- [ ] The detection construct is categorized correctly as a trigger, value, scope link, or other CK3 element.
- [ ] Required input scope and valid enclosing contexts are recorded.
- [ ] Bastard, legitimized-bastard, disputed-parentage, hidden-parentage, and other relevant concepts are distinguished only when their exact target-version representations are verified.
- [ ] Required DLC and version restrictions are recorded.
- [ ] The verified entry is added to `ck3_syntax_reference.md` before implementation.

Rejected evidence:

- [ ] Numeric trait IDs copied from a save.
- [ ] Numeric-to-name mappings inferred from load order or observation without a target-version definition.
- [ ] Localisation keys presented as script keys without a definition and call site.
- [ ] Wiki or community lists without same-version vanilla corroboration.
- [ ] Similar trait/status syntax from another Paradox game.

Current status: `UNVERIFIED CK3 SYNTAX: no bastard-related trait/status key or detection method is verified.`

## 5. Cross-Cutting Safety Verification

Complete these checks for every viable approach:

- [ ] Record CK3 executable/build identification proving `1.19.0.6` was tested.
- [ ] Record enabled DLC, language, load order, game rules, and relevant starting state.
- [ ] Preserve a reproducible baseline and backup before any future experiment.
- [ ] Do not alter installed vanilla files.
- [ ] Obtain separate authorization before creating any experimental gameplay or test mod files.
- [ ] Verify all actor, target, title, house, and dynasty scopes independently.
- [ ] Confirm Exile from Dynasty never kills or automatically imprisons the target.
- [ ] Confirm landlessness, court movement, or geographical exile is not treated as lineage separation without evidence and design approval.
- [ ] Confirm no automatic scan, yearly process, background event, delayed cleanup, or automatic exile is introduced.
- [ ] Confirm every state-changing path requires explicit player initiation and confirmation.
- [ ] Revalidate the target and all affected claims immediately before execution.
- [ ] Test cancellation and invalidation without state changes.
- [ ] Test save/reload after each state transition.
- [ ] Inspect the first relevant parser/runtime error and record actual logs without inventing paths or results.
- [ ] Compare individual and future bulk interfaces against the same verified eligibility and exile contract.
- [ ] Record compatibility risks and behavior with existing saves before release approval.

## 6. Final Implementation Gate

Gameplay implementation must not begin until all required items below pass:

- [ ] A safe CK3 `1.19.0.6` dynasty-separation mechanism is verified, or a documented product decision approves a different outcome.
- [ ] The valid post-exile house/dynasty state is verified.
- [ ] It is known whether a new house/dynasty is required.
- [ ] The character remains alive and is not automatically imprisoned.
- [ ] Landlessness is either proven technically necessary and approved, or excluded from the implementation.
- [ ] Lineage-controlled claims have a precise product definition and a safe verified treatment.
- [ ] The desired inheritance outcome is precisely defined and supported without global inheritance modification.
- [ ] Bastard-related keys and detection constructs are verified from target-version vanilla definitions and usages.
- [ ] No numeric save-game trait ID is used as a script identifier.
- [ ] Every required construct is entered in `ck3_syntax_reference.md` with version, file context, scopes, arguments, evidence, and restrictions.
- [ ] Relevant sourced examples are recorded in `ck3_vanilla_examples/` with provenance.
- [ ] All remaining uncertainties are visible as blockers rather than guessed syntax.

Final status: **NOT VERIFIED — DO NOT IMPLEMENT**
