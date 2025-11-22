# Development Rules

## Project Structure

- scripts
  - seeai.sh: Main installation and management script
- specs/agents/seeai: SeeAI agent specifications
  - design.md: Prompt to design a solution for a given problem
  - gherkin.md: Prompt to design BDD-style gherkin for a given problem
  - register.md: Prompt to register a change
  - analyze.md: Prompt to analyze a change
  - implement.md: Prompt to implement specifications
  - archive.md: Prompt to archive a change
  - specs/specs.md: Specification structure and creation criteria template

## bash Scripts

- All scripts must have the following header:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```
