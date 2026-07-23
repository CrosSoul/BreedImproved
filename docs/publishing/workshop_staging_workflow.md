# Breed Improved Workshop Staging Workflow

## Purpose

Steam Workshop is the sole supported end-user distribution channel. This workflow creates deterministic upload content; it does not create a ZIP, installer, local launcher entry, checksum, or Workshop upload.

The first upload created Workshop item `3769010534`. All future Breed Improved updates must reuse that item. The repository-owned association is stored in `docs/publishing/workshop_item_id.txt`; it is public publishing metadata, not a secret.

## Build command

From the repository root on Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\stage_workshop.ps1 -Version 0.2.0
```

The process-level execution-policy override does not modify the machine or user PowerShell policy.

## Source and output

- Verified production root: `MyCK3Mod/`
- Generated Workshop staging root: `dist/workshop/BreedImproved/`

The staging root directly contains:

```text
descriptor.mod
thumbnail.png
common/
events/
localization/
```

The script completely deletes and recreates the staging root on every run. It requires the production root to match the frozen v0.2.0 allowlist of 16 files; a missing or unexpected production file fails the build. It then copies those files directly from `MyCK3Mod/` and copies the fixed publishing asset from `assets/workshop/thumbnail.png` to the staging root. The thumbnail is Workshop publishing metadata, not a gameplay file and not part of the production Mod root.

The script verifies a byte-identical production copy and publishing-asset copy before applying the only authorized descriptor transform: adding exactly one `remote_file_id="3769010534"` to the staged `descriptor.mod`.

After injection, every gameplay and localisation file must remain byte-identical to production. The staged descriptor must equal the production descriptor plus only the exact Workshop association line. The production descriptor remains free of `remote_file_id` and local `path` fields.

After all validation passes, the script writes the internal release manifest to:

```text
dist/workshop/BreedImproved.manifest.json
```

The manifest is outside the upload root. It records the release and Workshop identifiers, file counts, and a stable path-sorted list of every staged file with its relative path, byte size, SHA-256, category, and role. The 16 production files use the category `gameplay production file`; `thumbnail.png` alone uses `publishing asset`. A stale manifest is deleted before each build and a new one is written only after staging validation succeeds.

## Validation gates

The workflow verifies:

- version `0.2.0`;
- `supported_version="1.19.*"`;
- no local `path` field;
- configured Workshop ID exists and is exactly `3769010534`;
- exactly one staged `remote_file_id="3769010534"` entry;
- no missing, duplicate, malformed, or different staged Workshop ID;
- required production gameplay and localisation files;
- an exact frozen 16-file production allowlist, with no missing or unexpected payload file;
- required `assets/workshop/thumbnail.png` source and staged `thumbnail.png`;
- PNG signature, `IHDR` header, exact `512×512` dimensions, non-empty byte size, and exact source/staging thumbnail size and SHA-256 match;
- English and Simplified Chinese UTF-8 BOM;
- no outer `.mod` file or `INSTALL.txt`;
- no extra `MyCK3Mod/` layer;
- no development directories, local absolute paths, or `breedimp_test_` identifiers; and
- byte-identical production/publishing-source and staging hashes before descriptor injection; and
- byte-identical gameplay, localisation, and thumbnail hashes after injection, with only the exact descriptor association permitted to differ.
- a deterministic internal manifest covering 16 production files and one publishing asset.

`dist/` is generated and Git-ignored. The staging directory is an internal upload input, not a public download or supported manual-install package.

## Updating the existing Workshop item

1. Run `scripts/stage_workshop.ps1` to prepare and validate the content.
2. In the CK3 Launcher, select the existing **Breed Improved** entry associated with Workshop item `3769010534`.
3. Use the Launcher's update workflow only after the separate publishing approval is granted.

Do not create a new Mod entry for an update; doing so risks creating a duplicate Workshop item. The local outer `BreedImproved.mod` under the user's CK3 Documents directory is Launcher-managed, machine-specific, and must not be generated or committed by this repository. The staged `descriptor.mod` must retain `remote_file_id="3769010534"` so the Launcher associates future uploads with the existing item.

The existence of this Workshop item does not establish that its visibility is public. Ray must separately confirm any visibility change.
