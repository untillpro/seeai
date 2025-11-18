# SeeAI Configuration Script Design

## Overview

[scripts/seeai.sh](../../../scripts/seeai.sh) - a multi-command installation script for seeai prompt templates that supports multiple agentic tools and installation scopes.

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

## Source Files

Source files are stored in the `src/` directory with simple names:

- `design.md` - Software Engineering Design prompt
- `gherkin.md` - Gherkin/BDD prompt

These files are transformed during installation based on the target agent (see "File Organization Strategy" below).

## Installation Locations

### File Organization Strategy

**Copilot** does not support subfolders in the prompts directory. Therefore:

- **Copilot**: Files are installed directly in the prompts directory with a `seeai-` prefix
  - Example: `seeai-design.prompt.md`, `seeai-gherkin.prompt.md`
- **Augment & Claude**: Files are installed in a `seeai/` subdirectory
  - Example: `seeai/design.md`, `seeai/gherkin.md`

### Workspace

- Augment: `./.augment/commands/seeai/`
- Copilot: `./.github/prompts/` (files: `seeai-design.prompt.md`, etc.)
- Claude: `./.claude/commands/seeai/`

### User

- Augment: `~/.augment/commands/seeai/`
- Copilot: Default profile or specific profile (user selects during installation)
  - Default profile: `%APPDATA%/Code/User/prompts/` (Windows), `~/Library/Application Support/Code/User/prompts/` (macOS), `~/.config/Code/User/prompts/` (Linux)
  - Specific profile: `%APPDATA%/Code/User/profiles/<profile-id>/prompts/` (Windows), `~/Library/Application Support/Code/User/profiles/<profile-id>/prompts/` (macOS), `~/.config/Code/User/profiles/<profile-id>/prompts/` (Linux)
  - Files: `seeai-design.prompt.md`, `seeai-gherkin.prompt.md`, etc.
- Claude: `~/.claude/commands/seeai/`

### List Command Search Strategy

The list command searches for files using current installation patterns only:

**For Copilot locations** (prompts directories):

- `seeai-*.prompt.md`

**For Augment/Claude locations** (commands directories):

- `seeai/*.md`

## Install Command Flow

### Step 0: Parse Command-Line Options

Parse options before starting interactive flow:

- `-l` flag: Use local files from `../src` folder
- `--agent <name>`: Pre-select agent (auggie, claude, copilot)

If `--agent` is specified:

- Skip Step 1 (agent selection)
- For copilot: Use default profile, skip profile selection
- Still ask for installation scope (workspace vs user) unless additional options are added

### Step 1: Ask Agent Type

Skip this step if `--agent` option is provided.

```text
Which agent?
1) Augment
2) Claude
3) GitHub Copilot
```

### Step 2: Show Installation Preview (User Scope Default)

Default to user scope and show installation preview:

```text
Installing from: latest
Target: /home/user/.augment/commands/seeai/

The following files will be installed:
  /home/user/.augment/commands/seeai/design.md
  /home/user/.augment/commands/seeai/gherkin.md

Proceed? (Y/w/n) [Y]:
  Y - Install to user scope
  w - Switch to workspace scope (will be prompted again)
  n - Cancel
```

User scope is the default. Options:

- `Y` or Enter: Install to user scope (proceed)
- `w`: Switch to workspace scope, show new preview, ask Y/n again
- `n`: Cancel installation

### Step 2a: Workspace Scope (if 'w' selected)

If user types 'w', switch to workspace scope and show new preview:

```text
Installing from: latest
Target: /home/user/myproject/.augment/commands/seeai/

The following files will be installed:
  /home/user/myproject/.augment/commands/seeai/design.md
  /home/user/myproject/.augment/commands/seeai/gherkin.md

Proceed? (Y/n) [Y]:
```

Simple Y/n confirmation. Default to Y if Enter is pressed.

### Step 2b: Copilot Profile Selection

If user selects Copilot + User scope, ask which VS Code profile.

Skip this step if `--agent copilot` is provided (use default profile).

```text
Select VS Code profile for Copilot:
1) Default profile
2) Specific profile (enter profile ID)
3) List available profiles
```

