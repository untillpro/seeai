# Archive a Change

You are archiving a completed change by moving it from the active folder to the archive folder.

## Step 1: Identify the Change

- Identify the $ChangeID in the `@/changes/active` folder
- If $ChangeID cannot be identified, ask user for clarification and repeat Step 1
- Load and understand all the change description files from `@/changes/active/$ChangeID`

## Step 2: Verify Completion Status

Before archiving, verify that the change is complete:

- Check if all todo items in all Change files are marked as done `[x]`
- If any items are incomplete, ask the user for confirmation before proceeding
- Report the completion status to the user

## Step 3: Move Change to Archive

Move the change folder from active to archive:

- Source: `changes/active/$ChangeID/`
- Destination: `changes/archive/$ChangeID/`
- Move the entire folder with all its contents (change.md, analysis.md, tasks.md, etc.)

## Step 4: Verify Archive

After moving:

- Confirm the folder exists in `changes/archive/$ChangeID/`
- Confirm the folder no longer exists in `changes/active/`

## Step 5: Report Completion

Report to the user:

- Change ID that was archived
- Location of archived change
- Summary of what was archived (list of files)

## Notes

- Do not modify the contents of any files during archiving
- Preserve all metadata and timestamps
- If the change folder contains uncommitted work, warn the user before archiving
