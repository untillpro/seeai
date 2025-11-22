# Analysis: Rename exec.md ACTION to implement.md

## Specifications to create

None

## Specifications to update

- [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Update reference to exec.md in Source Files section (line 77) to implement.md
- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [x] Update reference to exec.md in test specifications (line 43) to implement.md
- [specs/models/mconf/models.md](../../../specs/models/mconf/models.md)
  - [x] Update VersionInfo example files list from exec.md to implement.md (line 32)
  - [x] Update Triggering Instructions example from exec.md to implement.md (line 61)

## Affected files and tests

- move: [specs/agents/seeai/exec.md](../../../specs/agents/seeai/exec.md)
  - [x] Rename to [specs/agents/seeai/implement.md](../../../specs/agents/seeai/implement.md)
- update: [AGENTS.md](../../../AGENTS.md)
  - [x] Update triggering instruction reference from exec.md to implement.md (line 16)
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Update FILES array entry from "exec.md" to "implement.md" (line 9)
  - [x] Update triggering instructions template from exec.md to implement.md (line 221)
- move: [tests/fixtures/specs/agents/seeai/exec.md](../../../tests/fixtures/specs/agents/seeai/exec.md)
  - [x] Rename to [tests/fixtures/specs/agents/seeai/implement.md](../../../tests/fixtures/specs/agents/seeai/implement.md)
- update: [tests/test_user_scope_installs.bats](../../../tests/test_user_scope_installs.bats)
  - [x] Update expected file list from "exec.md" to "implement.md" (line 18)
  - [x] Update expected file list from "seeai-exec.prompt.md" to "seeai-implement.prompt.md" (line 21)
- test: User scope installation tests
  - [x] Run `bats tests/test_user_scope_installs.bats` to verify all 6 files install correctly with new name

## Notes

- This is a simple rename operation affecting 1 ACTION file and its references
- The ACTION functionality remains unchanged, only the filename and references are updated
- All 6 SeeAI files (register, design, analyze, implement, archive, gherkin) must be tracked consistently
- Test fixtures must mirror the actual file structure for accurate testing
- The triggering instruction pattern remains the same, only the filename reference changes

