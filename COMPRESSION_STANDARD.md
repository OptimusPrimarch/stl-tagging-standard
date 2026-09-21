# Compression Standard

7-Zip (`.7z`, LZMA2), tuned to favor ratio over speed. This machine has 32 GB RAM and 16 logical cores — the profiles below are sized against that; re-check the memory math in "Profiles" if this ever runs on different hardware.

## Core principle: compress after tagging, never instead of it

TagSpaces can browse and preview *inside* `.zip` files (its Archive Viewer extension), but it has no equivalent support for `.7z` — a compressed pack is a dead end for live tagging or searching its contents. So the sequence is always:

1. Extract → normalize filenames → tag every file that warrants it (per `TAGGING_GUIDE.md`) → confirm tags look right in TagSpaces.
2. **Then** compress the whole pack folder — files and their `.ts` sidecar folder together — into one `.7z` sitting where the folder was.
3. Put a coarse tag directly on the `.7z` file itself (its own sidecar entry works fine on any file type): at minimum `ObjectType`, `License`, `Source`/`Creator`. That keeps the archive searchable without opening it.
4. Delete the extracted folder only after step 2 is verified (see "Verify before you delete" below). The full per-file tags aren't lost — they're sealed inside the archive's `.ts` folder and reappear the moment you extract it again.

This makes archives a cold-storage/sharing format, not a live-browsing one. If you need to retag or re-triage a pack later, extract it, edit, recompress.

## Profiles

```powershell
# Everyday — safe on any machine, ~3 GB RAM during compression
& "C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=256m -ms=on -mqs=on -mmt=on "PackName.7z" "PackName\*"

# Max — best ratio this machine can push, ~16 GB RAM during compression
& "C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=1536m -ms=on -mqs=on -mmt=on "PackName.7z" "PackName\*"
```

What each flag is doing:
- `-mx=9` — Ultra preset. On its own this only sets fast-bytes to 64, not the true max.
- `-mfb=273` — pushes fast-bytes to its actual ceiling (max is 273). This is the single biggest ratio-for-speed trade you can make; it's exactly what "favor compression over speed" buys you.
- `-md=` — dictionary size. Bigger lets solid compression find matches across more of the pack at once. Memory cost for compression ≈ dictionary size × 10.5–11.5 (the default `bt4` match finder); decompression only needs roughly the dictionary size itself, so anyone you send a `.7z` to doesn't inherit your RAM cost. `256m` → ~3 GB to compress. `1536m` → ~16 GB — leaves headroom on 32 GB total, but **you currently have well under 1 GB free**, so close other apps before running the Max profile.
- `-ms=on` — solid archiving: treats every file in the pack as one continuous stream instead of compressing each separately. This is where most of the real gain comes from on a folder of many related files, and it's the whole reason to compress per-pack rather than per-file.
- `-mqs=on` — sorts files by type before the solid pass, so all STLs, all renders/images, all PDFs end up adjacent in the stream instead of interleaved. Matters specifically for the "wonky" mixed-content packs below. (Its usual downside — slower seeks on HDDs from non-name-order layout — doesn't apply on an SSD.)
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
5. **Tag, verify, then compress** per the core principle above, one `.7z` per pack folder — not one giant archive for all of `Miniatures/`. Per-pack archives stay independently shareable and keep the dictionary size sane relative to what's actually in each one.

## Worth A/B testing later, not assumed

Two knobs that *might* help further but depend on your actual file mix enough that I won't bake them in as defaults:

- **Delta filter** (`-m0=Delta:4 -m1=LZMA2:...`) — helps formats with a clean, regular byte stride (raw audio, uncompressed bitmaps). Binary STL's 50-byte-per-triangle record doesn't align to a 4-byte stride, so there's no strong reason to expect a win — but it's cheap to test on one representative pack.
- **`-mqs=off` for packs that are STL-only** — the sort-by-type flag only matters when a pack actually mixes file types; on an all-STL pack it's a no-op either way, so no need to toggle it per-pack.

Test methodology: compress the same real pack both ways, compare `Get-Item archive.7z | Select Length`, keep whichever setting actually wins on your content rather than trusting either claim in the abstract.
