# Feature: Natural Language Invocation

## Stories

As a User I want to invoke functions using natural language commands so that I can interact with the system more intuitively.

```text
User:

Let me see a new change [change description]

AI:

Ok, I prepared a new change in the /changes/251121-new-feature folder
```

## How

- Feature is installed per repository using the Agent Triggering File (ATF):
  - AGENTS.md for auggie, gemini, copilot
  - CLAUDE.md for claude
- Triggering Instructions are written to ATF

```markdown
<!-- SEEAI:BEGIN [version info]-->
# SeeAI Triggering Instructions

- Always open `@/specs/agents/seeai/registrar.md` and follow the instructions there when the request sounds like "let me see a change [change description]"
- Always open `@/specs/agents/seeai/analyst.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"
- Always open `@/specs/agents/seeai/specifier.md` and follow the instructions there when the request sounds like "let me see an analysis [change reference]"

<!-- SEEAI:END -->
```