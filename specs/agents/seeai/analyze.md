# Analyze Change

You are analyzing a registered change to identify impact on specifications and guidelines.

## Step 1: Identify the Change

- Identify the $ChangeID in the `@/changes/active` folder
- If $ChangeID may not be identified, ask user for clarification and repeat Step 1
- Load and understand all the change description files from `@/changes/active/$ChangeID`

## Step 2: Find related spec files to update

- Extract key concepts from the change (domain entities, actions, technical terms)
- Use codebase-retrieval to search for specifications semantically related to the change
- Search for those concepts across `@/specs/` directory and find which spec files are relevant to the change
- If the change is not related to any existing spec file, note that in the analysis report
- Identify which spec files need updates based on the change description

## Step 3: Identify spec files to create

- Load and understand the specification structure from `@/specs/project/specs.md`
- If something in the change is not covered by existing specs, identify what new spec files need to be created

## Step 4: Identify guideline files to update and create

- Identify any guideline (e.g. README.md) files that need updated/created based on the change
- CRITICAL: These files should be in `@/specs/**` folders

## Step 5: Generate analysis report

Create `analysis.md` in the change folder with these sections:

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

### Guidelines to create

List all guideline files that need creation:

```markdown
- [ ][folder1/filename1](relative/path): Description of the new guideline
- [ ][folder2/filename2](relative/path): Description of the new guideline
```

### Guidelines to update

List all guideline files that need changes:

```markdown
- [ ][folder1/filename1](relative/path): What should be changed
- [ ][folder2/filename2](relative/path): What should be changed
```
