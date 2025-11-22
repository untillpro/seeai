#!/usr/bin/env bats

load test_helper

setup() {
  setup_mock_env

  # For list command tests, we need to work in the temp directory
  # Save original directory
  ORIGINAL_DIR="$PWD"

  # Change to temp directory
  cd "$TEST_TEMP_DIR" || exit 1

  # Copy fixtures to temp directory (needed for local mode)
  mkdir -p specs/agents/seeai
  cp -r "$FIXTURES_DIR/specs/agents/seeai/"* specs/agents/seeai/
}

teardown() {
  # Return to original directory
  cd "$ORIGINAL_DIR" || true

  cleanup_mock_env
}

@test "list command shows project scope installation from specs/agents/seeai/" {
  # Install in project scope (creates version file in specs/agents/seeai/)
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install -l --agent auggie --scope project
  [ "$status" -eq 0 ] || {
    echo "Installation failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Run list command
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" list
  [ "$status" -eq 0 ] || {
    echo "List command failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Should show "Project (all agents)" label
  echo "$output" | grep -q "Project (all agents)" || {
    echo "Expected 'Project (all agents)' in output"
    echo "Output: $output"
    return 1
  }

  # Should show files from specs/agents/seeai/
  echo "$output" | grep -q "specs/agents/seeai/design.md" || {
    echo "Expected 'specs/agents/seeai/design.md' in output"
    echo "Output: $output"
    return 1
  }
}

@test "list command shows legacy project scope installations from agent-specific directories" {
  # Simulate legacy installation by manually creating files in agent-specific directory
  mkdir -p .augment/commands/seeai
  cp specs/agents/seeai/design.md .augment/commands/seeai/
  cp specs/agents/seeai/gherkin.md .augment/commands/seeai/

  # Create legacy version file
  cat > .augment/commands/seeai/seeai-version.yml << EOF
version: v0.0.9
installed_at: 2025-01-15T10:00:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.0.9
files:
  - design.md
  - gherkin.md
EOF

  # Run list command
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" list
  [ "$status" -eq 0 ] || {
    echo "List command failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Should show legacy label
  echo "$output" | grep -q "Project (auggie) \[legacy\]" || {
    echo "Expected 'Project (auggie) [legacy]' in output"
    echo "Output: $output"
    return 1
  }

  # Should show files from legacy location
  echo "$output" | grep -q ".augment/commands/seeai/design.md" || {
    echo "Expected '.augment/commands/seeai/design.md' in output"
    echo "Output: $output"
    return 1
  }
}

@test "list command shows both new and legacy project scope installations" {
  # Install new project scope
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install -l --agent auggie --scope project
  [ "$status" -eq 0 ] || {
    echo "Installation failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Simulate legacy installation
  mkdir -p .claude/commands/seeai
  cp specs/agents/seeai/design.md .claude/commands/seeai/
  cp specs/agents/seeai/gherkin.md .claude/commands/seeai/

  cat > .claude/commands/seeai/seeai-version.yml << EOF
version: v0.0.8
installed_at: 2025-01-10T10:00:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.0.8
files:
  - design.md
  - gherkin.md
EOF

  # Run list command
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" list
  [ "$status" -eq 0 ] || {
    echo "List command failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Should show both installations
  echo "$output" | grep -q "Project (all agents)" || {
    echo "Expected 'Project (all agents)' in output"
    echo "Output: $output"
    return 1
  }

  echo "$output" | grep -q "Project (claude) \[legacy\]" || {
    echo "Expected 'Project (claude) [legacy]' in output"
    echo "Output: $output"
    return 1
  }
}

@test "list command shows correct version info for project scope" {
  # Install in project scope
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install -l --agent auggie --scope project
  [ "$status" -eq 0 ] || {
    echo "Installation failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Run list command
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" list
  [ "$status" -eq 0 ] || {
    echo "List command failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Should show version info from specs/agents/seeai/seeai-version.yml
  echo "$output" | grep -q "Project (all agents)" || {
    echo "Expected 'Project (all agents)' in output"
    echo "Output: $output"
    return 1
  }

  echo "$output" | grep -q "local" || {
    echo "Expected 'local' version in output"
    echo "Output: $output"
    return 1
  }
}

@test "list command handles missing installations gracefully" {
  # Remove specs/agents/seeai to simulate no installations
  rm -rf specs/agents/seeai

  # Run list command with no installations
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" list
  [ "$status" -eq 0 ] || {
    echo "List command failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Should show "No SeeAI installations found" message
  echo "$output" | grep -q "No SeeAI installations found" || {
    echo "Expected 'No SeeAI installations found' in output"
    echo "Output: $output"
    return 1
  }
}

@test "list command shows user scope installations" {
  # Install in user scope
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install -l --agent auggie --scope user
  [ "$status" -eq 0 ] || {
    echo "Installation failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Run list command
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" list
  [ "$status" -eq 0 ] || {
    echo "List command failed with status $status"
    echo "Output: $output"
    return 1
  }

  # Should show user scope label
  echo "$output" | grep -q "User (auggie)" || {
    echo "Expected 'User (auggie)' in output"
    echo "Output: $output"
    return 1
  }

  # Should show files from user home directory
  echo "$output" | grep -q ".augment/commands/seeai/design.md" || {
    echo "Expected '.augment/commands/seeai/design.md' in output"
    echo "Output: $output"
    return 1
  }
}

