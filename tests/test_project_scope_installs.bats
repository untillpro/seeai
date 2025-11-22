#!/usr/bin/env bats

load test_helper

setup() {
  setup_mock_env

  # For project scope tests, we need to work in the temp directory
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

# Helper function to get all files for agent (Commands + Actions + Specs)
# Project scope: All 7 files
get_all_agent_files() {
  local agent="$1"
  case "$agent" in
    auggie|claude)
      echo "design.md gherkin.md register.md analyze.md implement.md archive.md specs/specs.md"
      ;;
    copilot)
      echo "seeai-design.prompt.md seeai-gherkin.prompt.md seeai-register.prompt.md seeai-analyze.prompt.md seeai-implement.prompt.md seeai-archive.prompt.md seeai-specs-specs.prompt.md"
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
      echo "seeai-register.prompt.md seeai-analyze.prompt.md seeai-implement.prompt.md seeai-archive.prompt.md"
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
@test "project scope installations (agent x version x mode)" {
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
        local cmd="install --agent $agent --scope project"

        if [[ "$mode" == "local" ]]; then
          cmd="install -l --agent $agent --scope project"
          # Local mode ignores version argument
        else
          # Remote mode: add version if not latest
          [[ "$version" != "latest" ]] && cmd="$cmd $version"
        fi

        # Run installation (from temp directory for project scope)
        run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" $cmd

        if [ "$status" -ne 0 ]; then
          echo "FAILED: Exit status $status"
          echo "Output: $output"
          continue
        fi

        # Get target directory (project scope)
        local target_dir
        target_dir=$(get_project_scope_dir "$agent")

        # Validate directory exists
        if [[ ! -d "$target_dir" ]]; then
          echo "FAILED: Directory does not exist: $target_dir"
          continue
        fi

        # Validate version file exists at specs/agents/seeai/seeai-version.yml
        if [[ ! -f "specs/agents/seeai/seeai-version.yml" ]]; then
          echo "FAILED: Version file missing at specs/agents/seeai/seeai-version.yml"
          continue
        fi

        # Check expected version string
        if [[ "$mode" == "local" ]]; then
          # Local mode: version should start with "local-"
          if ! grep -q "version: local-" "specs/agents/seeai/seeai-version.yml"; then
            echo "FAILED: Expected local version format"
            cat "specs/agents/seeai/seeai-version.yml"
            continue
          fi
        else
          # Remote mode: check expected version
          local expected_version
          expected_version=$(get_expected_version "$version")
          if ! grep -q "version: $expected_version" "specs/agents/seeai/seeai-version.yml"; then
            echo "FAILED: Expected version $expected_version"
            cat "specs/agents/seeai/seeai-version.yml"
            continue
          fi
        fi

        # Check all 7 files exist (Commands + Actions + Specs)
        local files_ok=true
        local agent_files
        agent_files=$(get_all_agent_files "$agent")
        for file in $agent_files; do
          if [[ ! -f "$target_dir/$file" ]]; then
            echo "FAILED: Missing file $file"
            files_ok=false
            break
          fi
        done

        if [[ "$files_ok" == "false" ]]; then
          continue
        fi

        # Verify specs directory exists for auggie/claude
        if [[ "$agent" != "copilot" ]]; then
          if [[ ! -d "$target_dir/specs" ]]; then
            echo "FAILED: specs directory not created"
            files_ok=false
            continue
          fi
        fi

        # Check Actions-only files do NOT exist in user scope
        local user_dir
        user_dir=$(get_user_scope_dir "$agent")
        local action_files
        action_files=$(get_action_files "$agent")
        for file in $action_files; do
          if [[ -f "$user_dir/$file" ]]; then
            echo "FAILED: Action-only file $file should not be in user scope"
            files_ok=false
            break
          fi
        done

        if [[ "$files_ok" == "false" ]]; then
          continue
        fi

        # Verify ACF file exists
        local acf_file
        if [[ "$agent" == "claude" ]]; then
          acf_file="CLAUDE.md"
        else
          acf_file="AGENTS.md"
        fi

        if [[ ! -f "$acf_file" ]]; then
          echo "FAILED: ACF file missing: $acf_file"
          continue
        fi

        # Verify triggering instructions markers exist
        if ! grep -q "<!-- seeai:triggering_instructions:begin -->" "$acf_file"; then
          echo "FAILED: Missing begin marker in ACF"
          continue
        fi

        if ! grep -q "<!-- seeai:triggering_instructions:end -->" "$acf_file"; then
          echo "FAILED: Missing end marker in ACF"
          continue
        fi

        # Verify all 6 action patterns exist
        local required_patterns=(
          "register.md"
          "design.md"
          "analyze.md"
          "implement.md"
          "archive.md"
          "gherkin.md"
        )

        for pattern in "${required_patterns[@]}"; do
          if ! grep -q "$pattern" "$acf_file"; then
            echo "FAILED: Missing pattern $pattern in ACF"
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
        cd "$ORIGINAL_DIR" || true
        cleanup_mock_env
        setup_mock_env
        cd "$TEST_TEMP_DIR" || exit 1
        mkdir -p specs/agents/seeai
        cp -r "$FIXTURES_DIR/specs/agents/seeai/"* specs/agents/seeai/
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

@test "ACF creation when no file exists" {
  local agent="auggie"
  local version="latest"
  local mode="remote"

  echo ""
  echo "=== Testing ACF creation: agent=$agent version=$version mode=$mode ==="

  # Ensure no ACF exists
  rm -f AGENTS.md CLAUDE.md

  # Run installation (from temp directory for project scope)
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install --agent $agent --scope project

  if [ "$status" -ne 0 ]; then
    echo "FAILED: Exit status $status"
    echo "Output: $output"
    return 1
  fi

  # Verify AGENTS.md was created
  if [[ ! -f "AGENTS.md" ]]; then
    echo "FAILED: AGENTS.md was not created"
    return 1
  fi

  # Verify triggering instructions markers exist
  if ! grep -q "<!-- seeai:triggering_instructions:begin -->" "AGENTS.md"; then
    echo "FAILED: Missing begin marker in AGENTS.md"
    return 1
  fi

  if ! grep -q "<!-- seeai:triggering_instructions:end -->" "AGENTS.md"; then
    echo "FAILED: Missing end marker in AGENTS.md"
    return 1
  fi

  # Verify all 6 action patterns exist
  local required_patterns=(
    "register.md"
    "design.md"
    "analyze.md"
    "implement.md"
    "archive.md"
    "gherkin.md"
  )

  for pattern in "${required_patterns[@]}"; do
    if ! grep -q "$pattern" "AGENTS.md"; then
      echo "FAILED: Missing pattern $pattern in AGENTS.md"
      return 1
    fi
  done

  echo "PASSED"
}

@test "ACF append when file exists without instructions" {
  local agent="claude"
  local version="latest"
  local mode="remote"

  echo ""
  echo "=== Testing ACF append: agent=$agent version=$version mode=$mode ==="

  # Create CLAUDE.md with custom content but no triggering instructions
  cat > "CLAUDE.md" <<'EOF'
# Existing Content

Some custom instructions here...
EOF

  # Run installation (from temp directory for project scope)
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install --agent $agent --scope project

  if [ "$status" -ne 0 ]; then
    echo "FAILED: Exit status $status"
    echo "Output: $output"
    return 1
  fi

  # Verify CLAUDE.md still exists
  if [[ ! -f "CLAUDE.md" ]]; then
    echo "FAILED: CLAUDE.md was deleted"
    return 1
  fi

  # Verify original content is preserved
  if ! grep -q "Some custom instructions here..." "CLAUDE.md"; then
    echo "FAILED: Original content not preserved"
    cat "CLAUDE.md"
    return 1
  fi

  # Verify triggering instructions markers exist
  if ! grep -q "<!-- seeai:triggering_instructions:begin -->" "CLAUDE.md"; then
    echo "FAILED: Missing begin marker in CLAUDE.md"
    return 1
  fi

  if ! grep -q "<!-- seeai:triggering_instructions:end -->" "CLAUDE.md"; then
    echo "FAILED: Missing end marker in CLAUDE.md"
    return 1
  fi

  # Verify all 6 action patterns exist
  local required_patterns=(
    "register.md"
    "design.md"
    "analyze.md"
    "implement.md"
    "archive.md"
    "gherkin.md"
  )

  for pattern in "${required_patterns[@]}"; do
    if ! grep -q "$pattern" "CLAUDE.md"; then
      echo "FAILED: Missing pattern $pattern in CLAUDE.md"
      return 1
    fi
  done

  echo "PASSED"
}

@test "ACF update when file exists with old instructions" {
  local agent="auggie"
  local version="latest"
  local mode="remote"

  echo ""
  echo "=== Testing ACF update: agent=$agent version=$version mode=$mode ==="

  # Create AGENTS.md with old triggering instructions and surrounding content
  cat > "AGENTS.md" <<'EOF'
# Existing Content Before

Some instructions before the block...

<!-- seeai:triggering_instructions:begin -->
## OLD SeeAI Instructions
- Old instruction 1
- Old instruction 2
<!-- seeai:triggering_instructions:end -->

More content after the block...
EOF

  # Run installation (from temp directory for project scope)
  run bash "$BATS_TEST_DIRNAME/../scripts/seeai.sh" install --agent $agent --scope project

  if [ "$status" -ne 0 ]; then
    echo "FAILED: Exit status $status"
    echo "Output: $output"
    return 1
  fi

  # Verify AGENTS.md still exists
  if [[ ! -f "AGENTS.md" ]]; then
    echo "FAILED: AGENTS.md was deleted"
    return 1
  fi

  # Verify content before block is preserved
  if ! grep -q "Some instructions before the block..." "AGENTS.md"; then
    echo "FAILED: Content before block not preserved"
    cat "AGENTS.md"
    return 1
  fi

  # Verify old instructions are replaced (should NOT exist)
  if grep -q "OLD SeeAI Instructions" "AGENTS.md"; then
    echo "FAILED: Old instructions not replaced"
    cat "AGENTS.md"
    return 1
  fi

  # Verify triggering instructions markers still exist
  if ! grep -q "<!-- seeai:triggering_instructions:begin -->" "AGENTS.md"; then
    echo "FAILED: Missing begin marker in AGENTS.md"
    return 1
  fi

  if ! grep -q "<!-- seeai:triggering_instructions:end -->" "AGENTS.md"; then
    echo "FAILED: Missing end marker in AGENTS.md"
    return 1
  fi

  # Verify all 6 action patterns exist (new instructions)
  local required_patterns=(
    "register.md"
    "design.md"
    "analyze.md"
    "implement.md"
    "archive.md"
    "gherkin.md"
  )

  for pattern in "${required_patterns[@]}"; do
    if ! grep -q "$pattern" "AGENTS.md"; then
      echo "FAILED: Missing pattern $pattern in AGENTS.md"
      return 1
    fi
  done

  echo "PASSED"
}


