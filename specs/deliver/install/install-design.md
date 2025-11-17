# SeeAI Installation Script Design

## Overview

Create `scripts/seeai.sh` - a multi-command installation script for seeai prompt templates that supports multiple agentic tools and installation scopes.

## README.md Documentation

README.md should contain only the two one-liner installation commands:

```bash
# Install latest stable version
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install

# Install from main branch (unstable)
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main
```

The script will interactively ask:

- Which agent to use (Augment/Copilot/Claude)
- Installation scope (workspace/global)
- Confirmation if existing files are found

## Command Structure

### Usage

```bash
# Install latest stable (default) - interactive
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install

# Install from main branch (unstable) - interactive
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main
# Install specific version - interactive
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install v0.1.0

# Install for specific agent (non-interactive)
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install --agent auggie

# Install from local ../src folder (for development)
./scripts/seeai.sh install -l --agent claude

# List installed files
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s list
```

### Command Syntax

```text
seeai.sh <command> [version] [options]

Commands:
  install [version]  - Install seeai templates (default: latest)
  list              - List installed templates

Version (for install):
  latest            - Latest stable release (default)
  main              - Current main branch (unstable)
  v0.1.0            - Specific version tag

Options (for install):
  -l                - Use local files from ../src folder (relative to script path, for development)
  --agent <name>    - Specify agent (auggie, claude, copilot) - skips interactive prompt
                      For copilot, uses default profile

Examples:
  seeai.sh install                    # Interactive install, latest version
  seeai.sh install main               # Interactive install, main branch
  seeai.sh install --agent auggie     # Non-interactive, Augment agent
  seeai.sh install -l --agent claude  # Local files, Claude agent
  seeai.sh list                       # List installed files
```

## Installation Locations

### Workspace

- Augment: `./.augment/commands/`
- Copilot: `./.github/prompts/`
- Claude: `./.claude/commands/`

### User Global

- Augment: `~/.augment/commands/`
- Copilot: Default profile or specific profile (user selects during installation)
  - Default profile: `%APPDATA%/Code/User/prompts/` (Windows), `~/Library/Application Support/Code/User/prompts/` (macOS), `~/.config/Code/User/prompts/` (Linux)
  - Specific profile: `%APPDATA%/Code/User/profiles/<profile-id>/prompts/` (Windows), `~/Library/Application Support/Code/User/profiles/<profile-id>/prompts/` (macOS), `~/.config/Code/User/profiles/<profile-id>/prompts/` (Linux)
- Claude: `~/.claude/commands/`

## Install Command Flow

### Step 0: Parse Command-Line Options

Parse options before starting interactive flow:

- `-l` flag: Use local files from `../src` folder
- `--agent <name>`: Pre-select agent (auggie, claude, copilot)

If `--agent` is specified:

- Skip Step 1 (agent selection)
- For copilot: Use default profile, skip profile selection
- Still ask for installation scope (workspace vs user global) unless additional options are added

### Step 1: Check Existing Installations (Automatic)

Use the list command logic to scan for existing `se-*.md` files in all known locations (non-recursively).

If existing files are found, display them and prompt for confirmation:

```text
Checking for existing installations...

Found existing files:
  ./.augment/commands/se-design.md
  ./.augment/commands/se-impl.md

Continue with installation? (y/n)
```

If no existing files are found, skip this prompt and proceed directly to Step 2.

If user answers "n", exit with code 0 (user cancelled, not an error).

Search locations: See "Installation Locations" section above.

### Step 2: Ask Agent Type

Skip this step if `--agent` option is provided.

```text
Which agent?
1) Augment (.augment/commands/)
2) GitHub Copilot (.github/prompts/)
3) Claude (.claude/commands/)
```

### Step 3: Ask Installation Scope

```text
Installation scope?
1) Current workspace
2) User global
```

See "Installation Locations" section for specific paths by agent and scope.

### Step 3a: Installation Location

If user selects Copilot + User global, ask which VS Code profile.

Skip this step if `--agent copilot` is provided (use default profile).

```text
Select VS Code profile for Copilot:
1) Default profile
2) Specific profile (enter profile ID)
3) List available profiles
```

See "Installation Locations" section for specific paths.

### Step 4: Download and Install

Show absolute paths and confirm before creating files:

```text
Installing from: latest (or main, or v0.1.0)
Target: /home/user/myproject/.augment/commands/

The following files will be installed:
  /home/user/myproject/.augment/commands/se-design.md
  /home/user/myproject/.augment/commands/se-gherkin.md

Proceed? (y/n)
```

If user answers "n", exit with code 0 (user cancelled, not an error).

If user answers "y", create target directory and install:

```bash
mkdir -p "$TARGET_DIR"
```

```text
Downloading se-design.md... OK
Downloading se-gherkin.md... OK

Installation complete!
```

