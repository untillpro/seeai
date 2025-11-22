# Register a Change

You are registering a new change to the project by creating a change folder and change.md file.

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

### File Structure

Create `change.md` inside the folder with these sections:

```markdown
# Change: [Descriptive Title]

## Why

[Brief 1-2 sentence description of the problem the change solves]


## How

[Brief 1-2 sentence description of the how problem is going to be solved]
```
