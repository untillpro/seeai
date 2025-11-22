#!/usr/bin/env bash
# Test helper functions for BATS tests

# Setup mock environment
setup_mock_env() {
  # Set fixtures directory
  export FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"
  
  # Add mocks to PATH
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  
  # Create temporary test directory
  export TEST_TEMP_DIR="$(mktemp -d)"
  
  # Set HOME to temp directory for user scope tests
  export HOME="$TEST_TEMP_DIR/home"
  mkdir -p "$HOME"
  
  # For Windows, also set APPDATA
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    export APPDATA="$TEST_TEMP_DIR/appdata"
    mkdir -p "$APPDATA"
  fi
}

# Cleanup mock environment
cleanup_mock_env() {
  if [[ -n "$TEST_TEMP_DIR" && -d "$TEST_TEMP_DIR" ]]; then
    rm -rf "$TEST_TEMP_DIR"
  fi
}

# Get user scope directory for agent
get_user_scope_dir() {
  local agent="$1"
  
  case "$agent" in
    augment|claude)
      if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        echo "$APPDATA/Claude/commands/seeai"
      else
        echo "$HOME/.claude/commands/seeai"
      fi
      ;;
    copilot)
      if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        echo "$APPDATA/GitHub Copilot/prompts"
      else
        echo "$HOME/.github-copilot/prompts"
      fi
      ;;
    *)
      echo "Unknown agent: $agent" >&2
      return 1
      ;;
  esac
}

# Assert file exists
assert_file_exists() {
  local file="$1"
  local message="${2:-File should exist: $file}"
  
  if [[ ! -f "$file" ]]; then
    echo "FAIL: $message" >&2
    return 1
  fi
}

# Assert file contains text
assert_file_contains() {
  local file="$1"
  local text="$2"
  local message="${3:-File should contain: $text}"
  
  if ! grep -q "$text" "$file"; then
    echo "FAIL: $message" >&2
    echo "File contents:" >&2
    cat "$file" >&2
    return 1
  fi
}

# Assert file does not exist
assert_file_not_exists() {
  local file="$1"
  local message="${2:-File should not exist: $file}"
  
  if [[ -f "$file" ]]; then
    echo "FAIL: $message" >&2
    return 1
  fi
}

# Assert directory exists
assert_dir_exists() {
  local dir="$1"
  local message="${2:-Directory should exist: $dir}"
  
  if [[ ! -d "$dir" ]]; then
    echo "FAIL: $message" >&2
    return 1
  fi
}

# Run seeai.sh script
run_seeai() {
  bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" "$@"
}

