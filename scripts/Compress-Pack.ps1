<#
Compresses one pack folder into a solid, maximum-ratio .7z next to it,
verifies the archive, and reports size savings. Never deletes the source -
that stays a manual, confirmed step once you're satisfied the archive is good.

Usage:
  .\Compress-Pack.ps1 -Path "F:\STL_CENTRAL\Miniatures\ElvishInfantryPack"
  .\Compress-Pack.ps1 -Path "F:\STL_CENTRAL\Miniatures\ElvishInfantryPack" -Profile Max
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [ValidateSet("Default", "Max")]
    [string]$Profile = "Default",

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
$archive = Join-Path $parent "$name.7z"

if (Test-Path $archive) {
    throw "$archive already exists - remove it first or choose a different target"
}

$dict = if ($Profile -eq "Max") { "1536m" } else { "256m" }

Write-Output "Compressing '$name' (profile: $Profile, dictionary: $dict)..."
$sizeBefore = (Get-ChildItem $Path -Recurse -File | Measure-Object -Property Length -Sum).Sum

& $SevenZipPath a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=$dict -ms=on -mqs=on -mmt=on "$archive" "$Path\*"
if ($LASTEXITCODE -ne 0) {
    throw "7-Zip compression failed (exit $LASTEXITCODE)"
}

Write-Output "Verifying archive integrity..."
& $SevenZipPath t "$archive"
if ($LASTEXITCODE -ne 0) {
    throw "Archive verification FAILED - do not delete the source folder. Archive left at $archive for inspection."
}

$sizeAfter = (Get-Item $archive).Length
$pct = [math]::Round((1 - ($sizeAfter / $sizeBefore)) * 100, 1)

Write-Output ""
Write-Output "Archive verified OK: $archive"
Write-Output ("Original: {0:N1} MB -> Compressed: {1:N1} MB ({2}% smaller)" -f ($sizeBefore / 1MB), ($sizeAfter / 1MB), $pct)
Write-Output ""
Write-Output "Source folder was NOT deleted. Once you've confirmed the archive and its tags look right, remove it manually:"
Write-Output "  Remove-Item -Recurse -Force `"$Path`""
