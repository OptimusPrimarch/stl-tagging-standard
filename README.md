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

## Keeping the primary collection (F:\STL_CENTRAL) in sync

TagSpaces reads a location's tags from a plain file called `tsl.json` sitting in that location's own `.ts` folder — same JSON format as `tag-library.json`. This works in the free **Lite** edition with no import UI involved at all, confirmed by testing.

`F:\STL_CENTRAL\.ts\tsl.json` is a **symlink** to this repo's `tag-library.json`, not a copy — there's genuinely one file, tracked here, read live by TagSpaces through the link. Editing `tag-library.json` and reopening the location in TagSpaces is the entire update process; nothing needs copying or re-exporting ever again.

The symlink needed a one-time elevated PowerShell command to create (`New-Item -ItemType SymbolicLink`, since this machine doesn't have Developer Mode enabled) — if it's ever missing (e.g. after moving the drive to another machine), recreate it:

```powershell
New-Item -ItemType SymbolicLink -Path "F:\STL_CENTRAL\.ts\tsl.json" -Target "F:\STL_CENTRAL\_TagStandard\tag-library.json"
```

## Using this on a new machine or with a friend

`tsl.json` is scoped to one location, so for anywhere else — a different machine, or a friend who isn't setting up `F:\STL_CENTRAL` as their own location — use the global Tag Library import instead:

1. Install [TagSpaces](https://www.tagspaces.org/products/lite/) (the free Lite version reads/writes filename and sidecar tags).
2. Open TagSpaces → Settings → Tag Library → **Import Tag Library** → select `tag-library.json`.
3. Read `TAGGING_GUIDE.md` for how the groups are meant to be used.

**Known Lite quirk**: the Import/Export menu (the `⋮` on the Tag Library panel) only shows up while the tag library is empty and disappears once anything's loaded — it's not that the feature vanished, just that its entry point does. If you need to import/export again after that, use **Settings → Backup Settings** instead, which stays available regardless of whether tags are already loaded.

Either way, import is a one-time, disconnected copy — it doesn't live-sync. If the taxonomy here changes later, redo the relevant step above to pick up the update (see `CHANGELOG.md` for what changed).

## Sharing tagged files with someone

TagSpaces tags travel with files as sidecar data in a hidden `.ts` folder next to them (per-file `<name>.json` + thumbnail). To hand someone a tagged file (or a subset of files), copy the files plus their matching `.ts` entries — no separate export step is needed for the tags themselves. Import this repo's `tag-library.json` once so their tag colors/groupings match yours.
