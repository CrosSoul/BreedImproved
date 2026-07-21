# Breed Improved — Exile Consequences Vanilla Evidence

**Researcher:** Lynn, CK3ModResearcher  
**Target:** Crusader Kings III `1.19.0.6`  
**Purpose:** Syntax and engine-behavior evidence for the Phase 1 `Exile from Dynasty` v0.1.0 RC2 prototype  
**Scope:** Vanilla script files only. No production or test gameplay files were changed.

## Classification

- **VERIFIED AND IMPLEMENTATION-READY** — exact vanilla syntax exists in a matching scope/context.
- **VERIFIED BUT CONTEXT-DEPENDENT** — the construct exists, but the proposed combination or target class still needs an in-game check.
- **NOT VERIFIED** — the inspected vanilla files do not establish the behavior.

All numerical values proposed by Breed Improved are product values, not claimed vanilla balance.

## 1. Decaying opinion modifier

### Definition and decay semantics

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** opinion-modifier definition  
**Source/target scope:** not applicable at definition time  
**Enclosing context:** top-level entry in `common/opinion_modifiers/`  
**Vanilla path:** `common/opinion_modifiers/_opinions.info`  
**CK3 version:** `1.19.0.6`

Minimal schema excerpt:

```text
decaying = no
# Makes opinion value decay over the duration of the modifier to 0
# Must define either monthly_change or duration

monthly_change = 0.0
# How much does the modifier value change each month?
# Must be a positive number
# Mutually exclusive with duration (days/months/years)
```

Verified meaning:

- `opinion` is the initial opinion value; vanilla definitions use negative integers such as `-60`.
- `decaying = yes` moves the value toward `0`.
- `monthly_change` is the exact monthly-decay field and must be positive.
- A decaying modifier must use either `monthly_change` or `days`/`months`/`years`.
- `monthly_change` and an explicit duration are mutually exclusive. Do not combine `monthly_change = 0.5` with `years = 10`.

Vanilla proves both lifetime models independently:

**Path:** `common/opinion_modifiers/04_dlc_ep2_opinions.txt:762`

```text
berated_child_opinion = {
	opinion = -40
	monthly_change = 0.5
	decaying = yes
}
```

**Path:** `common/opinion_modifiers/00_lifestyle_intrigue_opinions.txt:47`

```text
intrigue_defied_loved_one_opinion = {
	opinion = -60
	decaying = yes
	years = 10
}
```

The proposed `-60` with `monthly_change = 0.5` is not an exact vanilla balance entry, but its fields and semantics are verified. It has a nominal 120-month path to zero: `60 / 0.5 = 120`, or approximately ten years. Whether the zero-value entry disappears from the UI on the exact final monthly tick is **NOT VERIFIED** from static script.

### Recipient opinion of the actor

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** character effect, `add_opinion`  
**Source scope:** selected interaction recipient  
**Target scope:** interaction actor  
**Enclosing context:** `effect` flow of a Character Interaction  
**Vanilla path:** `common/character_interactions/00_artifact_interactions.txt:1413`  
**CK3 version:** `1.19.0.6`

```text
scope:recipient = {
	add_opinion = {
		target = scope:actor
		modifier = insult_opinion
		opinion = -10
	}
}
```

Inside `scope:recipient`, `add_opinion` with `target = scope:actor` gives the recipient an opinion modifier toward the actor. For the Breed Improved custom modifier, the definition can supply the opinion value, so an application-time `opinion` override is not required.

Vanilla also applies a modifier whose definition supplies `monthly_change` without restating the opinion value:

**Path:** `events/dlc/ep2/wedding_events/ep2_wedding_events.txt:4530`

```text
add_opinion = {
	target = root
	modifier = berated_child_opinion
}
```

### Opinion-breakdown localisation

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** English localisation  
**Source/target scope:** not applicable  
**Enclosing context:** `l_english` localisation file  
**Vanilla path:** `localization/english/dlc/ep2/wedding/ep2_wedding_modifiers_l_english.yml:18`  
**CK3 version:** `1.19.0.6`

```text
berated_child_opinion:0 "Berated My Child"
```

The opinion modifier identifier itself is localised for the opinion breakdown. The inspected opinion example does not require a separate `_desc` key.

