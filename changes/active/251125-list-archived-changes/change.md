# List archived changes

## Problem

Users need a way to view and browse archived changes to understand what has been completed in the past, but currently there is no mechanism to list or query archived changes.

## Solution

Capability to list archived changes with the following features:

- Display all archived changes from the changes/archive/ directory
- Show change ID and title for each archived change
- Support filtering or searching archived changes (optional)
- Provide quick access to archived change details

## Approach

- Implement as an Action invoked through Natural Language Invocation (e.g., "list archived changes")
- Read the changes/archive/ directory to discover archived change folders
- Parse change.md files to extract change ID and title
- Display minimal information (change ID and title) for quick scanning
- No filtering or searching in initial version
