# Analysis: Add project scope tests to mega tests

## Specifications to create

None

## Specifications to update

- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Update Project Scope Installation Tests section to mark as implemented
  - [x] Add reference to test_project_scope_installs.bats
  - [x] Update Tests section to list both test files

## Affected files and tests

- create: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [x] Create mega test "project scope installations (agent x version x mode)" covering 18 combinations (3 agents x 3 versions x 2 modes)
  - [x] Add separate test "ACF creation when no file exists" using agent=auggie, version=latest, mode=remote
  - [x] Add separate test "ACF append when file exists without instructions" using agent=claude, version=latest, mode=remote
  - [x] Add separate test "ACF update when file exists with old instructions" using agent=auggie, version=latest, mode=remote
  - [x] Verify all 6 files installed, VersionInfo at specs/agents/seeai/, ACF created/updated, and Actions NOT in user scope
- test: Run new tests
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify all 21 test cases pass (18 mega test + 3 ACF tests)

## Notes

- New test file mirrors structure of test_user_scope_installs.bats for consistency
- Mega test covers 18 combinations (3 agents x 3 versions x 2 modes) for basic installation functionality
- Three separate focused tests cover ACF update scenarios using two agents (auggie, claude) with latest version and remote mode
- Separate ACF tests are cleaner than adding fourth dimension (would be 54 cases), easier to debug, and sufficient since ACF logic doesn't depend on version/mode
- ACF test 1 (no file exists) tests Case 1: creates new ACF file
- ACF test 2 (without instructions) tests Case 2: appends to existing ACF without triggering instructions
- ACF test 3 (with old instructions) tests Case 3: replaces existing triggering instructions block
- Tests both AGENTS.md (auggie/copilot) and CLAUDE.md (claude) ACF files
- Project scope installs all 6 files (Commands + Actions) vs user scope which only installs 2 Commands
- VersionInfo location differs by scope: user scope stores in agent directory, project scope stores at specs/agents/seeai/seeai-version.yml
- Negative assertions verify Actions are NOT in user scope, ensuring proper scope separation
- All fixture files for Actions already exist in tests/fixtures/specs/agents/seeai/
- Test helper already has get_project_scope_dir() function ready to use
- Helper functions (get_all_agent_files, get_expected_version) are local to the test file
