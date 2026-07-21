param(
	[string]$Version = "0.1.0"
)

$ErrorActionPreference = "Stop"

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$distRoot = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot "dist"))
$stageRoot = [System.IO.Path]::GetFullPath((Join-Path $distRoot "staging/Breed-Improved-v$Version"))
$zipPath = [System.IO.Path]::GetFullPath((Join-Path $distRoot "Breed-Improved-v$Version.zip"))
$checksumPath = [System.IO.Path]::GetFullPath((Join-Path $distRoot "Breed-Improved-v$Version.sha256"))

$distPrefix = $distRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
if (-not $stageRoot.StartsWith($distPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
	throw "Refusing to use a staging path outside dist/."
}

New-Item -ItemType Directory -Path $distRoot -Force | Out-Null

if (Test-Path -LiteralPath $stageRoot) {
	Remove-Item -LiteralPath $stageRoot -Recurse -Force
}
if (Test-Path -LiteralPath $zipPath) {
	Remove-Item -LiteralPath $zipPath -Force
}
if (Test-Path -LiteralPath $checksumPath) {
	Remove-Item -LiteralPath $checksumPath -Force
}

$productionFiles = @(
	"MyCK3Mod.mod",
	"MyCK3Mod/descriptor.mod",
	"MyCK3Mod/common/character_interactions/breedimp_exile_from_dynasty_interaction.txt",
	"MyCK3Mod/common/modifiers/breedimp_dynasty_exile_modifiers.txt",
	"MyCK3Mod/common/opinion_modifiers/breedimp_dynasty_exile_opinions.txt",
	"MyCK3Mod/common/scripted_effects/breedimp_dynasty_exile_effects.txt",
	"MyCK3Mod/common/scripted_triggers/breedimp_dynasty_exile_triggers.txt",
	"MyCK3Mod/common/script_values/breedimp_dynasty_exile_values.txt",
	"MyCK3Mod/localization/english/breedimp_dynasty_exile_l_english.yml",
	"MyCK3Mod/localization/simp_chinese/breedimp_dynasty_exile_l_simp_chinese.yml"
)

foreach ($relativePath in $productionFiles) {
	$sourcePath = Join-Path $repositoryRoot $relativePath
	if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
		throw "Required production file is missing: $relativePath"
	}

	$destinationPath = Join-Path $stageRoot $relativePath
	$destinationDirectory = Split-Path -Parent $destinationPath
	New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
	Copy-Item -LiteralPath $sourcePath -Destination $destinationPath
}

$installationSource = Join-Path $repositoryRoot "packaging/INSTALL.txt"
$installationDestination = Join-Path $stageRoot "INSTALL.txt"
Copy-Item -LiteralPath $installationSource -Destination $installationDestination

$rootDescriptor = Get-Content -LiteralPath (Join-Path $stageRoot "MyCK3Mod.mod") -Raw -Encoding UTF8
$contentDescriptor = Get-Content -LiteralPath (Join-Path $stageRoot "MyCK3Mod/descriptor.mod") -Raw -Encoding UTF8

$requiredRootMetadata = @(
	"version=`"$Version`"",
	"name=`"Breed Improved`"",
	"supported_version=`"1.19.*`"",
	"path=`"<LOCAL_MOD_PATH>`""
)
foreach ($entry in $requiredRootMetadata) {
	if (-not $rootDescriptor.Contains($entry)) {
		throw "Root launcher descriptor is missing required metadata: $entry"
	}
}

$requiredContentMetadata = @(
	"version=`"$Version`"",
	"name=`"Breed Improved`"",
	"supported_version=`"1.19.*`""
)
foreach ($entry in $requiredContentMetadata) {
	if (-not $contentDescriptor.Contains($entry)) {
		throw "Content descriptor is missing required metadata: $entry"
	}
}

if ($contentDescriptor -match '(?m)^\s*path\s*=') {
	throw "The content descriptor must not contain a local path field."
}
if (($rootDescriptor + $contentDescriptor) -match 'remote_file_id') {
	throw "A Workshop ID must not exist before the first Workshop upload."
}

$localisationFiles = Get-ChildItem -LiteralPath (Join-Path $stageRoot "MyCK3Mod/localization") -Recurse -File -Filter "*.yml"
foreach ($file in $localisationFiles) {
	$bytes = [System.IO.File]::ReadAllBytes($file.FullName)
	if ($bytes.Length -lt 3 -or $bytes[0] -ne 0xEF -or $bytes[1] -ne 0xBB -or $bytes[2] -ne 0xBF) {
		throw "Localisation file is not UTF-8 BOM: $($file.FullName)"
	}
}

$stagedFiles = Get-ChildItem -LiteralPath $stageRoot -Recurse -File
foreach ($file in $stagedFiles) {
	if ($file.Name -match 'breedimp_test_') {
		throw "Test-only identifier found in staging: $($file.FullName)"
	}
	if ($file.Extension -in @(".txt", ".mod", ".yml")) {
		$content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
		if ($content -match '(?i)[A-Z]:[\\/]' -or $content -match '(?i)/(Users|home)/') {
			throw "Local absolute path found in staging: $($file.FullName)"
		}
		if ($content -match 'breedimp_test_') {
			throw "Test-only identifier found in staging content: $($file.FullName)"
		}
	}
}

Compress-Archive -Path (Join-Path $stageRoot "*") -DestinationPath $zipPath -CompressionLevel Optimal

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
	$archiveEntries = @($archive.Entries | ForEach-Object { $_.FullName })
	if ($archiveEntries -match 'breedimp_test_') {
		throw "Test-only identifier found in release archive."
	}
	if ($archiveEntries -match '(^|[\\/])(\.git|\.agents|tests|docs[\\/]research|docs[\\/]testing)([\\/]|$)') {
		throw "Development-only path found in release archive."
	}
}
finally {
	$archive.Dispose()
}

$hash = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
Set-Content -LiteralPath $checksumPath -Value "$hash  Breed-Improved-v$Version.zip" -Encoding ASCII

[PSCustomObject]@{
	Version = $Version
	Stage = $stageRoot
	Archive = $zipPath
	ChecksumFile = $checksumPath
	SHA256 = $hash
	Files = $stagedFiles.Count
}
