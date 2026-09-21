# Compression Standard

7-Zip (`.7z`, LZMA2), tuned to favor ratio over speed. This machine has 32 GB RAM and 16 logical cores — the profiles below are sized against that; re-check the memory math in "Profiles" if this ever runs on different hardware.

## Core principle: compress after tagging, never instead of it

TagSpaces can browse and preview *inside* `.zip` files (its Archive Viewer extension), but it has no equivalent support for `.7z` — a compressed pack is a dead end for live tagging or searching its contents. So the sequence is always:

1. Extract → normalize filenames → tag every file that warrants it (per `TAGGING_GUIDE.md`) → confirm tags look right in TagSpaces.
2. **Then** compress each unit (see "Choosing the compression unit" below) — its files and their `.ts` sidecar folder together — into one `.7z` sitting where the folder was.
3. Put a coarse tag directly on the `.7z` file itself (its own sidecar entry works fine on any file type): at minimum `ObjectType`, `License`, `Source`/`Creator`. That keeps the archive searchable without opening it.
4. Delete the extracted folder only after step 2 is verified (see "Verify before you delete" below). The full per-file tags aren't lost — they're sealed inside the archive's `.ts` folder and reappear the moment you extract it again.

This makes archives a cold-storage/sharing format, not a live-browsing one. If you need to retag or re-triage a pack later, extract it, edit, recompress.

## Choosing the compression unit: the model, not the download

A downloaded "pack" almost never turns out to be one thing. Two real samples from this collection each turned out to bundle **six distinct creatures** under a single zip. Compress at that whole-download level and you're stuck: the one visible, taggable `.7z` has to somehow represent six creatures that might have six different Factions, Genres, or Scales — exactly the ambiguity tags exist to solve, made unsolvable by sealing it behind one opaque archive.

The fix is to compress at the boundary of **one distinct model** instead — the level where every tag group (`GameSystem`, `Genre`, `Faction`, `Unit-Type`, `Scope`, `Scale`, `Format`, `Material`, `Creator`, `Source`, `License`) is genuinely uniform across everything inside it. A creature's `Pose 1`/`Pose 2`/`Pose 3` and `Supported`/`Unsupported`/`Base` variants all share the same Faction, same Genre, same Scale, same everything — they're one product, not several. That's not a coincidence; it's what makes this the right unit: tag the archive once, completely, and you never need to reopen it just to fix a tag. Bundling those variants together into one archive also happens to be exactly what solid compression wants, since near-duplicate meshes (a supported vs. unsupported version of the same model) are the biggest redundancy in the whole pack.

