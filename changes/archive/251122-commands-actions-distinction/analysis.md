# Analysis: Clear distinction between Commands and Actions

## Specifications to create

None - all necessary specifications already exist.

## Specifications to update

- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Add test specification for Commands vs Actions distinction
  - [x] Document that user scope tests should verify only Commands (design.md, gherkin.md) are installed
  - [x] Document that project scope tests should verify all 6 files (Commands + Actions) are installed

## Affected files and tests

- update: [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Update Source Files section to clarify which files are Commands (design.md, gherkin.md) vs Actions-only (register.md, analyze.md, implement.md, archive.md)
- update: [specs/models/mconf/models.md](../../../specs/models/mconf/models.md)
  - [x] Update VersionInfo documentation to clarify that user scope installs only Commands (design.md, gherkin.md) while project scope installs all 6 files
- update: [tests/test_user_scope_installs.bats](../../../tests/test_user_scope_installs.bats)
  - [x] Update get_agent_files helper function to return only Commands (design.md, gherkin.md) for user scope
  - [x] Update existing mega-test to verify only Commands are installed in user scope
  - [x] Update existing mega-test to verify Actions-only files (register.md, analyze.md, implement.md, archive.md) are NOT installed in user scope
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Split FILES array into COMMAND_FILES and ACTION_FILES
  - [x] Update installation logic to install only Commands in user scope
  - [x] Update create_version_info to accept file list parameter
  - [x] Update show_install_preview to display correct files based on scope
- test: Run existing tests
  - [x] Run `bats tests/test_user_scope_installs.bats` to verify updated tests pass
