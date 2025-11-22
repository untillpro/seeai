# Tasks: Scope as Parameter Implementation

## Overview

Add `--scope` parameter to enable fully non-interactive installations by specifying user or project scope.

## Tasks

### 1. Update `scripts/seeai.sh`

- [x] Add `--scope` parameter parsing in `install_command()` function
  - Accept values: `user` or `project`
  - Validate the scope parameter
  - Set `SCOPE` variable based on parameter
- [x] Skip Y/w/n prompt in `install_files()` when `--scope` is provided
  - Check if scope was provided via parameter
  - If yes, skip interactive prompt and proceed directly
  - If no, keep existing Y/w/n prompt behavior
- [x] Update error handling for invalid scope values

### 2. Update `specs/feat/conf/design.md`

- [x] Add `--scope` to Options section in Command Syntax
  - Document syntax: `--scope <user|project>`
  - Explain it skips interactive scope prompt
- [x] Add examples with `--scope` parameter
  - Example: `seeai.sh install --agent auggie --scope user`
  - Example: `seeai.sh install --agent claude --scope project`
- [x] Update Install Command Flow section
  - Document that Step 2 (Y/w/n prompt) is skipped when `--scope` is provided

### 3. Update `README.md`

- [x] Replace single installation command per agent with two commands (user and project)
- [x] For auggie section:
  - Add user scope command: `curl ... | bash -s install main --agent auggie --scope user`
  - Add project scope command: `curl ... | bash -s install main --agent auggie --scope project`
- [x] For claude section:
  - Add user scope command: `curl ... | bash -s install main --agent claude --scope user`
  - Add project scope command: `curl ... | bash -s install main --agent claude --scope project`
- [x] For copilot section:
  - Add user scope command: `curl ... | bash -s install main --agent copilot --scope user`
  - Add project scope command: `curl ... | bash -s install main --agent copilot --scope project`
- [x] Add explanatory text about the difference between user and project scopes

### 5. Documentation

- [x] Update proposal.md to reflect correct feature (scope, not agent)
- [x] Verify all examples in design.md are accurate
- [x] Check that README.md commands are copy-paste ready
