# Changelog

All notable changes to the tag taxonomy and folder framework are logged here, newest first.

## 2026-09-21 — v1.0.0 — Initial taxonomy

- Established the folder framework: object-type buckets (`Miniatures`, `Terrain`, `Tools_Accessories`) with pack-subfolder + `_Loose`/`_Unknown` convention, plus `_Inbox` for untriaged migration intake.
- Defined 13 tag groups: `ObjectType`, `GameSystem`, `Genre`, `Faction`, `Unit-Type`, `Scope`, `Scale`, `Format`, `Material`, `Creator`, `Source`, `License`, `Status`.
- `Scope` and `Format` (originally drafted as "GameSize") were given non-overlapping vocabularies after both included an "Army" value that meant two different things (bundle size vs. tabletop play scale).
- `License` was expanded from a binary Shared/Private into five values, including `Unverified` as a safe default for files with unknown provenance.
- Established the sparse-tagging principle: no tag group is required on every file. Only `Status:Needs-Triage` tracks whether a file has been reviewed at all; everything else is applied only where it's actually meaningful.
- Established the bulk-vs-per-file tiering workflow for applying tags at collection scale (see `TAGGING_GUIDE.md`).

## 2026-09-21 — v1.1.0 — Compression standard

- Added `COMPRESSION_STANDARD.md`: 7-Zip/LZMA2 settings tuned for maximum ratio (favoring compression over speed), sized against a 32 GB RAM / 16-core machine.
- Established the sequencing rule: tag first while files are extracted, compress to `.7z` only afterward. TagSpaces has no browsing/tagging support for `.7z` contents (unlike `.zip`, which it can preview into), so a compressed pack is treated as sealed cold storage, not a live-tagging target.
- Established per-pack archiving (one `.7z` per pack folder, matching the folder framework) with a coarse tag applied to the archive file itself so it stays searchable without extracting.
- Added `scripts/Compress-Pack.ps1`, which compresses and verifies a pack's archive integrity before any manual deletion of the source folder.
- Documented pre-compression workflow for messy real-world packs: flattening nested archives, culling duplicate/derivative content, normalizing filenames before tagging (not after, to avoid orphaning sidecar files), and enabling Windows long-path support.

## 2026-09-21 — v1.2.0 — Merged a previous tagging attempt's real usage data

A tag library export from an earlier, independent attempt at this project (`tagspaces-settings-export`, TagSpaces 6.13.12) was reviewed and merged in. Real usage beat the speculative starter vocabulary in several places:

- **GameSystem**: added `Age-of-Fantasy`, `Grimdark-Future`, `Kill-Team` (merged with existing), `Infinity`, `Trench-Crusade`, `Torch-and-Shield`, `Arsenal`, `FSD`, `1490-Doom` (the last three carried forward unverified — meaning wasn't obvious from the export alone).
- **Genre**: adopted the previous attempt's much larger real list (`Pulp`, `Modern`, `Ancient-History`, `WW1`, `WW2`, `Cold-War`, `Viking`, `Black-Powder`, `Dinos`, `Aerial`, `Naval`, `Starship`, `Star-Wars`, `RPG`, `Bugs`) on top of the existing set.
- **Faction**: adopted a much deeper real list (Chaos god sub-factions, several Space Marine chapters as siblings of `Astartes`, `Imperium`, `Eldar`, `Tyranids`, etc.), keeping the existing generic/fantasy-side values as a fallback for non-40k content. `Dark`, `Saurians`, `Saurian-Starhost` carried forward unverified.
- **ObjectType**: added `Print-and-Play` and `Papercraft` as genuinely distinct object types (previously under a "ProductType" group); matching folders added to the framework.
- **Unit-Type**: added `Bust` and `Display-Sculpture` (previously separate "ProductType" values).
- **Material**: added `Wood` and `Paper` — the previous attempt's data implies this collection includes non-printed content (e.g. laser-cut MDF terrain).
- **Scope**: confirmed the existing `Warband`/`Faction-Bundle`/`Mega-Bundle` values already cover the previous attempt's `WARBAND`/`ARMY` "ProductType" values; did not reintroduce the word "Army" as a tag.
- **Format**: added `Combat-Patrol` and `Spearhead`. The previous attempt had mixed these and `Skirmish`/`Mass-Battle` directly into its GameSystem group alongside actual rulesets — real-world confirmation of the GameSystem/Format conflation this taxonomy's group separation was designed to avoid.
- **ProjectPlans**: carried forward as an empty group (was never populated in the source either); purpose unconfirmed.
- Noted a stray `SCIF` tag (likely a typo of `SCIFI`) found in the previous export's orphaned "Collected Tags" group as a real example of why the naming-convention rule exists.

## 2026-09-21 — v1.3.0 — Compression unit corrected to the model boundary

- Inspected two real sample packs and found each bundles **six distinct creatures** under one download. Compressing at the whole-download level (the original guidance) would have forced one outer archive tag to represent six potentially different Factions/Genres/Scales — confirmed via direct listing, not assumed.
- Redefined the compression unit as **one distinct model/product** (a creature's pose + support variants), not the original download. At that granularity every tag group is uniform, so a single tagging pass on the archive is complete — the per-file tiering tier in `TAGGING_GUIDE.md` mostly collapses away as a result.
- Folder rule: a single-model pack's archive replaces its pack folder entirely; a multi-model pack keeps a thin pack folder holding one `.7z` per model. Pack folders end up bare by design.
- Added guidance to pull one representative preview render out of each archive (loose, or set as the file's TagSpaces thumbnail) so a model is recognizable and taggable without extracting.
- Flipped the default compression profile from Everyday (256 MB dictionary) to Max (1.5 GB dictionary): at model-sized units, Max's dictionary almost always covers the whole archive in one solid window, so there's no longer a size-driven reason to default to the lighter profile. `Compress-Pack.ps1` updated to match.