If `-l` flag is used, show "local (../src)" as source and "Copying" instead of "Downloading":

```text
Installing from: local (../src)
Target: /home/user/myproject/.augment/commands/

The following files will be installed:
  /home/user/myproject/.augment/commands/se-design.md
  /home/user/myproject/.augment/commands/se-gherkin.md

Proceed? (y/n)

Copying se-design.md... OK
Copying se-gherkin.md... OK

Installation complete!
```

For Copilot, files are renamed with `.prompt.md` extension during installation (show the `.prompt.md` extension in the file list).

Error handling: The `set -Eeuo pipefail` header ensures the script exits on any error (curl failure, copy failure, etc.).

## List Command

Searches for installed `se-*.md` files and displays their locations.

Search locations: See "Installation Locations" section above.

### Output Example

```text
Found seeai installations:

Workspace (Augment):
  ./.augment/commands/se-design.md
  ./.augment/commands/se-impl.md
  ./.augment/commands/se-plan.md
  (8 files total)

User Global (Claude):
  /home/user/.claude/commands/se-design.md
  /home/user/.claude/commands/se-impl.md
  (10 files total)

User Global (Copilot - Windows):
  C:/Users/Usuario/AppData/Roaming/Code/User/prompts/se-design.prompt.md
  C:/Users/Usuario/AppData/Roaming/Code/User/prompts/se-impl.prompt.md
  (10 files total)
```

## Implementation Details

### Main Script Structure

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# File list - update when adding/removing templates
FILES=(
  "se-design.md"
  "se-gherkin.md"
)

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
```

### Option Parsing

```bash
LOCAL_MODE=false
AGENT=""

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
```

### Version Resolution

```bash
VERSION=${VERSION:-latest}

if [[ $VERSION == "main" ]]; then
  REF="main"
elif [[ $VERSION == "latest" ]]; then
  REF=$(git ls-remote --tags --refs --sort='v:refname' \
    https://github.com/untillpro/seeai.git | tail -n1 | sed 's/.*\///')
else
  REF="$VERSION"
fi
```

### File Download

Files are downloaded from the `src` folder in the repository.

For remote installation (default):

```bash
BASE_URL="https://raw.githubusercontent.com/untillpro/seeai/${REF}/src"

FILES=(
  "se-design.md"
  "se-gherkin.md"
)

for file in "${FILES[@]}"; do
  curl -fsSL "${BASE_URL}/${file}" -o "$TARGET_DIR/$file"
done
```

For local installation (`-l` flag):

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/../src"

FILES=(
  "se-design.md"
  "se-gherkin.md"
)

for file in "${FILES[@]}"; do
  cp "$SRC_DIR/$file" "$TARGET_DIR/$file"
done
```

### Agent-Specific Handling

Agent name mapping:

```bash
# Map friendly names to internal names
case $AGENT in
  auggie)
    AGENT_INTERNAL="augment"
    ;;
  claude)
    AGENT_INTERNAL="claude"
    ;;
  copilot)
    AGENT_INTERNAL="copilot"
    ;;
esac
```

GitHub Copilot requires `.prompt.md` extension:

```bash
if [[ $AGENT_INTERNAL == "copilot" ]]; then
  # Rename se-design.md to se-design.prompt.md
  TARGET_FILE="${file%.md}.prompt.md"
else
  TARGET_FILE="$file"
fi
```

When `--agent copilot` is used with user global scope, automatically use default profile:

```bash
if [[ $AGENT == "copilot" && -n "$AGENT" ]]; then
  # Use default profile location
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) TARGET_DIR="$APPDATA/Code/User/prompts" ;;
    Darwin*) TARGET_DIR="$HOME/Library/Application Support/Code/User/prompts" ;;
    Linux*) TARGET_DIR="$HOME/.config/Code/User/prompts" ;;
  esac
fi
```

### File List

The global `FILES` array (defined in Main Script Structure) contains all `se-*.md` files to install. Update this array when adding/removing templates.

### Copilot Profile Detection

For listing available VS Code profiles:

```bash
# Detect OS
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) VSCODE_USER_DIR="$APPDATA/Code/User" ;;
  Darwin*) VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User" ;;
  Linux*) VSCODE_USER_DIR="$HOME/.config/Code/User" ;;
esac

# List profiles
if [ -d "$VSCODE_USER_DIR/profiles" ]; then
  ls -1 "$VSCODE_USER_DIR/profiles"
fi
```

Profile selection logic:

```bash
if [[ $PROFILE_CHOICE == "default" ]]; then
  TARGET_DIR="$VSCODE_USER_DIR/prompts"
else
  TARGET_DIR="$VSCODE_USER_DIR/profiles/$PROFILE_ID/prompts"
fi
```
