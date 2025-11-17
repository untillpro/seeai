# Installation

## Why

Users need an easy way to install seeai prompt templates (`se-*.md` files) for different agentic tools (Augment, GitHub Copilot, Claude) without manually copying files. The installation should support:

- Version control (stable vs unstable)
- Multiple agents with different folder conventions
- Both workspace-specific and user-global installations
- Visibility into what's already installed

### How

Create a single bash script (`seeai.sh`) with two commands:

1. **install** - Interactive installation that:
   - Checks for existing files first
   - Asks which agent (Augment/Copilot/Claude/All)
   - Asks scope (workspace vs user global)
   - Downloads files directly from GitHub raw URLs (no archives)
   - Handles agent-specific naming (e.g., `.prompt.md` for Copilot)

2. **list** - Scans known locations and displays installed files

Version is specified as a command argument (`main`, `latest`, or specific tag like `v0.1.0`), with version resolution using git tags for "latest".

### What

- `seeai.sh` script with hardcoded file list and multi-command support
- Installation via one-liner: `curl ... | bash -s install [version]`
- Support for 3 agents x 2 scopes = 6 installation targets
- List command to discover existing installations
- README documentation explaining `main` vs `latest` versions
