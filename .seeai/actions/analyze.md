# Analyze Change

You are analyzing a registered change to identify impact on specifications and implementation.

## General instructions

- Use sentence capitalization for all headings and lists
- Load and understand all specs from `@/specs/project` folder
- Use title case for terms from `@/specs/project/concepts*.md` files (e.g., "Command", "Action", "Natural Language Invocation")

## Identify the change

- Identify the $ChangeID in `@/changes/active` folder
- If $ChangeID cannot be identified, ask user for clarification
- Load all change description files from `@/changes/active/$ChangeID`

## Ask clarifying questions

Only if `analysis.md` does not exist in the change folder:

- Ask three clarifying questions about unclear requirements or ambiguous specifications
- Present suggestions as numbered lists with first option as recommended approach with rationale
- Keep questions and solutions extremely concise

Example format:

```markdown
## Q1: Question?

1. Answer1 (recommended) - rationale
2. Answer2 - rationale
3. Answer3 - rationale
```

## Integrate answers into change.md

After receiving answers:

- Load change.md file
- Integrate answers into appropriate sections (Why/How)
- Add new subsections if needed for important clarifications
- Preserve original formatting and style
- Keep content concise (1-2 sentences per clarification)

## Create analysis.md if not exists

If `analysis.md` does not exist in the change folder, create it with empty sections.

## Load existing analysis.md

If `analysis.md` exists, load it and understand all specifications mentioned there.

## Identify related spec files

- Extract key concepts from the change (domain entities, actions, technical terms)
- Use codebase-retrieval to search for specifications semantically related to the change
- Search across `@/specs/` directory for relevant spec files
- Identify which spec files need updates, moves, or deletions

## Identify spec files CRUD

- Load and understand specification structure from `@/.seeai/rules/specs.md`
- Determine what new spec files need to be created
- Identify existing specs that need updates
- Identify specs that need to be moved or deleted

## Actualize Specifications section

Create or update the Specifications section in `analysis.md`:

```markdown
## Specifications

- create: [folder/filename](relative-path)
  - [ ] Description of what should be in the file (max 5 items)
- update: [folder/filename](relative-path)
  - [ ] Description of what should be changed (max 5 items)
- move: [folder/filename](relative-path)
  - [ ] Relocate to [new/folder/filename](new-relative-path)
- delete: [folder/filename](relative-path)
  - [ ] Reason for deletion
```

## Stop if Specifications need implementation

CRITICAL STOPPING CONDITION:

- Check if Specifications section contains ANY uncompleted todo items (marked [ ])
- If ANY uncompleted items exist, you MUST stop immediately
- Do NOT proceed to generate System changes, Project changes, or File changes sections
- Do NOT generate any implementation-related content

Display this exact message:

```text
STOP: Specifications are incomplete.

The Specifications section contains uncompleted items that must be addressed first.

Please complete all specification updates (mark all items as [x]), then re-run the analysis to continue with implementation planning.

Do not proceed with System changes, Project changes, or File changes until all specifications are complete.
```

Only if ALL specification items are marked [x], continue to the next sections.

## Actualize System changes

PREREQUISITE: Only proceed if ALL specification items are marked [x] as complete.

If any specification items are incomplete, DO NOT generate this section.

Identify system-level changes (installations, global configurations):

```markdown
## System changes

- install: Description
  - [ ] Command or action to perform
- configure: Description
  - [ ] Configuration change needed
```

## Actualize Project changes

PREREQUISITE: Only proceed if ALL specification items are marked [x] as complete.

If any specification items are incomplete, DO NOT generate this section.

Identify project initialization or structure changes:

```markdown
## Project changes

- create: Description
  - [ ] Command to execute (e.g., `flutter create myapp --platforms web`)
- configure: Description
  - [ ] Project-level configuration change
```

## Actualize File changes

PREREQUISITE: Only proceed if ALL specification items AND all previous change items are marked [x] as complete.

If any specification items are incomplete, DO NOT generate this section.

Identify file-level changes and tests:

```markdown
## File changes

- create: [folder/filename](relative-path)
  - [ ] Description of new file and its purpose
- update: [folder/filename](relative-path)
  - [ ] Description of what should be changed
- move: [folder/filename](relative-path)
  - [ ] Relocate to [new/folder/filename](new-relative-path)
- delete: [folder/filename](relative-path)
  - [ ] Reason for deletion
- test: Description
  - [ ] Test command to run
```

Order files to minimize impact on project correctness.

## Format rules

Apply to all sections (Specifications, System changes, Project changes, File changes):

- File-level lines do not have checkboxes, only sub-items do
- List no more than 5 specific items per file
- Use relative paths from the change folder (e.g., `../../../path/to/file`)

## Notes section

Add Notes section at the end:

```markdown
## Notes

- Additional context about the change (3-5 bullets max)
```

CRITICAL: Do not create other sections beyond those specified above.
