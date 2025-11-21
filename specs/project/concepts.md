# Concepts

## Agent (SeeAI Agent)

A file located in `specs/agents/seeai/` that defines a specific role or function within the SeeAI framework. Each agent has its own set of instructions and capabilities.

References

- https://code.visualstudio.com/docs/copilot/customization/custom-agents

## Agent Triggering File (ATF)

A markdown file (AGENTS.md or CLAUDE.md) located in the project root that contains triggering instructions for invoking SeeAI agents through natural language commands.

- AGENTS.md: Used by auggie, gemini, and copilot
- CLAUDE.md: Used by claude

The ATF contains HTML comment markers (`<!-- SEEAI:BEGIN -->` / `<!-- SEEAI:END -->`) that wrap the triggering instructions and version metadata.

## Project Scope

Installation scope that applies to a single project folder. Files are installed in project-specific configuration directories (e.g., `.augment/`, `.github/`, `.claude/` within the project folder).

Contrast with User Scope, which applies globally across all projects for a user.

Note: The term "project" is preferred over "workspace" to avoid confusion with VS Code's multi-root workspace concept, where a workspace can contain multiple project folders linked together.

## Triggering Instructions

Natural language patterns embedded in Agent Triggering Files (AGENTS.md or CLAUDE.md) that tell AI agents when and how to invoke specific SeeAI agents based on user requests.

Example:

```markdown
<!-- SEEAI:BEGIN [version info]-->
# SeeAI Triggering Instructions

- Always open `@/specs/agents/seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/specs/agents/seeai/analyst.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"

<!-- SEEAI:END -->
```

## User Scope

Installation scope that applies globally to all projects for a user. Files are installed in user-level configuration directories (e.g., `~/.augment/`, `~/.claude/`, `~/Library/Application Support/Code/User/prompts/`).

Contrast with Project Scope, which applies only to a specific project folder.
