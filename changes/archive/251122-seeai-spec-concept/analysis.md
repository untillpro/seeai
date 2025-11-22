# Analysis: Introduce SeeAI Spec Concept

## Specifications to create

- [specs/agents/seeai/specs/specs.md](../../../specs/agents/seeai/specs/specs.md)
  - [x] Move content from specs/project/specs.md to this location
  - [x] Keep all existing specification structure guidance
  - [x] Maintain all examples and criteria for when to create specifications

## Specifications to update

- [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [x] Add new "SeeAI Spec" concept definition
  - [x] Describe SeeAI Specs as reusable specification templates stored in /specs/agents/seeai/specs/
  - [x] Explain that SeeAI Specs are referenced by Actions using relative paths
  - [x] Note that SeeAI Specs are not versioned separately - they evolve with Actions
  - [x] Note that SeeAI Specs are distributed only to project scope via seeai.sh
- [specs/agents/seeai/analyze.md](../../../specs/agents/seeai/analyze.md)
  - [x] Update Step 3 reference from `@/specs/project/specs.md` to `@/specs/agents/seeai/specs/specs.md` (line 65)
- [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Update Source Files section to include Specs category
  - [x] Document that specs/specs.md is installed in project scope only
  - [x] Update installation flow to mention specs directory creation
- [specs/project/dev.md](../../../specs/project/dev.md)
  - [x] Update Project Structure section to include specs/agents/seeai/specs/ directory
  - [x] Document specs.md file in the structure

## Affected files and tests

- move: [specs/project/specs.md](../../../specs/project/specs.md)
  - [x] Relocate to [specs/agents/seeai/specs/specs.md](../../../specs/agents/seeai/specs/specs.md)
- delete: [specs/project/specs.md](../../../specs/project/specs.md)
  - [x] Remove after content is moved to new location
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Add new SPEC_FILES array after ACTION_FILES: `SPEC_FILES=("specs/specs.md")`
  - [x] Update ALL_FILES array to include spec files from SPEC_FILES array
  - [x] Update install_files function to handle spec files in project scope only
  - [x] Add logic to create subdirectory structure when copying/downloading spec files
  - [x] For local mode: copy from `$SRC_DIR/specs/specs.md` to `$TARGET_DIR/specs/specs.md`
  - [x] For remote mode: download from `${BASE_URL}/specs/specs.md` to `$TARGET_DIR/specs/specs.md`
  - [x] Ensure `mkdir -p` creates specs subdirectory before copying spec files
  - [x] Update create_version_info to include spec files in the files list for project scope
- create: [tests/fixtures/specs/agents/seeai/specs/specs.md](../../../tests/fixtures/specs/agents/seeai/specs/specs.md)
  - [x] Create fixture file by copying content from specs/project/specs.md
- update: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [x] Update setup function to copy specs/specs.md fixture to temp directory
  - [x] Add verification that specs/specs.md is installed in project scope
  - [x] Verify specs directory is created in target installation directory
- test: Project scope installation
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify spec file installation

## Notes

- SeeAI Specs are internal templates used by Actions, not user-facing configuration
- Specs are distributed only to project scope since Actions (which use specs) are only installed in project scope
- New SPEC_FILES array in seeai.sh separates spec files from command and action files for clarity
- Specs are installed in subdirectory structure (specs/specs.md) to match source organization and allow future expansion
- Installation script automatically creates the specs directory structure during project installation
