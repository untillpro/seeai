# Development Guidelines

## Project Structure

- scripts
  - seeai.sh: Main installation and management script
- src: Source code
  - se-design.md: Prompt to design a solution for a given problem
  - se-gherkin.md: Prompt to design BDD-style gherkin for a given problem

## bash scripts

- All scripts must have the following header:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```
