# Register a Change

You are registering a new change to the project by creating a change folder and change.md file.

## General instructions

- If not specified otherwise, use sentence capitalization for all headings and lists
- Load and understand all specs from the `@/specs/project` folder, strictly follow all rules that are contained there
- Use title case for terms from `@/project/concepts*.md` files everywhere (e.g., "Command", "Action", "Natural Language Invocation"), use terms consistently where applicable

## Input

You will receive a change description from the user in the format:

- "Register a change [change description]"

## Output

Create a new change folder in `changes/active/` with the following structure:

### Folder Naming

Format: `YYMMDD-short-description`

- YYMMDD: Current date in 2-digit year, month, day format (e.g., 251122 for November 22, 2025)
- short-description: Kebab-case summary of the change (e.g., seeai-tests, scope-as-param)

Examples:

- "Register a change to add tests for seeai.sh" -> `changes/active/251122-seeai-tests/`
- "Register a change for scope parameter" -> `changes/active/251121-scope-as-param/`

### File structure

Create `change.md` inside the folder following the Problem/Approach structure defined in `.seeai/rules/psa-structure.md`.
