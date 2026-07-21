# Breed Improved Release Packaging Workflow

## Build command

From the repository root on Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\package_release.ps1 -Version 0.1.0
```

The process-level execution-policy override does not modify the machine or user PowerShell policy.

## Outputs

- Staging directory: `dist/staging/Breed-Improved-v0.1.0/`
- Release archive: `dist/Breed-Improved-v0.1.0.zip`
- Checksum record: `dist/Breed-Improved-v0.1.0.sha256`

The script rebuilds only those exact versioned outputs. It validates that the resolved staging path remains under `dist/` before removing an earlier staging copy.

## Packaging policy

The script copies an explicit allowlist:

- `MyCK3Mod.mod`;
- `MyCK3Mod/descriptor.mod`;
- the production Character Interaction, scripted trigger, scripted effect, scripted value, opinion modifier, and character modifier files;
- English and Simplified Chinese production localisation; and
- `packaging/INSTALL.txt` as the archive-root installation guide.

It does not copy the test harness, development skills, research, testing records, plans, repository metadata, logs, saves, empty-directory markers, or other source-tree files.

Before creating the ZIP, the script checks descriptor version/name/compatibility, absence of a Workshop ID, UTF-8 BOM on both localisation files, absence of `breedimp_test_`, and absence of local absolute paths. It then inspects ZIP entry names and writes the SHA-256 checksum.

## Launcher-path limitation

The verified repository launcher template uses `path="<LOCAL_MOD_PATH>"`. The package preserves that placeholder and requires the manual installer to replace it with the extracted content directory's absolute path. No unverified relative launcher path is generated. Steam Workshop upload behavior is not exercised by this workflow.
