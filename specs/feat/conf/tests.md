# Test: SeeAI Configuration Script

## Overview

- Black box testing strategy for [scripts/seeai.sh](../../../scripts/seeai.sh) using BATS (Bash Automated Testing System). Tests execute the script as a whole without accessing internal functions.
- [Initial version](https://github.com/untillpro/seeai/blob/3531723c2238c184ef425ac3f0f6004d90b057eb/specs/feat/conf/test.md)

## Testing Approach

Black Box Testing:

- Execute the script as an external command
- Test only through public interface (command line arguments, stdin, stdout, stderr, exit codes)
- No access to internal functions or variables
- Validate behavior through observable outputs and side effects

## Test Environment Strategy

### Isolated Test Environment

Each test runs in isolated environment:

- Temporary directory for all file operations
- Create necessary directory structure in temp dir
- Mocks
  - Controlled environment variables (HOME, APPDATA)
  - Simulated user input via stdin
  - GitHub API: Mock curl command with stub responses
  - Git operations: Mock git command for local mode tests only
- Execute script as external command (no sourcing)
- Cleanup all resources after test completes

## Tests

- [test_user_scope_installs.bats](../../../tests/test_user_scope_installs.bats)
- [test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)

## Test Specifications

### User Scope Installation Tests

Covered by: [test_user_scope_installs.bats](../../../tests/test_user_scope_installs.bats)

Verifies that only Commands (design.md, gherkin.md) are correctly installed in User Scope for all agents (auggie, claude, copilot) across different versions (latest, main, specific tags) and modes (remote, local).

Commands vs Actions distinction:

- Commands (design.md, gherkin.md): Installed in user scope, can be invoked explicitly via command syntax
- Actions (register.md, analyze.md, implement.md, archive.md): NOT installed in user scope, require Triggering Instructions which only exist in project scope

Test verifies:

- Only design.md and gherkin.md are installed in user scope
- Actions-only files (register.md, analyze.md, implement.md, archive.md) are NOT present in user scope
- VersionInfo file is created with only Commands listed

### Project Scope Installation Tests

Covered by: [test_project_scope_installs.bats](../../../tests/test_project_scope_installs.bats)

Verifies that all 6 files (Commands + Actions) are correctly installed in Project Scope for all agents (auggie, claude, copilot) across different versions (latest, main, specific tags) and modes (remote, local).

Mega test verifies:

- All 6 SeeAI files (Commands + Actions) are installed in Project Scope configuration directories
  - Commands: design.md, gherkin.md
  - Actions: register.md, analyze.md, implement.md, archive.md
  - Augment: `./.augment/commands/seeai/`
  - Claude: `./.claude/commands/seeai/`
  - Copilot: `./.github/prompts/` (with seeai- prefix and .prompt.md extension)
- VersionInfo file is created at `specs/agents/seeai/seeai-version.yml` with all 6 files listed
- ACF file (AGENTS.md or CLAUDE.md) exists with triggering instructions
- Actions are NOT installed in user scope (negative assertions)

Separate ACF update tests verify:

- ACF creation when no file exists (auggie, latest, remote)
- ACF append when file exists without triggering instructions (claude, latest, remote)
- ACF update when file exists with old triggering instructions (auggie, latest, remote)
- All 6 action patterns present in triggering instructions block
- HTML comment markers correctly wrap triggering instructions
- Existing ACF content is preserved when updating

## References

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [scripts/seeai.sh](../../../scripts/seeai.sh)
- [Design Specification](design.md)