In practice:
- **A pack containing one model** → the archive replaces the pack folder entirely: `Miniatures/PackName.7z`.
- **A pack containing several models** (the common case) → keep a thin pack folder for provenance, one archive per model inside it: `Miniatures/PackName/Model1.7z`, `Miniatures/PackName/Model2.7z`, ... The folder ends up holding a handful of `.7z` files and nothing else — bare, by design, exactly as intended.
- Use the creator's own top-level subfolders as the model boundary when the download already has them (it almost always does) — that's a free, reliable signal, not a judgment call you have to make yourself.
- **Pull one representative render/preview image out and leave it loose** next to the archive (or set it as the `.7z`'s TagSpaces thumbnail) before compressing the rest. That's what makes tagging "easily accessible" without extracting anything — you can see what a model is at a glance, tag its archive accordingly, and never need to open it again. Any extra render angles can go inside the archive with everything else.

This also simplifies the bulk-vs-per-file tiering in `TAGGING_GUIDE.md`: at this granularity, there normally *is* no per-file tier left — everything worth tagging is uniform across the one archive, so a single bulk pass on it is already complete.

## Profiles

```powershell
# Max — the default now that units are model-sized, not whole-download-sized; ~16 GB RAM during compression
& "C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=1536m -ms=on -mqs=on -mmt=on "ModelName.7z" "ModelName\*"

# Everyday — fallback when RAM is tight right now, or for an unusually huge single model; ~3 GB RAM during compression
& "C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=256m -ms=on -mqs=on -mmt=on "ModelName.7z" "ModelName\*"
```

A single model's pose/support variants rarely add up to more than a few hundred MB to low-GB, so the Max profile's 1.5 GB dictionary will almost always cover the *entire* archive in one solid window — full cross-variant matching, every time. That's why Max is the default now: the RAM cost is fixed regardless of how small the archive actually is, so there's no longer a reason to reach for Everyday except when free RAM is tight at the moment (check with `Get-CimInstance Win32_OperatingSystem`) or a single model is genuinely huge.

What each flag is doing:
- `-mx=9` — Ultra preset. On its own this only sets fast-bytes to 64, not the true max.
- `-mfb=273` — pushes fast-bytes to its actual ceiling (max is 273). This is the single biggest ratio-for-speed trade you can make; it's exactly what "favor compression over speed" buys you.
- `-md=` — dictionary size. Bigger lets solid compression find matches across more of the archive at once. Memory cost for compression ≈ dictionary size × 10.5–11.5 (the default `bt4` match finder); decompression only needs roughly the dictionary size itself, so anyone you send a `.7z` to doesn't inherit your RAM cost. `1536m` → ~16 GB to compress, comfortably inside 32 GB total when nothing else heavy is running; `256m` → ~3 GB, safe alongside anything.
- `-ms=on` — solid archiving: treats every file in the archive as one continuous stream instead of compressing each separately. This is where most of the real gain comes from on a model's pose/support variants, and it's the whole reason to compress per-model rather than per-file.
- `-mqs=on` — sorts files by type before the solid pass, so STLs, LYS project files, and renders end up adjacent in the stream instead of interleaved. (Its usual downside — slower seeks on HDDs from non-name-order layout — doesn't apply on an SSD.)
- `-mmt=on` — use all 16 cores. LZMA2 can parallelize within a solid block at `mx=9`, so this buys speed back with no meaningful ratio cost.

Verify, always, before deleting the source:

```powershell
& "C:\Program Files\7-Zip\7z.exe" t "PackName.7z"
```

A `.7z` with a broken CRC costs you nothing until the day you delete the only other copy of what's inside it.

## Handling "wonky" packs

Real downloaded packs rarely look like a clean folder of STLs. Before compressing one, work through this in order:

1. **Flatten nested archives.** If a pack contains its own zip/rar files, extract those fully first. A solid pass can't find cross-file redundancy across an archive boundary it can't see into, and there's nothing to gain from compressing an already-compressed inner archive again.
2. **Decide what to keep.** Packs frequently duplicate content: the same model pre-supported and un-supported, the same mesh as both STL and OBJ, slicer project files (`.lys`, `.chitubox`, `.lyz`) you may never open again. Culling what you won't actually use is a bigger size win than any compression flag — do this before step 3, not after.
3. **Normalize filenames.** Do this *before* tagging, not after. Sidecar tag files are named after the exact filename they belong to (`<file>.json`); renaming a file outside TagSpaces after it's been tagged orphans the sidecar and silently loses the tags. If a pack has non-ASCII or inconsistent names, fix that first.
4. **Enable Windows long-path support once, up front.** Pack names plus nested creator/subfolder names plus verbose STL filenames add up, and Windows' default 260-character path limit will silently break copies/extracts before you notice why. One-time fix:
   ```powershell
   New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
   ```
   (Requires admin PowerShell; a reboot may be needed for all apps to pick it up.)
5. **Tag, verify, then compress** per the core principle above, at the model-level unit described in "Choosing the compression unit" — not one giant archive for a whole download, and not one for all of `Miniatures/`. Per-model archives stay independently shareable, tag precisely, and keep the dictionary size sane relative to what's actually in each one.

## Worth A/B testing later, not assumed

Two knobs that *might* help further but depend on your actual file mix enough that I won't bake them in as defaults:

- **Delta filter** (`-m0=Delta:4 -m1=LZMA2:...`) — helps formats with a clean, regular byte stride (raw audio, uncompressed bitmaps). Binary STL's 50-byte-per-triangle record doesn't align to a 4-byte stride, so there's no strong reason to expect a win — but it's cheap to test on one representative pack.
- **`-mqs=off` for packs that are STL-only** — the sort-by-type flag only matters when a pack actually mixes file types; on an all-STL pack it's a no-op either way, so no need to toggle it per-pack.

Test methodology: compress the same real pack both ways, compare `Get-Item archive.7z | Select Length`, keep whichever setting actually wins on your content rather than trusting either claim in the abstract.
