# Change: Install all SeeAI files to .seeai folder during project scope installation

## Why

The current project scope installation uses `specs/agents/seeai/` directory, which mixes SeeAI framework files with project specifications. Moving to `.seeai` folder provides better separation between framework files and project content, following the convention of hidden directories for tool-specific files (like `.git`, `.augment`, `.claude`).

## How

Modify the `get_project_dir()` function in `scripts/seeai.sh` to return `.seeai/` instead of `specs/agents/seeai/`. Update all references in triggering instructions to use `@/.seeai/` path. Update documentation and tests to reflect the new location. No automated migration - users reinstall with `./scripts/seeai.sh install --scope project` and manually delete old `specs/agents/seeai/` files if needed. The `.seeai/` directory will be committed to repository to make SeeAI Actions available immediately after clone.

## What

- Installation File Structure model should be updated
- Repo scripts must be moved from the specs/seeai to the .seeai folder
