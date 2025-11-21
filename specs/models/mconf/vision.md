# Model: Configuration Version Tracking

## Why

We need to track which version of SeeAI configuration is installed in different scopes (user vs project) to enable version management, upgrades, and troubleshooting.

## What

- VersionInfo model: YAML metadata file for both user-scoped and project-scoped installations
- Triggering Instructions model: Natural language patterns in Agents Config Files that enable NLI
