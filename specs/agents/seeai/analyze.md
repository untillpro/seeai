# Analyze Change

You are analyzing a registered change to identify impact on specifications and guidelines.

## General instructions

- If not specified otherwise, use sentence capitalization for all headings and lists
- Load and understand all specs from the `@/specs/project` folder, strictly follow all rules that are contained there
- Use title case for terms from `@/project/concepts*.md` files everywhere (e.g., "Command", "Action", "Natural Language Invocation"), use terms consistently where applicable

## Step 1: Identify the Change

- Identify the $ChangeID in the `@/changes/active` folder
- If $ChangeID may not be identified, ask user for clarification and repeat Step 1
- Load and understand all the change description files from `@/changes/active/$ChangeID`

## Step 1a: Ask clarifying questions (if analysis.md does not exist)

If the `analysis.md` file does not exist in the change folder, ask the user three clarifying questions to better understand the change.

Keep questions and solutions extremely concise, ask about unclear requirements or ambiguous specifications.

Format for suggestions:

- Present suggestions as numbered lists
- First option should be the recommended approach with rationale

Example:

```markdown
## Q1: Question?

1. Answer1 (recommended) - rationale
2. Answer2 - rationale
3. Answer3 - rationale
```

Answers must be integrated to the Change file, preserve original formatting, style, be concise.

## Step 1b: Load existing analysis (if any) and the specifications

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

List all specification files that you recommend creating with specific things to specify (high-level only):

```markdown
- [folder1/filename1](relative/path)
  - [ ] Specific thing to specify 1
  - [ ] Specific thing to specify 2
  - [ ] Specific thing to specify 3
- [folder2/filename2](relative/path)
  - [ ] Specific thing to specify 1
  - [ ] Specific thing to specify 2
```

### Specifications to update

List all specification files that need changes with specific things to update:

```markdown
- [folder1/filename1](relative/path)
  - [ ] Specific thing to update 1
  - [ ] Specific thing to update 2
  - [ ] Specific thing to update 3
- [folder2/filename2](relative/path)
  - [ ] Specific thing to update 1
  - [ ] Specific thing to update 2
```

### Affected files and tests

List all non-specification files that need changes and related tests to run.

Example:

```markdown
- update: [scripts/deploy.sh](../../../scripts/deploy.sh)
  - [ ] Update API_URL from `api.old.com` to `api.new.com` (line 42)
  - [ ] Update timeout value from 30 to 60 (line 89)
- move: [src/config.json](../../../src/config.json)
  - [ ] Relocate to [config/app.json](../../../config/app.json)
- configure: Flutter dependencies
  - [ ] Related file: [pubspec.yaml](../../../pubspec.yaml)
  - [ ] Run `flutter pub get` to update dependencies
- update: [.gitignore](../../../.gitignore)
  - [ ] Add Flutter-specific patterns: `*.g.dart`, `*.freezed.dart`, `build/`, `.dart_tool/`
- test: Widget tests
  - [ ] Run `flutter test test/widget_test.dart` to verify widget changes
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
- configure: Description of configuration task
  - [ ] Related file: [folder/filename](relative/path)
  - [ ] Related file: [folder/filename2](relative/path) (if applicable)
  - [ ] Run command (e.g., `flutter pub get`, `npm install`, `go mod tidy`)
- test: Description of test suite or verification
  - [ ] Test command to run (e.g., `flutter test test/widget_test.dart`, `go test -short ./...`)
```

Guidelines:

- Files should be ordered to minimize impact on project correctness, ideally allowing one-by-one modifications without breaking the project
- Group logically related files if it does nit affect correctness
- Update guidelines and README files last
- Respect current file status - skip already-updated content
- Use sub-items (indented checkboxes) to list specific changes for each file
- File-level lines do not have checkboxes, only sub-items do
- If there are tests that are related to the changed files, create a test: item to run these tests only after all files related to these tests are modified
- If project configuration is needed (dependencies, code generation, etc.), create configure: items in the appropriate order (e.g., before tests that depend on them)
- Place configure: and test: items at the appropriate point in the sequence to maintain project correctness
- Always re-analyze if tests should be executed and fit then into the sequence properly
- If project-level configuration changes are detected, include an "update: .gitignore" item with technology-specific patterns to prevent committing generated or temporary files (detection criteria: configure: items for dependencies, new project directories like .augment/, .claude/, .github/, or framework-specific configuration files). Examples: Flutter project - add `*.g.dart`, `*.freezed.dart`, `build/`, `.dart_tool/`; Go project - add `*.exe`, `*.test`, `vendor/`, `bin/`

### Notes

Provide any additional context or notes about the change that may help implementers understand the impact. Use bullet list format. 3-5 bullets max.

CRITICAL: Do not create other sections beyond those specified above.
