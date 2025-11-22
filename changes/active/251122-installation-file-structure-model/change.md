# Change: Add Installation File Structure Model

## Why

The project lacks a formal model that describes the installation file structure for different agents (Augment, Claude, Copilot) across different scopes (User Scope, Project Scope), making it difficult to understand where files are installed and how they are organized.

## How

Create a new specification document in `specs/models/conf-files.md` that formally describes the installation file structure model, including base directories, subdirectory patterns, file naming conventions, and transformation rules for each agent and scope combination.

### Clarifications

- Include OS-specific path variations (Windows, macOS, Linux) for Copilot user scope installations
- Document file transformation rules (e.g., `design.md` -> `seeai-design.prompt.md` for Copilot, path flattening for subdirectories)
- Include version file location rules (`seeai-version.yml` placement differs between user and project scopes)
