# Analysis: Reorganize .seeai directory structure

## Specifications to create

None - this is an internal reorganization that does not require new specifications.

## Specifications to update

- [project/dev.md](../../../specs/project/dev.md)
  - [x] Update Project Structure section to reflect new subdirectories (actions/, commands/, rules/)
  - [x] Update file paths for all Action files to show new locations
  - [x] Update specs.md path from `.seeai/specs/specs.md` to `.seeai/rules/specs.md`
- [project/concepts.md](../../../specs/project/concepts.md)
  - [x] Update SeeAI Action concept to reference `.seeai/actions/` as source location
  - [x] Update SeeAI Spec concept to reference `.seeai/rules/` instead of `.seeai/specs/`
- [models/mconf-files/models.md](../../../specs/models/mconf-files/models.md)
  - [x] Update Source Directory structure diagram to show new subdirectories
  - [x] Update file paths to reflect actions/, commands/, and rules/ organization

## Affected files and tests

- move: `[.seeai/register.md](../../../.seeai/register.md)`
  - [x] Relocate to [.seeai/actions/register.md](../../../.seeai/actions/register.md)
- move: `[.seeai/analyze.md](../../../.seeai/analyze.md)`
  - [x] Relocate to [.seeai/actions/analyze.md](../../../.seeai/actions/analyze.md)
- move: `[.seeai/implement.md](../../../.seeai/implement.md)`
  - [x] Relocate to [.seeai/actions/implement.md](../../../.seeai/actions/implement.md)
- move: `[.seeai/archive.md](../../../.seeai/archive.md)`
  - [x] Relocate to [.seeai/actions/archive.md](../../../.seeai/actions/archive.md)
- move: `[.seeai/design.md](../../../.seeai/design.md)`
  - [x] Relocate to [.seeai/commands/design.md](../../../.seeai/commands/design.md)
- move: `[.seeai/gherkin.md](../../../.seeai/gherkin.md)`
  - [x] Relocate to [.seeai/commands/gherkin.md](../../../.seeai/commands/gherkin.md)
- move: `[.seeai/specs/specs.md](../../../.seeai/specs/specs.md)`
  - [x] Relocate to [.seeai/rules/specs.md](../../../.seeai/rules/specs.md)
- delete: `[.seeai/templates](../../../.seeai/templates)`
  - [x] Remove empty templates directory
- update: [AGENTS.md](../../../AGENTS.md)
  - [x] Update triggering instruction for register.md to use `@/.seeai/actions/register.md`
  - [x] Update triggering instruction for design.md to use `@/.seeai/commands/design.md`
  - [x] Update triggering instruction for analyze.md to use `@/.seeai/actions/analyze.md`
  - [x] Update triggering instruction for implement.md to use `@/.seeai/actions/implement.md`
  - [x] Update triggering instruction for archive.md to use `@/.seeai/actions/archive.md`
  - [x] Update triggering instruction for gherkin.md to use `@/.seeai/commands/gherkin.md`
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Update COMMAND_FILES array to use `commands/design.md` and `commands/gherkin.md`
  - [x] Update ACTION_FILES array to use `actions/register.md`, `actions/analyze.md`, `actions/implement.md`, `actions/archive.md`
  - [x] Update SPEC_FILES array to use `rules/specs.md`
  - [x] Update ALL_FILES array to reflect new paths for all files
  - [x] Update get_project_dir() function to handle subdirectory creation
  - [x] Update install_triggering_instructions() function to use new paths in generated content
  - [x] Update list command file search logic to look in subdirectories
- update: [.seeai/actions/analyze.md](../../../.seeai/actions/analyze.md)
  - [x] Update reference to specs.md from `@/.seeai/specs/specs.md` to `@/.seeai/rules/specs.md`
- update: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [x] Update file existence checks to use new subdirectory paths
  - [x] Update specs directory check from `.seeai/specs` to `.seeai/rules`
- update: [tests/test_list_command.bats](../../../tests/test_list_command.bats)
  - [x] Update file copy operations to use new subdirectory paths
- update: [tests/mocks/curl](../../../tests/mocks/curl)
  - [x] Update fixture file path resolution to handle subdirectories
- move: `[tests/fixtures/.seeai/register.md](../../../tests/fixtures/.seeai/register.md)`
  - [x] Relocate to [tests/fixtures/.seeai/actions/register.md](../../../tests/fixtures/.seeai/actions/register.md)
- move: `[tests/fixtures/.seeai/analyze.md](../../../tests/fixtures/.seeai/analyze.md)`
  - [x] Relocate to [tests/fixtures/.seeai/actions/analyze.md](../../../tests/fixtures/.seeai/actions/analyze.md)
- move: `[tests/fixtures/.seeai/implement.md](../../../tests/fixtures/.seeai/implement.md)`
  - [x] Relocate to [tests/fixtures/.seeai/actions/implement.md](../../../tests/fixtures/.seeai/actions/implement.md)
- move: `[tests/fixtures/.seeai/archive.md](../../../tests/fixtures/.seeai/archive.md)`
  - [x] Relocate to [tests/fixtures/.seeai/actions/archive.md](../../../tests/fixtures/.seeai/actions/archive.md)
- move: `[tests/fixtures/.seeai/design.md](../../../tests/fixtures/.seeai/design.md)`
  - [x] Relocate to [tests/fixtures/.seeai/commands/design.md](../../../tests/fixtures/.seeai/commands/design.md)
- move: `[tests/fixtures/.seeai/gherkin.md](../../../tests/fixtures/.seeai/gherkin.md)`
  - [x] Relocate to [tests/fixtures/.seeai/commands/gherkin.md](../../../tests/fixtures/.seeai/commands/gherkin.md)
- move: `[tests/fixtures/.seeai/specs/specs.md](../../../tests/fixtures/.seeai/specs/specs.md)`
  - [x] Relocate to [tests/fixtures/.seeai/rules/specs.md](../../../tests/fixtures/.seeai/rules/specs.md)
- test: Project scope installation tests
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify installation with new structure
- test: List command tests
  - [x] Run `bats tests/test_list_command.bats` to verify file discovery in new structure
- test: User scope installation tests
  - [x] Run `bats tests/test_user_scope_installs.bats` to verify user scope installations with new structure

## Notes

- The new structure separates Actions (project-only, NLI-invoked) from Commands (dual-purpose, explicit invocation) for better clarity
- The rules/ directory distinguishes internal SeeAI rules from project specifications in /specs/
- All file references in triggering instructions, installation script, and tests must be updated to reflect new paths
- The installation script must create subdirectories (actions/, commands/, rules/) during installation
- Test fixtures must mirror the new structure to ensure tests pass
- For user scope installations, file paths are flattened (subdirectory prefixes removed for auggie/claude, converted to seeai-{subdir}-{file}.prompt.md for copilot)
