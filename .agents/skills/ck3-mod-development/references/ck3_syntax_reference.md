# CK3 Syntax Reference

## Purpose

Use this file as a verification registry for Crusader Kings III syntax. Do not treat it as a complete API catalog. Add an entry only after verifying the exact construct against this repository, a user-provided target-version reference, same-version vanilla CK3 files, or version-matched official CK3 documentation.

Never add syntax based only on model memory, naming similarity, community claims without corroboration, or examples from another Paradox game.

## Admission Requirements

Record all of the following before marking a construct as verified:

- Exact token or field name.
- Category: trigger, effect, modifier, value, scope link, control structure, event field, localisation function, GUI field, file structure, or other CK3-defined element.
- Valid file family and enclosing block.
- Required input scope and any resulting scope or state change.
- Supported arguments and value types.
- CK3 version used for verification.
- Evidence path or document reference.
- A minimal source excerpt or a precise pointer to the verified example.
- Known restrictions, DLC dependencies, or version differences.

A matching name alone is not sufficient. The role, context, scope, and argument form must also match.

## Verification Status

Use only these statuses:

- `VERIFIED`: Confirmed for the target CK3 version and usage context.
- `VERSION-SPECIFIC`: Confirmed only for the recorded CK3 version.
- `DEPRECATED`: Confirmed obsolete or replaced in the recorded version.
- `UNVERIFIED`: Recorded as a research lead only; never use in runnable mod code.

## Entry Template

Copy this template for each verified construct:

```markdown
### <exact construct name>

- Status:
- Category:
- CK3 version:
- File family:
- Enclosing context:
- Input scope:
- Output scope or state change:
- Arguments:
- Evidence:
- Minimal verified example:
- Restrictions and notes:
```

## File Structure Verification

For directories, filenames, descriptors, history, map data, GUI, assets, and localisation, record:

- Exact relative path.
- How CK3 loads or merges the file.
- Naming and extension requirements.
- Encoding, BOM, and localisation requirements where applicable.
- Override or replacement behavior.
- Same-version vanilla or project evidence.

Treat `replace_path` as a high-risk override. Record its full masking effect before approving its use.

## Current Registry

No CK3 syntax entries are verified in this file yet. Inspect the project and add entries only when evidence becomes available.

## Uncertainty Protocol

When a required element is absent from the verified registry and cannot be confirmed from a higher-priority source:

1. Stop before writing the element into a runnable file.
2. Report `UNVERIFIED CK3 SYNTAX: <specific uncertainty>`.
3. State the missing version, scope, file-context, or source evidence.
4. Request a project example, same-version vanilla CK3 file, or version-matched official reference.
5. Keep any sketch separate and label it `PSEUDOCODE - NOT VALIDATED FOR CK3`.
