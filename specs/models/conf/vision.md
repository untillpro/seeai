# Model: Configuration Version Tracking

## Why

We need to track which version of SeeAI configuration is installed in different scopes (user vs project) to enable version management, upgrades, and troubleshooting.

## What

- UserConfig model: YAML metadata file for user-scoped installations
- ProjectConfig model: HTML comments in Agents Config Files for project-scoped installations
