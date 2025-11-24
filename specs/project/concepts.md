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

A specialized prompt file stored in project scope at .seeai/ directory. Actions are invoked implicitly through Natural Language Invocation (NLI) - natural language patterns (e.g., "let me see a design") matched by triggering instructions in Agents Config Files (AGENTS.md or CLAUDE.md).

Source location:

- `.seeai/` - Single source of truth for all Actions in project scope

Actions are referenced directly from .seeai/ by AI agents via triggering instructions. Unlike Commands, Actions are not copied to agent-specific directories in project scope.

Note: The same source files become either Commands or Actions depending on installation scope. In user scope, files are downloaded from GitHub (or copied from local source with -l flag) to agent-specific directories. In project scope, files are downloaded to .seeai/.

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

Installation scope that applies to a single project folder. In project scope, SeeAI Actions and Specs are stored in .seeai/ directory and referenced directly by AI agents through triggering instructions in Agents Config Files (AGENTS.md or CLAUDE.md).

Agent-specific directories (.augment/, .github/, .claude/) are only used in user scope installations where files are copied to user home directories. In project scope, these directories are not used.

Contrast with User Scope, which applies globally across all projects for a user and copies files to agent-specific directories.

Note: The term "project" is preferred over "workspace" to avoid confusion with VS Code's multi-root workspace concept, where a workspace can contain multiple project folders linked together.

## Triggering Instructions

Natural language patterns embedded in Agents Config Files (AGENTS.md or CLAUDE.md) that tell AI agents when and how to invoke specific SeeAI commands based on user requests.

Example:

```markdown
<!-- seeai:triggering_instructions:begin -->
# SeeAI Triggering Instructions

- Always open `@/.seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/.seeai/analyze.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"

<!-- seeai:triggering_instructions:end -->
```

## seeai-version.yml

- A YAML configuration file that tracks version information for SeeAI installations in both user and project scopes
- Ref. the `@mconf/models.md` file

## User Scope

Installation scope that applies globally to all projects for a user. Files are installed in user-level configuration directories (e.g., `~/.augment/`, `~/.claude/`, `~/Library/Application Support/Code/User/prompts/`).

Contrast with Project Scope, which applies only to a specific project folder.
