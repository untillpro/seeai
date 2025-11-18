# Configuration

## Why

Users need an easy way to install and manage seeai prompt templates for different agentic tools without manually copying files.

Requirements:

- Version control (stable vs unstable)
- Multiple agents with different conventions
- Workspace and user scopes
- Visibility into installed versions

## How

- Bash script with install and list commands.
- Install: Interactive, downloads from GitHub, creates version metadata.
- List: Shows installed files with version info.

## What

- scripts/seeai.sh
