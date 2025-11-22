# Analysis: Install Actions to /specs/agents/seeai

## Specifications to create

No new specifications need to be created. The change clarifies existing installation behavior rather than introducing new concepts.

## Specifications to update

- [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [ ] Update SeeAI Action definition to clarify that Actions are stored in specs/agents/seeai as source files
  - [ ] Update Project Scope definition to clarify that agent-specific directories (.augment, .claude, .github) are only used in user scope, not project scope
  - [ ] Update seeai-version.yml location description to emphasize project scope uses specs/agents/seeai/ only
- [specs/models/mconf-files/models.md](../../../specs/models/mconf-files/models.md)
  - [ ] Update Project Scope section to clarify these are target directories for user scope installations only
  - [ ] Add note that project scope installations do not use agent-specific directories
  - [ ] Clarify that specs/agents/seeai/ is the source location for all Actions and Specs
- [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [ ] Update Installation Locations section to clarify specs/agents/seeai as source directory
  - [ ] Clarify that project scope installations only create seeai-version.yml in specs/agents/seeai/
  - [ ] Update file organization strategy to explain source vs target directories
- [specs/feat/conf/tests.md](../../../specs/feat/conf/tests.md)
  - [ ] Update Project Scope Installation Tests section to clarify that tests verify files are NOT copied to agent-specific directories in project scope
  - [ ] Clarify that project scope only creates seeai-version.yml in specs/agents/seeai/

## Affected files and tests

- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [ ] Update comments to clarify that specs/agents/seeai is the source directory
  - [ ] Verify project scope installation logic does not copy files to agent-specific directories
  - [ ] Ensure seeai-version.yml is created only in specs/agents/seeai/ for project scope
  - [ ] Update documentation comments about installation behavior
- update: [README.md](../../../README.md)
  - [ ] Add clarification that project scope installations use specs/agents/seeai as the source
  - [ ] Explain that Actions are invoked from specs/agents/seeai via triggering instructions
- test: Installation tests
  - [ ] Run `bats tests/test_project_scope_installs.bats` to verify project scope behavior
  - [ ] Run `bats tests/test_user_scope_installs.bats` to verify user scope behavior
- create: [.gitignore](../../../.gitignore)
  - [ ] Add agent-specific directories to prevent accidental commits: `.augment/`, `.claude/`, `.github/prompts/`

## Notes

- The change clarifies that specs/agents/seeai is the single source of truth for all Actions and Specs in project scope
- User scope installations copy files from specs/agents/seeai to agent-specific directories in user home
- Project scope installations do NOT copy files to agent-specific directories - they remain in specs/agents/seeai
- Triggering instructions in ACF (AGENTS.md/CLAUDE.md) reference files in specs/agents/seeai using @/ syntax
- The seeai.sh script may already implement this behavior correctly - verification needed

