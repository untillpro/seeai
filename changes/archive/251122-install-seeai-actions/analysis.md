# Analysis: Install All SeeAI Files as Actions in Project Mode

## Specifications to create

None - all necessary specifications already exist.

## Specifications to update

- [feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Update Source Files section to list all 6 files (register.md, design.md, analyze.md, exec.md, archive.md, gherkin.md)
- [models/mconf/models.md](../../../specs/models/mconf/models.md)
  - [x] Update VersionInfo example to show all 6 installed files in the files list
  - [x] Update Triggering Instructions example to include all 6 ACTIONS with correct patterns

## Affected files and tests

- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Update FILES array (lines 5-8) to include all 6 files: register.md, design.md, analyze.md, exec.md, archive.md, gherkin.md
  - [x] Update install_triggering_instructions function (lines 210-218) to generate correct Triggering Instructions matching AGENTS.md for all 6 ACTIONS
- update: [AGENTS.md](../../../AGENTS.md)
  - [x] Add gherkin.md triggering instruction pattern (line 18)
- update: [tests/test_user_scope_installs.bats](../../../tests/test_user_scope_installs.bats)
  - [x] Update get_agent_files helper function (lines 14-24) to return all 6 files instead of just design.md and gherkin.md
- test: User Scope installation tests
  - [x] Run `bats tests/test_user_scope_installs.bats` to verify all 6 files install correctly in User Scope
- update: [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Add test specification for Project Scope installations verifying all 6 files are installed
  - [x] Add test specification for verifying Triggering Instructions are generated correctly for all 6 ACTIONS in Project Scope

## Notes

- The change affects both User Scope and Project Scope installations, but Triggering Instructions are only relevant for Project Scope
- Current FILES array in seeai.sh only lists design.md and gherkin.md, missing 4 files: register.md, analyze.md, exec.md, archive.md
- The install_triggering_instructions function has outdated patterns (registrar.md, specifier.md) that don't match actual files
- AGENTS.md has correct patterns for 5 ACTIONS (register, design, analyze, exec, archive), missing gherkin.md pattern
- Models.md already has complete examples with all 6 files and correct Triggering Instructions
