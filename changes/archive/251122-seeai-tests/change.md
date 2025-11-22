# Change: Tests for seeai.sh

## Summary

Add comprehensive test coverage for the seeai.sh installation script to ensure reliability across different scenarios, platforms, and edge cases.

## What

To create:

- `tests/seeai.sh`: Test suite for seeai.sh script
  - Test parameter parsing (--agent, --scope, --local, etc.)
  - Test installation flows (user scope, project scope)
  - Test agent-specific handling (auggie, claude, copilot)
  - Test file transformations (copilot prefix/extension handling)
  - Test error handling (invalid parameters, missing files, etc.)
  - Test version tracking (VersionInfo creation and updates)
  - Test path normalization across platforms
  - Test interactive prompts and non-interactive modes

To modify:

- `scripts/seeai.sh`: Add test hooks or refactor for testability if needed
- `README.md`: Add section on running tests
- [specs/feat/conf/test.md](../../../specs/feat/conf/test.md): Document testing approach and test coverage
