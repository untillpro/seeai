# Model: Configuration Version Tracking

## VersionInfo

A YAML configuration file that tracks version information for SeeAI installations in both user and project scopes.

- Format: YAML metadata file (`seeai-version.yml`)
- Location (see [Installation File Structure](../mconf-files/model.md) for detailed directory patterns):
  - User scope:
    - Augment: `~/.augment/commands/seeai/seeai-version.yml`
    - Claude: `~/.claude/commands/seeai/seeai-version.yml`
    - Copilot: `{prompts_dir}/seeai-version.yml`
  - Project scope:
    - `.seeai/seeai-version.yml`
- Structure:
  - `version`: Version identifier (v0.1.0, local-branch-hash, remote-branch-hash)
  - `installed_at`: ISO 8601 timestamp in UTC
  - `source`: Full GitHub URL (releases or tree)
  - `files`: List of installed base filenames
- Purpose: Track installation metadata for version management, upgrades, and troubleshooting

Example for user scope (Commands only):

```yaml
version: v0.1.0
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.1.0
files:
  - design.md
  - gherkin.md
```

Example for project scope (Commands + Actions):

```yaml
version: v0.1.0
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.1.0
files:
  - register.md
  - design.md
  - analyze.md
  - implement.md
  - archive.md
  - gherkin.md
```

## Triggering Instructions

Natural language patterns embedded in Agents Config Files (AGENTS.md or CLAUDE.md) that enable Natural Language Invocation (NLI) of SeeAI Actions.

- Format: Markdown wrapped in HTML comment markers
- Location:
  - AGENTS.md for auggie, gemini, copilot
  - CLAUDE.md for claude
- Structure:
  - `<!-- seeai:triggering_instructions:begin -->` - Block start marker
  - Triggering instructions content
  - `<!-- seeai:triggering_instructions:end -->` - Block end marker
- Purpose: Define patterns that match user requests to specific SeeAI Actions
- Note: Version metadata is stored separately in VersionInfo files, not in ACF

Example:

```markdown
<!-- seeai:triggering_instructions:begin -->
# SeeAI Triggering Instructions

- Always load `@/.seeai/register.md` and follow the instructions there when the request sounds like "Register a change [change description]"
- Always load `@/.seeai/design.md` and follow the instructions there when the request sounds like "Design a solution for [problem description]"
- Always load `@/.seeai/analyze.md` and follow the instructions there when the request sounds like "Analyze a change"
- Always load `@/.seeai/implement.md` and follow the instructions there when the request sounds like "implement todo items" or "implement specifications"
- Always load `@/.seeai/archive.md` and follow the instructions there when the request sounds like "archive a change [change reference]"
- Always load `@/.seeai/gherkin.md` and follow the instructions there when the request sounds like "Generate Gherkin scenarios for [feature description]"

<!-- seeai:triggering_instructions:end -->
```
