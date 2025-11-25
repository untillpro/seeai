#!/usr/bin/env bash
set -Eeuo pipefail

# File lists - update when adding/removing templates
# Commands: Can be invoked explicitly, work in both user and project scope
COMMAND_FILES=(
  "commands/design.md"
  "commands/gherkin.md"
)

# Actions: Require Triggering Instructions, work only in project scope
ACTION_FILES=(
  "actions/register.md"
  "actions/analyze.md"
  "actions/implement.md"
  "actions/archive.md"
)

# Specs: Internal templates used by Actions, work only in project scope
SPEC_FILES=(
  "rules/specs-structure.md"
  "rules/psa-structure.md"
  "rules/design-structure.md"
)

# All files (for project scope and version info)
# Built from the arrays above to ensure consistency
ALL_FILES=(
  "${ACTION_FILES[@]}"
  "${COMMAND_FILES[@]}"
  "${SPEC_FILES[@]}"
)

# Location definitions - declarative configuration
declare -A PROJECT_BASE_DIRS=(
  [augment]="./.augment/commands"
  [copilot]="./.github/prompts"
  [claude]="./.claude/commands"
)

declare -A GLOBAL_BASE_DIRS=(
  [augment]="$HOME/.augment/commands"
  [claude]="$HOME/.claude/commands"
)

# copilot global base dir depends on OS
get_copilot_global_base() {
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) echo "$APPDATA/Code/User/prompts" ;;
    Darwin*) echo "$HOME/Library/Application Support/Code/User/prompts" ;;
    Linux*) echo "$HOME/.config/Code/User/prompts" ;;
  esac
}

# Subdirectory for seeai files
SEEAI_SUBDIR="seeai"

# Global variables
LOCAL_MODE=false
AGENT=""
VERSION=""
AGENT_INTERNAL=""
SCOPE=""
SCOPE_PROVIDED=false
TARGET_DIR=""
REF=""

# Normalize path to use forward slashes and C:/ format
normalize_path() {
  local path="$1"
  # Convert backslashes to forward slashes
  path="${path//\\//}"
  # Convert /c/ to C:/ format (Git Bash style to Windows style)
  if [[ "$path" =~ ^/([a-z])/ ]]; then
    local drive="${BASH_REMATCH[1]}"
    path="${drive^^}:${path:2}"
  fi
  # Remove /./ patterns
  path="${path//\/.\//\/}"
  echo "$path"
}

# Get installation directory
# Project scope: All files go to .seeai/ regardless of agent
# This is the single source location for all agents in project scope
get_project_dir() {
  echo ".seeai/"
}

get_global_dir() {
  local agent=$1
  if [[ $agent == "copilot" ]]; then
    echo "$(get_copilot_global_base)/"
  else
    echo "${GLOBAL_BASE_DIRS[$agent]}/$SEEAI_SUBDIR/"
  fi
}

# Get all search locations for list command
get_all_locations() {
  local locations=()

  # Project scope: Check .seeai/ (new installations)
  locations+=(".seeai/")

  # Project scope: Also check agent-specific directories for backward compatibility with legacy installations
  for agent in augment copilot claude; do
    local base="${PROJECT_BASE_DIRS[$agent]}"
    locations+=("$base/")
    locations+=("$base/$SEEAI_SUBDIR/")
  done

  # User scope: Global locations - base and seeai subdirectories
  for agent in augment claude; do
    local base="${GLOBAL_BASE_DIRS[$agent]}"
    locations+=("$base/")
    locations+=("$base/$SEEAI_SUBDIR/")
  done

  # copilot global - base and seeai subdirectory
  local copilot_base
  copilot_base=$(get_copilot_global_base)
  locations+=("$copilot_base/")
  locations+=("$copilot_base/$SEEAI_SUBDIR/")

  printf '%s\n' "${locations[@]}"
}

