# Change: Reorganize .seeai directory structure

## Why

The current .seeai directory has a flat structure where Actions (register.md, design.md, etc.), SeeAI Specs (specs/), and an empty templates/ directory coexist at the same level, making it unclear which files serve which purpose and harder to maintain as the project grows.

## How

Create dedicated subdirectories (actions/, commands/, rules/) to separate different types of content, making the structure more maintainable and the purpose of each file immediately clear from its location.

### Structure

- Move existing Action files (register.md, analyze.md, implement.md, archive.md) to `.seeai/actions/` to clearly separate Actions from other content
- Create `.seeai/commands/` directory to store Command templates (design.md, gherkin.md) that serve dual purpose as both Actions (via NLI in project scope) and Commands (installed to user scope)
- Move `.seeai/specs/specs.md` to `.seeai/rules/specs.md` to distinguish internal SeeAI rules from project specifications in `/specs/`
- Remove empty `.seeai/templates/` directory

### Triggering instructions

Update triggering instructions in AGENTS.md to use new paths to ensure AI agents can find Actions in their new locations.

### Installation script

Update seeai.sh installation script to create new subdirectories for new installations and handle migration of existing installations.

### Documentation references

Update all references in documentation to use new paths to ensure accuracy and prevent confusion.
