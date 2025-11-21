# Concepts

## Agent (SeeAI Agent)

A file located in `specs/agents/seeai/` that defines a specific role or function within the SeeAI framework. Each agent has its own set of instructions and capabilities.

References

- https://code.visualstudio.com/docs/copilot/customization/custom-agents

## Project Scope

Installation scope that applies to a single project folder. Files are installed in project-specific configuration directories (e.g., `.augment/`, `.github/`, `.claude/` within the project folder).

Contrast with User Scope, which applies globally across all projects for a user.

Note: The term "project" is preferred over "workspace" to avoid confusion with VS Code's multi-root workspace concept, where a workspace can contain multiple project folders linked together.

## User Scope

Installation scope that applies globally to all projects for a user. Files are installed in user-level configuration directories (e.g., `~/.augment/`, `~/.claude/`, `~/Library/Application Support/Code/User/prompts/`).

Contrast with Project Scope, which applies only to a specific project folder.
