---
name: ck3-vanilla-research
description: Focused, cache-first research of Crusader Kings III vanilla script. Use when Lynn or Codex is asked to verify CK3 syntax, locate a vanilla example, or establish implementation evidence for an effect, trigger, scope, cost, Character Interaction field, localisation form, UI pattern, or static engine behavior. Do not use for ordinary Matt implementation work, mod-file editing, feature design, balance decisions, or runtime-test execution unless the request explicitly requires fresh vanilla evidence research.
---

# CK3 Vanilla Research

Perform narrowly scoped, version-specific vanilla-script research for implementation handoff. Minimize repeated searches, traversal, token use, and report length. Treat repository evidence as the technical cache; never encode feature-specific conclusions in this skill.

Read [templates](references/templates.md) when starting a research task or writing evidence back.

## 1. Establish the research boundary

Before any search:

1. State the exact target CK3 version.
2. List only the unresolved syntax or static-behavior questions.
3. Merge questions answerable from the same schema, directory, or vanilla definition.
4. Separate product choices from research questions.
5. Exclude product balance unless explicitly requested.
6. Publish a compact research checklist using the template.

Do not silently broaden scope. Mark optional edge cases as deliberately unresearched when they do not block the requested implementation decision.

## 2. Retrieve cache first

Resolve the active project root without searching the CK3 installation. Check evidence in this order:

1. `.agents/skills/ck3-mod-development/references/ck3_evidence_index.md`
2. `.agents/skills/ck3-mod-development/references/ck3_syntax_reference.md`
3. `.agents/skills/ck3-mod-development/references/ck3_vanilla_examples/`
4. `docs/research/`
5. Only then, the configured CK3 vanilla installation for the target version

If a path differs, locate only these exact evidence names inside the project with a targeted file search. Do not use broad filesystem traversal.

Reuse cached evidence without re-searching vanilla when it covers the same:

- CK3 version;
- current/source scope;
- target scope;
- enclosing context; and
- mechanism or field structure.

Re-search vanilla only when at least one condition applies:

- the target CK3 version changed;
- cached scope or enclosing context is insufficient;
- runtime results conflict with the cache;
- the cited vanilla file no longer exists; or
- the user explicitly requests independent verification.

State the reason before re-verifying cached material.

## 3. Search unresolved vanilla evidence narrowly

For each unresolved item, use this order:

1. relevant schema or `.info` file;
2. exact field, trigger, or effect name;
3. one closest vanilla usage in the required scope and enclosing context;
4. at most one supplemental example, only if the first leaves a material ambiguity.

Prefer exact-name searches and small contextual excerpts. Never read entire scripting directories or collect examples merely to show prevalence. Avoid assets unless the user explicitly needs an asset-backed UI fact and the task permits it.

## 4. Apply the evidence threshold

Classify every question as exactly one of:

- **VERIFIED AND IMPLEMENTATION-READY** — exact syntax exists for the required version, scope, and context.
- **VERIFIED BUT CONTEXT-DEPENDENT** — the construct exists, but the proposed combination or target context needs runtime confirmation.
- **NOT VERIFIED — RUNTIME PROTOTYPE REQUIRED** — static files cannot establish the requested behavior efficiently.

Use static evidence only for:

- exact names and fields;
- argument structure;
- current and target scopes;
- enclosing context;
- definition directory and localisation form; and
- existence of a mechanism.

Prefer a runtime prototype over further static searching for:

- combined modifier presentation;
- unusual character classes;
- save/reload persistence;
- exact UI appearance;
- timing behavior;
- side effects;
- balance behavior; and
- interactions among multiple otherwise verified effects.

Do not claim runtime behavior from static evidence.

## 5. Enforce search and report budgets

Use these default elapsed-time targets:

- isolated syntax question: approximately 5 minutes;
- bundled feature investigation: approximately 10–15 minutes;
- phase-level investigation: no more than approximately 20 minutes without separate approval.

Keep reports to 150 lines by default and no more than 200 lines when a bundled request genuinely requires it. Keep each vanilla excerpt at 10 lines or fewer unless the enclosing structure cannot otherwise be understood.

When the budget is reached, stop searching and use the time-budget stop template. Report only what is verified, what remains unresolved, and what is best answered by runtime testing.

## 6. Write the compact report

Put the implementation-ready conclusion first. For each unresolved mechanism include only:

- classification;
- syntax category;
- current/source scope;
- target scope;
- enclosing context;
- exact CK3 version;
- exact vanilla path;
- one minimal excerpt; and
- restrictions or uncertainties.

End every report with:

1. implementation-ready recommendation;
2. required runtime observations;
3. evidence-index updates made; and
4. items deliberately not researched.

Use the compact report template. Do not reproduce whole entries or files.

## 7. Write evidence back once

After a successful investigation:

1. Update `ck3_evidence_index.md` using the required row format from the templates.
2. If the index is absent and project rules do not specify another location, create it beside `ck3_syntax_reference.md` with the template header.
3. Update `ck3_syntax_reference.md` only when genuinely new, reusable syntax has been established.
4. Create one note under `ck3_vanilla_examples/` only when the evidence cannot be represented compactly in the index.
5. Link an existing research report rather than creating overlapping reports for the same mechanism and CK3 version.

Repository evidence files remain the source of technical facts. This skill supplies workflow and templates only.

## 8. Guardrails

- Never modify CK3 vanilla files.
- Never modify production or test gameplay files during research.
- Never invent fields, triggers, traits, scopes, effects, costs, identifiers, or localisation forms.
- Never use screenshots as proof of scripting fields.
- Never use save-game numeric IDs as script identifiers.
- Never re-investigate verified material without stating why.
- Preserve the distinctions among House, Dynasty, House Head, and Dynast.
- Label product inference separately from vanilla evidence.
- Do not implement the researched feature; hand evidence to the responsible developer.

Stop after the requested evidence and write-back are complete.
