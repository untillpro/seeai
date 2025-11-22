# Model: Installation File Structure

## Directory Structure Patterns

### Project Scope

```text
Project Scope (Augment, Claude):
.{augment|claude}/commands/seeai/
├── design.md
├── gherkin.md
├── register.md
├── analyze.md
├── implement.md
├── archive.md
└── specs/
    └── specs.md

Project Scope (Copilot):
.github/prompts/
├── seeai-design.prompt.md
├── seeai-gherkin.prompt.md
├── seeai-register.prompt.md
├── seeai-analyze.prompt.md
├── seeai-implement.prompt.md
├── seeai-archive.prompt.md
└── seeai-specs-specs.prompt.md
```

### User Scope

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

Project Scope Version File (All Agents):
specs/agents/seeai/
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

## File Transformation Rules

### Copilot

Files are transformed with `seeai-` prefix and `.prompt.md` extension.

Root-level files:

- `design.md` -> `seeai-design.prompt.md`
- `gherkin.md` -> `seeai-gherkin.prompt.md`
- `register.md` -> `seeai-register.prompt.md`

Subdirectory files (path flattening):

- `specs/specs.md` -> `seeai-specs-specs.prompt.md`
- Pattern: `{dir}/{file}.md` -> `seeai-{dir}-{file}.prompt.md`

Rationale: Copilot requires `.prompt.md` extension and does not support subdirectories, so paths are flattened using hyphens.

## Agents Config File Selection Rules

Agents Config File (ACF) is used for Triggering Instructions in project scope only.

Selection rules:

- Claude: `CLAUDE.md`
- Augment (auggie): `AGENTS.md`
- Copilot: `AGENTS.md`
- Gemini: `AGENTS.md`

Location: Project root directory

Format: Markdown with HTML comment markers wrapping triggering instructions
