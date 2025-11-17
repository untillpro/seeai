# Development Guidelines

## Project Structure

- scripts
  - seeai.sh: Main installation and management script
- src: Source code
  - se-design.md: Prompt to design a solution for a given problem
  - se-gherkin.md: Prompt to design BDD-style gherkin for a given problem

## Testing Installation Script Locally

```bash
# To test the installation script with local files from the src folder:
./scripts/seeai.sh install -l --agent <auggie|claude|copilot>
# The `-l` flag uses local files from `../src` (relative to script path) instead of downloading from GitHub.

# To list installed seeai files:
./scripts/seeai.sh list
```

## bash Scripts

- All scripts must have the following header:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```
