# Ray — Breed Improved v0.2.0 Workshop Update Procedure

The final runtime gates and Jay/Boss approval are complete. Confirm that `docs/publishing/v0.2.0_release_checklist.md` still says `READY FOR RAY UPLOAD` and that no production file has changed before beginning the upload.

This procedure updates the existing Workshop item. Never create a new Mod entry or Workshop item.

## Files to use

- Workshop item: `3769010534`
- Workshop page: https://steamcommunity.com/sharedfiles/filedetails/?id=3769010534
- Staging directory: `D:/Documents/GitHub/MyCK3Mod/dist/workshop/BreedImproved`
- English description: `docs/publishing/steam_workshop_en.md`
- Simplified Chinese description: `docs/publishing/steam_workshop_zh.md`
- Short update note: `docs/publishing/workshop_update_v0.2.0.txt`
- Internal manifest: `dist/workshop/BreedImproved.manifest.json`

## Upload steps

1. Close CK3 if it is running.
2. Disable the local repository-path development Mod in the release playset, or use a separate playset that does not enable it.
3. Confirm that the final runtime gates and Jay/Boss approval are recorded.
4. From the reviewed current working tree, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\stage_workshop.ps1 -Version 0.2.0`.
5. Continue only if the script exits successfully and `dist/workshop/BreedImproved.manifest.json` exists.
6. Open the Paradox Launcher Mod upload tool.
7. Select the existing **Breed Improved** entry associated with Workshop item `3769010534`.
8. Confirm the selected entry is an update to `3769010534`, not **Create Mod** or a new Workshop item.
9. Select `D:/Documents/GitHub/MyCK3Mod/dist/workshop/BreedImproved` as the upload content directory.
10. Confirm that its root directly contains `descriptor.mod`, `thumbnail.png`, `common/`, `events/`, and `localization/`.
11. Confirm the staged descriptor contains exactly one `remote_file_id="3769010534"` and no `path`.
12. Confirm the Launcher uses the existing staged `thumbnail.png`; do not replace it during this update.
13. If Steam exposes language-specific description fields, paste `steam_workshop_en.md` into English and `steam_workshop_zh.md` into Simplified Chinese. Preserve the BBCode in both fields.
14. If the upload tool exposes only one shared description field, use `steam_workshop_en.md` as the canonical upload description. Do not concatenate, overwrite, or improvise a bilingual body. Keep `steam_workshop_zh.md` ready for a separate Simplified Chinese field if Steam exposes one later; if Chinese listing text is required before visibility and no such field is available, stop and report that UI limitation.
15. Paste the reviewed text from `workshop_update_v0.2.0.txt` into the update-note field.
16. Review the item title, version `0.2.0`, CK3 compatibility `1.19.*`, Workshop ID, description, and thumbnail one final time.
17. Ray performs the upload.
18. If Steam requests a visibility decision, keep or set `Public` only after the visibility change is approved. Do not infer approval from this document.
19. Wait for Steam processing to finish; do not immediately assume the CDN copy is current.
20. Exit the Launcher after upload.
21. Open the Workshop page and verify the item ID is still `3769010534`; confirm the description, thumbnail, visibility, and update time.
22. Continue with `docs/publishing/v0.2.0_post_publish_checklist.md`.

## Duplicate-item prevention

- Never select **Create Mod** for this update.
- Never remove or replace `remote_file_id="3769010534"` in the staged descriptor.
- Never upload the repository root, `MyCK3Mod.mod`, `tests/`, or a local launcher database.
- The Launcher-managed outer `BreedImproved.mod` under the CK3 user Documents directory is not a repository file and must not be generated or committed here.
