# Versioning Rules

## Version Formats

### Tagged Releases (Stable)

Format: `v<major>.<minor>.<patch>`

Examples: `v0.1.0`, `v1.0.0`, `v1.2.3`

Rules:

- Use semantic versioning
- Tag in git with `v` prefix
- Major: breaking changes
- Minor: new features, backward compatible
- Patch: bug fixes

### Local Installations

Format: `local-<branch>-<short-hash>`

Examples: `local-main-4e24576`, `local-feature-123-a3f2c1b`

Rules:

- Prefix: `local-`
- Branch: Current branch name from `git rev-parse --abbrev-ref HEAD`
- Hash: 7-character git commit hash from `git rev-parse --short HEAD`
- Falls back to "unknown" if hash cannot be determined

### Remote Installations (from branch)

Format: `remote-<branch>-<short-hash>`

Examples: `remote-main-4e24576`, `remote-develop-f8e9d2a`

Rules:

- Prefix: `remote-`
- Branch: Branch name being installed from
- Hash: 7-character git commit hash fetched via GitHub API from `https://api.github.com/repos/untillpro/seeai/commits/<branch>`
- Falls back to "unknown" if hash cannot be determined

## Version Resolution

- `latest` - Most recent git tag (stable release)
- `main` - Current main branch HEAD (unstable)
- `v1.2.3` - Specific version tag

## Git Tags

- Create annotated tags for releases: `git tag -a v1.0.0 -m "Release 1.0.0"`
- Push tags: `git push origin v1.0.0`
- List tags: `git tag -l`

## Version Metadata File

`seeai-version.yml` is installed alongside prompt files to track installation metadata.

Location:

- Augment/Claude: `{commands_dir}/seeai/seeai-version.yml`
- Copilot: `{prompts_dir}/seeai-version.yml`

Format:

Tagged release:
```yaml
version: v0.1.0
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/releases/tag/v0.1.0
files:
  - design.md
  - gherkin.md
```

Local installation:
```yaml
version: local-main-4e24576
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/tree/main
files:
  - design.md
  - gherkin.md
```

Remote installation:
```yaml
version: remote-main-4e24576
installed_at: 2025-01-18T14:30:00Z
source: https://github.com/untillpro/seeai/tree/main
files:
  - design.md
  - gherkin.md
```

Fields:

- `version`: Version identifier
  - Tagged releases: `v0.1.0`
  - Local installations: `local-<branch>-<hash>`
  - Remote installations: `remote-<branch>-<hash>`
- `installed_at`: ISO 8601 timestamp in UTC
- `source`: Full GitHub URL
  - Tagged releases: `https://github.com/untillpro/seeai/releases/tag/<tag>`
  - Branch installations: `https://github.com/untillpro/seeai/tree/<branch>`
- `files`: List of installed base filenames

Usage:

- `list` command reads this file to show version info
- `install` command creates/updates this file
- Enables version tracking and upgrade detection
