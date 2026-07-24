param(
	[string]$Version = "0.3.0"
)

$ErrorActionPreference = "Stop"

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$productionRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "MyCK3Mod"))
$distRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "dist"))
$workshopRoot = [System.IO.Path]::GetFullPath((Join-Path $distRoot "workshop"))
$stageRoot = [System.IO.Path]::GetFullPath((Join-Path $workshopRoot "BreedImproved"))
$manifestPath = [System.IO.Path]::GetFullPath((Join-Path $workshopRoot "BreedImproved.manifest.json"))
$workshopIdConfigPath = Join-Path $repositoryRoot "docs/publishing/workshop_item_id.txt"
$expectedWorkshopId = "3769010534"
$thumbnailSourcePath = Join-Path $repositoryRoot "assets/workshop/thumbnail.png"
$thumbnailStagePath = Join-Path $stageRoot "thumbnail.png"

function Get-PngMetadata {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Path
	)

	if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
		throw "Required Workshop thumbnail is missing: $Path"
	}

	$bytes = [System.IO.File]::ReadAllBytes($Path)
	if ($bytes.Length -lt 24) {
		throw "Workshop thumbnail is empty or too small to be a valid PNG: $Path"
	}

	$pngSignature = @(0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
	for ($index = 0; $index -lt $pngSignature.Count; $index++) {
		if ($bytes[$index] -ne $pngSignature[$index]) {
			throw "Workshop thumbnail does not have a valid PNG signature: $Path"
		}
	}
	if ([System.Text.Encoding]::ASCII.GetString($bytes, 12, 4) -ne "IHDR") {
		throw "Workshop thumbnail does not contain the required PNG IHDR header: $Path"
	}

	$width = [System.Net.IPAddress]::NetworkToHostOrder([System.BitConverter]::ToInt32($bytes, 16))
	$height = [System.Net.IPAddress]::NetworkToHostOrder([System.BitConverter]::ToInt32($bytes, 20))
	if ($width -le 0 -or $height -le 0) {
		throw "Workshop thumbnail has invalid PNG dimensions: $Path"
	}

	[PSCustomObject]@{
		Path = $Path
		Bytes = $bytes.Length
		Width = $width
		Height = $height
		SHA256 = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
	}
}

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

$thumbnailSourceMetadata = Get-PngMetadata -Path $thumbnailSourcePath
if ($thumbnailSourceMetadata.Width -ne 512 -or $thumbnailSourceMetadata.Height -ne 512) {
	throw "Workshop thumbnail must be exactly 512x512 pixels: $thumbnailSourcePath"
}

# Release payload allowlist. Any file in the production Mod root must either be
# listed here or be a repository-only .gitkeep marker. This prevents accidental
# diagnostics, prototypes, or developer files from reaching Workshop staging.
$requiredProductionFiles = @(
	"descriptor.mod",
	"common/character_interactions/breedimp_dynasty_cleanup_protection_interactions.txt",
	"common/character_interactions/breedimp_exile_from_dynasty_interaction.txt",
	"common/decisions/breedimp_dynasty_cleanup_decisions.txt",
	"common/decisions/breedimp_dynasty_matchmaking_decisions.txt",
	"common/modifiers/breedimp_dynasty_exile_modifiers.txt",
	"common/on_action/breedimp_dynasty_matchmaking_on_actions.txt",
	"common/opinion_modifiers/breedimp_dynasty_exile_opinions.txt",
	"common/script_values/breedimp_dynasty_exile_values.txt",
	"common/script_values/breedimp_dynasty_matchmaking_values.txt",
	"common/scripted_effects/breedimp_dynasty_cleanup_effects.txt",
	"common/scripted_effects/breedimp_dynasty_exile_effects.txt",
	"common/scripted_effects/breedimp_dynasty_matchmaking_candidate_effects.txt",
	"common/scripted_effects/breedimp_dynasty_matchmaking_lifecycle_effects.txt",
	"common/scripted_effects/breedimp_dynasty_matchmaking_plan_effects.txt",
	"common/scripted_effects/breedimp_dynasty_matchmaking_relationship_effects.txt",
	"common/scripted_triggers/breedimp_dynasty_cleanup_triggers.txt",
	"common/scripted_triggers/breedimp_dynasty_exile_triggers.txt",
	"common/scripted_triggers/breedimp_dynasty_matchmaking_candidate_triggers.txt",
	"common/scripted_triggers/breedimp_dynasty_matchmaking_lifecycle_triggers.txt",
	"common/scripted_triggers/breedimp_dynasty_matchmaking_plan_triggers.txt",
	"events/breedimp_dynasty_cleanup_events.txt",
	"events/breedimp_dynasty_matchmaking_events.txt",
	"localization/english/breedimp_dynasty_cleanup_l_english.yml",
	"localization/english/breedimp_dynasty_exile_l_english.yml",
	"localization/english/breedimp_dynasty_matchmaking_l_english.yml",
	"localization/simp_chinese/breedimp_dynasty_cleanup_l_simp_chinese.yml",
	"localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml",
	"localization/simp_chinese/breedimp_dynasty_matchmaking_l_simp_chinese.yml"
)

