#!/usr/bin/env bash
set -Eeuo pipefail

# File list - update when adding/removing templates
FILES=(
  "design.md"
  "gherkin.md"
)

# Location definitions - declarative configuration
declare -A WORKSPACE_BASE_DIRS=(
  [augment]="./.augment/commands"
  [copilot]="./.github/prompts"
  [claude]="./.claude/commands"
)

declare -A GLOBAL_BASE_DIRS=(
  [augment]="$HOME/.augment/commands"
  [claude]="$HOME/.claude/commands"
)

# Copilot global base dir depends on OS
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
# Copilot doesn't support subfolders, so files go directly in base dir with seeai- prefix
# Other agents use seeai/ subdirectory
get_workspace_dir() {
  local agent=$1
  if [[ $agent == "copilot" ]]; then
    echo "${WORKSPACE_BASE_DIRS[$agent]}/"
  else
    echo "${WORKSPACE_BASE_DIRS[$agent]}/$SEEAI_SUBDIR/"
  fi
}

get_global_dir() {
  local agent=$1
  if [[ $agent == "copilot" ]]; then
    echo "$(get_copilot_global_base)/"
  else
    echo "${GLOBAL_BASE_DIRS[$agent]}/$SEEAI_SUBDIR/"
  fi
}

# Get all search locations for list command (base dirs + seeai subdirs)
get_all_locations() {
  local locations=()

  # Workspace locations - base and seeai subdirectories
  for agent in augment copilot claude; do
    local base="${WORKSPACE_BASE_DIRS[$agent]}"
    locations+=("$base/")
    locations+=("$base/$SEEAI_SUBDIR/")
  done

  # Global locations - base and seeai subdirectories
  for agent in augment claude; do
    local base="${GLOBAL_BASE_DIRS[$agent]}"
    locations+=("$base/")
    locations+=("$base/$SEEAI_SUBDIR/")
  done

  # Copilot global - base and seeai subdirectory
  local copilot_base
  copilot_base=$(get_copilot_global_base)
  locations+=("$copilot_base/")
  locations+=("$copilot_base/$SEEAI_SUBDIR/")

  printf '%s\n' "${locations[@]}"
}

# Create version metadata file
create_version_metadata() {
  local target_dir="$1"
  local version_string
  local source_type

  # Determine version string
  if [[ "$LOCAL_MODE" == true ]]; then
    version_string="local"
    source_type="local"
  else
    source_type="github"
    if [[ "$VERSION" == "main" ]]; then
      # For main branch, use date-hash format
      local date_part
      local hash_part
      date_part=$(date +%Y%m%d)
      hash_part=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
      version_string="${date_part}-${hash_part}"
    else
      # For tagged versions, use the REF
      version_string="$REF"
    fi
  fi

  # Generate ISO 8601 timestamp
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Create YAML file
  local metadata_file="$target_dir/seeai-version.yml"
  cat > "$metadata_file" <<EOF
version: $version_string
installed_at: $timestamp
source: $source_type
files:
EOF

  # Add file list
  for file in "${FILES[@]}"; do
    echo "  - $file" >> "$metadata_file"
  done
}

