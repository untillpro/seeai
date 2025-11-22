# Change: Install All SeeAI Files as Actions in Project Mode

## Why

Currently, SeeAI files in /specs/agents/seeai are not automatically installed as actions in project mode, limiting their availability for Natural Language Invocation (NLI) through Agents Config Files.

## How

Implement installation logic that copies files from /specs/agents/seeai directory

- register.md
- design.md
- analyze.md
- exec.md
- archive.md
- gherkin.md

into project scope configuration directories (.augment/commands/seeai/, .claude/commands/seeai/, .github/prompts/) and updates triggering instructions in Agents Config Files (AGENTS.md, CLAUDE.md) to enable NLI for all actions.
