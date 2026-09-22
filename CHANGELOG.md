# Changelog

All notable changes to the tag taxonomy and folder framework are logged here, newest first.

## 2026-09-22 — v1.8.0 — Confirmed a Pro-free sync workflow

- Confirmed TagSpaces Pro marketing page lists "Export and import location configurations," "Collect all tags used in a given location," and "Specify tagging method (filename or sidecar) per location" as Pro-exclusive — the free Lite edition genuinely does not have the convenient Tag Library import/export path documented earlier, it wasn't a UI we were missing.
- Tested and confirmed a free workaround: placing `tag-library.json`'s content as `tsl.json` in a location's `.ts` folder works in Lite with no import UI at all. This is now the primary sync method for `F:\STL_CENTRAL` specifically (see README.md) — just overwrite `F:\STL_CENTRAL\.ts\tsl.json` and reopen the location.
- Also found: the global Tag Library's `⋮` import/export menu only appears while the library is empty and disappears once populated — not a missing feature, a state-dependent entry point. **Settings → Backup Settings** provides the same import/export capability and stays available regardless of state; useful for onboarding a different machine or a friend who isn't using `F:\STL_CENTRAL` as their own location.

## 2026-09-22 — v1.7.0 — Seeded 19 real Creator values

Pulled real, verifiable creator/studio names from MyMiniFactory's own blog posts and search results to pre-populate `Creator` (previously only `Tiny-Legends`) — no official "top creators" leaderboard exists on the platform to rank against, so this isn't a verified top-N list, just genuinely real names confirmed to exist rather than invented ones. Added: `Printed-Obsession`, `Rescale-Miniatures`, `Archvillain-Games`, `KMFP`, `Parasite-Collectibles`, `Highlands-Miniatures`, `Vae-Victis`, `Beholders-Miniatures`, `Avatars-of-War`, `White-Angel-Miniatures`, `Devale-Games`, `Custom-Miniature-Maker`, `BulkamancerSculpts`, `RedMakers`, `PrintMinis`, `Venatus-Maps`, `Scan-the-World`, `MakeAnything`, `Iain-Lovecraft`. The last three are flagged as general maker-community names rather than tabletop-specific — kept anyway since an unused Creator value costs nothing, and every real name added is one less hand-typed (and one less typo risk).

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

## 2026-09-21 — v1.4.0 — Distribution wrapping and a note on volume-splitting

- Added a second, outer packaging layer for multi-model packs: `Model.7z` files (LZMA2, solid, tagged individually) get wrapped into one `PackName.zip` in STORE mode (`-mx=0`, no recompression) purely for single-file distribution. Verified TagSpaces' Archive Viewer surfaces filenames/sizes/dates for content nested in a `.zip` but not sidecar tag chips - the wrap gives glanceable pack contents without extraction, not live tag search two layers deep.
- Established the outer zip as disposable/regenerate-on-demand at share time, not the permanent at-rest form - keeps every model's own tags fully live for day-to-day search on the drive itself.
- Added `scripts/Wrap-Pack.ps1`.
- Documented fixed-size volume-splitting (`-v`) as a delivery-mechanism knob with zero effect on compression ratio, and explicitly not a default: splitting a `Model.7z` breaks the single-file/tag mapping the whole taxonomy depends on. Left as a one-off tool for a specific transfer-size constraint, applied to a disposable copy, not to the archive that lives in the collection.

## 2026-09-22 — v1.5.0 — Corrected a bad GUI recommendation: Solid Block size

- Earlier guidance told the GUI's "Add to archive" dialog to use the largest available Solid Block size. In practice (hit for real on this machine) an oversized block combined with the 1536 MB dictionary and multithreading made 7-Zip try to run several dictionary-sized compression streams in parallel, demanding ~71 GB against 32 GB installed RAM - the operation was blocked outright.
- Corrected to `2 GB`: comfortably larger than any single model's real total size (per the samples already measured), so solid coverage of the whole archive is unaffected, at zero ratio cost. The CLI recipe (`-ms=on`) was never affected since it leaves block sizing to 7-Zip's own automatic default rather than forcing a specific size.
- Added a "Using the 7-Zip GUI" section to `COMPRESSION_STANDARD.md` with the full field mapping, this specific warning, and a reminder to leave "Delete files after compression" unchecked (it bypasses the verify-then-delete step the standard depends on).

## 2026-09-22 — v1.5.1 — The RAM blocker was never about Solid Block size

- v1.5.0's diagnosis was wrong, caught by direct testing on this machine: changing Solid Block size didn't move the memory estimate at all; changing Dictionary size did. The actual mechanism is that Ultra-level LZMA2 can run multiple compression streams in parallel across threads, each needing its own dictionary-sized buffer, so the memory estimate scales with dictionary size × thread count, not block size.
- Corrected `COMPRESSION_STANDARD.md`'s GUI section: the fix for a memory-blocked archive is to lower **Number of CPU threads** first (costs speed only), and reduce Dictionary size only as a fallback (costs real ratio). Solid Block size can stay at a modest value like `2 GB` without needing to chase it as the cause.

## 2026-09-22 — v1.6.0 — Bits/upgrades, and a policy shift to filename tags

Prompted by a real file (`PlasmaGuns[...].7z` in `Miniatures/`) tagged during a previous attempt, used as a deliberate test case:

- **Found the tags were exact-string stale**: the file carried old, pre-cleanup words (`40K`, `MODELS`, `SCIFI`, `GRIMDARK`, `RESIN`) that don't match this taxonomy's current canonical values (`Warhammer-40k`, `Miniatures`, `Sci-Fi`, `Grimdark`, `Resin`) — a live instance of the same fragmentation risk the `SCIF` typo illustrated earlier. Renamed the file (and its sidecar) to the corrected tag set.
- Added `Faction: Steel-Legion` (a specific Astra Militarum regiment, applied alongside `Imperium` + `Guard` per the existing hierarchy pattern) and `Unit-Type: Bits` (interchangeable weapon/head/upgrade parts for an existing squad, not a standalone model).
- Documented the **bits-to-squad linking pattern**: tag an accessory/bits pack with the same Faction/regiment identifiers as the squad it's compatible with; a shared tag reunites them in search with no separate linking mechanism needed. `ObjectType` stays `Miniatures` for bits, not `Tools-Accessories`.
- **Policy shift**: adopted filename tagging (tags embedded in brackets, e.g. `Model[tag1 tag2].7z`) as the default for all stable/descriptive groups, based on real prior usage plus two concrete advantages over sidecar-only: tags survive any copy/zip/cloud-sync/email with no risk of losing the `.ts` folder, and they stay readable (via Explorer, `7z l`, or the zip Archive Viewer) even on a fully sealed `.7z`. Only `Status` stays in the sidecar, since it churns during triage and filename tags don't. This is practical specifically because compressing at the model boundary already keeps per-file tag counts to ~6-10, not dozens.
