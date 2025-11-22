# Change: Install Actions to /specs/agents/seeai

## Why

Currently, SeeAI Actions are not properly installed or organized in the /specs/agents/seeai directory, which prevents them from being invoked through Natural Language Invocation (NLI) in the project scope.

Ref. [mconf-files/model.md](../../../specs/models/mconf-files/models.md).

## How

- Use specs/agents/seeai as the source location for all Actions and Specs, making it the single source of truth
- Maintain the subdirectory structure with specs/agents/seeai/specs/specs.md (not flat)
- For project scope installations, create seeai-version.yml in specs/agents/seeai/ only (centralized version tracking)
- Installation script reads from specs/agents/seeai and copies to agent-specific directories (.augment, .claude, .github)
- Nothing is installed into agent-specific directories in project scope - they only exist in user scope
- seeai-version.yml for user scope includes only Commands (design.md, gherkin.md), for project scope includes all files

### Extra

- list command for local scope must check both specs/agents/seeai/ and agent-specific directories
- there must be a test for the list command