### Product-value form supported by the evidence

This is the verified field structure using Breed Improved's requested values; the identifier remains project-owned:

```text
<breed_improved_opinion_modifier> = {
	opinion = -60
	monthly_change = 0.5
	decaying = yes
}
```

Do not add `years = 10` to this definition.

## 2. Temporary visible character modifier

### Definition location and exact modifier keys

**Classification:** VERIFIED AND IMPLEMENTATION-READY for each key; VERIFIED BUT CONTEXT-DEPENDENT for the exact three-key combination  
**Syntax category:** character-modifier definition  
**Source/target scope:** not applicable at definition time  
**Enclosing context:** top-level entry in `common/modifiers/`  
**Vanilla path:** `common/modifiers/_modifiers.info`  
**CK3 version:** `1.19.0.6`

The schema identifies entries in this directory as character modifiers and gives this form:

```text
modifer_key = {
	icon = icon_name
	# Effects...
}
```

Each requested statistic key is present in vanilla with the requested numeric type:

| Requested consequence | Exact verified key/value | Vanilla path and enclosing modifier | Classification |
| --- | --- | --- | --- |
| Diplomacy reduction | `diplomacy = -1` | `common/modifiers/00_activity_tournament_modifiers.txt:206`, `tournament_discombobulated_modifier` | VERIFIED AND IMPLEMENTATION-READY |
| Stress gain +10% | `stress_gain_mult = 0.1` | `common/modifiers/00_ep2_travel_modifiers.txt:102`, `satiated_curiosity` | VERIFIED AND IMPLEMENTATION-READY |
| Monthly prestige reduction | `monthly_prestige = -0.25` | `common/modifiers/00_stress_effect_modifiers.txt:232`, `symbol_of_folly_modifier` | VERIFIED AND IMPLEMENTATION-READY |

Minimal excerpts:

```text
tournament_discombobulated_modifier = {
	icon = health_negative
	...
	diplomacy = -1
}
```

```text
satiated_curiosity = {
	icon = learning_mixed
	learning = 1
	stress_gain_mult = 0.1
}
```

```text
symbol_of_folly_modifier = {
	icon = county_modifier_opinion_negative
	...
	monthly_prestige = -0.25
}
```

Formatting evidence is in `common/modifier_definition_formats/00_definitions.txt`:

```text
monthly_prestige = {
	decimals = 2
	...
}

stress_gain_mult = {
	decimals = 0
	color = bad
	...
	percent = yes
}
```

Therefore `stress_gain_mult = 0.1` is presented as a percentage modifier, while `monthly_prestige = -0.25` is a flat monthly value. No inspected vanilla modifier combines exactly these three product values, so the combined definition requires an RC2 in-game display/stat check.

### Applying a ten-year character modifier

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** character effect, `add_character_modifier`  
**Source scope:** selected interaction recipient  
**Target scope:** the same recipient character  
**Enclosing context:** Character Interaction effect  
**Vanilla path:** `common/character_interactions/00_religious_interactions.txt:7046`  
**CK3 version:** `1.19.0.6`

```text
scope:recipient = {
	trigger_event = { id = religious_interaction.2400 }
	add_character_modifier = {
		modifier = literally_debated_modifier
		years = 10
	}
}
```

`days` is also supported. `events/dlc/bp2/bp2_yearly_5.txt:2103` applies `days = watchful_modifier_duration`, and `common/script_values/00_scheme_values.txt:43` defines that duration as `730`.

### Localisation, description, and icon

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** modifier presentation  
**Source/target scope:** not applicable  
**Enclosing context:** modifier definition, modifier-icon registry, and English localisation  
**Vanilla paths:**

- `localization/english/event_localization/religion_events/religious_interaction_events_l_english.yml:173`
- `common/modifier_icons/00_modifier_icons.txt:1`
- `common/modifiers/00_event_modifiers.txt:457`

**CK3 version:** `1.19.0.6`

```text
literally_debated_modifier:0 "Recently Debated"
literally_debated_modifier_desc:0 "This character has recently been engaged in a debate on the fundamentals of their faith."
```

