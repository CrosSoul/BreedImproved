# Breed Improved

Breed Improved is a Crusader Kings III dynasty management utility mod. The project is currently in the design and foundation phase; no gameplay systems have been implemented.

## Naming Convention

- Display name: `Breed Improved`
- Internal prefix: `breedimp`
- Event namespaces: `breedimp_<system>`
- Scripted effects, scripted triggers, localisation keys, and other project-owned internal identifiers must begin with `breedimp_`.

Angle-bracket components such as `<system>` are planning placeholders, not literal identifiers. Exact CK3 declaration and file syntax must be verified before gameplay implementation.

## Core Concept

Breed Improved provides player-controlled tools for managing dynasty membership and planning marriages within large dynasties. It does not modify Crusader Kings III's vanilla genetics or inheritance mechanics.

## Product Boundaries

- Dynasty-management actions must remain under player control.
- Do not perform automatic or scheduled candidate scanning, including yearly cleanup scans.
- Do not remove dynasty members automatically.
- Do not use background events to modify dynasty membership.
- Every cleanup operation must begin with explicit player interaction, and every removal must require player confirmation.
- A candidate scan is permitted only when the player explicitly opens or activates the relevant management interface.
- Long-term breeding assistance must support player decisions rather than operate as a fully autonomous system.
- CK3 script structures and identifiers must be verified from project references or vanilla CK3 examples before implementation.
- Implementation details remain flexible until each feature receives a separate, reviewed specification.

## Development Roadmap

### Phase 1: Dynasty Membership Management

Provide player-initiated tools for removing unwanted dynasty members. The initial design criteria are characters with the bastard trait and characters whose biological parents are not members of the intended dynasty. The precise meaning of "intended dynasty," eligibility rules, and CK3 implementation mechanism remain to be defined and verified.

#### Character Interaction

Handle an individual case by allowing the player to initiate removal for a specific dynasty member from that character's interaction menu. This interface is intended for removing one unwanted member and must show a confirmation step before applying any change.

#### Dynasty Decision

Handle large dynasties through an explicitly player-initiated management flow. When activated by the player, it may scan for eligible candidates, present the results, allow selection of multiple characters, and require confirmation before applying removals. It must never run as an automatic, scheduled, or background process.

Both interfaces should use the same eligibility and validation rules where possible so that individual and bulk management produce consistent results. This is a design requirement only; the CK3 structures used to implement either interface and any reusable validation definition must be verified before development.

### Phase 2: Dynasty Marriage Assistance

Reduce repetitive manual marriage management in large dynasties. Assistance may consider age compatibility, traits, genetic risks, and avoidance of excessively close blood relationships. Exact evaluation rules and relationship thresholds remain open design questions.

### Phase 3: Advanced Breeding Assistant

Support long-term, player-guided planning. This phase is intended as decision assistance and must not become a fully autonomous breeding system.

## Current Status

The repository contains the mod foundation, development standards, and reference material only. It does not yet contain events, decisions, interactions, or gameplay scripts for the features described above.
