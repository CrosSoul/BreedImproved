# Project Rules

## Contents

- [Project Status and Goals](#project-status-and-goals)
- [Evidence and Approval](#evidence-and-approval)
- [Folder Structure Conventions](#folder-structure-conventions)
- [Namespace Naming Rules](#namespace-naming-rules)
- [Event ID Naming Rules](#event-id-naming-rules)
- [Decision Naming Rules](#decision-naming-rules)
- [Localisation Naming Rules](#localisation-naming-rules)
- [Script Organization Rules](#script-organization-rules)
- [Version Control Rules](#version-control-rules)
- [Pre-Implementation Checklist](#pre-implementation-checklist)

## Project Status and Goals

Treat this repository as a new CK3 mod project with no gameplay implementation yet. Define development standards only; do not infer or create gameplay features from this document.

Use angle-bracket values as unresolved placeholders. Do not copy them literally into runnable mod files.

| Project setting | Value |
| --- | --- |
| Mod name | `<MOD_NAME>` |
| Short mod identifier | `<MOD_PREFIX>` |
| Namespace prefix | `<MOD_NAMESPACE_PREFIX>` |
| Target CK3 version | `<CK3_VERSION>` |
| Supported DLC policy | `<DLC_POLICY>` |
| Supported languages | `<SUPPORTED_LANGUAGES>` |
| Mod scope | `<MOD_SCOPE>` |
| Compatibility policy | `<COMPATIBILITY_POLICY>` |
| Distribution target | `<DISTRIBUTION_TARGET>` |
| Release versioning scheme | `<VERSIONING_SCHEME>` |

Adopt these development goals:

- Favor correctness, maintainability, and traceability over rapid feature volume.
- Minimize conflicts with vanilla CK3 and other mods.
- Keep systems modular so individual content families can be reviewed and tested independently.
- Keep all CK3 syntax tied to project evidence or target-version CK3 references.
- Keep IDs, namespaces, localisation keys, and filenames globally unique.
- Preserve backward compatibility for released IDs whenever practical.
- Document compatibility assumptions and actual validation results.
- Leave gameplay design goals as `<GAMEPLAY_GOALS>` until the user defines them.

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

## Folder Structure Conventions

Mirror verified vanilla CK3 paths exactly. Treat directories and file placement as part of the game API.

Use this abstract pattern only as an organization template, not as a literal CK3 directory tree:

```text
<MOD_ROOT>/
  <VERIFIED_CK3_DIRECTORY>/
    <MOD_PREFIX>_<SYSTEM>_<PURPOSE>.<VERIFIED_EXTENSION>
```

Follow these rules:

- Create only directories confirmed by same-version vanilla CK3 or an approved project reference.
- Use lowercase ASCII filenames with underscores unless a verified CK3 format requires otherwise.
- Prefix project-owned script filenames with `<MOD_PREFIX>_`.
- Group files by CK3 content family first, then by coherent project system.
- Keep events, decisions, reusable script definitions, localisation, GUI, history, map data, and assets in their verified CK3 locations; never create a convenient custom path that CK3 will not load.
- Keep one coherent system or responsibility per file when practical.
- Avoid copying entire vanilla files when a smaller compatible override or additive file is verified.
- Do not add `replace_path` without explicit approval and a documented analysis of everything it masks.
- Preserve the encoding, BOM, line endings, and extension required by the target file family.
- Add new root-level tooling or documentation directories only when they cannot be confused with CK3-loaded mod content.

## Namespace Naming Rules

Use `<MOD_NAMESPACE_PREFIX>` as the reserved root for all project-owned namespaces.

Default project pattern:

```text
<MOD_NAMESPACE_PREFIX>_<SYSTEM>
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
| Unassigned system | `<MOD_NAMESPACE_PREFIX>_<SYSTEM>` | `<RANGE>` | Placeholder |

## Event ID Naming Rules

Use this project pattern after confirming the target CK3 event-ID format:

```text
<MOD_NAMESPACE_PREFIX>_<SYSTEM>.<NNNN>
```

Apply these rules:

- Use the approved namespace exactly.
- Use zero-padded numeric IDs of a consistent width, defaulting to four digits unless project evidence establishes another width.
- Allocate non-overlapping numeric blocks per event file or event series.
- Keep released event IDs stable; do not renumber them only to improve ordering.
- Reserve gaps between blocks for later additions.
- Keep event filenames descriptive and prefixed, using `<MOD_PREFIX>_<SYSTEM>_events.txt` only after its CK3 path and extension are verified.
- Verify every caller and referenced event ID after adding or moving an event.
- Never derive an event's gameplay behavior from its numeric range or filename.

## Decision Naming Rules

Use lowercase ASCII snake_case for project-owned decision IDs.

Default project pattern:

```text
<MOD_PREFIX>_<ACTION>_decision
```

Apply these rules:

- Begin every decision ID with the approved mod prefix.
- Use a concise action or purpose label supplied by the feature specification.
- End with `_decision` to make the content type clear within the project.
- Keep the ID stable after release.
- Do not include display text, balance values, dates, CK3 versions, or temporary implementation details in the ID.
- Use `<MOD_PREFIX>_<SYSTEM>_decisions.txt` as a filename pattern only after verifying the CK3 directory and file form.
- Derive related localisation keys from the stable decision ID, but verify every required suffix and field against same-version CK3 examples.
- Do not define decision fields, triggers, effects, costs, or AI behavior in this standards document.

## Localisation Naming Rules

Reserve the approved `<MOD_PREFIX>_` prefix for every project-owned localisation key.

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
- Use `<MOD_PREFIX>_<SYSTEM>_<LANGUAGE_MARKER>.<VERIFIED_LOCALISATION_EXTENSION>` only as a planning template until the target CK3 format is verified.
- Check for missing keys, duplicate keys, spelling drift, and orphaned keys before release.
- Do not invent dynamic localisation functions or scope expressions.

## Script Organization Rules

- Organize scripts by CK3 content family and coherent project system.
- Keep one primary responsibility per file.
- Prefix every project-owned filename and globally visible scripted definition with `<MOD_PREFIX>_`.
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
- Do not copy large vanilla CK3 files into the repository without a documented technical need and applicable distribution rights.
- Preserve released namespaces, event IDs, decision IDs, and localisation keys whenever possible.
- Record CK3 compatibility in verified project metadata once the metadata format is established.
- Tag releases according to `<VERSIONING_SCHEME>` only after that scheme is approved.
- Update this document when a placeholder becomes an approved project convention.
- Never rewrite shared history, force-push, or delete branches without explicit authorization.

## Pre-Implementation Checklist

Complete these items before the first gameplay implementation:

- Replace `<MOD_NAME>`, `<MOD_PREFIX>`, and `<MOD_NAMESPACE_PREFIX>` with approved values.
- Record the target CK3 version.
- Define the DLC, language, compatibility, distribution, branching, and versioning policies.
- Locate or provide same-version vanilla CK3 references.
- Add verified examples to `ck3_vanilla_examples/`.
- Verify the actual CK3 root directories and file formats needed by the first feature.
- Allocate the first namespace and event ID range only if events are required.
- Verify decision and localisation field conventions only if those content families are required.
- Establish validation tooling and an in-game test procedure.
- Keep `<GAMEPLAY_GOALS>` unresolved until the user supplies gameplay requirements.
