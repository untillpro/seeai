# SeeAI Tests

Black box tests for the seeai.sh installation script using BATS (Bash Automated Testing System).

## Prerequisites

Install BATS:

- brew install bats-core
- sudo apt-get install bats
- npm install -g bats

## Running Tests

```bash
bats tests
bats tests/test_user_scope_installs.bats
bats tests/test_user_scope_installs.bats -f "user scope"
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
  - `specs/agents/seeai/design.md`: Mock source file
  - `specs/agents/seeai/gherkin.md`: Mock source file
