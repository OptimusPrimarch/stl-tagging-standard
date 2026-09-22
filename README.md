# STL Tagging Standard

The tag taxonomy and folder conventions for a personal, multi-terabyte STL collection (miniatures, terrain, tools/accessories), organized in [TagSpaces](https://www.tagspaces.org/) via sidecar tags rather than deep folder hierarchies.

This repo holds **only the classification system** — the tag library definition and the docs explaining how to use it. It does not and will not contain any STL files. Most of this collection is under third-party licenses that don't permit redistribution, so the actual files stay off GitHub; only the empty scaffolding of how they're organized lives here.

## What's in here

- [`tag-library.json`](./tag-library.json) — the importable TagSpaces tag library: all tag groups, their colors, and starter values.
- [`TAGGING_GUIDE.md`](./TAGGING_GUIDE.md) — what each tag group means, the controlled vocabulary, and the workflow for tagging a huge backlog without it taking forever.
- [`FOLDER_FRAMEWORK.md`](./FOLDER_FRAMEWORK.md) — the (deliberately thin) folder structure the tags live on top of.
- [`COMPRESSION_STANDARD.md`](./COMPRESSION_STANDARD.md) — the 7-Zip settings and workflow for compressing tagged packs into cold storage, including handling messy real-world bundles.
- [`scripts/Compress-Pack.ps1`](./scripts/Compress-Pack.ps1) — compresses one model-level folder per the standard, verifies it, and reports the size savings. Never deletes the source.
- [`scripts/Wrap-Pack.ps1`](./scripts/Wrap-Pack.ps1) — wraps a pack folder of already-compressed `Model.7z` files into a single store-mode `.zip` for handing a whole pack to someone. Disposable/regenerable, never deletes the source.
- [`CHANGELOG.md`](./CHANGELOG.md) — how the taxonomy and standards have evolved over time.

## Loading the tag library — every session, on this machine or any other

Confirmed by direct testing (fully quitting TagSpaces, verifying no process was left running, then relaunching cold): the tag library does **not** persist automatically in the free **Lite** edition. That applies whether it was loaded via the global import or via a `tsl.json` file sitting in a location's `.ts` folder — neither survives a genuine cold start on its own. **Import is step 1 of every session, deliberately, not a one-time setup task.**

1. Open TagSpaces.
2. **Settings → Backup Settings** → import `tag-library.json` from this repo. (The `⋮` menu on the Tag Library panel does the same thing, but only appears while the library is already empty — Backup Settings works regardless of state, so it's the reliable path.)
3. Open `F:\STL_CENTRAL` as the location and work as normal.

This is a conscious, accepted part of the workflow, not a bug being worked around.

`F:\STL_CENTRAL\.ts\tsl.json` is still kept as a regenerated copy of `tag-library.json` whenever the file changes — `.ts` is TagSpaces' own internal cache folder outside this repo's root, so it's never git-tracked. What exactly it does on its own is unconfirmed after the test above; keeping it current costs nothing and doesn't replace the Backup Settings import.

```powershell
Copy-Item "F:\STL_CENTRAL\_TagStandard\tag-library.json" "F:\STL_CENTRAL\.ts\tsl.json" -Force
```

## Using this on a different machine or with a friend

Same as above: install [TagSpaces](https://www.tagspaces.org/products/lite/), then **Settings → Backup Settings** (or the `⋮` on the Tag Library panel, while it's still empty) → import `tag-library.json`. Read `TAGGING_GUIDE.md` for how the groups are meant to be used.

Import is a one-time, disconnected copy — it doesn't live-sync. If the taxonomy here changes later, redo the import to pick up the update (see `CHANGELOG.md` for what changed).

## Sharing tagged files with someone

TagSpaces tags travel with files as sidecar data in a hidden `.ts` folder next to them (per-file `<name>.json` + thumbnail). To hand someone a tagged file (or a subset of files), copy the files plus their matching `.ts` entries — no separate export step is needed for the tags themselves. Import this repo's `tag-library.json` once so their tag colors/groupings match yours.
