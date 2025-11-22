#!/usr/bin/env bash
# Test helper functions for BATS tests

# Setup mock environment
setup_mock_env() {
  # Set fixtures directory
  export FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"

  # Add mocks to PATH
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"

  # Create temporary test directory
  TEST_TEMP_DIR="$(mktemp -d)"
  export TEST_TEMP_DIR

  # Set HOME to temp directory for user scope tests
  export HOME="$TEST_TEMP_DIR/home"
  mkdir -p "$HOME"

  # Always set APPDATA for testing (needed for copilot on Windows)
  export APPDATA="$TEST_TEMP_DIR/appdata"
  mkdir -p "$APPDATA"
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

  # Map external agent names to internal names
  local agent_internal
  case "$agent" in
    auggie) agent_internal="augment" ;;
    claude) agent_internal="claude" ;;
    copilot) agent_internal="copilot" ;;
    *) agent_internal="$agent" ;;
  esac

  case "$agent_internal" in
    augment)
      echo "$HOME/.augment/commands/seeai"
      ;;
    claude)
      echo "$HOME/.claude/commands/seeai"
      ;;
    copilot)
      case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*)
          echo "$APPDATA/Code/User/prompts/"
          ;;
        Darwin*)
          echo "$HOME/Library/Application Support/Code/User/prompts/"
          ;;
        Linux*)
          echo "$HOME/.config/Code/User/prompts/"
          ;;
        *)
          echo "$HOME/.config/Code/User/prompts/"
          ;;
      esac
      ;;
    *)
      echo "Unknown agent: $agent" >&2
      return 1
      ;;
  esac
}

# Get project scope directory for agent (for negative assertions only)
# Note: In project scope, files remain in specs/agents/seeai/ and are NOT copied
# to agent-specific directories. This function returns the agent-specific directory
# path to verify it does NOT exist.
get_project_scope_dir() {
  local agent="$1"

  # Map external agent names to internal names
  local agent_internal
  case "$agent" in
    auggie) agent_internal="augment" ;;
    claude) agent_internal="claude" ;;
    copilot) agent_internal="copilot" ;;
    *) agent_internal="$agent" ;;
  esac

  case "$agent_internal" in
    augment)
      echo "./.augment/commands/seeai"
      ;;
    claude)
      echo "./.claude/commands/seeai"
      ;;
    copilot)
      echo "./.github/prompts"
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

