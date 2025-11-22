#!/usr/bin/env bats
# Tests for remote installation with user scope per agent

load test_helper

setup() {
  setup_mock_env
}

teardown() {
  cleanup_mock_env
}

# Test: Install latest version for auggie user scope
@test "remote install latest version for auggie user scope" {
  run run_seeai install --agent auggie --scope user
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "augment")
  
  assert_dir_exists "$target_dir"
  assert_file_exists "$target_dir/design.md"
  assert_file_exists "$target_dir/gherkin.md"
  assert_file_exists "$target_dir/seeai-version.yml"
  
  assert_file_contains "$target_dir/seeai-version.yml" "version: v0.1.0"
  assert_file_contains "$target_dir/seeai-version.yml" "source: https://github.com/untillpro/seeai/releases/tag/v0.1.0"
}

# Test: Install latest version for claude user scope
@test "remote install latest version for claude user scope" {
  run run_seeai install --agent claude --scope user
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "claude")
  
  assert_dir_exists "$target_dir"
  assert_file_exists "$target_dir/design.md"
  assert_file_exists "$target_dir/gherkin.md"
  assert_file_exists "$target_dir/seeai-version.yml"
  
  assert_file_contains "$target_dir/seeai-version.yml" "version: v0.1.0"
}

# Test: Install latest version for copilot user scope
@test "remote install latest version for copilot user scope" {
  run run_seeai install --agent copilot --scope user
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "copilot")
  
  assert_dir_exists "$target_dir"
  # Copilot files should have seeai- prefix and .prompt.md extension
  assert_file_exists "$target_dir/seeai-design.prompt.md"
  assert_file_exists "$target_dir/seeai-gherkin.prompt.md"
  assert_file_exists "$target_dir/seeai-version.yml"
  
  assert_file_contains "$target_dir/seeai-version.yml" "version: v0.1.0"
}

# Test: Install main branch for auggie user scope
@test "remote install main branch for auggie user scope" {
  run run_seeai install --agent auggie --scope user main
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "augment")
  
  assert_file_exists "$target_dir/seeai-version.yml"
  assert_file_contains "$target_dir/seeai-version.yml" "version: remote-main-a20d9e2"
  assert_file_contains "$target_dir/seeai-version.yml" "source: https://github.com/untillpro/seeai/tree/main"
}

# Test: Install main branch for claude user scope
@test "remote install main branch for claude user scope" {
  run run_seeai install --agent claude --scope user main
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "claude")
  
  assert_file_exists "$target_dir/seeai-version.yml"
  assert_file_contains "$target_dir/seeai-version.yml" "version: remote-main-a20d9e2"
}

# Test: Install main branch for copilot user scope
@test "remote install main branch for copilot user scope" {
  run run_seeai install --agent copilot --scope user main
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "copilot")
  
  assert_file_exists "$target_dir/seeai-version.yml"
  assert_file_contains "$target_dir/seeai-version.yml" "version: remote-main-a20d9e2"
}

# Test: Install specific tag for auggie user scope
@test "remote install specific tag v0.1.0 for auggie user scope" {
  run run_seeai install --agent auggie --scope user v0.1.0
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "augment")
  
  assert_file_exists "$target_dir/seeai-version.yml"
  assert_file_contains "$target_dir/seeai-version.yml" "version: v0.1.0"
  assert_file_contains "$target_dir/seeai-version.yml" "source: https://github.com/untillpro/seeai/releases/tag/v0.1.0"
}

# Test: Install specific tag for claude user scope
@test "remote install specific tag v0.1.0 for claude user scope" {
  run run_seeai install --agent claude --scope user v0.1.0
  
  [ "$status" -eq 0 ]
  
  local target_dir
  target_dir=$(get_user_scope_dir "claude")
  
  assert_file_exists "$target_dir/seeai-version.yml"
  assert_file_contains "$target_dir/seeai-version.yml" "version: v0.1.0"
}

# Test: Install specific tag for copilot user scope
@test "remote install specific tag v0.1.0 for copilot user scope" {
  run run_seeai install --agent copilot --scope user v0.1.0

  [ "$status" -eq 0 ]

  local target_dir
  target_dir=$(get_user_scope_dir "copilot")

  assert_file_exists "$target_dir/seeai-version.yml"
  assert_file_contains "$target_dir/seeai-version.yml" "version: v0.1.0"
}

# Test: Error when no tags exist
@test "remote install fails when no tags exist" {
  export MOCK_EMPTY_TAGS=true

  run run_seeai install --agent auggie --scope user

  [ "$status" -ne 0 ]
  [[ "$output" == *"No releases found"* ]]
}

# Test: Error with invalid agent
@test "remote install fails with invalid agent" {
  run run_seeai install --agent invalid --scope user

  [ "$status" -ne 0 ]
  [[ "$output" == *"Invalid agent"* ]]
}

# Test: Files list in version file
@test "remote install creates correct files list in version file" {
  run run_seeai install --agent auggie --scope user

  [ "$status" -eq 0 ]

  local target_dir
  target_dir=$(get_user_scope_dir "augment")

  assert_file_contains "$target_dir/seeai-version.yml" "files:"
  assert_file_contains "$target_dir/seeai-version.yml" "- design.md"
  assert_file_contains "$target_dir/seeai-version.yml" "- gherkin.md"
}

