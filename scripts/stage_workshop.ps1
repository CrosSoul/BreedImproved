param(
	[string]$Version = "0.1.0"
)

$ErrorActionPreference = "Stop"

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$productionRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "MyCK3Mod"))
$distRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "dist"))
$workshopRoot = [System.IO.Path]::GetFullPath((Join-Path $distRoot "workshop"))
$stageRoot = [System.IO.Path]::GetFullPath((Join-Path $workshopRoot "BreedImproved"))

$workshopPrefix = $workshopRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if (-not $stageRoot.StartsWith($workshopPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
	throw "Refusing to use a staging path outside dist/workshop/."
}
if (-not (Test-Path -LiteralPath (Join-Path $productionRoot "descriptor.mod") -PathType Leaf)) {
	throw "Verified production Mod root is invalid: $productionRoot"
}

New-Item -ItemType Directory -Path $workshopRoot -Force | Out-Null

# Workshop staging is never incremental.
if (Test-Path -LiteralPath $stageRoot) {
	Remove-Item -LiteralPath $stageRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $stageRoot | Out-Null

# Copy every production file directly from MyCK3Mod/. Repository-only .gitkeep
# files preserve empty source directories but are not runtime content.
$productionFiles = @(
	Get-ChildItem -LiteralPath $productionRoot -Recurse -File -Force |
		Where-Object { $_.Name -ne ".gitkeep" }
)

foreach ($sourceFile in $productionFiles) {
	$relativePath = $sourceFile.FullName.Substring($productionRoot.Length + 1)
	$destinationPath = Join-Path $stageRoot $relativePath
	$destinationDirectory = Split-Path -Parent $destinationPath
	New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
	Copy-Item -LiteralPath $sourceFile.FullName -Destination $destinationPath
}

$requiredProductionFiles = @(
	"descriptor.mod",
	"common/character_interactions/breedimp_exile_from_dynasty_interaction.txt",
	"common/modifiers/breedimp_dynasty_exile_modifiers.txt",
	"common/opinion_modifiers/breedimp_dynasty_exile_opinions.txt",
	"common/scripted_effects/breedimp_dynasty_exile_effects.txt",
	"common/scripted_triggers/breedimp_dynasty_exile_triggers.txt",
	"common/script_values/breedimp_dynasty_exile_values.txt",
	"localization/english/breedimp_dynasty_exile_l_english.yml",
	"localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml"
)
foreach ($relativePath in $requiredProductionFiles) {
	if (-not (Test-Path -LiteralPath (Join-Path $stageRoot $relativePath) -PathType Leaf)) {
		throw "Required Workshop production file is missing: $relativePath"
	}
}

foreach ($requiredDirectory in @("common", "localization")) {
	if (-not (Test-Path -LiteralPath (Join-Path $stageRoot $requiredDirectory) -PathType Container)) {
		throw "Required Workshop root directory is missing: $requiredDirectory"
	}
}
if (Test-Path -LiteralPath (Join-Path $stageRoot "MyCK3Mod")) {
	throw "Workshop staging contains an unintended extra MyCK3Mod layer."
}
if (Test-Path -LiteralPath (Join-Path $stageRoot "MyCK3Mod.mod")) {
	throw "Workshop staging must not contain an outer launcher .mod file."
}
if (Test-Path -LiteralPath (Join-Path $stageRoot "INSTALL.txt")) {
	throw "Workshop staging must not contain manual-install instructions."
}

$descriptorPath = Join-Path $stageRoot "descriptor.mod"
$descriptor = Get-Content -LiteralPath $descriptorPath -Raw -Encoding UTF8
foreach ($entry in @(
	"version=`"$Version`"",
	"name=`"Breed Improved`"",
	"supported_version=`"1.19.*`""
)) {
	if (-not $descriptor.Contains($entry)) {
		throw "Workshop descriptor is missing required metadata: $entry"
	}
}
if ($descriptor -match '(?m)^\s*path\s*=') {
	throw "Workshop descriptor must not contain a local path field."
}
if ($descriptor -match 'remote_file_id') {
	throw "Do not add a Workshop ID before the first upload assigns one."
}

$localisationFiles = @(
	Get-ChildItem -LiteralPath (Join-Path $stageRoot "localization") -Recurse -File -Filter "*.yml"
)
foreach ($file in $localisationFiles) {
	$bytes = [System.IO.File]::ReadAllBytes($file.FullName)
	if ($bytes.Length -lt 3 -or $bytes[0] -ne 0xEF -or $bytes[1] -ne 0xBB -or $bytes[2] -ne 0xBF) {
		throw "Workshop localisation file is not UTF-8 BOM: $($file.FullName)"
	}
}

$stagedFiles = @(Get-ChildItem -LiteralPath $stageRoot -Recurse -File -Force)
foreach ($file in $stagedFiles) {
	$relativePath = $file.FullName.Substring($stageRoot.Length + 1)
	if ($relativePath -match '(^|[\\/])(\.agents|docs|tests|logs?|saves?)([\\/]|$)') {
		throw "Development-only path found in Workshop staging: $relativePath"
	}
	if ($file.Name -match 'breedimp_test_') {
		throw "Test-only filename found in Workshop staging: $relativePath"
	}
	if ($file.Extension -in @(".txt", ".mod", ".yml")) {
		$content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
		if ($content -match '(?i)[A-Z]:[\\/]' -or $content -match '(?i)/(Users|home)/') {
			throw "Local absolute path found in Workshop staging: $relativePath"
		}
		if ($content -match 'breedimp_test_') {
			throw "Test-only content found in Workshop staging: $relativePath"
		}
	}
}

# Require a one-to-one file set and byte-identical production hashes.
$sourceMap = @{}
foreach ($sourceFile in $productionFiles) {
	$relativePath = $sourceFile.FullName.Substring($productionRoot.Length + 1)
	$sourceMap[$relativePath] = $sourceFile
}
$stageMap = @{}
foreach ($stagedFile in $stagedFiles) {
	$relativePath = $stagedFile.FullName.Substring($stageRoot.Length + 1)
	$stageMap[$relativePath] = $stagedFile
}

$allRelativePaths = @($sourceMap.Keys + $stageMap.Keys | Sort-Object -Unique)
foreach ($relativePath in $allRelativePaths) {
	if (-not $sourceMap.ContainsKey($relativePath)) {
		throw "Unexpected file in Workshop staging: $relativePath"
	}
	if (-not $stageMap.ContainsKey($relativePath)) {
		throw "Production file missing from Workshop staging: $relativePath"
	}
	$sourceFile = $sourceMap[$relativePath]
	$stagedFile = $stageMap[$relativePath]
	$sourceHash = (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash
	$stagedHash = (Get-FileHash -LiteralPath $stagedFile.FullName -Algorithm SHA256).Hash
	if ($sourceFile.Length -ne $stagedFile.Length -or $sourceHash -ne $stagedHash) {
		throw "Workshop staging file differs from production source: $relativePath"
	}
}

[PSCustomObject]@{
	Version = $Version
	ProductionRoot = $productionRoot
	WorkshopStage = $stageRoot
	ProductionFiles = $productionFiles.Count
	StagedFiles = $stagedFiles.Count
	HashComparison = "PASS"
	LocalisationBOM = "PASS"
	ContentRootLayout = "descriptor.mod + common/ + localization/"
}
