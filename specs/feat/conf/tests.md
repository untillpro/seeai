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

Verifies that project scope installations store all Actions and Specs in specs/agents/seeai/ directory and do NOT copy files to agent-specific directories.

Mega test verifies:

- All SeeAI files (Commands + Actions + Specs) remain in source directory specs/agents/seeai/
  - Commands: design.md, gherkin.md
  - Actions: register.md, analyze.md, implement.md, archive.md
  - Specs: specs/specs.md
- Files are NOT copied to agent-specific directories in project scope:
  - NOT in `./.augment/commands/seeai/`
  - NOT in `./.claude/commands/seeai/`
  - NOT in `./.github/prompts/`
- VersionInfo file is created at `specs/agents/seeai/seeai-version.yml` with all files listed
- ACF file (AGENTS.md or CLAUDE.md) exists with triggering instructions that reference specs/agents/seeai/
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
