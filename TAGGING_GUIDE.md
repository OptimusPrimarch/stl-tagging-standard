# Tagging Guide

How to use the tag groups in `tag-library.json`. Read this once before you start triaging, and hand it to anyone importing the tag library so tags stay consistent across machines.

## Core principle: tags are optional, per file, per group

No file needs a value from every group. A generic terrain rock has no `Faction`, `Unit-Type`, or `GameSystem` — those groups simply don't apply to it, and that's correct, not incomplete. Apply whichever subset of groups genuinely describes the file and skip the rest. A typical file will touch 5-7 of the 13 groups, not all of them.

The one exception is `Status`, which exists specifically to distinguish "not applicable" from "not reviewed yet" — see below.

## The groups

**ObjectType** — Miniatures / Terrain / Tools-Accessories / Print-and-Play / Papercraft. Mirrors the top-level folder split (see `FOLDER_FRAMEWORK.md`); kept as a tag too so you can build tag-only saved searches that don't care about folder location. The last two were pulled in from a previous tagging attempt's real usage — Print-and-Play (board/card game components) and Papercraft (paper models, not 3D-printed) are genuinely distinct enough from Miniatures/Terrain to warrant their own bucket rather than living as a sub-case of either.

**GameSystem** — the ruleset(s) a file fits: `Warhammer-40k`, `Age-of-Sigmar`, `Age-of-Fantasy`, `Grimdark-Future`, `Kill-Team`, `Infinity`, `Trench-Crusade`, `Torch-and-Shield`, `Arsenal`, `FSD`, `1490-Doom`, `DnD-5e`, `Battletech`, `Warmachine-Hordes`, `Necromunda`, `Star-Wars-Legion`, `Malifaux`, `Bolt-Action`, `Pathfinder`, `Generic-System-Agnostic`. Multi-select when a file genuinely fits more than one. Use `Generic-System-Agnostic` for the large share of minis that aren't tied to any specific ruleset — don't leave GameSystem blank for these, or they become invisible to system-scoped search. `Arsenal`, `FSD`, and `1490-Doom` were carried forward unchanged from a previous tagging attempt — their exact meaning wasn't obvious from the export alone, so nothing was renamed or guessed at.

A previous attempt at this taxonomy had mixed actual rulesets (40K, AOS, Infinity) together with play-format terms (SKIRMISH, SPEARHEAD, COMBATPATROL, MASS_BATTLE) in one flat group. Those format terms are now under `Format` instead — a real example of exactly the kind of conflation this taxonomy's group separation is meant to prevent (see `Format` below and `CHANGELOG.md` v1.2.0).

**Genre** — broad flavor: `Fantasy`, `Sci-Fi`, `Grimdark`, `Dieselpunk`, `Steampunk`, `Cyberpunk`, `Post-Apocalyptic`, `Historical`, `Horror`, `Western`, `Pulp`, `Modern`, `Ancient-History`, `WW1`, `WW2`, `Cold-War`, `Viking`, `Black-Powder`, `Dinos`, `Aerial`, `Naval`, `Starship`, `Star-Wars`, `RPG`, `Bugs`. Mostly useful for system-agnostic content where GameSystem alone won't surface it. `Historical` is a deliberate fallback for historically-themed content that doesn't fit one of the specific eras. `Star-Wars` (thematic setting) and `RPG` (thematic flavor) are independent of `GameSystem:Star-Wars-Legion` and `Format:Warband-RPG`, which describe the actual ruleset/play-scale instead — it's normal for a file to carry both a Genre and a Format/GameSystem value that share a name-ish concept but answer different questions.

**Faction** — army/faction affiliation. This group has real depth from prior usage and is naturally hierarchical even though tags themselves are flat: apply both the broad tag and the specific one when known (e.g. `Astartes` + `Space-Wolves`, or `Chaos` + `Khorne`) so you can query at either level. Current values: `Chaos`, `Khorne`, `Tzeentch`, `Nurgle`, `Slaanesh`, `Imperium`, `Astartes`, `Space-Wolves`, `Dark-Angels`, `Blood-Angels`, `Grey-Knights`, `Flesh-Tearers`, `Guard`, `Sisters`, `Titans`, `Knights`, `Demons`, `Eldar`, `Dark`, `Tyranids`, `Saurians`, `Saurian-Starhost`, `Orks`, `Necrons`, `Undead`, `Humans`, `Dwarves`, `Greenskins-Orcs`, `Custom-Homebrew`. `Dark`, `Saurians`, and `Saurian-Starhost` were carried forward unchanged from a previous attempt — `Dark` in particular is ambiguous (Dark Eldar/Drukhari? something else?) and wasn't renamed rather than risk guessing wrong. This will keep growing — treat it as your single most-used retrieval filter in practice.

**Unit-Type** — role within its faction/scene: `Infantry`, `Cavalry`, `Vehicle`, `Monster`, `Character-Hero`, `Bust`, `Display-Sculpture`, or, for terrain, its structural role (`Ruins`, `Fortification`, `Scatter-Terrain`, `Dungeon-Tile`). `Bust` and `Display-Sculpture` were added from a previous attempt's real usage — both are non-gaming display formats distinct enough from a standard gaming miniature to warrant their own values here rather than being folded into `Character-Hero`.

**Scope** — how much content is *in this file/bundle*, not what it's used for:
- `Single` — one sculpt
- `Multi-Pose` — same model, multiple pose/variant options
- `Squad` — ~5-10 units
- `Warband` — ~10-20 units
- `Unit-Box` — mirrors a standard tabletop unit box
- `Faction-Bundle` — multiple unit types from one faction
- `Mega-Bundle` — an entire faction/range in one bundle