# Get commit hash from GitHub API
get_github_commit_hash() {
  local ref="$1"
  local api_url="https://api.github.com/repos/untillpro/seeai/commits/$ref"

  # Try to fetch commit info from GitHub API
  local response
  response=$(curl -fsSL "$api_url" 2>/dev/null)

  if [[ $? -eq 0 && -n "$response" ]]; then
    # Extract SHA and get first 7 characters
    echo "$response" | grep -o '"sha": *"[^"]*"' | head -1 | sed 's/"sha": *"\([^"]*\)"/\1/' | cut -c1-7
  else
    echo "unknown"
  fi
}

# Get latest tag from GitHub API
get_latest_tag() {
  local api_url="https://api.github.com/repos/untillpro/seeai/tags"

  # Try to fetch tags from GitHub API
  local response
  response=$(curl -fsSL "$api_url" 2>/dev/null)

  if [[ $? -eq 0 && -n "$response" ]]; then
    # Extract first tag name from JSON array
    echo "$response" | grep -o '"name": *"[^"]*"' | head -1 | sed 's/"name": *"\([^"]*\)"/\1/'
  else
    echo ""
  fi
}

# Create VersionInfo file
create_version_info() {
  local scope="$1"  # "user" or "project"
  local target_dir="$2"
  shift 2
  local files_list=("$@")  # Remaining arguments are the file list
  local version_string
  local source_url
  local branch_name
  local hash_part

  # Determine version string and source URL
  if [[ "$LOCAL_MODE" == true ]]; then
    # Local mode: local-<branch>-<hash>
    branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    hash_part=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    version_string="local-${branch_name}-${hash_part}"
    source_url="https://github.com/untillpro/seeai/tree/${branch_name}"
  else
    if [[ "$VERSION" == "main" ]]; then
      # Remote main branch: remote-main-<hash>
      hash_part=$(get_github_commit_hash "main")
      version_string="remote-main-${hash_part}"
      source_url="https://github.com/untillpro/seeai/tree/main"
    else
      # Tagged version: v0.1.0
      version_string="$REF"
      source_url="https://github.com/untillpro/seeai/releases/tag/${REF}"
    fi
  fi

  # Generate ISO 8601 timestamp
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Determine VersionInfo file location
  local version_info_file
  if [[ "$scope" == "project" ]]; then
    # Project scope: .seeai/seeai-version.yml
    version_info_file=".seeai/seeai-version.yml"
    mkdir -p ".seeai"
  else
    # User scope: in target directory
    version_info_file="$target_dir/seeai-version.yml"
  fi

  # Create YAML file
  cat > "$version_info_file" <<EOF
version: $version_string
installed_at: $timestamp
source: $source_url
files:
EOF

  # Add file list
  for file in "${files_list[@]}"; do
    echo "  - $file" >> "$version_info_file"
  done
}

# Install triggering instructions to ACF (project scope only)
install_triggering_instructions() {
  local agent_internal="$1"

  # Determine ACF filename based on agent
  local acf_file
  if [[ "$agent_internal" == "claude" ]]; then
    acf_file="CLAUDE.md"
  else
    acf_file="AGENTS.md"
  fi

  # Triggering instructions content
  local instructions='<!-- seeai:triggering_instructions:begin -->
## SeeAI Triggering Instructions

- Always load `@/.seeai/actions/register.md` and follow the instructions there when the request sounds like "Register a change [change description]"
- Always load `@/.seeai/commands/design.md` and follow the instructions there when the request sounds like "Design a solution for [problem description]"
- Always load `@/.seeai/actions/analyze.md` and follow the instructions there when the request sounds like "Analyze a change"
- Always load `@/.seeai/actions/implement.md` and follow the instructions there when the request sounds like "implement todo items" or "implement specifications"
- Always load `@/.seeai/actions/archive.md` and follow the instructions there when the request sounds like "archive a change [change reference]"
- Always load `@/.seeai/commands/gherkin.md` and follow the instructions there when the request sounds like "Generate Gherkin scenarios for [feature description]"

<!-- seeai:triggering_instructions:end -->'

  # Check if ACF exists
  if [[ -f "$acf_file" ]]; then
    # Check if triggering instructions block already exists
    if grep -q "<!-- seeai:triggering_instructions:begin -->" "$acf_file"; then
      # Update existing block
      # Create temp file with content before the block
      sed '/<!-- seeai:triggering_instructions:begin -->/,/<!-- seeai:triggering_instructions:end -->/d' "$acf_file" > "${acf_file}.tmp"
      # Append new instructions
      echo "$instructions" >> "${acf_file}.tmp"
      # Replace original file
      mv "${acf_file}.tmp" "$acf_file"
    else
      # Append to existing file
      echo "" >> "$acf_file"
      echo "$instructions" >> "$acf_file"
    fi
  else
    # Create new ACF with instructions
    echo "$instructions" > "$acf_file"
  fi
}

