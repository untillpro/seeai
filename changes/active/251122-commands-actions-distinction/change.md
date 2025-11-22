# Change: Clear distinction between COMMANDS and ACTIONS

## Why

The current documentation does not clearly distinguish between Commands and Actions, leading to confusion about which features trigger agent execution and which scopes they belong to.

## How

Update the code and the documentation to clearly specify that Commands and Actions (both trigger agent execution) like design and gherkin are installed in both user and project scope, while Actions only (register, analyze, implement, archive) are project scope only.