A previous attempt tagged this concept as `WARBAND`/`ARMY` under a "ProductType" group. Those map onto `Warband` and `Faction-Bundle`/`Mega-Bundle` here — deliberately not reintroducing the literal word "Army" as a value, since that's the exact word that caused a real collision with `Format` in the old data (see below).

**Scale** — 10mm / 15mm / 28mm / 32mm / 54mm / Unspecified. Multi-select if a bundle includes more than one pre-scaled version.

**Format** — what tabletop format the content suits: `Skirmish`, `Warband-RPG`, `Mass-Battle`, `Fleet-Naval`, `Combat-Patrol`, `Spearhead` (the last two are official 40k-specific format names, only meaningful alongside `GameSystem:Warhammer-40k`). This is *not* the same axis as `Scope` — a `Single` file can be for `Mass-Battle`, a `Mega-Bundle` can be for `Skirmish`. Don't reuse "Army" as a value in either group; a previous attempt's real data had `SPEARHEAD`, `COMBATPATROL`, `SKIRMISH`, and `MASS_BATTLE` all jammed into the same flat group as actual rulesets like `40K` and `AOS` — this group exists specifically to keep that distinction clean going forward.

**Material** — `Resin`, `FDM`, `Wood`, `Paper`, `Unspecified`. Print-technical/physical-medium, unrelated to everything else. `Wood` and `Paper` cover non-printed content like laser-cut MDF terrain — added after a previous attempt's real usage showed this collection isn't 100% 3D-printed files.

**Creator** — the designer/studio name. No starter list — add names as you encounter them. **Naming convention**: always use the creator's exact storefront name, consistent capitalization, no variant spellings (e.g. always "HeroForge", never "Hero Forge" or "heroforge") — inconsistent capture here silently fragments the tag into duplicates that don't group together.

**Source** — where the file came from: MyMiniFactory, Cults3D, Thingiverse, Patreon, Kickstarter, Direct-Other. Patreon and Kickstarter are kept distinct from marketplaces because backer-model sources tend to carry stricter, easier-to-forget redistribution terms — worth being able to audit "everything from Patreon" separately when checking licenses.

**License** — the one group where getting it wrong has real consequences:
- `Personal-Only` — no sharing in any form, not files, not prints
- `Share-Prints-Only` — physical prints may be gifted; the digital file may not
- `Share-Files-Personal` — file may go to friends, non-commercial, not public
- `Share-Public` — freely shareable/redistributable per its license
- `Unverified` — **default for anything you haven't personally confirmed.** Treat as `Personal-Only` in practice until checked. Never guess `Share-*` on an unverified file.

**Status** — workflow tags, not descriptive ones: `Needs-Triage`, `Printed`, `Favorite`. See the workflow section below.

**ProjectPlans** — carried forward as an empty group from a previous tagging attempt; it was never populated with values there either, so its intended purpose is currently unknown. Left in place rather than deleted since it represents deliberate structure someone set up — define its values once its purpose is confirmed.

### A cautionary tale from the old data

The previous export's "Collected Tags" group contained a lone tag `SCIF` — almost certainly a typo of `SCIFI` (which exists correctly in `Genre`) applied directly to one or more files without going through the defined tag group. Any file carrying `SCIF` won't show up in a search for `Sci-Fi`. This is the exact failure mode the naming-convention rule under `Creator` above exists to prevent — worth a quick cleanup pass in TagSpaces once tagging resumes.

## Applying tags at multi-terabyte scale

Tagging every file individually isn't finishable on a collection this size. Split by how a tag is actually applied:

**Bulk tier** — same value for an entire pack/folder, applied once via multi-select on the whole directory: `ObjectType`, `Source`, `Creator`, `License`, usually `GameSystem`/`Genre`. This is cheap and covers most of the practical value. Do this immediately when a pack is migrated.

**Per-file tier** — varies within a pack, requires actually looking at each item: `Faction`, `Unit-Type`, `Scope`, `Scale`, `Format`. Expensive; backfill opportunistically rather than blocking migration on it.

## The Status workflow

Tag everything `Status:Needs-Triage` as it lands in `_Inbox` or gets sorted into a bucket. Once you've looked at a file and applied whichever bulk + per-file tags genuinely apply to it (even if that's only one or two), remove `Needs-Triage`. Progress on the whole migration becomes a single query: how many files still carry `Needs-Triage`. This is what lets sparse tagging coexist with actually knowing what's left to do — completeness lives in `Status` alone, not in whether every descriptive group got filled in.

## Worked example

An Elvish infantry bundle, originally downloaded from MyMiniFactory, usable in either Age of Sigmar or D&D, license allows sharing files with friends:

- **Folder**: `Miniatures/ElvishInfantryPack/`
- **Tags**: `ObjectType:Miniatures`, `GameSystem:Age-of-Sigmar`, `GameSystem:DnD-5e`, `Genre:Fantasy`, `Faction:Aeldari-Elves`, `Unit-Type:Infantry`, `Scope:Squad`, `Scale:32mm`, `Source:MyMiniFactory`, `Creator:<name>`, `License:Share-Files-Personal`

No `Format` or `Material` tag here — not because they were skipped, but because nothing about this file makes one obviously true yet. Add them later if it becomes relevant; leaving them off is not a defect.