See "Installation Locations" section for specific paths.

### Step 3: Download and Install

After user confirms (either Y for user scope or Y after switching to workspace), create target directory and install files:

```bash
mkdir -p "$TARGET_DIR"
```

```text
Downloading design.md... OK
Downloading gherkin.md... OK
Creating seeai-version.yml... OK

Installation complete!
```

If `-l` flag is used, show "local (../src)" as source and "Copying" instead of "Downloading":

```text
Installing from: local (../src)
Target: /home/user/myproject/.augment/commands/seeai/

The following files will be installed:
  /home/user/myproject/.augment/commands/seeai/design.md
  /home/user/myproject/.augment/commands/seeai/gherkin.md

Proceed? (Y/n) [Y]:

Copying design.md... OK
Copying gherkin.md... OK
Creating seeai-version.yml... OK

Installation complete!
```

For Copilot, files are transformed with `seeai-` prefix and `.prompt.md` extension during installation (show the transformed names in the file list).

### Step 4: Create Version Metadata File

After successful file installation, create `seeai-version.yml` in the target directory.

Version string generation:

```bash
if [[ "$LOCAL_MODE" == true ]]; then
  VERSION_STRING="local"
else
  if [[ "$VERSION" == "main" ]]; then
    VERSION_STRING="$(date +%Y%m%d)-$(git rev-parse --short HEAD)"
  else
    VERSION_STRING="$REF"
  fi
fi
```

Metadata file content:

```yaml
version: v1.0.0
installed_at: 2025-01-18T14:30:00Z
source: github
files:
  - design.md
  - gherkin.md
```

Fields:

- `version`: Version identifier (tag like `v1.0.0`, date-hash like `20250118-a3f2c1b`, or `local`)
- `installed_at`: ISO 8601 timestamp (`date -u +"%Y-%m-%dT%H:%M:%SZ"`)
- `source`: `github` or `local`
- `files`: List of installed base filenames (not transformed names)

For Copilot installations, the metadata file is placed in the prompts directory alongside the transformed files.

Error handling: The `set -Eeuo pipefail` header ensures the script exits on any error (curl failure, copy failure, etc.).

## List Command

Searches for installed SeeAI files and displays their locations with version metadata.

Search patterns:

- Copilot: `seeai-*.prompt.md`
- Augment/Claude: `seeai/*.md`

Search locations: See "Installation Locations" section above.

Version metadata reading:

- Check for `seeai-version.yml` in each installation directory
- Parse version, source, and installed_at fields
- Display in format: `[version, source, timestamp]`
- If metadata file missing, show files without version info

### Output Example

```text
Found SeeAI installations:

Workspace (Augment) [v1.0.0, github, 2025-01-18T14:30:00Z]:
  ./.augment/commands/seeai/design.md
  ./.augment/commands/seeai/gherkin.md

User (Claude) [local, local, 2025-01-18T10:15:00Z]:
  /home/user/.claude/commands/seeai/design.md

User (Copilot) [20250118-a3f2c1b, github, 2025-01-18T16:45:00Z]:
  C:/Users/Usuario/AppData/Roaming/Code/User/prompts/seeai-design.prompt.md
  C:/Users/Usuario/AppData/Roaming/Code/User/prompts/seeai-gherkin.prompt.md
```

## Implementation Details

### Path Normalization

All output paths are normalized to use forward slashes and consistent drive letter format (C:/ style):

```bash
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
```

This ensures consistent output across different environments (Git Bash, native Windows, etc.).

### Main Script Structure

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# File list - update when adding/removing templates
FILES=(
  "design.md"
  "gherkin.md"
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
  "design.md"
  "gherkin.md"
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
  "design.md"
  "gherkin.md"
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

GitHub Copilot requires `.prompt.md` extension and `seeai-` prefix (no subfolder support):

```bash
if [[ $AGENT_INTERNAL == "copilot" ]]; then
  # Transform: design.md -> seeai-design.prompt.md
  TARGET_FILE="seeai-${file%.md}.prompt.md"
else
  # Keep original name: design.md
  TARGET_FILE="$file"
fi
```

When `--agent copilot` is used with user scope, automatically use default profile:

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
