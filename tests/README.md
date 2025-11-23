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
