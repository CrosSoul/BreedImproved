# CK3 Vanilla Research Templates

## Research checklist

```markdown
Target version: CK3 <version>
Budget: <isolated 5m | bundled 10–15m | phase ≤20m>

- [ ] <unresolved syntax/static-behavior question>
- [ ] <related question batched with the same evidence source>

Product decisions excluded: <items>
Cached evidence expected: <paths or none>
```

## Evidence index entry

Use this header when an index must be created:

```markdown
| Mechanism | Exact syntax | Current scope | Target scope | Enclosing context | Vanilla path | CK3 version | Verification status | Evidence document |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
```

Append one compact row per reusable mechanism:

```markdown
| `<mechanism>` | `<exact syntax>` | `<scope>` | `<scope>` | `<context>` | `<path>` | `<version>` | `<status>` | `<document/path>` |
```

## Compact research report

````markdown
# <Research subject> — CK3 <version>

## Implementation-ready conclusion
<short conclusion first>

## Evidence

### <Mechanism>
- Classification: <one required classification>
- Syntax category: <category>
- Current/source scope: <scope>
- Target scope: <scope>
- Enclosing context: <context>
- Vanilla path: `<path>`
- CK3 version: `<version>`

```text
<minimal excerpt, normally ≤10 lines>
```

Restrictions/uncertainties: <only material limits>

## Implementation-ready recommendation
<what the evidence safely supports>

## Required runtime observations
- <observation or none>

## Evidence-index updates made
- <file and entry or none>

## Deliberately not researched
- <excluded product choice or non-blocking edge case>
````

## Time-budget stop report

```markdown
# Research budget stop — <subject>

## Verified
- <result with evidence pointer>

## Still unresolved
- <question and why static evidence is insufficient>

## Best resolved by runtime testing
- <smallest useful runtime observation>

## Evidence-index updates made
- <completed write-back or none>

## Deliberately not researched
- <optional edge cases deferred>
```
