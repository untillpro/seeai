# Model: Installation File Structure

## Directory Structure Patterns

### Source Location

In project scope, all Actions and Specs are downloaded during installation to a single location:

```text
Source Directory (All Agents):
.seeai/
├── actions/
│   ├── register.md
│   ├── analyze.md
│   ├── implement.md
│   └── archive.md
├── commands/
│   ├── design.md
│   └── gherkin.md
├── rules/
│   └── specs.md
└── seeai-version.yml
```

This directory structure is created during project scope installation. Files are downloaded from the GitHub repository (or copied from local source in development mode) to .seeai/. Existing files are overwritten to ensure version consistency.

Actions are referenced directly from this location via triggering instructions in Agents Config Files (AGENTS.md or CLAUDE.md). Files are not copied to agent-specific directories in project scope.

### User Scope Target Directories

For user scope installations, files are downloaded from GitHub (or copied from local source with -l flag) to agent-specific directories in user home:

```text
User Scope (Augment, Claude):
~/.{augment|claude}/commands/seeai/
├── design.md
├── gherkin.md
└── seeai-version.yml

User Scope (Copilot):
{os_prompts_dir}/
├── seeai-design.prompt.md
├── seeai-gherkin.prompt.md
└── seeai-version.yml
```

Note: User scope installs only Commands (design.md, gherkin.md), not Actions or Specs.

## Variable Definitions

### {os_prompts_dir}

Copilot user scope paths (OS-specific):

- Windows: `%APPDATA%/Code/User/prompts/`
- macOS: `~/Library/Application Support/Code/User/prompts/`
- Linux: `~/.config/Code/User/prompts/`

Profile-specific paths:

- Windows: `%APPDATA%/Code/User/profiles/<profile-id>/prompts/`
- macOS: `~/Library/Application Support/Code/User/profiles/<profile-id>/prompts/`
- Linux: `~/.config/Code/User/profiles/<profile-id>/prompts/`

## File Transformation Rules

### Copilot

Commands are transformed with `seeai-` prefix and `.prompt.md` extension.

- Pattern: `{dir}/{file}.md` -> `seeai-{dir}-{file}.prompt.md`
- `commands/design.md` -> `seeai-commands-design.prompt.md`
- `commands/gherkin.md` -> `seeai-commands-gherkin.prompt.md`

Rationale: Copilot requires `.prompt.md` extension and does not support subdirectories, so paths are flattened using hyphens.

## Agents Config File Selection Rules

- Agents Config File (ACF) is used for Triggering Instructions in project scope only.
- Selection rules:
  - Claude: `CLAUDE.md`
  - Other agents:: `AGENTS.md`
- Location: Project root directory
- Format: Markdown with HTML comment markers wrapping triggering instructions