# Read version metadata from seeai-version.yml
read_version_metadata() {
  local metadata_file="$1"

  if [[ ! -f "$metadata_file" ]]; then
    echo ""
    return
  fi

  local version
  local installed_at

  version=$(grep "^version:" "$metadata_file" 2>/dev/null | sed 's/^version: *//' | tr -d '"' | tr -d "'")
  installed_at=$(grep "^installed_at:" "$metadata_file" 2>/dev/null | sed 's/^installed_at: *//' | tr -d '"' | tr -d "'")

  if [[ -n "$version" && -n "$installed_at" ]]; then
    echo "[$version, $installed_at]"
  else
    echo ""
  fi
}

# List command
list_command() {
  echo "Found SeeAI installations:"
  echo

  local found_any=false
  local locations
  mapfile -t locations < <(get_all_locations)

  for location in "${locations[@]}"; do
    if [[ ! -d "$location" ]]; then
      continue
    fi

    local files=()
    local label=""
    local scope=""

    # Determine scope and label based on location
    if [[ "$location" == ".seeai/" ]]; then
      # Project scope: single source location for all agents (new installations)
      label="Project (all agents)"
      scope="project"
      # Find all .md files in .seeai/ subdirectories (actions/, commands/, rules/)
      mapfile -t files < <(find "$location" -type f -name "*.md" 2>/dev/null || true)
    elif [[ "$location" == *"/prompts/"* ]]; then
      # copilot locations: search for seeai-*.prompt.md
      mapfile -t files < <(find "$location" -maxdepth 1 -type f -name "seeai-*.prompt.md" 2>/dev/null || true)
      case "$location" in
        ./.github/prompts/*) label="Project (copilot) [legacy]"; scope="project" ;;
        "$HOME"*) label="User (copilot)"; scope="user" ;;
        *) label="User (copilot)"; scope="user" ;;
      esac
    else
      # Augment/Claude locations: search in seeai/ subfolder
      mapfile -t files < <(find "$location" -maxdepth 1 -type f -name "*.md" -path "*/seeai/*.md" 2>/dev/null || true)
      case "$location" in
        ./.augment/commands/*) label="Project (auggie) [legacy]"; scope="project" ;;
        ./.claude/commands/*) label="Project (claude) [legacy]"; scope="project" ;;
        "$HOME/.augment/commands"*) label="User (auggie)"; scope="user" ;;
        "$HOME/.claude/commands"*) label="User (claude)"; scope="user" ;;
        *) continue ;;
      esac
    fi

    if [[ ${#files[@]} -gt 0 ]]; then
      found_any=true

      # Read VersionInfo
      local metadata_file
      local version_info

      if [[ "$scope" == "project" ]]; then
        # Project scope: check .seeai/seeai-version.yml
        metadata_file=".seeai/seeai-version.yml"
      else
        # User scope: check in installation directory
        if [[ "$location" == *"/prompts/"* ]]; then
          # copilot: metadata in prompts directory
          metadata_file="$location/seeai-version.yml"
        elif [[ "$location" == *"/seeai/" ]]; then
          # Already in seeai subdirectory
          metadata_file="$location/seeai-version.yml"
        else
          # Augment/Claude: metadata in seeai subdirectory
          metadata_file="$location/seeai/seeai-version.yml"
        fi
      fi

      version_info=$(read_version_metadata "$metadata_file")

      if [[ -n "$version_info" ]]; then
        echo "$label $version_info:"
      else
        echo "$label:"
      fi

      for file in "${files[@]}"; do
        echo "  $(normalize_path "$file")"
      done
      echo
    fi
  done

  if [[ "$found_any" == false ]]; then
    echo "No SeeAI installations found."
  fi
}



# Ask agent type
ask_agent() {
  if [[ -n "$AGENT" ]]; then
    return
  fi

  echo "Which agent?"
  echo "1) auggie"
  echo "2) claude"
  echo "3) copilot"
  read -p "Select (1-3): " -r choice </dev/tty

  case $choice in
    1) AGENT="auggie" ;;
    2) AGENT="claude" ;;
    3) AGENT="copilot" ;;
    *)
      echo "Error: Invalid choice"
      exit 1
      ;;
  esac
}

# Ask installation scope (removed - now handled in install_files with Y/w prompt)
ask_scope() {
  # Default to user scope
  SCOPE="global"
}

# Ask copilot profile (if needed)
ask_copilot_profile() {
  if [[ "$AGENT_INTERNAL" != "copilot" || "$SCOPE" != "global" ]]; then
    return
  fi

  # If --agent was provided, use default profile
  if [[ -n "$AGENT" ]] && [[ "$AGENT" == "copilot" ]]; then
    return
  fi

  echo
  echo "Select VS Code profile for copilot:"
  echo "1) Default profile"
  echo "2) Specific profile (enter profile ID)"
  echo "3) List available profiles"
  read -p "Select (1-3): " -r choice </dev/tty

  case $choice in
    1)
      # Use default profile (already set by get_global_dir)
      ;;
    2)
      read -p "Enter profile ID: " -r profile_id </dev/tty
      # copilot doesn't support subfolders, so files go directly in prompts/
      case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) TARGET_DIR="$APPDATA/Code/User/profiles/$profile_id/prompts/" ;;
        Darwin*) TARGET_DIR="$HOME/Library/Application Support/Code/User/profiles/$profile_id/prompts/" ;;
        Linux*) TARGET_DIR="$HOME/.config/Code/User/profiles/$profile_id/prompts/" ;;
      esac
      ;;
    3)
      echo
      echo "Available profiles:"
      case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) VSCODE_USER_DIR="$APPDATA/Code/User" ;;
        Darwin*) VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User" ;;
        Linux*) VSCODE_USER_DIR="$HOME/.config/Code/User" ;;
      esac

      if [[ -d "$VSCODE_USER_DIR/profiles" ]]; then
        ls -1 "$VSCODE_USER_DIR/profiles"
      else
        echo "No profiles found"
      fi
      echo

      # Ask again
      ask_copilot_profile
      ;;
    *)
      echo "Error: Invalid choice"
      exit 1
      ;;
  esac
}

# Resolve version to git ref
resolve_version() {
  VERSION=${VERSION:-latest}

  if [[ $VERSION == "main" ]]; then
    REF="main"
  elif [[ $VERSION == "latest" ]]; then
    REF=$(get_latest_tag)
    # Fail if no tags found
    if [[ -z "$REF" ]]; then
      echo "Error: No releases found. Use 'bash -s install main' to install from the main branch."
      exit 1
    fi
  else
    REF="$VERSION"
  fi
}

# Show installation preview and get confirmation
show_install_preview() {
  local source_label

  if [[ "$LOCAL_MODE" == true ]]; then
    source_label="local (../src)"
  else
    source_label="$VERSION"
  fi

  # Determine which files to show based on scope
  local preview_files=()
  if [[ "$SCOPE" == "user" ]]; then
    preview_files=("${COMMAND_FILES[@]}")
  else
    preview_files=("${ALL_FILES[@]}")
  fi

  echo
  echo "Installing from: $source_label"

  if [[ "$SCOPE" == "project" ]]; then
    # Project scope: Files will be downloaded to .seeai/
    echo "Target: .seeai/"
    echo
    echo "The following files will be installed:"
    for file in "${preview_files[@]}"; do
      echo "  .seeai/$file"
    done
    echo
    echo "Installation will:"
    if [[ "$LOCAL_MODE" == true ]]; then
      echo "  - Copy files from local source to .seeai/"
    else
      echo "  - Download files from GitHub to .seeai/"
    fi
    echo "  - Overwrite existing files to ensure version consistency"
    echo "  - Create seeai-version.yml in .seeai/"
    echo "  - Update triggering instructions in AGENTS.md or CLAUDE.md"
  else
    # User scope: Files will be copied to target directory
    # Convert to absolute path without creating directories
    local abs_target_dir
    if [[ "$TARGET_DIR" != /* && "$TARGET_DIR" != [A-Za-z]:/* ]]; then
      # Relative path: prepend current directory
      abs_target_dir="$(pwd)/$TARGET_DIR"
    else
      # Already absolute
      abs_target_dir="$TARGET_DIR"
    fi
    abs_target_dir=$(normalize_path "$abs_target_dir")

    echo "Target: $abs_target_dir"
    echo
    echo "The following files will be installed:"

    for file in "${preview_files[@]}"; do
      local target_file="$file"
      local base_name="${file##*/}"
      if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
        # copilot: add seeai- prefix and change extension to .prompt.md
        local dir_name="${file%/*}"
        if [[ "$dir_name" != "$file" ]]; then
          target_file="seeai-${dir_name//\//-}-${base_name%.md}.prompt.md"
        else
          target_file="seeai-${file%.md}.prompt.md"
        fi
      else
        # auggie/claude: just use base filename without subdirectory
        target_file="$base_name"
      fi
      echo "  $abs_target_dir$target_file"
    done
  fi
  echo
}

