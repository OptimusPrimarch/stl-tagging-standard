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
