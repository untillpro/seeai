# Proposal: Scope as parameter

## Summary

Specify an installation scope as a parameter to the installation script, reducing the need for interactive prompts and enabling fully non-interactive installations.

## Motivation

Currently, the `--agent` parameter allows non-interactive agent selection, but users still need to respond to the Y/w/n prompt for scope selection. Adding a `--scope` parameter enables:

- Fully automated, non-interactive installations
- CI/CD pipeline integration
- Scripted setup for development environments
- Clear, copy-paste ready commands for both user and project installations

## Changes

To modify:

- `scripts/seeai.sh`: Add `--scope` parameter to specify the installation scope (user, project)
- specs/feat/conf/design.md: Update design to include scope parameter handling
- README.md: For each agent provide separate URLs to install with two scopes: user and project