# Download and install files
install_files() {
  # Resolve version first if not local mode
  if [[ "$LOCAL_MODE" != true ]]; then
    resolve_version
  fi

  # Show initial preview
  show_install_preview

  # Skip prompt if scope was provided via parameter
  if [[ "$SCOPE_PROVIDED" == true ]]; then
    # Non-interactive mode: proceed directly
    echo
    echo "Proceeding with non-interactive installation..."
    echo
  else
    # Interactive mode: prompt with Y/w/n options
    echo
    echo "Proceed? (Y/w/n) [Y]: "
    echo "  Y - Install to user scope"
    echo "  w - Switch to project scope (will be prompted again)"
    echo "  n - Cancel"
    echo
    read -p "> " -r choice </dev/tty
    echo

    # Default to Y if empty
    choice=${choice:-Y}

    case $choice in
      [Yy])
        # Continue with user scope (already set)
        ;;
      [Ww])
        # Switch to project scope
        SCOPE="project"
        TARGET_DIR=$(get_project_dir "$AGENT_INTERNAL")

        # Show new preview for project
        show_install_preview

        # Simple Y/n confirmation
        read -p "Proceed? (Y/n) [Y]: " -r confirm </dev/tty
        echo

        # Default to Y if empty, exit only on explicit n/N
        if [[ -n $confirm && $confirm =~ ^[Nn]$ ]]; then
          exit 0
        fi
        ;;
      [Nn])
        exit 0
        ;;
      *)
        echo "Error: Invalid choice"
        exit 1
        ;;
    esac
  fi

  # Determine which files to install based on scope
  local files_to_install=()
  if [[ "$SCOPE" == "user" ]]; then
    # User scope: Install only Commands
    files_to_install=("${COMMAND_FILES[@]}")
  else
    # Project scope: All files (Commands + Actions + Specs) for version tracking
    files_to_install=("${ALL_FILES[@]}")
  fi

  # Install files
  # Create target directory
  mkdir -p "$TARGET_DIR"

  if [[ "$LOCAL_MODE" == true ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SRC_DIR="$SCRIPT_DIR/../.seeai"

    for file in "${files_to_install[@]}"; do
      local target_file="$file"
      if [[ "$SCOPE" == "user" ]]; then
        # User scope: flatten subdirectory paths
        local base_name="${file##*/}"
        if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
          # copilot: add seeai- prefix and change extension to .prompt.md
          local dir_name="${file%/*}"
          if [[ "$dir_name" != "$file" ]]; then
            # File is in subdirectory, use directory name as part of prefix
            target_file="seeai-${dir_name//\//-}-${base_name%.md}.prompt.md"
          else
            target_file="seeai-${file%.md}.prompt.md"
          fi
        else
          # auggie/claude: just use base filename without subdirectory
          target_file="$base_name"
        fi
      fi

      # Create subdirectory if needed (for project scope only)
      local target_dir_path="$(dirname "$TARGET_DIR/$target_file")"
      if [[ "$target_dir_path" != "$TARGET_DIR" ]]; then
        mkdir -p "$target_dir_path"
      fi

      # Sequential operation: use echo -n for traditional progress display
      echo -n "Copying $file... "
      if cp "$SRC_DIR/$file" "$TARGET_DIR/$target_file"; then
        echo "OK"
      else
        echo "FAILED"
        exit 1
      fi
    done
  else
    BASE_URL="https://raw.githubusercontent.com/untillpro/seeai/${REF}/.seeai"

    # Helper function to download a single file
    download_file() {
      local file="$1"
      local target_file="$file"

      if [[ "$SCOPE" == "user" ]]; then
        # User scope: flatten subdirectory paths
        local base_name="${file##*/}"
        if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
          # copilot: add seeai- prefix and change extension to .prompt.md
          local dir_name="${file%/*}"
          if [[ "$dir_name" != "$file" ]]; then
            # File is in subdirectory, use directory name as part of prefix
            target_file="seeai-${dir_name//\//-}-${base_name%.md}.prompt.md"
          else
            target_file="seeai-${file%.md}.prompt.md"
          fi
        else
          # auggie/claude: just use base filename without subdirectory
          target_file="$base_name"
        fi
      fi

      # Create subdirectory if needed (for project scope only)
      local target_dir_path="$(dirname "$TARGET_DIR/$target_file")"
      if [[ "$target_dir_path" != "$TARGET_DIR" ]]; then
        mkdir -p "$target_dir_path"
      fi

      # Parallel operation: use atomic echo to prevent output interleaving
      # When running in parallel with xargs, separate echo statements can interleave
      # (e.g., "Downloading file1... Downloading file2... OK" on same line)
      if curl -fsSL "${BASE_URL}/${file}" -o "$TARGET_DIR/$target_file"; then
        echo "Downloading $file... OK"
        return 0
      else
        echo "Downloading $file... FAILED"
        return 1
      fi
    }

    # Export function and variables for xargs subshells
    export -f download_file
    export BASE_URL
    export TARGET_DIR
    export SCOPE
    export AGENT_INTERNAL
    export REF

    # Download files in parallel using xargs
    # -P 4: Run up to 4 downloads in parallel
    # -I {}: Replace {} with the input line
    # The process will fail fast if any download fails
    if ! printf '%s\n' "${files_to_install[@]}" | xargs -P 4 -I {} bash -c 'download_file "$@"' _ {}; then
      echo
      echo "Error: One or more downloads failed."
      exit 1
    fi
  fi

  # Validate that all files were successfully installed
  echo -n "Validating installation... "
  local missing_files=()
  for file in "${files_to_install[@]}"; do
    local target_file="$file"
    if [[ "$SCOPE" == "user" ]]; then
      # User scope: flatten subdirectory paths
      local base_name="${file##*/}"
      if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
        # copilot: add seeai- prefix and change extension to .prompt.md
        local dir_name="${file%/*}"
        if [[ "$dir_name" != "$file" ]]; then
          target_file="seeai-${dir_name//\//-}-${base_name%.md}.prompt.md"
        else
          target_file="seeai-${file%.md}.prompt.md"
        fi
      else
        # auggie/claude: just use base filename without subdirectory
        target_file="$base_name"
      fi
    fi

    if [[ ! -f "$TARGET_DIR/$target_file" ]]; then
      missing_files+=("$file")
    fi
  done

  if [[ ${#missing_files[@]} -gt 0 ]]; then
    echo "FAILED"
    echo
    echo "Error: Installation incomplete. The following files are missing:"
    for file in "${missing_files[@]}"; do
      echo "  - $file"
    done
    echo
    echo "Please try running the installation again."
    exit 1
  fi
  echo "OK"

  # Create VersionInfo file
  echo -n "Creating seeai-version.yml... "
  create_version_info "$SCOPE" "$TARGET_DIR" "${files_to_install[@]}"
  echo "OK"

  # Install triggering instructions (project scope only)
  if [[ "$SCOPE" == "project" ]]; then
    echo -n "Installing triggering instructions to ACF... "
    install_triggering_instructions "$AGENT_INTERNAL"
    echo "OK"
  fi

  echo
  echo "Installation complete!"
}

# Install command
install_command() {
  # Parse options
  while [[ $# -gt 0 ]]; do
    case $1 in
      -l)
        LOCAL_MODE=true
        shift
        ;;
      --agent)
        AGENT="$2"
        shift 2
        ;;
      --scope)
        SCOPE="$2"
        SCOPE_PROVIDED=true
        shift 2
        ;;
      *)
        VERSION="$1"
        shift
        ;;
    esac
  done

  # Validate agent if provided
  if [[ -n "$AGENT" ]]; then
    case $AGENT in
      auggie|claude|copilot)
        # Valid agent
        ;;
      *)
        echo "Error: Invalid agent '$AGENT'. Must be: auggie, claude, or copilot"
        exit 1
        ;;
    esac
  fi

  # Validate scope if provided
  if [[ "$SCOPE_PROVIDED" == true ]]; then
    case $SCOPE in
      user|project)
        # Valid scope
        ;;
      *)
        echo "Error: Invalid scope '$SCOPE'. Must be: user or project"
        exit 1
        ;;
    esac
  fi

  # Map agent names
  case $AGENT in
    auggie) AGENT_INTERNAL="augment" ;;
    claude) AGENT_INTERNAL="claude" ;;
    copilot) AGENT_INTERNAL="copilot" ;;
  esac

  # Step 1: Ask agent type
  ask_agent

  # Map agent name if it was just selected
  if [[ -z "$AGENT_INTERNAL" ]]; then
    case $AGENT in
      auggie) AGENT_INTERNAL="augment" ;;
      claude) AGENT_INTERNAL="claude" ;;
      copilot) AGENT_INTERNAL="copilot" ;;
    esac
  fi

  # Step 2: Ask installation scope (skip if --scope provided)
  if [[ "$SCOPE_PROVIDED" != true ]]; then
    ask_scope
  fi

  # Set target directory based on scope
  if [[ "$SCOPE" == "project" ]]; then
    TARGET_DIR=$(get_project_dir "$AGENT_INTERNAL")
  else
    # Default to global/user scope
    if [[ -z "$SCOPE" ]]; then
      SCOPE="global"
    fi
    TARGET_DIR=$(get_global_dir "$AGENT_INTERNAL")
  fi

  # Step 2a: Ask copilot profile (if needed)
  ask_copilot_profile

  # Step 3: Download and install
  install_files
}

# Main script
COMMAND="${1:-}"
shift || true

case "$COMMAND" in
  install)
    install_command "$@"
    ;;
  list)
    list_command
    ;;
  *)
    echo "Usage: seeai.sh <install|list> [options]"
    exit 1
    ;;
esac

