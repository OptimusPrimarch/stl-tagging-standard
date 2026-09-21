# STL Tagging Standard

The tag taxonomy and folder conventions for a personal, multi-terabyte STL collection (miniatures, terrain, tools/accessories), organized in [TagSpaces](https://www.tagspaces.org/) via sidecar tags rather than deep folder hierarchies.

This repo holds **only the classification system** — the tag library definition and the docs explaining how to use it. It does not and will not contain any STL files. Most of this collection is under third-party licenses that don't permit redistribution, so the actual files stay off GitHub; only the empty scaffolding of how they're organized lives here.

## What's in here

- [`tag-library.json`](./tag-library.json) — the importable TagSpaces tag library: all tag groups, their colors, and starter values.
- [`TAGGING_GUIDE.md`](./TAGGING_GUIDE.md) — what each tag group means, the controlled vocabulary, and the workflow for tagging a huge backlog without it taking forever.
- [`FOLDER_FRAMEWORK.md`](./FOLDER_FRAMEWORK.md) — the (deliberately thin) folder structure the tags live on top of.
- [`COMPRESSION_STANDARD.md`](./COMPRESSION_STANDARD.md) — the 7-Zip settings and workflow for compressing tagged packs into cold storage, including handling messy real-world bundles.
- [`scripts/Compress-Pack.ps1`](./scripts/Compress-Pack.ps1) — compresses one pack folder per the standard, verifies it, and reports the size savings. Never deletes the source.
- [`CHANGELOG.md`](./CHANGELOG.md) — how the taxonomy and standards have evolved over time.

## Using this on a new machine or with a friend

1. Install [TagSpaces](https://www.tagspaces.org/products/lite/) (the free Lite version reads/writes sidecar tags).
2. Open TagSpaces → Settings → Tag Library → **Import Tag Library** → select `tag-library.json`.
3. Read `TAGGING_GUIDE.md` for how the groups are meant to be used.

Import is a one-time, disconnected copy — it doesn't live-sync. If the taxonomy here changes later, re-import to pick up the update (see `CHANGELOG.md` for what changed).

## Sharing tagged files with someone

TagSpaces tags travel with files as sidecar data in a hidden `.ts` folder next to them (per-file `<name>.json` + thumbnail). To hand someone a tagged file (or a subset of files), copy the files plus their matching `.ts` entries — no separate export step is needed for the tags themselves. Import this repo's `tag-library.json` once so their tag colors/groupings match yours.
