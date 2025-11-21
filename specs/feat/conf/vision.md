# Feature: Configuration

## Stories

- As a User I need an easy way to install and manage seeai files in both user and project scopes so that I can keep my environment up to date and consistent.

## How

- Bash script with install and list commands.
- Install: Interactive, downloads from GitHub, creates version metadata.
- List: Shows installed files with version info.

## Requirements

### General

- Distinguish stable vs unstable versions
- Handle multiple agents with different conventions
- Project and user scopes
- Visibility into installed versions

### NLI support

- System installs Triggering Instructions into Agents Config Files (project scope only):
  - AGENTS.md for auggie, gemini, copilot
  - CLAUDE.md for claude
- Version metadata is stored separately in VersionInfo file at `specs/agents/seeai/seeai-version.yml`
- Only instruction block markers are written to ACF (no version metadata in HTML comments)

```markdown
<!-- SEEAI:BEGIN [version info]-->
# SeeAI Triggering Instructions

- Always open `@/specs/agents/seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/specs/agents/seeai/analyst.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"
- Always open `@/specs/agents/seeai/specifier.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"

<!-- SEEAI:END -->
```  

## What

- scripts/seeai.sh
