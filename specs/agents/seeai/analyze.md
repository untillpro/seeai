# Analyze Change

You are analyzing a registered change to identify impact on specifications and guidelines.

## Genereal instructions

- If not specified otherwise, use sentence capitalization for all headings and lists
- Uppercase terms from `@/project/concepts*.md` files everywhere in the analysis

## Step 1: Identify the Change

- Identify the $ChangeID in the `@/changes/active` folder
- If $ChangeID may not be identified, ask user for clarification and repeat Step 1
- Load and understand all the change description files from `@/changes/active/$ChangeID`

## Step 1a: Load existing analysis (if any)

- If the `analysis.md` file already exists in the change folder read it carefully and load and understand all specifications mentioned there

## Step 2: Find related spec files to update

- Extract key concepts from the change (domain entities, actions, technical terms)
- Use codebase-retrieval to search for specifications semantically related to the change
- Search for those concepts across `@/specs/` directory and find which spec files are relevant to the change
- If the change is not related to any existing spec file, note that in the analysis report
- Identify which spec files need updates based on the change description

## Step 3: Identify spec files to create

- Load and understand the specification structure from `@/specs/project/specs.md`
- If something in the change is not covered by existing specs, identify what new spec files need to be created

## Step 4: Identify files to update and create

- Identify any guideline (e.g. README.md) files that need updated/created based on the change
- CRITICAL: These files should be in `@/specs/**` folders

## Step 5: Generate analysis report

Create or update `analysis.md` in the change folder with these sections:

### Specifications to create

List all specification files that you recommend creating:

```markdown
- [ ][folder1/filename1](relative/path): Description of the new specification
- [ ][folder2/filename2](relative/path): Description of the new specification
```

### Specifications to update

List all specification files that need changes:

```markdown
- [ ][folder1/filename1](relative/path): What should be changed
- [ ][folder2/filename2](relative/path): What should be changed
```

### Affected files

List all non-specification files that need changes.

Example:

```markdown
- update: [scripts/deploy.sh](../../../scripts/deploy.sh)
  - [ ] Update API_URL from `api.old.com` to `api.new.com` (line 42)
  - [ ] Update timeout value from 30 to 60 (line 89)
- move: [src/config.json](../../../src/config.json)
  - [ ] Relocate to [config/app.json](../../../config/app.json)
```

Format:

```markdown
- create: [folder/filename](relative/path)
  - [ ] Description of new file and its purpose
- update: [folder/filename](relative/path)
  - [ ] Description of what should be changed
  - [ ] Another change to the same file (if applicable)
- move: [folder/filename](relative/path)
  - [ ] Relocate to [new/folder/filename](relative/path)
- delete: [folder/filename](relative/path)
  - [ ] Reason for deletion
```

Guidelines:

- Files should be ordered to minimize impact on project correctness, ideally allowing one-by-one modifications without breaking the project
- Group logically related files if it does nit affect correctness
- Update guidelines and README files last
- Respect current file status - skip already-updated content
- Use sub-items (indented checkboxes) to list specific changes for each file
- File-level lines do not have checkboxes, only sub-items do

### Notes

Provide any additional context or notes about the change that may help implementers understand the impact. 3-5 sentences max.

CRITICAL: Do not create other sections beyond those specified above.
