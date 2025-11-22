# Analysis: Add Installation File Structure Model

## Specifications to create

- [specs/models/mconf-files/vision.md](../../../specs/models/mconf-files/vision.md)
  - [x] Define the purpose of the installation file structure model
  - [x] Explain why formal documentation of installation patterns is needed
  - [x] Describe the scope (agents, scopes, OS variations)

- [specs/models/mconf-files/model.md](../../../specs/models/mconf-files/model.md)
  - [x] Define base directory patterns for each agent (Augment, Claude, Copilot)
  - [x] Specify subdirectory usage rules (seeai/ for Augment/Claude, flat for Copilot)
  - [x] Document OS-specific path variations for Copilot user scope (Windows, macOS, Linux)
  - [x] Specify file transformation rules (prefix, extension, path flattening)
  - [x] Define version file location rules (user scope vs project scope)
  - [x] Document file categories (Commands, Actions, Specs) and scope distribution
  - [x] Specify Agents Config File (ACF) selection rules (AGENTS.md vs CLAUDE.md)

## Affected files and tests

- update: [specs/models/mconf/models.md](../../../specs/models/mconf/models.md)
  - [x] Add cross-reference to mconf-files model for installation directory details in VersionInfo section

- update: [specs/feat/conf/design.md](../../../specs/feat/conf/design.md)
  - [x] Add reference to specs/models/mconf-files/model.md in Installation Locations section (line 94)
  - [x] Note that detailed structure is documented in the model specification

## Notes

- The new model extracts installation file structure patterns from specs/feat/conf/design.md into a dedicated model specification
- This follows the specs/models pattern for user-facing structures (configuration files, folder structures)
- The model will serve as the single source of truth for installation directory patterns, file transformations, and version file locations
- specs/feat/conf/design.md will reference the model rather than duplicating the detailed structure information
- The model complements specs/models/mconf/models.md (VersionInfo) by documenting the directory structure where version files are placed