# Read version metadata from seeai-version.yml
read_version_metadata() {
  local metadata_file="$1"

  if [[ ! -f "$metadata_file" ]]; then
    echo ""
    return
  fi

  local version
  local source
  local installed_at
  local date_part

  version=$(grep "^version:" "$metadata_file" 2>/dev/null | sed 's/^version: *//' | tr -d '"' | tr -d "'")
  source=$(grep "^source:" "$metadata_file" 2>/dev/null | sed 's/^source: *//' | tr -d '"' | tr -d "'")
  installed_at=$(grep "^installed_at:" "$metadata_file" 2>/dev/null | sed 's/^installed_at: *//' | tr -d '"' | tr -d "'")

  # Extract just the date part (YYYY-MM-DD)
  date_part=$(echo "$installed_at" | cut -d'T' -f1)

  if [[ -n "$version" && -n "$source" && -n "$date_part" ]]; then
    echo "[$version, $source, $date_part]"
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

    if [[ "$location" == *"/prompts/"* ]]; then
      # Copilot locations: search for seeai-*.prompt.md
      mapfile -t files < <(find "$location" -maxdepth 1 -type f -name "seeai-*.prompt.md" 2>/dev/null || true)
    else
      # Augment/Claude locations: search in seeai/ subfolder
      mapfile -t files < <(find "$location" -maxdepth 1 -type f -name "*.md" -path "*/seeai/*.md" 2>/dev/null || true)
    fi

    if [[ ${#files[@]} -gt 0 ]]; then
      found_any=true

      # Determine label
      local label=""
      case "$location" in
        ./.augment/commands/*) label="Workspace (Augment)" ;;
        ./.github/prompts/*) label="Workspace (Copilot)" ;;
        ./.claude/commands/*) label="Workspace (Claude)" ;;
        "$HOME/.augment/commands"*) label="User (Augment)" ;;
        "$HOME/.claude/commands"*) label="User (Claude)" ;;
        *) label="User (Copilot)" ;;
      esac

      # Read version metadata
      local metadata_file
      local version_info

      if [[ "$location" == *"/prompts/"* ]]; then
        # Copilot: metadata in prompts directory
        metadata_file="$location/seeai-version.yml"
      elif [[ "$location" == *"/seeai/" ]]; then
        # Already in seeai subdirectory
        metadata_file="$location/seeai-version.yml"
      else
        # Augment/Claude: metadata in seeai subdirectory
        metadata_file="$location/seeai/seeai-version.yml"
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
  echo "1) Augment"
  echo "2) Claude"
  echo "3) GitHub Copilot"
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

# Ask installation scope
ask_scope() {
  echo
  echo "Installation scope?"
  echo "1) User [default]"
  echo "2) Current workspace"
  read -p "Select (1-2) [1]: " -r choice </dev/tty

  # Default to User if empty
  choice=${choice:-1}

  case $choice in
    1) SCOPE="global" ;;
    2) SCOPE="workspace" ;;
    *)
      echo "Error: Invalid choice"
      exit 1
      ;;
  esac
}

# Ask Copilot profile (if needed)
ask_copilot_profile() {
  if [[ "$AGENT_INTERNAL" != "copilot" || "$SCOPE" != "global" ]]; then
    return
  fi

  # If --agent was provided, use default profile
  if [[ -n "$AGENT" ]] && [[ "$AGENT" == "copilot" ]]; then
    return
  fi

  echo
  echo "Select VS Code profile for Copilot:"
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
      # Copilot doesn't support subfolders, so files go directly in prompts/
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
    REF=$(git ls-remote --tags --refs --sort='v:refname' \
      https://github.com/untillpro/seeai.git | tail -n1 | sed 's/.*\///')
    # Fail if no tags found
    if [[ -z "$REF" ]]; then
      echo "Error: No releases found. Use 'bash -s install main' to install from the main branch."
      exit 1
    fi
  else
    REF="$VERSION"
  fi
}

# Download and install files
install_files() {
  local source_label
  if [[ "$LOCAL_MODE" == true ]]; then
    source_label="local (../src)"
  else
    resolve_version
    source_label="$VERSION"
  fi

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

  echo
  echo "Installing from: $source_label"
  echo "Target: $abs_target_dir"
  echo
  echo "The following files will be installed:"

  for file in "${FILES[@]}"; do
    local target_file="$file"
    if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
      # Copilot: add seeai- prefix and change extension to .prompt.md
      target_file="seeai-${file%.md}.prompt.md"
    fi
    echo "  $abs_target_dir$target_file"
  done

  echo
  read -p "Proceed? (Y/n) [Y]: " -n 1 -r </dev/tty
  echo
  # Default to Y if empty, exit only on explicit n/N
  if [[ -n $REPLY && $REPLY =~ ^[Nn]$ ]]; then
    exit 0
  fi

  # Create target directory
  mkdir -p "$TARGET_DIR"

  # Install files
  if [[ "$LOCAL_MODE" == true ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    SRC_DIR="$SCRIPT_DIR/../src"

    for file in "${FILES[@]}"; do
      local target_file="$file"
      if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
        # Copilot: add seeai- prefix and change extension to .prompt.md
        target_file="seeai-${file%.md}.prompt.md"
      fi

      echo -n "Copying $file... "
      cp "$SRC_DIR/$file" "$TARGET_DIR/$target_file"
      echo "OK"
    done
  else
    BASE_URL="https://raw.githubusercontent.com/untillpro/seeai/${REF}/src"

    for file in "${FILES[@]}"; do
      local target_file="$file"
      if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
        # Copilot: add seeai- prefix and change extension to .prompt.md
        target_file="seeai-${file%.md}.prompt.md"
      fi

      echo -n "Downloading $file... "
      curl -fsSL "${BASE_URL}/${file}" -o "$TARGET_DIR/$target_file"
      echo "OK"
    done
  fi

  # Create version metadata file
  echo -n "Creating seeai-version.yml... "
  create_version_metadata "$TARGET_DIR"
  echo "OK"

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

  # Step 2: Ask installation scope
  ask_scope

  # Set target directory
  if [[ "$SCOPE" == "workspace" ]]; then
    TARGET_DIR=$(get_workspace_dir "$AGENT_INTERNAL")
  else
    TARGET_DIR=$(get_global_dir "$AGENT_INTERNAL")
  fi

  # Step 2a: Ask Copilot profile (if needed)
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

