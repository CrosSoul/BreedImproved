---
name: ck3-mod-development
description: Develop, review, and debug Crusader Kings III (CK3) mods with strict project-first evidence and CK3-only syntax. Use for Paradox Script, events, decisions, interactions, traits, modifiers, localisation, history, on_actions, scripted triggers/effects, GUI, descriptors, and related CK3 mod files. Prioritize correctness over creativity, reject syntax from other Paradox games, and stop for verification whenever a CK3 construct is uncertain.
type: prompt
whenToUse: When implementing, reviewing, debugging, or validating CK3 Mod code
disableModelInvocation: false
---

# CK3 Mod Development

## Purpose

Develop and maintain this Crusader Kings III mod without inventing game APIs or relying on syntax from other Paradox titles. Treat the repository as the primary source of truth for structure, naming, formatting, and established implementation patterns.

Produce changes that are conservative, traceable, and compatible with the target CK3 version. Prefer a smaller verified implementation over a complete-looking implementation that contains assumptions.

## Core Rules

1. **Prioritize correctness over creativity.** Never fill a knowledge gap with plausible-looking CK3 script.
2. **Inspect the project first.** Search and read relevant repository files before proposing or writing code.
3. **Use CK3-only evidence.** Never treat Stellaris, Europa Universalis IV, Victoria 3, Hearts of Iron IV, or another Paradox game as evidence that syntax is valid in CK3.
4. **Verify every non-trivial construct.** Confirm the exact name, role, supported arguments, file context, and scope requirements of triggers, effects, modifiers, script commands, iterators, event fields, GUI keys, and other game-defined elements.
5. **Preserve context.** Treat the directory, file type, enclosing block, root scope, and scope transitions as part of a construct's meaning.
6. **Keep triggers and effects separate.** Use triggers only in valid condition contexts and effects only in valid execution contexts.
7. **Preserve project conventions.** Retain existing paths, extensions, encoding, BOM, line endings, indentation, prefixes, namespaces, ID schemes, and localisation style unless the task explicitly requires a change.
8. **Make minimal changes.** Modify only the files and lines required by the request. Do not reformat, rename, or refactor unrelated content.
9. **Protect existing work.** Inspect the worktree before editing and never overwrite, revert, or clean up user changes outside the requested scope.
10. **Report uncertainty explicitly.** If evidence is insufficient, write `UNVERIFIED CK3 SYNTAX: <specific uncertainty>` in the response, state what reference is needed, and do not place the uncertain construct in a runnable mod file.

Use this evidence order:

1. Existing files in this repository with the same file family and usage context.
2. References supplied by the user for the target CK3 version.
3. Vanilla CK3 files from the same game version.
4. Version-matched official CK3 documentation.
5. Community material only when its CK3 version and claims can be corroborated by a higher-priority source.

If the repository contains no relevant example, say so. Continue only with version-compatible CK3 references; never substitute model memory or cross-game similarity for evidence.

Load [project rules](references/project_rules.md) before implementing repository changes. Load the [CK3 syntax reference](references/ck3_syntax_reference.md) when validating a game-defined construct or recording verified syntax. Search [vanilla CK3 examples](references/ck3_vanilla_examples/) only for examples whose CK3 version and source are recorded.

## Development Workflow

1. **Define the task.** Identify the requested behavior, affected content type, target CK3 version when available, and acceptable change scope.
2. **Inspect the repository.** Use `rg --files` to map relevant directories and `rg` to find similar IDs, namespaces, definitions, calls, localisation keys, triggers, effects, modifiers, and scope patterns. Read full surrounding blocks, not isolated search matches.
3. **Find the closest project pattern.** Prefer an existing implementation from the same directory and file family. Record the files that justify the proposed syntax and structure.
4. **Verify missing elements.** Check provided references or same-version vanilla CK3 files for anything not demonstrated by the project. Confirm that each element is used in the same role and scope context.
5. **Plan important-system changes before editing.** Explain the intended behavior, affected files, reference pattern, scope flow, compatibility risk, and validation approach before changing on_actions, core interactions, event chains, scripted triggers/effects used widely, GUI, history, map data, descriptors, or `replace_path`. Ask for direction if the impact or boundary is ambiguous.
6. **Implement the smallest valid change.** Copy the nearest verified pattern and alter only what the requirement needs. Keep definitions, callers, IDs, namespaces, assets, and localisation references consistent.
7. **Validate the result.** Perform static checks, run repository-provided validators when available, and test in CK3 when the environment permits. Never claim game validation that was not performed.
8. **Report clearly.** List changed files, project or vanilla references used, checks performed, game-test status, and every unresolved uncertainty.

