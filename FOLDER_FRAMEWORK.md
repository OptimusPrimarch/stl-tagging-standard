# Folder Framework

Folders here only encode what's genuinely non-ambiguous and single-valued per file. Everything else — game system, genre, faction, license, scale, etc. — is a tag, because most of this collection is cross-applicable (a fantasy infantry file can belong to Age of Sigmar *and* D&D at once) and a folder can't represent that.

The one axis that's never contested is **physical object type**: a terrain piece is never also a miniature.

```
STL_CENTRAL/
  Miniatures/
    <PackName-or-Creator>/     one subfolder per original zip/bundle/creator
    _Loose/
      <Creator>/                singles you know the source of
      _Unknown/                 nonsense-named orphans, pending ID + tagging
  Terrain/
    <PackName-or-Creator>/
    _Loose/
  Tools_Accessories/           fidgets, organizers, non-wargaming functional prints
    <PackName-or-Creator>/
    _Loose/
  _Inbox/                      freshly migrated, untouched, not yet triaged
  _TagStandard/                this repo (tag library + docs, no STLs)
```

## Why the pack-subfolder layer

Grouping by original pack/bundle/creator, rather than dumping files flat, is free organization you already have from how the files arrived — no categorization judgment needed, so it never blocks migration. It also:

- Keeps a pack's readme/license file physically next to the files it covers.
- Bounds folder size. TagSpaces stores tag/thumbnail sidecars in a `.ts` subfolder per directory; splitting by pack keeps each `.ts` folder small instead of one enormous one for the whole collection.
- Keeps Explorer/backup/antivirus tooling sane — tens of thousands of files in one flat directory is a bad time regardless of TagSpaces.

## Edge case: a pack spans multiple object types

Some bundles (Kickstarters especially) mix miniatures and terrain in one download. Split its contents into `Miniatures/PackName/` and `Terrain/PackName/` using the *same* pack name in both places, and tag every file from it with the same `Source`/`Creator` tags. The tag — not the folder — is what reunites "everything from this creator" across the type split.

## Deliberately not folders

No folders for: game system, genre, faction, license, scale, format, scope, material, or status. All of these are ambiguous, multi-valued, or purely descriptive — see [`TAGGING_GUIDE.md`](./TAGGING_GUIDE.md) for how they're tagged instead.
