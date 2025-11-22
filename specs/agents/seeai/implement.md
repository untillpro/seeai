# Implement

## Purpose

Execute a file containing todo items (`[ ], [x]`), inspect each item to verify if it's implemented, implement if needed, and mark as done.

## Input

A markdown file path containing todo items in the format:

```markdown
- [ ] Task description
- Another task
  - [ ] Sub-task1
  - [ ] Sub-task2
```

- If it is unclear which file to process, ask the user for clarification.
- User may specify a subsection or part of the file to execute (e.g., "execute the testing section", "execute tasks 1-3"). Parse the user's intent from natural language.

## Execution Flow

### Step 1: Read and parse file with todo items

- Read the specified markdown file
- Load all files in the same folder to understand context
- Parse todo items marked with `- [ ]` from the specified section or entire file
- Identify task hierarchy (main tasks and sub-tasks)
- Create internal task list for tracking
- Report to the user what you are going to process

### Step 2: Process todo items

For each todo item:

1. **Understand the task**
   - Read the task description carefully
   - Read any sub-items or details under the task
   - If task contains links to specifications, load and understand those specifications
   - Identify what needs to be checked or implemented

2. **Inspect current state**
   - Use codebase-retrieval to find relevant code
   - Use view tool to examine specific files mentioned in the task
   - Determine if the task is already implemented
   - Document findings

3. **Decide action**
   - If already implemented: Mark as done `[x]` and move to next task
   - If not implemented: Proceed to implementation
   - If unclear: Ask user for clarification

4. **Implement if needed**
   - Gather all necessary information using codebase-retrieval
   - Verify signatures and existence of classes/functions to use
   - Make the required changes using str-replace-editor
   - Never create new files unless explicitly required by the task
   - Update existing tests if affected by changes

5. **Mark as Done**
   - Update the todo file to mark the item as `[x]` immediately after completion
   - Do not batch marking - update after each task completes

### Step 3: Final Summary

After processing all items:

- Provide summary of completed tasks
- List any tasks that need user input
- Suggest testing if code changes were made

## Content Rules

### Do not add unsolicited content

- NEVER add sections, summaries, or documentation that are not explicitly requested in the task
- NEVER create "Implementation Summary" or similar sections unless the task specifically asks for it
- Only make changes that are directly required by the task description
- If you think additional documentation would be helpful, ask the user first

## Safety Rules

### Never execute generated code

- NEVER run scripts or executables that are the result of the execution
- NEVER run build outputs, compiled binaries, or generated scripts
- NEVER execute code that was just created or modified using run commands (e.g., `go run`, `python script.py`, `node app.js`)
- Test commands are allowed if the task explicitly requires testing or verification

### Safe operations only

Allowed operations:

- Reading files (view, codebase-retrieval)
- Editing existing files (str-replace-editor)
- Running test commands if task requires testing or verification (e.g., `go test`, `flutter test`, `npm test`, `pytest`)
- Running linters or formatters on code
- Running tools to configure system or project, if explicitly required

Forbidden operations:

- Executing code with run commands (e.g., `go run .`, `python script.py`, `node app.js`, `flutter run`)
- Running compiled outputs or binaries
- Executing newly created scripts
- Executing downloaded files
- Running code generation tools that produce executables
