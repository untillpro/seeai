# SeeAI Tests

Black box tests for the seeai.sh installation script using BATS (Bash Automated Testing System).

## Prerequisites

Install BATS:

### On macOS

```bash
brew install bats-core
```

### On Linux

```bash
# Ubuntu/Debian
sudo apt-get install bats

# Or install from source
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

### On Windows (Git Bash)

```bash
# Install via npm
npm install -g bats

# Or download and add to PATH
# https://github.com/bats-core/bats-core
```

## Running Tests

Run all tests:
```bash
bats tests/test_remote_user_agent.bats
```

Run specific test:
```bash
bats tests/test_remote_user_agent.bats -f "remote install latest version for auggie"
```

Run with verbose output:
```bash
bats tests/test_remote_user_agent.bats --tap
```

## Test Structure

- `test_helper.bash`: Common setup, mock commands, assertions
- `test_remote_user_agent.bats`: Remote installation tests for user scope per agent
- `mocks/`: Mock command implementations
  - `curl`: Mock curl for GitHub API calls
- `fixtures/`: Test data and mock responses
  - `tags.json`: Mock GitHub tags response
  - `tags_empty.json`: Empty tags for error testing
  - `commits_main.json`: Mock commit info response
  - `src/design.md`: Mock source file
  - `src/gherkin.md`: Mock source file

## Test Coverage

### Remote / User / Agent Tests

Tests remote installation with user scope for each agent (auggie, claude, copilot):

- Install latest version (resolves to newest tag)
- Install main branch (with commit hash)
- Install specific version tag (v0.1.0)
- Error handling (no tags, invalid agent)
- File transformations (copilot prefix/extension)
- Version tracking (seeai-version.yml format)

## Mocking Strategy

Tests use mocked curl commands instead of actual network calls:

- Mock curl returns fixture data based on URL
- Fixtures directory contains predefined responses
- Tests run in isolated temporary directories
- No actual GitHub API calls are made

## Adding New Tests

1. Add test case to appropriate .bats file
2. Use `setup()` and `teardown()` for test isolation
3. Use helper functions from `test_helper.bash`
4. Add new fixtures if needed
5. Run tests to verify

Example:
```bash
@test "my new test" {
  run run_seeai install --agent auggie --scope user
  
  [ "$status" -eq 0 ]
  assert_file_exists "$target_dir/myfile.md"
}
```
