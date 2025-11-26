#!/usr/bin/env bats

load test_helper

setup() {
  setup_mock_env
}

teardown() {
  cleanup_mock_env
}

# Helper function to get expected files for agent
# User scope: Only Commands (design.md, gherkin.md)
get_agent_files() {
  local agent="$1"
  case "$agent" in
    auggie|claude)
      echo "design.md gherkin.md"
      ;;
    copilot)
      echo "seeai-commands-design.prompt.md seeai-commands-gherkin.prompt.md"
      ;;
  esac
}

# Helper function to get Actions-only files (should NOT be in user scope)
get_action_files() {
  local agent="$1"
  case "$agent" in
    auggie|claude)
      echo "register.md analyze.md implement.md archive.md"
      ;;
    copilot)
      echo "seeai-actions-register.prompt.md seeai-actions-analyze.prompt.md seeai-actions-implement.prompt.md seeai-actions-archive.prompt.md"
      ;;
  esac
}

# Helper function to get expected version for remote mode
get_expected_version() {
  local version="$1"
  case "$version" in
    latest)
      echo "v0.1.0"
      ;;
    main)
      echo "remote-main-a20d9e2"
      ;;
    v0.0.9)
      echo "v0.0.9"
      ;;
  esac
}

# Single mega-test covering all combinations
# test(@conf-4, @conf-12)
@test "user scope installations (agent x version x mode)" {
  local agents=("auggie" "claude" "copilot")
  local versions=("latest" "main" "v0.0.9")
  local modes=("remote" "local")

  local total=0
  local passed=0

  for agent in "${agents[@]}"; do
    for version in "${versions[@]}"; do
      for mode in "${modes[@]}"; do
        total=$((total + 1))
        echo ""
        echo "=== Test $total: agent=$agent version=$version mode=$mode ==="

        # Build command
        local cmd="install --agent $agent --scope user"

        if [[ "$mode" == "local" ]]; then
          cmd="install -l --agent $agent --scope user"
          # Local mode ignores version argument
        else
          # Remote mode: add version if not latest
          [[ "$version" != "latest" ]] && cmd="$cmd $version"
        fi

        # Run installation
        run run_seeai $cmd

        if [ "$status" -ne 0 ]; then
          echo "FAILED: Exit status $status"
          echo "Output: $output"
          continue
        fi

        # Get target directory (always user scope)
        local target_dir
        target_dir=$(get_user_scope_dir "$agent")

        # Validate directory exists
        if [[ ! -d "$target_dir" ]]; then
          echo "FAILED: Directory does not exist: $target_dir"
          continue
        fi

        # Validate version file exists
        if [[ ! -f "$target_dir/seeai-version.yml" ]]; then
          echo "FAILED: Version file missing"
          continue
        fi

        # Check expected version string
        if [[ "$mode" == "local" ]]; then
          # Local mode: version should start with "local-"
          if ! grep -q "version: local-" "$target_dir/seeai-version.yml"; then
            echo "FAILED: Expected local version format"
            cat "$target_dir/seeai-version.yml"
            continue
          fi
        else
          # Remote mode: check expected version
          local expected_version
          expected_version=$(get_expected_version "$version")
          if ! grep -q "version: $expected_version" "$target_dir/seeai-version.yml"; then
            echo "FAILED: Expected version $expected_version"
            cat "$target_dir/seeai-version.yml"
            continue
          fi
        fi

        # Check expected files exist (Commands only)
        local files_ok=true
        local agent_files
        agent_files=$(get_agent_files "$agent")
        for file in $agent_files; do
          if [[ ! -f "$target_dir/$file" ]]; then
            echo "FAILED: Missing Command file $file"
            files_ok=false
            break
          fi
        done

        if [[ "$files_ok" == "false" ]]; then
          continue
        fi

        # Check Actions-only files do NOT exist in user scope
        local action_files
        action_files=$(get_action_files "$agent")
        for file in $action_files; do
          if [[ -f "$target_dir/$file" ]]; then
            echo "FAILED: Action-only file $file should not be in user scope"
            files_ok=false
            break
          fi
        done

        if [[ "$files_ok" == "false" ]]; then
          continue
        fi

        # Test passed
        passed=$((passed + 1))
        echo "PASSED"

        # Cleanup for next iteration
        cleanup_mock_env
        setup_mock_env
      done
    done
  done

  echo ""
  echo "=========================================="
  echo "Results: $passed/$total tests passed"
  echo "=========================================="

  # Fail if not all tests passed
  [ "$passed" -eq "$total" ]
}