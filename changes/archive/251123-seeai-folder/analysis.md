# Analysis: Install all SeeAI files to .seeai folder

## Specifications to create

None - this is an implementation change that doesn't introduce new user-facing models or features.

## Specifications to update

- [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [x] Update SeeAI Action concept to reference `.seeai/` instead of `specs/agents/seeai/`
  - [x] Update Project Scope concept to reference `.seeai/` directory
  - [x] Update Triggering Instructions example to use `@/.seeai/` path
  - [x] Update seeai-version.yml locations to reference `.seeai/`
- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Update project scope test expectations to use `.seeai/` directory
  - [x] Update version file location from `specs/agents/seeai/seeai-version.yml` to `.seeai/seeai-version.yml`
  - [x] Update ACF triggering instructions references
- [specs/feat/conf/vision.md](../../../specs/feat/conf/vision.md)
  - [x] Update version metadata location from `specs/agents/seeai/seeai-version.yml` to `.seeai/seeai-version.yml`
- [specs/feat/nli/vision.md](../../../specs/feat/nli/vision.md)
  - [x] Update triggering instructions example to use `@/.seeai/` path
- [specs/models/mconf-files/models.md](../../../specs/models/mconf-files/models.md)
  - [x] Update Source Directory section from `specs/agents/seeai/` to `.seeai/`
  - [x] Update directory structure diagram to show `.seeai/` instead of `specs/agents/seeai/`
  - [x] Update comments about project scope installation location
- [specs/models/mconf/models.md](../../../specs/models/mconf/models.md)
  - [x] Update VersionInfo project scope location from `specs/agents/seeai/seeai-version.yml` to `.seeai/seeai-version.yml`
  - [x] Update Triggering Instructions example to use `@/.seeai/` path

## Affected files and tests

- move: Repository source files from `specs/agents/seeai/` to `.seeai/`
  - [x] Move all files from `specs/agents/seeai/` directory to `.seeai/` directory
  - [x] This includes: design.md, gherkin.md, register.md, analyze.md, implement.md, archive.md, specs/specs.md
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Change `get_project_dir()` function to return `.seeai/` instead of `specs/agents/seeai/`
  - [x] Update list command search locations from `specs/agents/seeai/` to `.seeai/`
  - [x] Update version file path in `create_version_info()` from `specs/agents/seeai/seeai-version.yml` to `.seeai/seeai-version.yml`
  - [x] Update triggering instructions content to use `@/.seeai/` instead of `@/specs/agents/seeai/`
  - [x] Update preview messages to show `.seeai/` instead of `specs/agents/seeai/`
  - [x] Update local mode source directory reference from `specs/agents/seeai` to `.seeai`
  - [x] Update remote download URL from `specs/agents/seeai` to `.seeai`
  - [x] Update all comments referencing `specs/agents/seeai/` to `.seeai/`
- update: [AGENTS.md](../../../AGENTS.md)
  - [x] Update all triggering instruction paths from `@/specs/agents/seeai/` to `@/.seeai/`
- update: [README.md](../../../README.md)
  - [x] Update project scope description from `specs/agents/seeai/` to `.seeai/`
- update: [docs/devguide.md](../../../docs/devguide.md)
  - [x] Update comment about local files source from `specs/agents/seeai` to `.seeai`
- update: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [x] Update setup to create `.seeai` directory instead of `specs/agents/seeai`
  - [x] Update all version file path assertions from `specs/agents/seeai/seeai-version.yml` to `.seeai/seeai-version.yml`
  - [x] Update all file existence checks from `specs/agents/seeai/$file` to `.seeai/$file`
  - [x] Update directory existence checks from `specs/agents/seeai/specs` to `.seeai/specs`
  - [x] Update file copy operations from `specs/agents/seeai/` to `.seeai/`
  - [x] Update file modification tests from `specs/agents/seeai/design.md` to `.seeai/design.md`
- update: [tests/test_list_command.bats](../../../tests/test_list_command.bats)
  - [x] Update project scope installation directory from `specs/agents/seeai` to `.seeai`
  - [x] Update version file path from `specs/agents/seeai/seeai-version.yml` to `.seeai/seeai-version.yml`
  - [x] Update file copy operations to use `.seeai/` directory
- update: [tests/test_helper.bash](../../../tests/test_helper.bash)
  - [x] Update comments about project scope location from `specs/agents/seeai/` to `.seeai/`
- update: [tests/mocks/curl](../../../tests/mocks/curl)
  - [x] Update URL pattern matching from `/specs/agents/seeai/` to `/.seeai/`
  - [x] Update fixture file path from `$fixtures_dir/specs/agents/seeai/` to `$fixtures_dir/.seeai/`
- move: Test fixtures from `tests/fixtures/specs/agents/seeai/` to `tests/fixtures/.seeai/`
  - [x] Move all fixture files to new location
- test: Project scope installation tests
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify project scope installations work with new `.seeai/` directory
- test: List command tests
  - [x] Run `bats tests/test_list_command.bats` to verify list command finds files in new `.seeai/` directory
- test: All installation tests
  - [x] Run `bats tests/*.bats` to verify all installation scenarios work correctly

## Notes

- The source location in the repository changes from `specs/agents/seeai/` to `.seeai/` - all source files are moved
- In project scope, files are installed to `.seeai/` (same as the new source location in the repository)
- The installation script downloads/copies from `.seeai/` (new source) and installs to `.seeai/` (project scope target)
- The `.seeai/` directory will be committed to the repository (not added to .gitignore) to make SeeAI Actions available immediately after clone
- No automated migration is provided - users must reinstall with `./scripts/seeai.sh install --scope project` and manually delete old `specs/agents/seeai/` files
- This change only affects project scope installations - user scope installations remain unchanged
- All triggering instructions in AGENTS.md and CLAUDE.md must be updated to reference the new `@/.seeai/` path
