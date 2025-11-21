# Model: Configuration Version Tracking

## UserVersion

A YAML metadata file that tracks version information for user-scoped SeeAI installations that apply globally across all projects.

- Format: YAML metadata file (`seeai-version.yml`)
- Location:
  - Augment: `~/.augment/commands/seeai/seeai-version.yml`
  - Claude: `~/.claude/commands/seeai/seeai-version.yml`
  - Copilot: `{prompts_dir}/seeai-version.yml`
- Structure:
  - `version`: Version identifier (v0.1.0, local-branch-hash, remote-branch-hash)
  - `installed_at`: ISO 8601 timestamp in UTC
  - `source`: Full GitHub URL (releases or tree)
  - `files`: List of installed base filenames
- Purpose: Track global installations that apply across all projects for a user

Example:

```yaml
version: v0.1.0
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.1.0
files:
  - design.md
  - gherkin.md
```

## ProjectVersion

HTML comment markers embedded in Agent Triggering Files that track version information for project-scoped SeeAI installations.

- Format: HTML comments in Agent Triggering Files
- Location:
  - AGENTS.md for auggie, gemini, copilot
  - CLAUDE.md for claude
- Structure:
  - `<!-- SEEAI:BEGIN [version info]-->` marker with version metadata
  - Triggering instructions content
  - `<!-- SEEAI:END -->` closing marker
- Purpose: Track project-specific installations with version info embedded in triggering instructions
- Benefit: Version info stays with the configuration that uses it

Example:

```markdown
<!-- SEEAI:BEGIN [version info]-->
# SeeAI Triggering Instructions

- Always open `@/specs/agents/seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/specs/agents/seeai/analyst.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"
- Always open `@/specs/agents/seeai/specifier.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"

<!-- SEEAI:END -->
```
