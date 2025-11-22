# Analysis: Introduce SeeAI Spec Concept

## Specifications to create

- [specs/agents/seeai/specs/specs.md](../../../specs/agents/seeai/specs/specs.md)
  - [ ] Move content from specs/project/specs.md to this location
  - [ ] Keep all existing specification structure guidance
  - [ ] Maintain all examples and criteria for when to create specifications

## Specifications to update

- [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [ ] Add new "SeeAI Spec" concept definition
  - [ ] Describe SeeAI Specs as reusable specification templates stored in /specs/agents/seeai/specs/
  - [ ] Explain that SeeAI Specs are referenced by Actions using relative paths
  - [ ] Note that SeeAI Specs are not versioned separately - they evolve with Actions
  - [ ] Note that SeeAI Specs are distributed only to project scope via seeai.sh
- [specs/agents/seeai/analyze.md](../../../specs/agents/seeai/analyze.md)
  - [ ] Update Step 3 reference from `@/specs/project/specs.md` to `@/specs/agents/seeai/specs/specs.md` (line 65)
- [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [ ] Update Source Files section to include Specs category
  - [ ] Document that specs/specs.md is installed in project scope only
  - [ ] Update installation flow to mention specs directory creation
- [specs/project/dev.md](../../../specs/project/dev.md)
  - [ ] Update Project Structure section to include specs/agents/seeai/specs/ directory
  - [ ] Document specs.md file in the structure

## Affected files and tests

- move: [specs/project/specs.md](../../../specs/project/specs.md)
  - [ ] Relocate to [specs/agents/seeai/specs/specs.md](../../../specs/agents/seeai/specs/specs.md)
- delete: [specs/project/specs.md](../../../specs/project/specs.md)
  - [ ] Remove after content is moved to new location
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [ ] Add new SPEC_FILES array after ACTION_FILES: `SPEC_FILES=("specs/specs.md")`
  - [ ] Update ALL_FILES array to include spec files from SPEC_FILES array
  - [ ] Update install_files function to handle spec files in project scope only
  - [ ] Add logic to create subdirectory structure when copying/downloading spec files
  - [ ] For local mode: copy from `$SRC_DIR/specs/specs.md` to `$TARGET_DIR/specs/specs.md`
  - [ ] For remote mode: download from `${BASE_URL}/specs/specs.md` to `$TARGET_DIR/specs/specs.md`
  - [ ] Ensure `mkdir -p` creates specs subdirectory before copying spec files
  - [ ] Update create_version_info to include spec files in the files list for project scope
- create: [tests/fixtures/specs/agents/seeai/specs/specs.md](../../../tests/fixtures/specs/agents/seeai/specs/specs.md)
  - [ ] Create fixture file by copying content from specs/project/specs.md
- update: [tests/test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)
  - [ ] Update setup function to copy specs/specs.md fixture to temp directory
  - [ ] Add verification that specs/specs.md is installed in project scope
  - [ ] Verify specs directory is created in target installation directory
- test: Project scope installation
  - [ ] Run `bats tests/test_project_scope_installs.bats` to verify spec file installation

## Notes

- SeeAI Specs are internal templates used by Actions, not user-facing configuration
- Specs are distributed only to project scope since Actions (which use specs) are only installed in project scope
- New SPEC_FILES array in seeai.sh separates spec files from command and action files for clarity
- Specs are installed in subdirectory structure (specs/specs.md) to match source organization and allow future expansion
- Installation script automatically creates the specs directory structure during project installation
