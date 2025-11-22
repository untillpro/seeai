# Analysis: Install Actions to /specs/agents/seeai

## Specifications to create

No new specifications need to be created.

## Specifications to update

- [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [x] Update SeeAI Action definition to clarify that Actions are stored in specs/agents/seeai as source files
  - [x] Update Project Scope definition to clarify that agent-specific directories (.augment, .claude, .github) are only used in user scope, not project scope
  - [x] Update seeai-version.yml location description to emphasize project scope uses specs/agents/seeai/ only
- [specs/models/mconf-files/models.md](../../../specs/models/mconf-files/models.md)
  - [x] Update Project Scope section to clarify these are target directories for user scope installations only
  - [x] Add note that project scope installations do not use agent-specific directories
  - [x] Clarify that specs/agents/seeai/ is the source location for all Actions and Specs
- [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Update Installation Locations section to clarify specs/agents/seeai as source directory
  - [x] Clarify that project scope installations only create seeai-version.yml in specs/agents/seeai/
  - [x] Update file organization strategy to explain source vs target directories
  - [x] Update List Command Search Strategy section to specify checking BOTH specs/agents/seeai/ and agent-specific directories for project scope
  - [x] Update List Command section to clarify backward compatibility with legacy installations
  - [x] Update Output Example to show "Project (all agents)" label for new installations from specs/agents/seeai/
  - [x] Update VersionInfo reading section to clarify handling of both new and legacy project scope installations
- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Update Project Scope Installation Tests section to clarify that tests verify files are NOT copied to agent-specific directories in project scope
  - [x] Clarify that project scope only creates seeai-version.yml in specs/agents/seeai/

## Affected files and tests

- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Change project scope installation to NOT copy files to agent-specific directories
  - [x] For project scope, skip file copying entirely - files already exist in specs/agents/seeai/
  - [x] Ensure seeai-version.yml is created in specs/agents/seeai/ for project scope (already implemented correctly)
  - [x] Update triggering instructions to reference @/specs/agents/seeai/ paths (already implemented correctly)
  - [x] Update comments to clarify new behavior
  - [x] Update get_all_locations() to check BOTH specs/agents/seeai/ AND agent-specific directories for backward compatibility
  - [x] Update list_command() to properly display files from both locations with [legacy] marker
- update: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [x] Update tests to verify files are NOT copied to agent-specific directories in project scope
  - [x] Verify files exist in specs/agents/seeai/ directory
  - [x] Verify seeai-version.yml is created only in specs/agents/seeai/
  - [x] Update test helper functions if needed
- update: [tests/test_helper.bash](../../../tests/test_helper.bash)
  - [x] Add comment to get_project_scope_dir() clarifying it's for negative assertions only
  - [x] Document that files remain in specs/agents/seeai/ in project scope
- update: [README.md](../../../README.md)
  - [x] Update project scope installation instructions to clarify files remain in specs/agents/seeai/
  - [x] Explain that Actions are invoked from specs/agents/seeai via triggering instructions
- create: [tests/test_list_command.bats](../../../tests/test_list_command.bats)
  - [x] Create new test file for list command functionality
  - [x] Test list command shows project scope installation from specs/agents/seeai/
  - [x] Test list command shows legacy project scope installations from agent-specific directories
  - [x] Test list command shows user scope installations
  - [x] Test list command shows correct version info for each installation
  - [x] Test list command handles missing installations gracefully
  - [x] Test list command shows both new and legacy installations together
- test: Installation tests
  - [x] Install BATS if not available: `npm install -g bats` (Windows) or `brew install bats-core` (macOS)
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify new behavior - All 4 tests passed
  - [x] Run `bats tests/test_user_scope_installs.bats` to ensure user scope still works correctly - All tests passed
  - [x] Run `bats tests/test_list_command.bats` to verify list command works correctly - All 6 tests passed

## Notes

- This change modifies the installation behavior for project scope to use specs/agents/seeai as the single source of truth
- After the change, project scope installations only create seeai-version.yml in specs/agents/seeai/ and update ACF
- User scope installations continue to copy files from specs/agents/seeai to agent-specific directories in user home
- Triggering instructions reference files using @/specs/agents/seeai/ paths
- The seeai-version.yml creation logic for project scope was already correct (line 202-205 in seeai.sh)
- The list command checks BOTH specs/agents/seeai/ AND agent-specific directories for backward compatibility with legacy installations
- Legacy installations are marked with [legacy] label in the list output
- All changes are complete and verified with passing tests (4 project scope tests, 1 user scope test, 6 list command tests)
