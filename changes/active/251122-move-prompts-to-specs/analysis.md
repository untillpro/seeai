# Analysis: Move Prompt Files from src to specs/agents/seeai

## Specifications to create

None. The existing specification structure already supports agent specifications under `specs/agents/`.

## Specifications to update

- [ ] [specs/project/dev.md](../../../specs/project/dev.md): Update Project Structure section to reflect new location of prompt files (design.md and gherkin.md should be under specs/agents/seeai instead of src)
- [ ] [specs/feat/conf/design.md](../../../specs/feat/conf/design.md): Update Source Files section to reflect new location (specs/agents/seeai instead of src directory)

## Guidelines to create

None. No new guidelines are needed for this organizational change.

## Guidelines to update

None. The existing guidelines do not need updates beyond the specification changes listed above.

## Additional Impact

### Code Changes Required

- [ ] [scripts/seeai.sh](../../../scripts/seeai.sh): Update SRC_DIR path from `$SCRIPT_DIR/../src` to `$SCRIPT_DIR/../specs/agents/seeai` (line 555)
- [ ] [scripts/seeai.sh](../../../scripts/seeai.sh): Update BASE_URL from `https://raw.githubusercontent.com/untillpro/seeai/${REF}/src` to `https://raw.githubusercontent.com/untillpro/seeai/${REF}/specs/agents/seeai` (line 569)

### Test Fixtures

- [ ] [tests/fixtures/src/design.md](../../../tests/fixtures/src/design.md): Move to tests/fixtures/specs/agents/seeai/design.md
- [ ] [tests/fixtures/src/gherkin.md](../../../tests/fixtures/src/gherkin.md): Move to tests/fixtures/specs/agents/seeai/gherkin.md
- [ ] Test helper functions may need updates if they reference the src directory structure

### Files to Move

- [ ] [src/design.md](../../../src/design.md): Move to specs/agents/seeai/design.md
- [ ] [src/gherkin.md](../../../src/gherkin.md): Move to specs/agents/seeai/gherkin.md

### Notes

The change aligns with the project's specification structure where agent-related specifications belong under `specs/agents/`. The src directory currently contains prompt files that are actually specifications for how agents should behave, not source code for the seeai tool itself.

The installation script (seeai.sh) copies files from the source location to various target locations (.augment/commands/seeai/, .claude/commands/seeai/, .github/prompts/). This change only affects the source location within the repository, not the installation targets.
