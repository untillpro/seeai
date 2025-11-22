# Change: Install Actions to /specs/agents/seeai

## Why

Currently, SeeAI Actions are not properly installed or organized in the /specs/agents/seeai directory, which prevents them from being invoked through Natural Language Invocation (NLI) in the project scope.

Ref. [mconf-files/model.md](../../../specs/models/mconf-files/models.md).

## How

- Install and organize all SeeAI Action files (design.md, gherkin.md, analyze.md, implement.md, register.md, archive.md) into the /specs/agents/seeai directory with proper structure and ensure triggering instructions are configured in the Agents Config File (ACF).
- specs.md should also be installed as the /specs/agents/seeai/specs.md file.
- So nothing is installed project scope into agent-specific directories like .augment or .github
- seeai-version.yml for User scope includes only commands (design.md, gherkin.md), for Project scope includes all files.
