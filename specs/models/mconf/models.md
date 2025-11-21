# Model: Configuration Version Tracking

## VersionInfo

A YAML configuration file that tracks version information for SeeAI installations in both user and project scopes.

- Format: YAML metadata file (`seeai-version.yml`)
- Location:
  - User scope:
    - Augment: `~/.augment/commands/seeai/seeai-version.yml`
    - Claude: `~/.claude/commands/seeai/seeai-version.yml`
    - Copilot: `{prompts_dir}/seeai-version.yml`
  - Project scope:
    - `specs/agents/seeai/seeai-version.yml`
- Structure:
  - `version`: Version identifier (v0.1.0, local-branch-hash, remote-branch-hash)
  - `installed_at`: ISO 8601 timestamp in UTC
  - `source`: Full GitHub URL (releases or tree)
  - `files`: List of installed base filenames
- Purpose: Track installation metadata for version management, upgrades, and troubleshooting

Example:

```yaml
version: v0.1.0
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.1.0
files:
  - design.md
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

- Always open `@/specs/agents/seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/specs/agents/seeai/analyst.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"
- Always open `@/specs/agents/seeai/specifier.md` and follow the instructions there when the request sounds like "let me see a specification [change reference]"

<!-- seeai:triggering_instructions:end -->
```
