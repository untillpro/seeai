# Model: Installation File Structure

## Directory Structure Patterns

```text
Project Scope (Augment, Claude):
.${agent}/commands/
└── seeai/
    ├── $design.md
    ├── $gherkin.md
    ├── $register.md
    ├── $analyze.md
    ├── $implement.md
    ├── $archive.md
    └── specs/
        └── $specs.md

Project Scope (Copilot):
.github/
└── prompts/
    ├── $design.md
    ├── $gherkin.md
    ├── $register.md
    ├── $analyze.md
    ├── $implement.md
    ├── $archive.md
    └── $specs/specs.md

User Scope (Augment, Claude):
~/.${agent}/commands/
└── seeai/
    ├── $design.md
    ├── $gherkin.md
    └── seeai-version.yml

User Scope (Copilot):
{os_prompts_dir}/
├── $design.md
├── $gherkin.md
└── seeai-version.yml

Project Scope Version File (All Agents):
specs/agents/
└── seeai/
    └── seeai-version.yml
```

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

## File Expansion Rules

### $design.md

- Augment: `design.md`
- Claude: `design.md`
- Copilot: `seeai-design.prompt.md`

### $gherkin.md

- Augment: `gherkin.md`
- Claude: `gherkin.md`
- Copilot: `seeai-gherkin.prompt.md`

### $register.md, $analyze.md, $implement.md, $archive.md

- Augment: `{name}.md` (e.g., `register.md`)
- Claude: `{name}.md` (e.g., `register.md`)
- Copilot: `seeai-{name}.prompt.md` (e.g., `seeai-register.prompt.md`)

### $specs/specs.md

- Augment: `specs/specs.md`
- Claude: `specs/specs.md`
- Copilot: `seeai-specs-specs.prompt.md` (path flattened with hyphens)

### Transformation Pattern

- Augment/Claude: Original filename and path preserved
- Copilot: `seeai-{flattened_path}.prompt.md` where subdirectories are flattened using hyphens

Rationale: Copilot requires `.prompt.md` extension and does not support subdirectories.

## File Categories and Scope Distribution

### Commands

Files: `design.md`, `gherkin.md`

Distribution:

- User scope: Installed
- Project scope: Installed

Purpose: Can be invoked explicitly via command syntax (e.g., `/seeai:design @file.md`)

### Actions

Files: `register.md`, `analyze.md`, `implement.md`, `archive.md`

Distribution:

- User scope: NOT installed
- Project scope: Installed

Purpose: Invoked implicitly through Natural Language Invocation (NLI) using Triggering Instructions

### Specs

Files: `specs/specs.md`

Distribution:

- User scope: NOT installed
- Project scope: Installed

Purpose: Internal templates used by Actions to maintain consistency

## Agents Config File Selection Rules

Agents Config File (ACF) is used for Triggering Instructions in project scope only.

Selection rules:

- Claude: `CLAUDE.md`
- Augment (auggie): `AGENTS.md`
- Copilot: `AGENTS.md`
- Gemini: `AGENTS.md`

Location: Project root directory

Format: Markdown with HTML comment markers wrapping triggering instructions
