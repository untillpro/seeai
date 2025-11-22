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

## Test Structure

Directory organization:

- tests/test_helper.bash: Common setup, mock commands, assertions
- tests/test_install_remote.bats: Install command from GitHub
- tests/mocks/: Mock curl command implementation
- tests/fixtures/: Test data and mock responses

## Test Coverage Areas

### Remote / User / Agent

Test remote installation, user scope, per agent.

- Test install latest version resolves to newest tag
- Test install main branch
- Test install specific version tag (v0.1.0)
- Test error when no tags exist
- Test files are downloaded from GitHub
- Verify seeai-version.yml is created with remote version format
- Test network failure handling

## Mocking Strategy

Mock curl command instead of running HTTP server:

Curl commands to mock for remote installations:

- `curl -fsSL https://api.github.com/repos/untillpro/seeai/tags`: Return mock tags JSON
- `curl -fsSL https://api.github.com/repos/untillpro/seeai/commits/$ref`: Return mock commit JSON
- `curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/${REF}/src/${file}`: Return mock file content

Git commands to mock for local installations only:

- `git rev-parse --abbrev-ref HEAD`: Return mock branch name
- `git rev-parse --short HEAD`: Return mock commit hash

Implementation approach:

- Create mock curl script in tests/mocks/
- Add mocks directory to PATH in test setup
- Mock curl script checks URL and returns appropriate response from fixtures
- Use fixtures directory for mock response data

Mock response fixtures:

- fixtures/tags.json: Mock tags list JSON
- fixtures/commits_main.json: Mock commit SHA response JSON
- fixtures/src/design.md: Mock source file
- fixtures/src/gherkin.md: Mock source file

## References

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [scripts/seeai.sh](../../../scripts/seeai.sh)
- [Design Specification](design.md)
