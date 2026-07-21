# Project Rules

## Contents

- [Project Status and Goals](#project-status-and-goals)
- [Confirmed Design Direction](#confirmed-design-direction)
- [Evidence and Approval](#evidence-and-approval)
- [Foundation Layout and Launcher Setup](#foundation-layout-and-launcher-setup)
- [Folder Structure Conventions](#folder-structure-conventions)
- [Namespace Naming Rules](#namespace-naming-rules)
- [Event ID Naming Rules](#event-id-naming-rules)
- [Decision Naming Rules](#decision-naming-rules)
- [Localisation Naming Rules](#localisation-naming-rules)
- [Script Organization Rules](#script-organization-rules)
- [Version Control Rules](#version-control-rules)
- [Pre-Implementation Checklist](#pre-implementation-checklist)

## Project Status and Goals

Treat this repository as the Breed Improved CK3 mod project. Version `0.1.0` contains one runtime-verified production Character Interaction; future features remain design-only until separately approved.

Use angle-bracket values as unresolved placeholders. Do not copy them literally into runnable mod files.

| Project setting | Value |
| --- | --- |
| Mod display name | `Breed Improved` |
| Internal identifier prefix | `breedimp` |
| Event namespace root | `breedimp` |
| Mod content folder | `MyCK3Mod` (temporary scaffold name) |
| Developer launcher template | `MyCK3Mod.mod` (not distributed to end users) |
| Developer local launcher path | `<LOCAL_MOD_PATH>` (temporary placeholder) |
| Target CK3 version | `1.19.*` (verified against installed CK3 `1.19.0.6`) |
| Supported DLC policy | `<DLC_POLICY>` |
| Supported languages | English and Simplified Chinese |
| Mod scope | CK3 dynasty management utility |
| Compatibility policy | `<COMPATIBILITY_POLICY>` |
| Supported end-user distribution | Steam Workshop only |
| Steam Workshop item | `3769010534` |
| Steam Workshop URL | `https://steamcommunity.com/sharedfiles/filedetails/?id=3769010534` |
| GitHub role | Public source, history, issues, roadmap, documentation, tags, and Release notes |
| Release versioning scheme | `<VERSIONING_SCHEME>` |

Adopt these development goals:

- Favor correctness, maintainability, and traceability over rapid feature volume.
- Minimize conflicts with vanilla CK3 and other mods.
- Keep systems modular so individual content families can be reviewed and tested independently.
- Keep all CK3 syntax tied to project evidence or target-version CK3 references.
- Keep IDs, namespaces, localisation keys, and filenames globally unique.
- Preserve backward compatibility for released IDs whenever practical.
- Document compatibility assumptions and actual validation results.
- Preserve the confirmed player-controlled dynasty-management scope without inferring implementation details.

## Confirmed Design Direction

Breed Improved is a Crusader Kings III dynasty management utility mod. It provides player-controlled tools for dynasty membership management and internal marriage planning. It must not modify vanilla CK3 genetics or inheritance mechanics.

### Confirmed Naming Convention

The player-facing mod display name is `Breed Improved`. Use the lowercase ASCII prefix `breedimp` for project-owned internal identifiers.

Apply the prefix as follows:

- Event namespaces: `breedimp_<system>`.
- Event IDs: `breedimp_<system>.<NNNN>`, subject to verification of the target-version CK3 event-ID format.
- Scripted effects: `breedimp_<purpose>`.
- Scripted triggers: `breedimp_<purpose>`.
- Localisation keys: `breedimp_<purpose>` plus only those semantic suffixes verified for the relevant CK3 content family.
- Other project-owned internal identifiers: begin with `breedimp_` unless a verified CK3 format imposes a different requirement.

Use lowercase ASCII snake_case after the prefix. Angle-bracket components are planning placeholders and must never be copied literally into runnable files. This convention confirms identifier ownership and spelling; it does not verify any CK3 declaration, field, command, file structure, or required localisation suffix.

The existing `MyCK3Mod` content-folder and launcher-template names are temporary scaffold names. This documentation update does not authorize renaming metadata or content paths; handle any future rename as a separate, reviewed foundation change.

### Player Control and Automation Prohibition

- Do not perform automatic or scheduled dynasty-member scans, including yearly cleanup scans.
- Do not remove dynasty members automatically.
- Do not use background events or passive processes to modify dynasty membership.
- Require explicit player interaction to begin every dynasty-cleanup workflow.
- Require player confirmation before every individual or multi-character removal is applied.
- Permit candidate scanning only inside a management flow explicitly initiated by the player. A player-triggered scan must not continue as recurring or background automation.

### Phase 1: Dynasty Membership Management

- Version `0.1.0` implements the individual **Exile from Dynasty** Character Interaction.
- Require explicit player initiation and confirmation before every exile.
- Support minors, adults, unlanded characters, landed rulers, and current player heirs when they meet production validation.
- Exclude House Heads and the Dynast.
- Move the target and descendants into a generated replacement Dynasty.
- Keep bulk management outside Phase 1 release scope.

#### Character Interaction Interface

Purpose:

- Handle individual cases.
- Allow the player to initiate removal of a specific dynasty member from that character's interaction menu.

Use case:

- Remove one unwanted dynasty member.

The interface must require explicit player initiation and a confirmation step before applying removal.

### Phase 2: Bulk Dynasty Cleanup

Status: deferred; not implemented.

Apply these design boundaries:

- Use a separate conservative candidate trigger; do not automatically reuse the manual interaction's cost trigger.
- Permit Dynasty-external parents to be marked as accepted founder parents only after separate approval.
- Protect children of accepted founder parents from a future player-initiated bulk candidate set.
- Keep manual **Exile from Dynasty** available independently.
- Never hardcode character names or save-specific character IDs.
- Require separate design approval, CK3 evidence, implementation approval, and runtime testing.
- Run any candidate scan only after explicit player initiation; never schedule or repeat it in the background.

### Phase 3: Dynasty Marriage Assistance

- Reduce repetitive manual marriage management in large dynasties.
- Consider age compatibility, traits, and genetic risks when assisting the player.
- Avoid excessively close blood relationships.
- Keep scoring rules, relationship-distance thresholds, candidate scope, presentation, and player controls open for later design and CK3 syntax verification.

### Phase 4: Advanced Breeding Assistant

- Support long-term planning.
- Remain player-assisted rather than fully autonomous.
- Keep planning models, recommendations, limits, and user interface open for later design.

### Scope Control

- Do not implement any phase directly from this roadmap.
- Before gameplay work begins, convert the selected phase into a reviewed feature specification with acceptance criteria.
- Verify every required CK3 trigger, effect, scope, modifier, command, script structure, and file location against the evidence order in this document.
- Do not infer new mechanics, automation, AI behavior, eligibility rules, or compatibility promises from the high-level roadmap.
- Keep implementation choices flexible until supported by approved design decisions and target-version CK3 references.

## Evidence and Approval

Apply this evidence order:

1. Existing project files from the same file family and usage context.
2. User-provided references for the target CK3 version.
3. Vanilla files from the same CK3 version.
4. Version-matched official CK3 documentation.
5. Community material only when corroborated by a higher-priority source.

Never use another Paradox game's files as CK3 implementation evidence.

Before introducing a new CK3 directory, file type, field, trigger, effect, modifier, scope link, or script command:

- Verify its exact CK3 form and context.
- Record the target CK3 version and evidence path.
- Stop and report `UNVERIFIED CK3 SYNTAX` when evidence is insufficient.
- Request approval before establishing a new project-wide convention from a placeholder.

## Foundation Layout and Launcher Setup

Use this confirmed repository layout:

```text
<REPOSITORY_ROOT>/
  MyCK3Mod.mod
  MyCK3Mod/
    descriptor.mod
    common/
      decisions/
      scripted_effects/
      scripted_triggers/
    events/
    localization/
      english/
    gfx/
    gui/
```

Treat `MyCK3Mod/` as the CK3 mod content root. Keep development-only material, including `.agents/`, outside that folder.

Steam Workshop is the sole supported end-user installation channel. Users subscribe through Steam Workshop and enable the Mod in a CK3 Launcher playset. GitHub source archives are not supported installable Mod packages, and cloning the repository does not automatically install the Mod.

Use `MyCK3Mod.mod` only as a developer/advanced-user local launcher template. Keep `path="<LOCAL_MOD_PATH>"` unchanged in the committed template. For repository-path development testing:

1. Copy `MyCK3Mod.mod` to the CK3 user mod directory used by the launcher.
2. In that copied file only, replace `<LOCAL_MOD_PATH>` with the absolute path to this repository's `MyCK3Mod/` directory, using forward slashes.
3. Keep the repository template portable; never commit the machine-specific replacement path.
4. Enable the copied launcher entry in a CK3 playset.

This local path workflow is not an officially supported end-user installation method. Do not include `MyCK3Mod.mod` in Workshop staging.

Keep `MyCK3Mod/descriptor.mod` free of the local `path` field and `remote_file_id`. The first upload assigned Workshop item `3769010534`; store that public ID in `docs/publishing/workshop_item_id.txt`, and let `scripts/stage_workshop.ps1` inject exactly one `remote_file_id="3769010534"` into the generated staged descriptor. All future Workshop updates must reuse this item. Select the existing **Breed Improved** Launcher entry instead of creating a new Mod entry, which could create a duplicate Workshop item. The user-directory outer `BreedImproved.mod` is Launcher-managed and must not be generated or committed by the repository.

The empty leaf directories contain only `.gitkeep` repository markers. These markers preserve the verified folder structure and are not gameplay definitions.

## Folder Structure Conventions

Mirror verified vanilla CK3 paths exactly. Treat directories and file placement as part of the game API.

Use this abstract pattern for future files inside the confirmed content root:

```text
MyCK3Mod/
  <VERIFIED_CK3_DIRECTORY>/
    breedimp_<system>_<purpose>.<VERIFIED_EXTENSION>
```

Follow these rules:

- Create only directories confirmed by same-version vanilla CK3 or an approved project reference.
- Use lowercase ASCII filenames with underscores unless a verified CK3 format requires otherwise.
- Prefix project-owned script filenames with `breedimp_`.
- Group files by CK3 content family first, then by coherent project system.
- Keep events, decisions, reusable script definitions, localisation, GUI, history, map data, and assets in their verified CK3 locations; never create a convenient custom path that CK3 will not load.
- Keep one coherent system or responsibility per file when practical.
- Avoid copying entire vanilla files when a smaller compatible override or additive file is verified.
- Do not add `replace_path` without explicit approval and a documented analysis of everything it masks.
- Preserve the encoding, BOM, line endings, and extension required by the target file family.
- Add new root-level tooling or documentation directories only when they cannot be confused with CK3-loaded mod content.

## Namespace Naming Rules

Use `breedimp` as the confirmed root for all project-owned event namespaces.

Default project pattern:

```text
breedimp_<system>
```

Apply these rules:

- Use lowercase ASCII snake_case.
- Start with the approved project namespace prefix.
- Use a short, stable system label; do not encode temporary implementation details or version numbers.
- Assign one namespace to one coherent event series or system boundary.
- Do not reuse a namespace for unrelated systems.
- Do not use generic or vanilla-like namespace names that could collide with another mod.
- Keep the namespace declaration and every event ID spelling identical.
- Verify the exact CK3 namespace declaration syntax before writing it.
- Record approved namespaces and allocated event ranges in this document or a dedicated registry.

Initial namespace registry:

| Purpose | Namespace | Event range | Status |
| --- | --- | --- | --- |
| Unassigned system | `breedimp_<system>` | `<RANGE>` | Prefix confirmed; system and range unassigned |

## Event ID Naming Rules

Use this project pattern after confirming the target CK3 event-ID format:

```text
breedimp_<system>.<NNNN>
```

Apply these rules:

- Use the approved namespace exactly.
- Use zero-padded numeric IDs of a consistent width, defaulting to four digits unless project evidence establishes another width.
- Allocate non-overlapping numeric blocks per event file or event series.
- Keep released event IDs stable; do not renumber them only to improve ordering.
- Reserve gaps between blocks for later additions.
- Keep event filenames descriptive and prefixed, using `breedimp_<system>_events.txt` only after its CK3 path and extension are verified.
- Verify every caller and referenced event ID after adding or moving an event.
- Never derive an event's gameplay behavior from its numeric range or filename.

## Decision Naming Rules

Use lowercase ASCII snake_case for project-owned decision IDs.

Default project pattern:

```text
breedimp_<action>_decision
```

Apply these rules:

- Begin every decision ID with the approved mod prefix.
- Use a concise action or purpose label supplied by the feature specification.
- End with `_decision` to make the content type clear within the project.
- Keep the ID stable after release.
- Do not include display text, balance values, dates, CK3 versions, or temporary implementation details in the ID.
- Use `breedimp_<system>_decisions.txt` as a filename pattern only after verifying the CK3 directory and file form.
- Derive related localisation keys from the stable decision ID, but verify every required suffix and field against same-version CK3 examples.
- Do not define decision fields, triggers, effects, costs, or AI behavior in this standards document.

## Localisation Naming Rules

Reserve the confirmed `breedimp_` prefix for every project-owned localisation key.

Apply these rules:

- Base keys on the stable script ID they describe.
- Use lowercase ASCII snake_case for keys unless a verified CK3 requirement says otherwise.
- Use semantic suffixes only when required or demonstrated by the same CK3 content family.
- Do not guess required suffixes such as names, descriptions, tooltips, or confirmation labels; verify them from target-version examples.
- Keep one canonical key for each meaning and reuse it intentionally.
- Keep player-facing text out of script IDs.
- Keep terminology and capitalization consistent across supported languages.
- Store each language in its verified CK3 localisation path and format.
- Preserve the required language header, version marker, quoting, escaping, encoding, and BOM.
- Use `breedimp_<system>_<language_marker>.<VERIFIED_LOCALISATION_EXTENSION>` only as a planning template until the target CK3 format is verified.
- Check for missing keys, duplicate keys, spelling drift, and orphaned keys before release.
- Do not invent dynamic localisation functions or scope expressions.

## Script Organization Rules

- Organize scripts by CK3 content family and coherent project system.
- Keep one primary responsibility per file.
- Prefix every project-owned filename and globally visible scripted definition, including scripted effects and scripted triggers, with `breedimp_`.
- Separate reusable conditions from state-changing operations, and keep triggers and effects in their valid contexts.
- Introduce scripted triggers or scripted effects only when reuse is justified and their CK3 syntax is verified.
- Keep scope transitions short and explicit; verify each link and expected scope type.
- Keep definitions close to their callers when CK3 loading rules permit, otherwise document the cross-file dependency.
- Use a consistent internal order for metadata, visibility or availability conditions, execution logic, AI logic, and references only after that order is verified for the file family.
- Add a brief file header comment only where the format supports comments. Include purpose, owned ID range, dependencies, and reference CK3 version.
- Comment design intent and non-obvious scope assumptions; do not comment obvious syntax line by line.
- Avoid monolithic files, circular call chains, duplicate definitions, and hidden cross-system dependencies.
- Keep experimental or unverified pseudocode outside runnable mod directories.
- Re-search IDs, namespaces, scripted definitions, localisation keys, and asset paths after every structural change.

## Version Control Rules

- Inspect the worktree before editing and preserve unrelated user changes.
- Use focused branches according to `<BRANCHING_POLICY>`.
- Make atomic commits that contain one coherent change.
- Use commit messages that state the affected system and intent.
- Review the complete diff before committing.
- Do not mix formatting-only changes with behavioral changes.
- Do not commit saves, logs, crash dumps, launcher caches, generated runtime data, editor temporary files, or machine-specific configuration.
- Do not commit secrets, credentials, usernames, or local absolute paths.
- Keep the developer-only `MyCK3Mod.mod` portable in version control. Put an absolute path only in the copied launcher file used on the local machine, and never include it in Workshop staging.
- Treat `dist/workshop/BreedImproved/` as generated, Git-ignored Workshop upload staging rather than a public download.
- Preserve Workshop item `3769010534` in the repository publishing configuration. Require the staged descriptor to contain exactly one matching `remote_file_id`, while keeping the production descriptor free of it.
- Do not publish or support manual-install ZIPs, installers, checksums, or GitHub Release assets for end-user installation.
- Do not copy large vanilla CK3 files into the repository without a documented technical need and applicable distribution rights.
- Preserve released namespaces, event IDs, decision IDs, and localisation keys whenever possible.
- Record CK3 compatibility in verified project metadata once the metadata format is established.
- Tag releases according to `<VERSIONING_SCHEME>` only after that scheme is approved.
- Update this document when a placeholder becomes an approved project convention.
- Never rewrite shared history, force-push, or delete branches without explicit authorization.

## Pre-Implementation Checklist

Complete these items before the first gameplay implementation:

- Apply the confirmed display name `Breed Improved` and internal prefix `breedimp` whenever related metadata or gameplay files are separately approved for implementation.
- Confirm whether `1.19.*` remains the release target when gameplay work begins.
- Define the DLC, language, compatibility, distribution, branching, and versioning policies.
- Locate or provide same-version vanilla CK3 references.
- Add verified examples to `ck3_vanilla_examples/`.
- Verify the actual CK3 root directories and file formats needed by the first feature.
- Verify target-version CK3 examples for character interactions, decisions, player-initiated candidate presentation or selection, and confirmation flows before implementing either Phase 1 interface.
- Allocate the first namespace and event ID range only if events are required.
- Verify decision and localisation field conventions only if those content families are required.
- Establish validation tooling and an in-game test procedure.
- Select one confirmed phase and create a separate, reviewed feature specification before adding gameplay files.
- Resolve the open design terms needed by that feature without expanding the confirmed product scope.
- Design one shared Phase 1 eligibility specification for the individual and bulk interfaces before choosing a CK3 reuse mechanism.
- Verify all required CK3 identifiers and syntax; design-language labels are not implementation evidence.
