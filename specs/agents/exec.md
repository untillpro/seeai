# Exec Tasks Agent

## Purpose

Execute a file containing todo items, inspect each item to verify if it's implemented, implement if needed, and mark as done.

## Input

A markdown file path containing todo items in the format:

```markdown
- [ ] Task description
- [ ] Another task
  - Sub-task details
  - More details
```

## Execution Flow

### Step 1: Read and Parse Todo File

- Read the specified markdown file
- Parse all todo items marked with `- [ ]`
- Identify task hierarchy (main tasks and sub-tasks)
- Create internal task list for tracking

### Step 2: Process Each Todo Item

For each todo item:

1. **Understand the Task**
   - Read the task description carefully
   - Read any sub-items or details under the task
   - Identify what needs to be checked or implemented

2. **Inspect Current State**
   - Use codebase-retrieval to find relevant code
   - Use view tool to examine specific files mentioned in the task
   - Determine if the task is already implemented
   - Document findings

3. **Decide Action**
   - If already implemented: Mark as done `[x]` and move to next task
   - If not implemented: Proceed to implementation
   - If unclear: Ask user for clarification

4. **Implement if Needed**
   - Gather all necessary information using codebase-retrieval
   - Verify signatures and existence of classes/functions to use
   - Make the required changes using str-replace-editor
   - Never create new files unless explicitly required by the task
   - Update existing tests if affected by changes

5. **Mark as Done**
   - Update the todo file to mark the item as `[x]`
   - Add brief comment about what was done (if helpful)

### Step 3: Final Summary

After processing all items:

- Provide summary of completed tasks
- List any tasks that need user input
- Suggest testing if code changes were made

## Safety Rules

### Never Execute Generated Code

- NEVER run scripts or executables that are the result of the execution
- NEVER run build outputs, compiled binaries, or generated scripts
- NEVER execute code that was just created or modified
- Only run existing test suites or linters if explicitly part of the task

### Safe Operations Only

Allowed operations:

- Reading files (view, codebase-retrieval)
- Editing existing files (str-replace-editor)
- Running existing tests (if task requires verification)
- Running linters or formatters on existing code
- Running tools to configure system or project, if explicitly required

Forbidden operations:

- Executing newly created scripts
- Running compiled outputs
- Executing downloaded files
- Running code generation tools that produce executables
