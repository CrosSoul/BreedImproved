# Breed Improved Workshop Staging Workflow

## Purpose

Steam Workshop is the sole supported end-user distribution channel. This workflow creates deterministic upload content; it does not create a ZIP, installer, local launcher entry, checksum, or Workshop upload.

## Build command

From the repository root on Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\stage_workshop.ps1 -Version 0.1.0
```

The process-level execution-policy override does not modify the machine or user PowerShell policy.

## Source and output

- Verified production root: `MyCK3Mod/`
- Generated Workshop staging root: `dist/workshop/BreedImproved/`

The staging root directly contains:

```text
descriptor.mod
common/
localization/
```

The script completely deletes and recreates the staging root on every run. It recursively copies all production files except repository-only `.gitkeep` markers, then requires identical source and staged file sets, sizes, and SHA-256 hashes.

## Validation gates

The workflow verifies:

- version `0.1.0`;
- `supported_version="1.19.*"`;
- no local `path` field;
- no pre-upload `remote_file_id`;
- required production gameplay and localisation files;
- English and Simplified Chinese UTF-8 BOM;
- no outer `.mod` file or `INSTALL.txt`;
- no extra `MyCK3Mod/` layer;
- no development directories, local absolute paths, or `breedimp_test_` identifiers; and
- byte-identical production/staging hashes.

`dist/` is generated and Git-ignored. The staging directory is an internal upload input, not a public download or supported manual-install package.
