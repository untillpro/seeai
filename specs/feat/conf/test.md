# Test: SeeAI Configuration Script

## Overview

Black box testing strategy for [scripts/seeai.sh](../../../scripts/seeai.sh) using BATS (Bash Automated Testing System). Tests execute the script as a whole without accessing internal functions.

## Testing Approach

Black Box Testing:

- Execute the script as an external command
- Test only through public interface (command line arguments, stdin, stdout, stderr, exit codes)
- No access to internal functions or variables
- Validate behavior through observable outputs and side effects

## Test Environment Strategy

### Isolated Test Environment

Each test runs in isolated environment with:

- Temporary directory for all file operations
- Mock external services (GitHub API, git remote)
- Controlled environment variables (HOME, APPDATA)
- Simulated user input via stdin

### Mock External Services

Mock only external services that cannot be controlled:

- GitHub API: Use local mock HTTP server or stub responses
- Git remote operations: Use local git repository as remote
- Network downloads: Redirect to local file server

### Real Operations

Use real operations for everything else:

- File system operations (mkdir, cp, mv, rm)
- Text processing (grep, sed, awk)
- Git local operations (if needed)
- Date/time (accept non-deterministic timestamps or use faketime)

## Test Structure

Directory organization:

- tests/test_helper.bash: Common setup, mock servers, assertions
- tests/test_install_local.bats: Install command with -l flag
- tests/test_install_remote.bats: Install command from GitHub
- tests/test_list_command.bats: List command tests
- tests/test_agent_selection.bats: Agent selection flows
- tests/test_scope_selection.bats: Scope selection flows
- tests/test_error_handling.bats: Error conditions
- tests/mock_server/: Mock HTTP server for GitHub API
- tests/mock_server/responses/: Mock API responses
- tests/fixtures/: Test data (mock source files, git repository)

## Test Environment Setup

Each test runs in isolated environment:

- Create temporary directory for all operations
- Override HOME and APPDATA environment variables
- Create necessary directory structure
- Execute script as external command (no sourcing)
- Start mock HTTP server for GitHub API if needed
- Cleanup all resources after test completes

## Test Coverage Areas

### Local Installation Tests (install -l)

Execute script with -l flag and validate outputs:

- Test install with --agent auggie creates files in correct location
- Test install with --agent claude creates files in correct location
- Test install with --agent copilot creates files with correct naming
- Test user scope installation (default, press Y)
- Test project scope installation (press w)
- Test cancellation (press n)
- Verify files are copied from ../src directory
- Verify seeai-version.yml is created with local version format
- Verify AGENTS.md or CLAUDE.md is updated (project scope only)

### Remote Installation Tests (install without -l)

Execute script without -l flag using mock GitHub server:

- Test install latest version resolves to newest tag
- Test install main branch
- Test install specific version tag (v0.1.0)
- Test error when no tags exist
- Test files are downloaded from GitHub
- Verify seeai-version.yml is created with remote version format
- Test network failure handling

### Agent Selection Tests

Execute script and provide input via stdin:

- Test interactive agent selection (input: 1, 2, 3)
- Test --agent auggie bypasses prompt
- Test --agent claude bypasses prompt
- Test --agent copilot bypasses prompt
- Test invalid agent name shows error and exits
- Test invalid selection number shows error

### Scope Selection Tests

Execute script and provide input via stdin:

- Test Y continues with user scope
- Test w switches to project scope and prompts again
- Test n cancels installation
- Test empty input defaults to Y
- Test invalid input shows error

### File Naming Tests

Execute script and verify created files:

- Test copilot files: seeai-design.prompt.md, seeai-gherkin.prompt.md
- Test augment files: design.md, gherkin.md in seeai/ subdirectory
- Test claude files: design.md, gherkin.md in seeai/ subdirectory

### Version Info Tests

Execute script and verify seeai-version.yml content:

- Test local mode: version format local-{branch}-{hash}
- Test remote main: version format remote-main-{hash}
- Test tagged version: version format v0.1.0
- Test installed_at timestamp is ISO 8601 format
- Test source URL is correct
- Test files list is complete

### Triggering Instructions Tests

Execute script in project scope and verify ACF files:

- Test AGENTS.md is created if not exists
- Test CLAUDE.md is created for claude agent
- Test existing content is preserved
- Test triggering instructions block is added
- Test existing triggering instructions block is replaced

### List Command Tests

Execute script list command and verify output:

- Test lists user scope installations
- Test lists project scope installations
- Test shows version metadata if available
- Test shows correct paths for each agent
- Test shows "No installations found" when empty

### Error Handling Tests

Execute script with error conditions:

- Test invalid command shows usage
- Test network failure shows error message
- Test missing source files shows error
- Test permission denied shows error
- Test invalid version shows error

## Mock TTY Operations

The script reads from /dev/tty for interactive prompts. Mock strategies:

### Option 1: Redirect /dev/tty

Create a named pipe or file to simulate /dev/tty:

- Create FIFO (named pipe) before test
- Write test input to the pipe
- Redirect /dev/tty to the pipe when executing script
- Script reads from pipe instead of real TTY

### Option 2: Wrapper Script

Create wrapper script that replaces /dev/tty references:

- Copy seeai.sh to temp location
- Use sed to replace </dev/tty with </dev/stdin
- Execute modified script
- Provide input via stdin (echo or printf)

### Option 3: expect Tool

Use expect for TTY automation:

- Install expect tool
- Write expect script to interact with prompts
- Send responses automatically
- Capture output for assertions

Recommended: Option 2 (wrapper script) for simplicity and portability

## Mock GitHub Server

Simple HTTP server to mock GitHub API and raw content:

- Listen on local port
- Serve mock responses for GitHub API endpoints
- Serve mock file content for raw.githubusercontent.com URLs
- Return 404 for unknown paths

Mock response files:

- commits_main.json: Mock commit SHA response
- tags.txt: Mock git tags list
- src/design.md: Mock source file
- src/gherkin.md: Mock source file

## Test Execution Pattern

Each test follows this pattern:

- Setup: Create isolated environment, start mock servers
- Execute: Run script as external command with input via stdin
- Assert: Verify files created, content correct, output messages
- Teardown: Stop mock servers, cleanup temp directory

## CI/CD Integration

Run tests on multiple platforms:

- ubuntu-latest
- macos-latest
- windows-latest

Install BATS framework and execute all test files

## Benefits of Black Box Testing

- Tests actual script behavior as users experience it
- No coupling to internal implementation details
- Script can be refactored without changing tests
- Tests validate complete workflows end-to-end
- Catches integration issues between functions
- Simpler test code without function mocking
- Tests are more maintainable and robust
- Validates exit codes, stdout, stderr correctly

## Limitations and Considerations

- Cannot test individual internal functions in isolation
- Harder to test specific edge cases in internal logic
- Test failures may require more debugging to identify root cause
- Some error conditions may be harder to simulate
- Tests may be slower than unit tests (but still fast with local operations)

Mitigation:

- Use descriptive test names to indicate what is being tested
- Add comments in tests to explain complex setup
- Use helper functions to reduce duplication
- Consider adding integration tests for critical paths
- Use real file operations in temp directories for speed

## References

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [scripts/seeai.sh](../../../scripts/seeai.sh)
- [Design Specification](design.md)