The modifier key and `<modifier_key>_desc` provide the visible name and description.

Vanilla declares a default icon fallback:

```text
default = {
	positive = "gfx/interface/icons/modifiers/_default.dds"
	default = yes
}
```

Explicit reuse is better evidenced than relying on the fallback. `stress_negative` is a verified vanilla icon key used by `seeing_dead_people_modifier`:

```text
seeing_dead_people_modifier = {
	icon = stress_negative
	stress_gain_mult = 0.25
}
```

Reusing `icon = stress_negative` requires no new asset. No `gfx` asset was inspected or copied.

### Product-value form supported by the evidence

```text
<breed_improved_character_modifier> = {
	icon = stress_negative
	diplomacy = -1
	stress_gain_mult = 0.1
	monthly_prestige = -0.25
}
```

The field structure is verified. The exact combined result and UI presentation remain **VERIFIED BUT CONTEXT-DEPENDENT** until tested in game.

## 3. One-time stress

### Fixed stress effect and interaction recipient scope

**Classification:** VERIFIED AND IMPLEMENTATION-READY for character scope and a fixed value  
**Syntax category:** character effect, `add_stress`  
**Source scope:** the character receiving stress  
**Target scope:** same character; no separate target argument  
**Enclosing context:** event option / Character Interaction effect  
**Vanilla paths:**

- `events/scheme_events/intrigue_scheme_ongoing_events.txt:2953`
- `common/character_interactions/00_house_head_interactions.txt:720`

**CK3 version:** `1.19.0.6`

Fixed numeric example:

```text
scope:agent_in_question = {
	add_stress = 20
	add_opinion = {
		modifier = forced_to_scheme_against_friend_opinion
		target = scope:scheme.scheme_owner
	}
}
```

Matching Character Interaction recipient-scope example:

```text
scope:recipient = {
	add_stress = major_stress_gain
	...
	add_opinion = {
		modifier = accused_of_decadence_opinion
		target = scope:actor
	}
}
```

Together these verify `scope:recipient = { add_stress = 20 }` as the matching character-scoped form. A separate tooltip or notification is not syntactically required: vanilla uses bare `add_stress = 20` inside an option. The house-head interaction wraps its result in `send_interface_toast`, proving that a toast is optional presentation rather than part of `add_stress` syntax. Exact Character Interaction result presentation should still be observed in RC2.

### Minor behavior

**Classification:** VERIFIED BUT CONTEXT-DEPENDENT  
**Syntax category:** character effect on an explicitly non-adult character  
**Source scope:** saved child scope  
**Target scope:** same child  
**Enclosing context:** option in character event `bp2_yearly.5054`  
**Vanilla path:** `events/dlc/bp2/bp2_yearly_5.txt:2020-2105`  
**CK3 version:** `1.19.0.6`

The event selects a child with `is_adult = no`, then applies stress:

```text
random_child = {
	limit = {
		age > 4
		is_adult = no
		...
	}
	save_scope_as = child
}
...
scope:child = {
	...
	add_stress = minor_stress_gain
}
```

This verifies that `add_stress` can be applied to a minor and that the engine does not require an adulthood gate for the effect. The inspected minor example uses the named value `minor_stress_gain`, not the fixed literal `20`; fixed `20` on a minor is therefore an RC2 test point rather than an exact combined vanilla example.

Vanilla sometimes gates an event or interaction by adulthood because of that feature's eligibility, but the minor example prevents treating adulthood as a universal `add_stress` requirement. No quantitative claim about what vanilla “commonly” does is supported by this focused sample.

### Personality and relationship scaling

**Classification:** VERIFIED that vanilla scripts these separately; NOT VERIFIED that bare `add_stress` supplies either automatically  
**Syntax category:** contextual stress scripting  
**Source scope:** event option or affected character  
**Target scope:** current character  
**Enclosing context:** event effects  
**Vanilla paths:**

- `events/activities/tour_activity/claudia_tour_grounds_events.txt:233`
- `events/harm_events.txt:4381`

**CK3 version:** `1.19.0.6`

Personality-sensitive stress is explicitly authored with `stress_impact`:

```text
stress_impact = {
	generous = medium_stress_impact_gain
	compassionate = minor_stress_impact_gain
}
```

