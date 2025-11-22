# Concepts

## SeeAI Command

A specialized prompt file (e.g., `design.md`, `gherkin.md`) installed into user scope directories. Commands are invoked explicitly using command syntax like `/seeai:design @file.md`.

Installation location examples:

- `~/.augment/commands/seeai/`
- `~/.claude/commands/seeai/`
- `{user_prompts_dir}/seeai-*.prompt.md`

References

- https://code.visualstudio.com/docs/copilot/customization/custom-agents

## SeeAI Action

A specialized prompt file installed into project scope specs/agents/seaa directory. Actions are invoked implicitly through Natural Language Invocation (NLI) - natural language patterns (e.g., "let me see a design") matched by triggering instructions in Agents Config Files (AGENTS.md or CLAUDE.md).

Installation locations:

- `./.augment/commands/seeai/`
- `./.claude/commands/seeai/`
- `./.github/prompts/seeai-*.prompt.md`

Note: The same source files become either Commands or Actions depending on installation scope.

## SeeAI Spec

A reusable specification template stored in `/specs/agents/seeai/specs/` that defines common patterns and structures used by SeeAI Actions. SeeAI Specs are internal templates that guide Actions in creating consistent specifications across different workflows.

Key characteristics:

- Stored in `/specs/agents/seeai/specs/` directory
- Referenced by Actions using relative paths (e.g., `@/specs/agents/seeai/specs/specs.md`)
- Distributed only to project scope via seeai.sh installation script
- Not versioned separately - they evolve with Actions
- Not user-facing configuration - internal templates for Actions

Example: `specs.md` defines the specification structure and criteria for when to create new specifications, which is used by the analyze action to guide specification creation.

## Natural Language Invocation (NLI)

The capability to invoke SeeAI Actions through natural language patterns instead of explicit command syntax. NLI is enabled by triggering instructions embedded in Agents Config Files (AGENTS.md or CLAUDE.md) that match user requests to specific actions.

Example flow:

1. User says: "let me see a design for login feature"
2. AI reads triggering instructions from ACF
3. Pattern matches "let me see a design"
4. AI invokes the design action automatically
5. Action guides AI through the workflow

NLI allows users to interact with SeeAI Actions naturally without memorizing command syntax.

## Agents Config File (ACF)

A markdown file (AGENTS.md or CLAUDE.md) located in the project root that contains triggering instructions for invoking SeeAI commands through natural language requests.

- AGENTS.md: Used by auggie, gemini, and copilot
- CLAUDE.md: Used by claude

The ACF contains HTML comment markers that wrap the triggering instructions.

## Project Scope

Installation scope that applies to a single project folder. Files are installed in project-specific configuration directories (e.g., `.augment/`, `.github/`, `.claude/` within the project folder).

Contrast with User Scope, which applies globally across all projects for a user.

Note: The term "project" is preferred over "workspace" to avoid confusion with VS Code's multi-root workspace concept, where a workspace can contain multiple project folders linked together.

## Triggering Instructions

Natural language patterns embedded in Agents Config Files (AGENTS.md or CLAUDE.md) that tell AI agents when and how to invoke specific SeeAI commands based on user requests.

Example:

```markdown
<!-- seeai:triggering_instructions:begin -->
# SeeAI Triggering Instructions

- Always open `@/specs/agents/seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/specs/agents/seeai/analyze.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"

<!-- seeai:triggering_instructions:end -->
```

## VersionInfo

A YAML configuration file that tracks version information for SeeAI installations in both user and project scopes.

Format: `seeai-version.yml`

Locations:

- User scope: `~/.augment/commands/seeai/`, `~/.claude/commands/seeai/`, `{prompts_dir}/`
- Project scope: `specs/agents/seeai/`

Example:

```yaml
version: v0.1.0
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.1.0
files:
  - design.md
  - gherkin.md
```

## User Scope

Installation scope that applies globally to all projects for a user. Files are installed in user-level configuration directories (e.g., `~/.augment/`, `~/.claude/`, `~/Library/Application Support/Code/User/prompts/`).

Contrast with Project Scope, which applies only to a specific project folder.
