# Changelog

All notable changes to the tag taxonomy and folder framework are logged here, newest first.

## 2026-09-21 — v1.0.0 — Initial taxonomy

- Established the folder framework: object-type buckets (`Miniatures`, `Terrain`, `Tools_Accessories`) with pack-subfolder + `_Loose`/`_Unknown` convention, plus `_Inbox` for untriaged migration intake.
- Defined 13 tag groups: `ObjectType`, `GameSystem`, `Genre`, `Faction`, `Unit-Type`, `Scope`, `Scale`, `Format`, `Material`, `Creator`, `Source`, `License`, `Status`.
- `Scope` and `Format` (originally drafted as "GameSize") were given non-overlapping vocabularies after both included an "Army" value that meant two different things (bundle size vs. tabletop play scale).
- `License` was expanded from a binary Shared/Private into five values, including `Unverified` as a safe default for files with unknown provenance.
- Established the sparse-tagging principle: no tag group is required on every file. Only `Status:Needs-Triage` tracks whether a file has been reviewed at all; everything else is applied only where it's actually meaningful.
- Established the bulk-vs-per-file tiering workflow for applying tags at collection scale (see `TAGGING_GUIDE.md`).
