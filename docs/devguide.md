# Development Guide

## Testing Installation Script Locally

```bash
# To test the installation script with local files from the .seeai folder:
# The `-l` flag uses local files from `../.seeai` (relative to script path) instead of downloading from GitHub.
./scripts/seeai.sh install -l --agent <auggie|claude|copilot>


# To list installed seeai files:
./scripts/seeai.sh list
```

Install:

- ./scripts/seeai.sh install -l --agent auggie
- ./scripts/seeai.sh install -l --agent claude
- ./scripts/seeai.sh install -l --agent copilot

List:

- ./scripts/seeai.sh list
