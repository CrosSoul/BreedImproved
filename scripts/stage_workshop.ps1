param(
	[string]$Version = "0.1.0"
)

$ErrorActionPreference = "Stop"

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$productionRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "MyCK3Mod"))
$distRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "dist"))
$workshopRoot = [System.IO.Path]::GetFullPath((Join-Path $distRoot "workshop"))
$stageRoot = [System.IO.Path]::GetFullPath((Join-Path $workshopRoot "BreedImproved"))
$workshopIdConfigPath = Join-Path $repositoryRoot "docs/publishing/workshop_item_id.txt"
$expectedWorkshopId = "3769010534"

$workshopPrefix = $workshopRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if (-not $stageRoot.StartsWith($workshopPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
	throw "Refusing to use a staging path outside dist/workshop/."
}
if (-not (Test-Path -LiteralPath (Join-Path $productionRoot "descriptor.mod") -PathType Leaf)) {
	throw "Verified production Mod root is invalid: $productionRoot"
}
if (-not (Test-Path -LiteralPath $workshopIdConfigPath -PathType Leaf)) {
	throw "Workshop ID configuration is missing: $workshopIdConfigPath"
}

$configuredWorkshopId = [System.IO.File]::ReadAllText($workshopIdConfigPath).Trim()
if ([string]::IsNullOrWhiteSpace($configuredWorkshopId)) {
	throw "Workshop ID configuration is empty: $workshopIdConfigPath"
}
if ($configuredWorkshopId -ne $expectedWorkshopId) {
	throw "Configured Workshop ID '$configuredWorkshopId' does not match the approved item '$expectedWorkshopId'."
}

$sourceDescriptorPath = Join-Path $productionRoot "descriptor.mod"
$sourceDescriptor = Get-Content -LiteralPath $sourceDescriptorPath -Raw -Encoding UTF8
if ($sourceDescriptor -match '(?m)^\s*remote_file_id\s*=') {
	throw "Production descriptor must not contain remote_file_id; it is injected only into Workshop staging."
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
if (Test-Path -LiteralPath (Join-Path $stageRoot "INSTALL.txt")) {
	throw "Workshop staging must not contain manual-install instructions."
}

# Before applying the one authorized staging transform, require a one-to-one
# file set and byte-identical hashes for the complete production copy.
$preInjectionStagedFiles = @(Get-ChildItem -LiteralPath $stageRoot -Recurse -File -Force)
$sourceMap = @{}
foreach ($sourceFile in $productionFiles) {
	$relativePath = $sourceFile.FullName.Substring($productionRoot.Length + 1)
	$sourceMap[$relativePath] = $sourceFile
}
$preInjectionStageMap = @{}
foreach ($stagedFile in $preInjectionStagedFiles) {
	$relativePath = $stagedFile.FullName.Substring($stageRoot.Length + 1)
	$preInjectionStageMap[$relativePath] = $stagedFile
}

$allRelativePaths = @($sourceMap.Keys + $preInjectionStageMap.Keys | Sort-Object -Unique)
foreach ($relativePath in $allRelativePaths) {
	if (-not $sourceMap.ContainsKey($relativePath)) {
		throw "Unexpected file in Workshop staging: $relativePath"
	}
	if (-not $preInjectionStageMap.ContainsKey($relativePath)) {
		throw "Production file missing from Workshop staging: $relativePath"
	}
	$sourceFile = $sourceMap[$relativePath]
	$stagedFile = $preInjectionStageMap[$relativePath]
	$sourceHash = (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash
	$stagedHash = (Get-FileHash -LiteralPath $stagedFile.FullName -Algorithm SHA256).Hash
	if ($sourceFile.Length -ne $stagedFile.Length -or $sourceHash -ne $stagedHash) {
		throw "Workshop staging file differs from production source before descriptor injection: $relativePath"
	}
}

# Append the public Workshop association to the staged descriptor only. The
# production descriptor remains suitable for source and local development use.
$descriptorPath = Join-Path $stageRoot "descriptor.mod"
$sourceDescriptorBytes = [System.IO.File]::ReadAllBytes($sourceDescriptorPath)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$needsLeadingNewline = $sourceDescriptorBytes.Length -gt 0 -and $sourceDescriptorBytes[$sourceDescriptorBytes.Length - 1] -ne 0x0A
$descriptorSuffix = if ($needsLeadingNewline) {
	"`nremote_file_id=`"$configuredWorkshopId`"`n"
} else {
	"remote_file_id=`"$configuredWorkshopId`"`n"
}
$descriptorSuffixBytes = $utf8NoBom.GetBytes($descriptorSuffix)
$expectedStagedDescriptorBytes = New-Object byte[] ($sourceDescriptorBytes.Length + $descriptorSuffixBytes.Length)
[System.Buffer]::BlockCopy($sourceDescriptorBytes, 0, $expectedStagedDescriptorBytes, 0, $sourceDescriptorBytes.Length)
[System.Buffer]::BlockCopy($descriptorSuffixBytes, 0, $expectedStagedDescriptorBytes, $sourceDescriptorBytes.Length, $descriptorSuffixBytes.Length)
[System.IO.File]::WriteAllBytes($descriptorPath, $expectedStagedDescriptorBytes)

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

$remoteFileIdDeclarations = [regex]::Matches($descriptor, '(?m)^\s*remote_file_id\s*=')
if ($remoteFileIdDeclarations.Count -ne 1) {
	throw "Workshop descriptor must contain exactly one remote_file_id entry; found $($remoteFileIdDeclarations.Count)."
}
$remoteFileIdMatches = [regex]::Matches($descriptor, '(?m)^\s*remote_file_id\s*=\s*"([^"]+)"\s*$')
if ($remoteFileIdMatches.Count -ne 1) {
	throw "Workshop descriptor remote_file_id entry is malformed or duplicated."
}
$stagedWorkshopId = $remoteFileIdMatches[0].Groups[1].Value
if ($stagedWorkshopId -ne $expectedWorkshopId) {
	throw "Staged Workshop ID '$stagedWorkshopId' does not match the approved item '$expectedWorkshopId'."
}

$actualStagedDescriptorBytes = [System.IO.File]::ReadAllBytes($descriptorPath)
if ($actualStagedDescriptorBytes.Length -ne $expectedStagedDescriptorBytes.Length) {
	throw "Staged descriptor contains an unauthorized difference after remote_file_id injection."
}
for ($index = 0; $index -lt $expectedStagedDescriptorBytes.Length; $index++) {
	if ($actualStagedDescriptorBytes[$index] -ne $expectedStagedDescriptorBytes[$index]) {
		throw "Staged descriptor contains an unauthorized difference after remote_file_id injection."
	}
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
$outerModFiles = @(
	$stagedFiles | Where-Object {
		$relativePath = $_.FullName.Substring($stageRoot.Length + 1).Replace("\", "/")
		$_.Extension -eq ".mod" -and $relativePath -ne "descriptor.mod"
	}
)
if ($outerModFiles.Count -ne 0) {
	throw "Workshop staging must not contain an outer launcher .mod file: $($outerModFiles[0].FullName)"
}

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

# After descriptor injection, retain one-to-one file coverage and require all
# gameplay/localisation files to remain byte-identical to production.
$stageMap = @{}
foreach ($stagedFile in $stagedFiles) {
	$relativePath = $stagedFile.FullName.Substring($stageRoot.Length + 1)
	$stageMap[$relativePath] = $stagedFile
}
$allRelativePaths = @($sourceMap.Keys + $stageMap.Keys | Sort-Object -Unique)
foreach ($relativePath in $allRelativePaths) {
	if (-not $sourceMap.ContainsKey($relativePath)) {
		throw "Unexpected file in final Workshop staging: $relativePath"
	}
	if (-not $stageMap.ContainsKey($relativePath)) {
		throw "Production file missing from final Workshop staging: $relativePath"
	}
	if ($relativePath -eq "descriptor.mod") {
		continue
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
	WorkshopItemId = $configuredWorkshopId
	RemoteFileIdCount = $remoteFileIdDeclarations.Count
	ProductionFiles = $productionFiles.Count
	StagedFiles = $stagedFiles.Count
	HashComparison = "PASS (all files before injection; all gameplay/localisation files after injection)"
	DescriptorTransform = "PASS (exact remote_file_id injection only)"
	LocalisationBOM = "PASS"
	ContentRootLayout = "descriptor.mod + common/ + localization/"
}
