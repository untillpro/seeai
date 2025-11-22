# Analysis: Move Prompt Files from src to specs/agents/seeai

## Specifications to create

None. The existing specification structure already supports agent specifications under `specs/agents/`.

## Specifications to update

- [x] [specs/project/dev.md](../../../specs/project/dev.md): Update Project Structure section to reflect new location of prompt files (design.md and gherkin.md should be under specs/agents/seeai instead of src)
- [x] [specs/feat/conf/design.md](../../../specs/feat/conf/design.md): Update Source Files section and File Download section to reflect new location (specs/agents/seeai instead of src directory)

## Affected files

- move: [src/design.md](../../../src/design.md)
  - [x] Relocate to [specs/agents/seeai/design.md](../../../specs/agents/seeai/design.md)
- move: [src/gherkin.md](../../../src/gherkin.md)
  - [x] Relocate to [specs/agents/seeai/gherkin.md](../../../specs/agents/seeai/gherkin.md)
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Update SRC_DIR path from `$SCRIPT_DIR/../src` to `$SCRIPT_DIR/../specs/agents/seeai` (line 555)
  - [x] Update BASE_URL from `https://raw.githubusercontent.com/untillpro/seeai/${REF}/src` to `https://raw.githubusercontent.com/untillpro/seeai/${REF}/specs/agents/seeai` (line 569)
- move: [tests/fixtures/src/design.md](../../../tests/fixtures/src/design.md)
  - [x] Relocate to [tests/fixtures/specs/agents/seeai/design.md](../../../tests/fixtures/specs/agents/seeai/design.md)
- move: [tests/fixtures/src/gherkin.md](../../../tests/fixtures/src/gherkin.md)
  - [x] Relocate to [tests/fixtures/specs/agents/seeai/gherkin.md](../../../tests/fixtures/specs/agents/seeai/gherkin.md)
- update: [tests/mocks/curl](../../../tests/mocks/curl)
  - [x] Update URL pattern matching from `/src/` to `/specs/agents/seeai/` (line 66)
  - [x] Update fixture path from `$fixtures_dir/src/$filename` to `$fixtures_dir/specs/agents/seeai/$filename` (line 68, 70, 72)
- update: [tests/README.md](../../../tests/README.md)
  - [x] Update fixture documentation from `src/design.md` and `src/gherkin.md` to `specs/agents/seeai/design.md` and `specs/agents/seeai/gherkin.md`
- update: [docs/devguide.md](../../../docs/devguide.md)
  - [x] Update comment from `../src` to `../specs/agents/seeai` (line 7)

## Notes

- The change aligns with the project's specification structure where agent-related specifications belong under `specs/agents/`
- The src directory currently contains prompt files that are actually specifications for how AGENTS should behave (SeeAI ACTIONS), not source code for the seeai tool itself
- The installation script (seeai.sh) copies files from the source location to various target locations (.augment/commands/seeai/, .claude/commands/seeai/, .github/prompts/)
- This change only affects the source location within the repository, not the installation targets