Relationship-sensitive stress is explicitly branched:

```text
if = {
	limit = { has_relation_soulmate = root }
	add_stress = 250
}
else = { add_stress = major_stress_gain }
```

There is no inspected evidence that `add_stress = 20` automatically changes for personality or relationship. Breed Improved should treat `20` as the requested base effect and not assume extra personality/relationship scaling. The runtime interaction between this one-time gain and an already-active `stress_gain_mult` modifier is **NOT VERIFIED** by the static files.

## 4. Persistent character flag

### Add, check, and remove

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** character flag effects and trigger  
**Source scope:** character receiving/owning the flag  
**Target scope:** same character  
**Enclosing context:** event option, later event trigger, and cleanup effect  
**Vanilla paths:**

- `events/dlc/bp2/bp2_yearly_events_6.txt:5411`
- `events/dlc/bp2/bp2_yearly_events_6.txt:13372`
- `common/story_cycles/bp2_story_cycle_foreign_raised_reformer.txt:59`

**CK3 version:** `1.19.0.6`

Untimed add:

```text
add_character_flag = rejecting_foreign_ritual_reforms
```

Later check in event `bp2_yearly.6182`:

```text
root = {
	has_character_flag = rejecting_foreign_ritual_reforms
}
```

Explicit cleanup:

```text
remove_character_flag = rejecting_foreign_ritual_reforms
```

This verifies an untimed character marker that remains available to later script until explicitly removed by the vanilla flow. A timed form is also verified in `events/activities/playdate_activity/playdate_events.txt:4430`:

```text
add_character_flag = {
	flag = playdate_sports
	years = 3
}
```

For the requested permanent marker, the untimed bare form is the closest exact vanilla evidence.

**Save/reload:** NOT VERIFIED. Static script proves reuse across later events, but does not prove serialization through a save/reload. RC2 must test this directly before the marker is called save-persistent.

### Can a flag identify the exiling character?

**Classification:** NOT VERIFIED  
The inspected `add_character_flag` forms store a flag identifier and, optionally, a duration. No verified character-valued payload field was found. A simple flag must not be assumed to remember `scope:actor`.

### Closest verified character-valued mechanism

**Classification:** VERIFIED BUT CONTEXT-DEPENDENT  
**Syntax category:** character-scoped variable containing a character scope  
**Source scope:** character owning the variable  
**Target/value scope:** another character  
**Enclosing context:** event effect and later event condition  
**Vanilla paths:**

- `events/board_game_events.txt:2314`
- `events/board_game_events.txt:1183`
- `events/birth_events.txt:863`
- `events/relations_events/adultery_events.txt:2696`

**CK3 version:** `1.19.0.6`

Timed character-valued variable:

```text
scope:bg_loser = {
	set_variable = {
		name = bg_recent_land_loss_to
		value = scope:bg_victor
		years = 10
	}
}
```

Later existence and value comparison:

```text
scope:bg_opponent = {
	exists = var:bg_recent_land_loss_to
	var:bg_recent_land_loss_to = scope:bg_myself
}
```

Vanilla also sets a character-valued variable without a duration and later removes it:

```text
scope:father = {
	set_variable = {
		name = suspect_this_child_of_illegitimacy
		value = scope:child
	}
}
```

```text
if = {
	limit = { exists = var:suspect_this_child_of_illegitimacy }
	remove_variable = suspect_this_child_of_illegitimacy
}
```

This is the closest verified mechanism if Breed Improved later needs to remember the exiling actor. It is not required for the requested boolean marker, and its save/reload behavior for this use remains **NOT VERIFIED**.

## 5. Recipient-only scope and `create_dynasty` ordering

### Safest verified scope structure

**Classification:** VERIFIED AND IMPLEMENTATION-READY for scope placement; VERIFIED BUT CONTEXT-DEPENDENT for the complete combined transaction  
**Syntax category:** Character Interaction recipient effect  
**Source scope:** `scope:recipient`  
**Target scopes:** recipient for stress/modifier/flag/Dynasty creation; `scope:actor` only as the opinion target  
**Enclosing context:** the existing Character Interaction's effect block  
**Vanilla evidence paths:**

