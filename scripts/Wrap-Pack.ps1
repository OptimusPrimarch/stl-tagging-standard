<#
Wraps a pack folder (already containing one or more tagged Model.7z archives,
per COMPRESSION_STANDARD.md) into a single distribution-friendly .zip, using
STORE mode - the payload is already LZMA2-compressed, so this only packages
it, it doesn't recompress it. Meant to be regenerated on demand whenever you
actually want to hand a whole pack to someone, not kept as the permanent
at-rest form (keep the loose Model.7z files for your own live tag search).

Usage:
  .\Wrap-Pack.ps1 -Path "F:\STL_CENTRAL\Miniatures\PackName"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe"
)

if (-not (Test-Path $SevenZipPath)) {
    throw "7-Zip not found at $SevenZipPath"
}

$Path = (Resolve-Path $Path).Path
if (-not (Test-Path $Path -PathType Container)) {
    throw "$Path is not a folder"
}

$parent = Split-Path $Path -Parent
$name = Split-Path $Path -Leaf
$zipPath = Join-Path $parent "$name.zip"

if (Test-Path $zipPath) {
    throw "$zipPath already exists - remove it first or choose a different target"
}

Write-Output "Wrapping '$name' into a store-mode .zip (no recompression)..."
$sizeBefore = (Get-ChildItem $Path -Recurse -File | Measure-Object -Property Length -Sum).Sum

& $SevenZipPath a -tzip -mx=0 "$zipPath" "$Path\*"
if ($LASTEXITCODE -ne 0) {
    throw "7-Zip wrapping failed (exit $LASTEXITCODE)"
}

Write-Output "Verifying archive integrity..."
& $SevenZipPath t "$zipPath"
if ($LASTEXITCODE -ne 0) {
    throw "Archive verification FAILED - do not send this file. Left at $zipPath for inspection."
}

$sizeAfter = (Get-Item $zipPath).Length
$overheadKB = [math]::Round(($sizeAfter - $sizeBefore) / 1KB, 1)

Write-Output ""
Write-Output "Wrapped OK: $zipPath"
Write-Output ("Container overhead: ~{0} KB (expected - store mode adds no real compression cost)" -f $overheadKB)
Write-Output ""
Write-Output "This zip is disposable and cheap to regenerate. If it was just for sending to someone,"
Write-Output "delete it once they have it - the loose Model.7z files remain your tagged, searchable copy:"
Write-Output "  Remove-Item -Force `"$zipPath`""