## Code Generation Rules

- Generate only constructs verified as valid CK3 syntax for the target version and file context.
- Verify a construct independently even when its name resembles a known CK3 or Paradox command. Never infer APIs from patterns such as `has_*`, `add_*`, `remove_*`, or `set_*`.
- Confirm the current scope and every scope transition. Do not copy a working block into a context with a different root or iterator scope without new evidence.
- Confirm whether every game-defined element is a trigger, effect, value, modifier, scope, event target, data field, or control structure before using it.
- Verify control-flow forms such as conditions, limits, iterators, and triggered blocks in the same CK3 file family before reuse.
- Preserve balanced braces, quotes, block nesting, and the established `key = value` layout.
- Use the repository's prefix and namespace conventions for new global IDs, events, scripted definitions, and localisation keys. If no convention exists, propose one before spreading it across files.
- Keep references closed: ensure every new caller, definition, event ID, namespace, localisation key, icon, and asset path resolves to an intended target.
- Treat localisation as a distinct format. Preserve the neighbouring files' language header, key format, quoting, escaping, encoding, and BOM. Verify dynamic localisation and scope expressions against CK3 examples.
- Treat directory placement and file structure as game API. Do not create a directory, file family, descriptor field, history field, GUI field, or asset definition without project or same-version vanilla CK3 evidence.
- Do not add `replace_path` unless explicitly required and its full masking effect has been explained and verified.
- Keep uncertain material outside runnable files. If the user requests a sketch, label it `PSEUDOCODE - NOT VALIDATED FOR CK3` and separate it from production code.
- Re-search new IDs and references after editing to detect duplicates, spelling drift, and unresolved links.

## Debugging Rules

Debug from the earliest relevant error and change one assumption at a time.

1. **Fix the environment.** Record the CK3 version, mod version, enabled DLC, load order, language, and exact reproduction steps.
2. **Preserve the failing state.** Inspect existing changes and retain a reproducible baseline before attempting a fix.
3. **Check syntax structure.** Verify balanced braces and quotes, valid nesting, encoding/BOM, and the expected file extension.
4. **Check namespace consistency.** Confirm namespace declarations, event IDs, calls, scripted definition names, prefixes, and references use exactly the same spelling and expected ownership.
5. **Check localisation keys.** Confirm every referenced key exists in the correct localisation file, follows the project format, and is not unintentionally duplicated.
6. **Check paths and naming conventions.** Confirm file placement, filenames, resource paths, case, extensions, and IDs match repository patterns and same-version vanilla CK3 expectations.
7. **Check CK3 validity.** Verify every trigger, effect, modifier, script command, field, control structure, and scope transition against project evidence or version-compatible CK3 references. Do not repair an error with syntax copied from another game.
8. **Check context and scope.** Confirm triggers are in condition contexts, effects are in execution contexts, and each command receives the scope type it expects.
9. **Read current logs.** Reproduce in a suitable CK3 debug environment and start with the first relevant parser or runtime error. Treat later messages as possible cascading failures.
10. **Isolate minimally.** Narrow the failure to one file or block through reversible, scoped changes. Do not delete user content to test a theory.
11. **Retest and report.** Reproduce the full scenario after the fix, check for new errors or regressions, and distinguish static validation from actual in-game testing.

Do not assert a log path, launch option, or validation tool unless it has been confirmed in the current environment or an applicable CK3 reference.

## Forbidden Behaviors

- Never invent CK3 triggers, effects, scopes, scope links, modifiers, values, script commands, event types, on_actions, GUI keys, localisation functions, fields, or file structures.
- Never copy or adapt syntax from Stellaris, EU4, Victoria 3, HOI4, or another Paradox game without independent proof that the exact construct exists in CK3.
- Never treat shared Clausewitz/Jomini appearance, including `key = value`, as proof of compatibility.
- Never guess an API from its English meaning or naming pattern.
- Never write unverified syntax into a runnable mod file or present pseudocode as valid CK3 script.
- Never hide uncertainty. State the exact unknown and request a project, vanilla CK3, or version-matched official reference.
- Never use a trigger as an effect, an effect as a trigger, or a scope-dependent command without verifying its context.
- Never invent project conventions, game versions, test results, log output, vanilla behavior, or claims that a construct exists.
- Never create broad overrides, add `replace_path`, restructure directories, or modify important systems without explaining the plan and impact first.
- Never modify unrelated mod files, perform drive-by formatting, or broaden the task without authorization.
- Never overwrite, revert, delete, or clean user changes unless the user explicitly requests that exact action.
- Never claim completion while unresolved syntax uncertainty remains hidden or while required references are missing.
