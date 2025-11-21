# Model: Configuration Version Tracking

## Why

We need to track which version of SeeAI configuration is installed in different scopes (user vs project) to enable version management, upgrades, and troubleshooting.

## What

- UserVersion model: YAML metadata file for user-scoped installations
- ProjectVersion model: HTML comments in Agent Triggering Files for project-scoped installations
