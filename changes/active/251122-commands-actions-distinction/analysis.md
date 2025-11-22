# Analysis: Clear distinction between Commands and Actions

## Specifications to create

None - all necessary specifications already exist.

## Specifications to update

- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [ ] Add test specification for Commands vs Actions distinction
  - [ ] Document that user scope tests should verify only Commands (design.md, gherkin.md) are installed
  - [ ] Document that project scope tests should verify all 6 files (Commands + Actions) are installed

## Affected files and tests

- update: [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [ ] Update Source Files section to clarify which files are Commands (design.md, gherkin.md) vs Actions-only (register.md, analyze.md, implement.md, archive.md)
- update: [specs/models/mconf/models.md](../../../specs/models/mconf/models.md)
  - [ ] Update VersionInfo documentation to clarify that user scope installs only Commands (design.md, gherkin.md) while project scope installs all 6 files
- update: [tests/test_user_scope_installs.bats](../../../tests/test_user_scope_installs.bats)
  - [ ] Update get_agent_files helper function to return only Commands (design.md, gherkin.md) for user scope
  - [ ] Update existing mega-test to verify only Commands are installed in user scope
  - [ ] Update existing mega-test to verify Actions-only files (register.md, analyze.md, implement.md, archive.md) are NOT installed in user scope
- test: Run existing tests
  - [ ] Run `bats tests/test_user_scope_installs.bats` to verify updated tests pass

## Notes

- Currently all 6 files are installed in both user and project scopes, but only design.md and gherkin.md are designed to work as Commands (explicit invocation)
- The other 4 files (register.md, analyze.md, implement.md, archive.md) require Triggering Instructions in ACF files, which only exist in project scope
- This is a documentation clarification change - the code behavior is already correct (Triggering Instructions are only installed in project scope)
- Tests are needed to verify and document this distinction clearly