$productionFiles = @(
	Get-ChildItem -LiteralPath $productionRoot -Recurse -File -Force |
		Where-Object { $_.Name -ne ".gitkeep" }
)
$productionRelativePaths = @(
	$productionFiles |
		ForEach-Object { $_.FullName.Substring($productionRoot.Length + 1).Replace("\", "/") }
)
$unexpectedProductionFiles = @(
	$productionRelativePaths | Where-Object { $_ -notin $requiredProductionFiles }
)
$missingProductionFiles = @(
	$requiredProductionFiles | Where-Object { $_ -notin $productionRelativePaths }
)
if ($unexpectedProductionFiles.Count -ne 0) {
	throw "Unexpected file in production payload: $($unexpectedProductionFiles[0])"
}
if ($missingProductionFiles.Count -ne 0) {
	throw "Required production file is missing: $($missingProductionFiles[0])"
}

$sourceDescriptorPath = Join-Path $productionRoot "descriptor.mod"
$sourceDescriptor = Get-Content -LiteralPath $sourceDescriptorPath -Raw -Encoding UTF8
if ($sourceDescriptor -match '(?m)^\s*remote_file_id\s*=') {
	throw "Production descriptor must not contain remote_file_id; it is injected only into Workshop staging."
}
if ($sourceDescriptor -match '(?m)^\s*path\s*=') {
	throw "Production descriptor must not contain a local path field."
}
foreach ($entry in @(
	"version=`"$Version`"",
	"name=`"Breed Improved`"",
	"supported_version=`"1.19.*`""
)) {
	if (-not $sourceDescriptor.Contains($entry)) {
		throw "Production descriptor is missing required metadata: $entry"
	}
}
if (-not ($sourceDescriptor -match '(?m)^\s*tags\s*=\s*\{\s*("Utilities"\s+"Gameplay"|"Gameplay"\s+"Utilities")\s*\}')) {
	throw 'Production descriptor must contain tags { "Utilities" "Gameplay" } in either order.'
}

New-Item -ItemType Directory -Path $workshopRoot -Force | Out-Null

# A manifest is proof of a fully successful build. Remove any stale copy before
# rebuilding and write a new one only after every staging validation passes.
if (Test-Path -LiteralPath $manifestPath) {
	Remove-Item -LiteralPath $manifestPath -Force
}

# Workshop staging is never incremental.
if (Test-Path -LiteralPath $stageRoot) {
	Remove-Item -LiteralPath $stageRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $stageRoot | Out-Null

foreach ($sourceFile in $productionFiles) {
	$relativePath = $sourceFile.FullName.Substring($productionRoot.Length + 1)
	$destinationPath = Join-Path $stageRoot $relativePath
	$destinationDirectory = Split-Path -Parent $destinationPath
	New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
	Copy-Item -LiteralPath $sourceFile.FullName -Destination $destinationPath
}

# The Workshop thumbnail is a publishing asset, not a gameplay file. Keep its
# repository source outside the CK3 production Mod root and copy it explicitly.
Copy-Item -LiteralPath $thumbnailSourcePath -Destination $thumbnailStagePath
$thumbnailStageMetadata = Get-PngMetadata -Path $thumbnailStagePath
if (
	$thumbnailStageMetadata.Bytes -ne $thumbnailSourceMetadata.Bytes -or
	$thumbnailStageMetadata.Width -ne $thumbnailSourceMetadata.Width -or
	$thumbnailStageMetadata.Height -ne $thumbnailSourceMetadata.Height -or
	$thumbnailStageMetadata.SHA256 -ne $thumbnailSourceMetadata.SHA256
) {
	throw "Staged Workshop thumbnail does not match the repository publishing asset."
}

foreach ($relativePath in $requiredProductionFiles) {
	if (-not (Test-Path -LiteralPath (Join-Path $stageRoot $relativePath) -PathType Leaf)) {
		throw "Required Workshop production file is missing: $relativePath"
	}
}

foreach ($requiredDirectory in @("common", "events", "localization")) {
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

# Before applying the one authorized descriptor transform, require a one-to-one
# file set and byte-identical hashes for the production copy and publishing asset.
$preInjectionStagedFiles = @(Get-ChildItem -LiteralPath $stageRoot -Recurse -File -Force)
$sourceMap = @{}
foreach ($sourceFile in $productionFiles) {
	$relativePath = $sourceFile.FullName.Substring($productionRoot.Length + 1)
	$sourceMap[$relativePath] = $sourceFile
}
$sourceMap["thumbnail.png"] = Get-Item -LiteralPath $thumbnailSourcePath
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
if (-not ($descriptor -match '(?m)^\s*tags\s*=\s*\{\s*("Utilities"\s+"Gameplay"|"Gameplay"\s+"Utilities")\s*\}')) {
	throw 'Workshop descriptor must contain tags { "Utilities" "Gameplay" } in either order.'
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
# gameplay/localisation files and the publishing asset to remain byte-identical.
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

$roleByPath = @{
	"descriptor.mod" = "descriptor"
	"thumbnail.png" = "workshop thumbnail"
	"common/character_interactions/breedimp_dynasty_cleanup_protection_interactions.txt" = "Phase 2 protection interactions"
	"common/character_interactions/breedimp_exile_from_dynasty_interaction.txt" = "Phase 1 individual interaction"
	"common/decisions/breedimp_dynasty_cleanup_decisions.txt" = "Phase 2 decision"
	"common/decisions/breedimp_dynasty_matchmaking_decisions.txt" = "Phase 3 decision"
	"common/modifiers/breedimp_dynasty_exile_modifiers.txt" = "shared exile modifier"
	"common/on_action/breedimp_dynasty_matchmaking_on_actions.txt" = "Phase 3 lifecycle on_actions"
	"common/opinion_modifiers/breedimp_dynasty_exile_opinions.txt" = "shared exile opinion modifier"
	"common/script_values/breedimp_dynasty_exile_values.txt" = "Phase 1 interaction cost value"
	"common/script_values/breedimp_dynasty_matchmaking_values.txt" = "Phase 3 ranking values"
	"common/scripted_effects/breedimp_dynasty_cleanup_effects.txt" = "Phase 2 effects"
	"common/scripted_effects/breedimp_dynasty_exile_effects.txt" = "shared exile effect"
	"common/scripted_effects/breedimp_dynasty_matchmaking_candidate_effects.txt" = "Phase 3 candidate effects"
	"common/scripted_effects/breedimp_dynasty_matchmaking_lifecycle_effects.txt" = "Phase 3 lifecycle effects"
	"common/scripted_effects/breedimp_dynasty_matchmaking_plan_effects.txt" = "Phase 3 plan and preflight effects"
	"common/scripted_effects/breedimp_dynasty_matchmaking_relationship_effects.txt" = "Phase 3 relationship execution effects"
	"common/scripted_triggers/breedimp_dynasty_cleanup_triggers.txt" = "Phase 2 triggers"
	"common/scripted_triggers/breedimp_dynasty_exile_triggers.txt" = "shared exile triggers"
	"common/scripted_triggers/breedimp_dynasty_matchmaking_candidate_triggers.txt" = "Phase 3 candidate triggers"
	"common/scripted_triggers/breedimp_dynasty_matchmaking_lifecycle_triggers.txt" = "Phase 3 lifecycle triggers"
	"common/scripted_triggers/breedimp_dynasty_matchmaking_plan_triggers.txt" = "Phase 3 plan triggers"
	"events/breedimp_dynasty_cleanup_events.txt" = "Phase 2 events"
	"events/breedimp_dynasty_matchmaking_events.txt" = "Phase 3 events"
	"localization/english/breedimp_dynasty_cleanup_l_english.yml" = "Phase 2 English localisation"
	"localization/english/breedimp_dynasty_exile_l_english.yml" = "Phase 1 English localisation"
	"localization/english/breedimp_dynasty_matchmaking_l_english.yml" = "Phase 3 English localisation"
	"localization/simp_chinese/breedimp_dynasty_cleanup_l_simp_chinese.yml" = "Phase 2 Simplified Chinese localisation"
	"localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml" = "Phase 1 Simplified Chinese localisation"
	"localization/simp_chinese/breedimp_dynasty_matchmaking_l_simp_chinese.yml" = "Phase 3 Simplified Chinese localisation"
}

$sourceRevision = ""
try {
	$gitOutput = & git -C $repositoryRoot rev-parse HEAD 2>$null
	if ($LASTEXITCODE -eq 0 -and $gitOutput) {
		$sourceRevision = $gitOutput.Trim()
	}
} catch {
	$sourceRevision = ""
}

$manifestFiles = @(
	foreach ($relativePath in @($stageMap.Keys | Sort-Object)) {
		$normalizedPath = $relativePath.Replace("\", "/")
		$stagedFile = $stageMap[$relativePath]
		[ordered]@{
			path = $normalizedPath
			size_bytes = [int64]$stagedFile.Length
			sha256 = (Get-FileHash -LiteralPath $stagedFile.FullName -Algorithm SHA256).Hash
			category = if ($normalizedPath -eq "thumbnail.png") { "publishing asset" } else { "gameplay production file" }
			role = $roleByPath[$normalizedPath]
		}
	}
)
$manifest = [ordered]@{
	schema_version = 1
	release_version = $Version
	supported_version = "1.19.*"
	workshop_item_id = $configuredWorkshopId
	staging_root = "dist/workshop/BreedImproved"
	source_revision = if ($sourceRevision) { $sourceRevision } else { "unknown" }
	production_file_count = $productionFiles.Count
	publishing_asset_count = 1
	staged_file_count = $stagedFiles.Count
	files = $manifestFiles
}
$manifestJson = ($manifest | ConvertTo-Json -Depth 5).Replace("`r`n", "`n") + "`n"
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, $utf8NoBom)
$manifestHash = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash

[PSCustomObject]@{
	Version = $Version
	ProductionRoot = $productionRoot
	WorkshopStage = $stageRoot
	WorkshopItemId = $configuredWorkshopId
	RemoteFileIdCount = $remoteFileIdDeclarations.Count
	ProductionFiles = $productionFiles.Count
	PublishingAssets = 1
	StagedFiles = $stagedFiles.Count
	Manifest = $manifestPath
	ManifestSHA256 = $manifestHash
	HashComparison = "PASS (production files and publishing asset)"
	DescriptorTransform = "PASS (exact remote_file_id injection only)"
	ThumbnailValidation = "PASS (PNG, $($thumbnailStageMetadata.Width)x$($thumbnailStageMetadata.Height), $($thumbnailStageMetadata.Bytes) bytes)"
	ThumbnailSHA256 = $thumbnailStageMetadata.SHA256
	LocalisationBOM = "PASS"
	ContentRootLayout = "descriptor.mod + thumbnail.png + common/ + events/ + localization/"
}
