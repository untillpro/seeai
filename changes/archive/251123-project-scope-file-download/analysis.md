# Analysis: Project scope installation should download files

## Specifications to create

None

## Specifications to update

- [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Update Step 3 section to document that project scope downloads files to specs/agents/seeai/
  - [x] Remove or clarify any language suggesting files "remain" in specs/agents/seeai/ without being downloaded
  - [x] Add validation step that verifies all required files were successfully downloaded
  - [x] Document overwrite behavior for existing files in project scope
  - [x] Fix incorrect claim at line 121: "files are copied from specs/agents/seeai/" - files are downloaded from GitHub (or copied from local source with -l flag), not from specs/agents/seeai/
- [specs/models/mconf-files/models.md](../../../specs/models/mconf-files/models.md)
  - [x] Update Source Location section to clarify that files are downloaded during installation
  - [x] Clarify that the directory structure shown is the result of installation, not pre-existing
  - [x] Fix incorrect claim at line 29: "files are copied from specs/agents/seeai/" - files are downloaded from GitHub (or copied from local source with -l flag), not from specs/agents/seeai/
- [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [x] Fix incorrect claim at line 27: "In user scope, files are copied to agent-specific directories" - files are downloaded from GitHub (or copied from local source with -l flag) to agent-specific directories, not copied from specs/agents/seeai/

## Affected files and tests

- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Remove the else block at lines 692-695 that skips file installation for project scope
  - [x] Add file download/copy logic for project scope (similar to user scope)
  - [x] Create specs/agents/seeai/ directory if it doesn't exist (mkdir -p)
  - [x] For local mode: copy files from SRC_DIR to specs/agents/seeai/
  - [x] For remote mode: download files from BASE_URL to specs/agents/seeai/
  - [x] Add validation after download to verify all files in files_to_install array exist
  - [x] If validation fails, print error message listing missing files and exit with non-zero status
  - [x] Update show_install_preview to clarify that files will be downloaded to specs/agents/seeai/
- update: [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Add test specification for project scope file download validation
  - [x] Document expected behavior when files are missing after download
- update: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [x] Update setup function to NOT pre-populate specs/agents/seeai/ with fixture files
  - [x] Verify that installation creates all required files in specs/agents/seeai/
  - [x] Add test case for installation failure when download fails
  - [x] Add test case for overwriting existing files in specs/agents/seeai/
- test: Project scope installation tests
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify file download works correctly

## Notes

- Current behavior assumes files already exist in specs/agents/seeai/, which is incorrect for fresh installations
- The script should download files to specs/agents/seeai/ in project scope, just like it downloads to user directories in user scope
- Validation is critical to prevent silent failures where only seeai-version.yml is created without actual Action/Spec files
- Overwriting existing files ensures version consistency and prevents stale file issues
- Tests currently pre-populate fixture files, masking the bug - they need to verify actual download behavior
- IMPORTANT: Documentation incorrectly states that user scope files are "copied from specs/agents/seeai/" - this is wrong. Files are downloaded from GitHub (or copied from local source with -l flag) for BOTH user and project scope. The specs/agents/seeai/ directory is NOT a source for user scope installations
