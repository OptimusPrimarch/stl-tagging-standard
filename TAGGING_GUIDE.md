# Tagging Guide

How to use the tag groups in `tag-library.json`. Read this once before you start triaging, and hand it to anyone importing the tag library so tags stay consistent across machines.

## Core principle: tags are optional, per file, per group

No file needs a value from every group. A generic terrain rock has no `Faction`, `Unit-Type`, or `GameSystem` — those groups simply don't apply to it, and that's correct, not incomplete. Apply whichever subset of groups genuinely describes the file and skip the rest. A typical file will touch 5-7 of the 13 groups, not all of them.

The one exception is `Status`, which exists specifically to distinguish "not applicable" from "not reviewed yet" — see below.

## The groups

**ObjectType** — Miniatures / Terrain / Tools-Accessories. Mirrors the top-level folder split (see `FOLDER_FRAMEWORK.md`); kept as a tag too so you can build tag-only saved searches that don't care about folder location.

**GameSystem** — the ruleset(s) a file fits. Multi-select when a file genuinely fits more than one (e.g. a generic elf infantry file tagged both `Age-of-Sigmar` and `DnD-5e`). Use `Generic-System-Agnostic` for the large share of minis that aren't tied to any specific ruleset — don't leave GameSystem blank for these, or they become invisible to system-scoped search.

**Genre** — broad flavor (Fantasy, Sci-Fi, Grimdark, Dieselpunk, ...). Mostly useful for system-agnostic content where GameSystem alone won't surface it. Keep this list broad; don't create near-duplicate genre tags (e.g. "Dark Fantasy" vs "Fantasy") — let `Faction` and `GameSystem` carry the finer distinctions.

**Faction** — army/faction affiliation (Space Marines, Orks, Elves, Necrons, ...). This will grow a lot — it's seeded with a handful of examples, not meant to be exhaustive. Add new values as you go; this is probably your single most-used retrieval filter in practice.

**Unit-Type** — role within its faction/scene (Infantry, Cavalry, Vehicle, Monster, Character-Hero) or, for terrain, its structural role (Ruins, Fortification, Scatter-Terrain, Dungeon-Tile).

**Scope** — how much content is *in this file/bundle*, not what it's used for:
- `Single` — one sculpt
- `Multi-Pose` — same model, multiple pose/variant options
- `Squad` — ~5-10 units
- `Warband` — ~10-20 units
- `Unit-Box` — mirrors a standard tabletop unit box
- `Faction-Bundle` — multiple unit types from one faction
- `Mega-Bundle` — an entire faction/range in one bundle

**Scale** — 10mm / 15mm / 28mm / 32mm / 54mm / Unspecified. Multi-select if a bundle includes more than one pre-scaled version.

**Format** — what tabletop format the content suits: `Skirmish`, `Warband-RPG`, `Mass-Battle`, `Fleet-Naval`. This is *not* the same axis as `Scope` — a `Single` file can be for `Mass-Battle`, a `Mega-Bundle` can be for `Skirmish`. Don't reuse "Army" as a value in either group; that word caused the original ambiguity this taxonomy fixed.

**Material** — Resin / FDM / Unspecified. Print-technical, unrelated to everything else.

**Creator** — the designer/studio name. No starter list — add names as you encounter them. **Naming convention**: always use the creator's exact storefront name, consistent capitalization, no variant spellings (e.g. always "HeroForge", never "Hero Forge" or "heroforge") — inconsistent capture here silently fragments the tag into duplicates that don't group together.

**Source** — where the file came from: MyMiniFactory, Cults3D, Thingiverse, Patreon, Kickstarter, Direct-Other. Patreon and Kickstarter are kept distinct from marketplaces because backer-model sources tend to carry stricter, easier-to-forget redistribution terms — worth being able to audit "everything from Patreon" separately when checking licenses.

**License** — the one group where getting it wrong has real consequences:
- `Personal-Only` — no sharing in any form, not files, not prints
- `Share-Prints-Only` — physical prints may be gifted; the digital file may not
- `Share-Files-Personal` — file may go to friends, non-commercial, not public
- `Share-Public` — freely shareable/redistributable per its license
- `Unverified` — **default for anything you haven't personally confirmed.** Treat as `Personal-Only` in practice until checked. Never guess `Share-*` on an unverified file.

**Status** — workflow tags, not descriptive ones: `Needs-Triage`, `Printed`, `Favorite`. See the workflow section below.

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
