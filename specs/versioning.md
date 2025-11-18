# Versioning Rules

## Version Formats

### Releases (Stable)

Format: `v<major>.<minor>.<patch>`

Examples: `v0.1.0`, `v1.0.0`, `v1.2.3`

Rules:

- Use semantic versioning
- Tag in git with `v` prefix
- Major: breaking changes
- Minor: new features, backward compatible
- Patch: bug fixes

### Main Branch (Unstable)

Format: `YYYYMMDD-<short-hash>`

Examples: `20250118-a3f2c1b`, `20250215-f8e9d2a`

Rules:

- Date: `YYYYMMDD` format
- Hash: 7-character git commit hash
- Generated via: `date +%Y%m%d`-`git rev-parse --short HEAD`

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

```yaml
version: v1.0.0
installed_at: 2025-01-18T14:30:00Z
source: github
files:
  - design.md
  - gherkin.md
```

Fields:

- `version`: Version identifier (tag, main+date-hash, or "local")
- `installed_at`: ISO 8601 timestamp
- `source`: "github" or "local"
- `files`: List of installed files

Usage:

- `list` command reads this file to show version info
- `install` command creates/updates this file
- Enables version tracking and upgrade detection