- `common/character_interactions/00_artifact_interactions.txt:1413`
- `common/character_interactions/00_house_head_interactions.txt:720`
- `common/character_interactions/00_religious_interactions.txt:7046`
- `events/dlc/tgp/tgp_mandala_task_contract_events.txt:1350`

**CK3 version:** `1.19.0.6`

The verified structural sequence is:

```text
scope:recipient = {
	add_opinion = {
		target = scope:actor
		modifier = <breed_improved_opinion_modifier>
	}
	add_stress = 20
	add_character_modifier = {
		modifier = <breed_improved_character_modifier>
		years = 10
	}
	add_character_flag = <breed_improved_exile_flag>

	create_dynasty = {
		# Existing, separately verified Breed Improved arguments
	}
}
```

Angle-bracketed names are project-owned identifiers, not vanilla identifiers. No iterator such as `every_child` or `every_descendant` is present, so the opinion, stress, character modifier, and character flag are scoped only to the selected recipient. `spread_to_descendants = yes` belongs only to `create_dynasty`; it does not syntactically wrap or repeat preceding recipient effects.

### Does `create_dynasty` change the active scope?

**Classification:** VERIFIED AND IMPLEMENTATION-READY  
**Syntax category:** character effect with continued execution in its enclosing character scope  
**Source scope:** `scope:local_character`  
**Target scope:** same character for the subsequent `marry` effect  
**Enclosing context:** `hidden_effect_new_object` in a vanilla event  
**Vanilla path:** `events/dlc/tgp/tgp_mandala_task_contract_events.txt:1350`  
**CK3 version:** `1.19.0.6`

```text
scope:local_character = {
	if = {
		limit = { ... }
		create_dynasty = {
			spread_to_descendants = yes
		}
	}
	marry = scope:local_character_2
}
```

Vanilla executes a later character effect in the same enclosing character scope after `create_dynasty`, including when `spread_to_descendants = yes`. A second example, `events/dlc/tgp/tgp_japan_decision_events.txt:2044`, enters `house = { ... }` immediately after Dynasty creation from the same current character.

Therefore `create_dynasty` is not evidenced as an active-scope switch. Nevertheless, placing recipient-only consequences before it is the safest RC2 order because:

1. all consequences run while the interaction's original actor/recipient relationship and Dynasty context are unchanged;
2. none can be mistaken for descendant propagation;
3. `create_dynasty` remains the final, already-tested affiliation operation.

No inspected vanilla flow combines all five requested consequences in one transaction. CK3 script does not provide rollback evidence here; partial application after a later failure is **NOT VERIFIED** and must not be assumed transactional.

## 6. Minimal v0.1.0 RC2 recommendation

The evidence supports this minimal prototype boundary:

1. Define one custom opinion modifier in `common/opinion_modifiers/` using `opinion = -60`, `monthly_change = 0.5`, and `decaying = yes`. Do not add a duration. Localise the modifier key for the opinion breakdown.
2. Define one character modifier in `common/modifiers/` with `icon = stress_negative`, `diplomacy = -1`, `stress_gain_mult = 0.1`, and `monthly_prestige = -0.25`. Localise both its key and `<key>_desc`.
3. In the existing interaction effect, enter `scope:recipient` once. Apply, in order: the recipient-to-actor opinion modifier, `add_stress = 20`, the ten-year character modifier, and the untimed character flag.
4. Execute the existing `create_dynasty` block last. Keep its already-approved arguments unchanged.
5. Do not add a character-valued variable in RC2 unless Jay separately requires attribution to the exiling actor. The boolean flag does not store that actor.

Required RC2 observations before promotion:

- opinion begins at `-60`, recovers by `0.5` per monthly step, and reaches zero after approximately 120 monthly steps without an explicit duration;
- the combined character modifier shows the expected three statistics and expires after ten years;
- fixed `add_stress = 20` behaves as intended for an adult and, if minors remain eligible, for a minor;
- the untimed character flag is still present after save/reload;
- only the selected recipient receives the opinion, stress, modifier, and flag, while `create_dynasty` retains its separately approved descendant behavior;
- subsequent effects still execute and the interaction result presentation is understandable without an added toast.
