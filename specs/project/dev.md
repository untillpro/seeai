# Development Rules

## Project Structure

- scripts
  - seeai.sh: Main installation and management script
- specs/agents/seeai: SeeAI agent specifications
  - design.md: Prompt to design a solution for a given problem
  - gherkin.md: Prompt to design BDD-style gherkin for a given problem

## bash Scripts

- All scripts must have the following header:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```
