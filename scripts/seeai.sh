#!/usr/bin/env bash
set -Eeuo pipefail

# File list - update when adding/removing templates
FILES=(
  "se-design.md"
  "se-gherkin.md"
)

# Global variables
LOCAL_MODE=false
AGENT=""
VERSION=""
AGENT_INTERNAL=""
SCOPE=""
TARGET_DIR=""

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
  echo "$path"
}

# Installation locations
get_workspace_dir() {
  local agent=$1
  case $agent in
    augment) echo "./.augment/commands/" ;;
    copilot) echo "./.github/prompts/" ;;
    claude) echo "./.claude/commands/" ;;
  esac
}

get_global_dir() {
  local agent=$1
  case $agent in
    augment) echo "$HOME/.augment/commands/" ;;
    claude) echo "$HOME/.claude/commands/" ;;
    copilot)
      # Default profile
      case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*) echo "$APPDATA/Code/User/prompts/" ;;
        Darwin*) echo "$HOME/Library/Application Support/Code/User/prompts/" ;;
        Linux*) echo "$HOME/.config/Code/User/prompts/" ;;
      esac
      ;;
  esac
}

# Get all search locations for list command
get_all_locations() {
  local locations=()
  
  # Workspace locations
  locations+=("./.augment/commands/")
  locations+=("./.github/prompts/")
  locations+=("./.claude/commands/")
  
  # Global locations
  locations+=("$HOME/.augment/commands/")
  locations+=("$HOME/.claude/commands/")
  
  # Copilot default profile
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) locations+=("$APPDATA/Code/User/prompts/") ;;
    Darwin*) locations+=("$HOME/Library/Application Support/Code/User/prompts/") ;;
    Linux*) locations+=("$HOME/.config/Code/User/prompts/") ;;
  esac
  
  printf '%s\n' "${locations[@]}"
}

# List command
list_command() {
  echo "Found seeai installations:"
  echo
  
  local found_any=false
  local locations
  mapfile -t locations < <(get_all_locations)
  
  for location in "${locations[@]}"; do
    if [[ ! -d "$location" ]]; then
      continue
    fi
    
    local files=()

    # For Copilot locations, also search for .prompt.md
    if [[ "$location" == *"/prompts/"* ]]; then
      mapfile -t files < <(find "$location" -maxdepth 1 -type f \( -name "se-*.md" -o -name "se-*.prompt.md" \) 2>/dev/null || true)
    else
      mapfile -t files < <(find "$location" -maxdepth 1 -type f -name "se-*.md" 2>/dev/null || true)
    fi
    
    if [[ ${#files[@]} -gt 0 ]]; then
      found_any=true
      
      # Determine label
      local label=""
      case "$location" in
        ./.augment/commands/) label="Workspace (Augment)" ;;
        ./.github/prompts/) label="Workspace (Copilot)" ;;
        ./.claude/commands/) label="Workspace (Claude)" ;;
        "$HOME/.augment/commands/") label="User Global (Augment)" ;;
        "$HOME/.claude/commands/") label="User Global (Claude)" ;;
        *) label="User Global (Copilot)" ;;
      esac
      
      echo "$label:"
      for file in "${files[@]}"; do
        echo "  $(normalize_path "$file")"
      done
      echo "  (${#files[@]} files total)"
      echo
    fi
  done
  
  if [[ "$found_any" == false ]]; then
    echo "No seeai installations found."
  fi
}

# Check for existing installations
check_existing() {
  local locations
  mapfile -t locations < <(get_all_locations)
  
  local found_files=()
  
  for location in "${locations[@]}"; do
    if [[ ! -d "$location" ]]; then
      continue
    fi
    
    if [[ "$location" == *"/prompts/"* ]]; then
      mapfile -t files < <(find "$location" -maxdepth 1 -type f \( -name "se-*.md" -o -name "se-*.prompt.md" \) 2>/dev/null || true)
    else
      mapfile -t files < <(find "$location" -maxdepth 1 -type f -name "se-*.md" 2>/dev/null || true)
    fi
    
    found_files+=("${files[@]}")
  done
  
  if [[ ${#found_files[@]} -gt 0 ]]; then
    echo "Checking for existing installations..."
    echo
    echo "Found existing files:"
    for file in "${found_files[@]}"; do
      echo "  $(normalize_path "$file")"
    done
    echo

    read -p "Continue with installation? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 0
    fi
  fi
}

# Ask agent type
ask_agent() {
  if [[ -n "$AGENT" ]]; then
    return
  fi

  echo "Which agent?"
  echo "1) Augment (.augment/commands/)"
  echo "2) GitHub Copilot (.github/prompts/)"
  echo "3) Claude (.claude/commands/)"
  read -p "Select (1-3): " -r choice

  case $choice in
    1) AGENT="auggie" ;;
    2) AGENT="copilot" ;;
    3) AGENT="claude" ;;
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
  echo "1) Current workspace"
  echo "2) User global"
  read -p "Select (1-2): " -r choice

  case $choice in
    1) SCOPE="workspace" ;;
    2) SCOPE="global" ;;
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
  read -p "Select (1-3): " -r choice

  case $choice in
    1)
      # Use default profile (already set by get_global_dir)
      ;;
    2)
      read -p "Enter profile ID: " -r profile_id
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
    source_label="$VERSION"
  fi

  # Convert to absolute path
  local abs_target_dir
  abs_target_dir=$(cd "$(dirname "$TARGET_DIR")" 2>/dev/null && pwd)/$(basename "$TARGET_DIR") || abs_target_dir="$TARGET_DIR"
  abs_target_dir=$(normalize_path "$abs_target_dir")

  echo
  echo "Installing from: $source_label"
  echo "Target: $abs_target_dir"
  echo
  echo "The following files will be installed:"

  for file in "${FILES[@]}"; do
    local target_file="$file"
    if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
      target_file="${file%.md}.prompt.md"
    fi
    echo "  $abs_target_dir$target_file"
  done

  echo
  read -p "Proceed? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
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
        target_file="${file%.md}.prompt.md"
      fi

      echo -n "Copying $file... "
      cp "$SRC_DIR/$file" "$TARGET_DIR/$target_file"
      echo "OK"
    done
  else
    resolve_version
    BASE_URL="https://raw.githubusercontent.com/untillpro/seeai/${REF}/src"

    for file in "${FILES[@]}"; do
      local target_file="$file"
      if [[ "$AGENT_INTERNAL" == "copilot" ]]; then
        target_file="${file%.md}.prompt.md"
      fi

      echo -n "Downloading $file... "
      curl -fsSL "${BASE_URL}/${file}" -o "$TARGET_DIR/$target_file"
      echo "OK"
    done
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

  # Step 1: Check existing installations
  check_existing

  # Step 2: Ask agent type
  ask_agent

  # Map agent name if it was just selected
  if [[ -z "$AGENT_INTERNAL" ]]; then
    case $AGENT in
      auggie) AGENT_INTERNAL="augment" ;;
      claude) AGENT_INTERNAL="claude" ;;
      copilot) AGENT_INTERNAL="copilot" ;;
    esac
  fi

  # Step 3: Ask installation scope
  ask_scope

  # Set target directory
  if [[ "$SCOPE" == "workspace" ]]; then
    TARGET_DIR=$(get_workspace_dir "$AGENT_INTERNAL")
  else
    TARGET_DIR=$(get_global_dir "$AGENT_INTERNAL")
  fi

  # Step 3a: Ask Copilot profile (if needed)
  ask_copilot_profile

  # Step 4: Download and install
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

