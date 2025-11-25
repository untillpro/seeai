# Specification Document Structure

## Overview

The `specs` may containt the following categories of specifications:

- contracts: Specifications for user-facing project-defined contracts, like API, protocols, workflows
  - requirements.md
  - contract.md
  - scenarious.feature (if applicable)
- components: Specifications for system components or modules that are shared across features
  - E.g. routers, authentication/authorization modules, own implementation of logging, error handling
  - requirements.md
  - design.md
- features: Feature specifications
  - requirements.md, scenarious.feature, design.md
- integrations: Specifications for integrations with external systems
  - requirements.md
  - integration.md: A reference document that outlines integration protocols and relevant parts to be implemented
  - scenarious.feature
  - design.md
- models: Specifications related to user-facing structures
  - requirements.md
  - models.md
    - User-facing structures: what end users see, create, or interact with
    - Examples: Configuration file formats, folder structures, version files, UI data displays
    - Not included: Implementation details (database schemas, DTOs, state objects) - these belong
- project: Project-level specifications that must be followed across the codebase
  - adr.md: Architecture Decision Records
    - Brief documents with extremely concise descriptions and rationale and links to more detailed docs
  - concepts.md: High-level concepts for the project
  - dev.md: Development rules
  - test.md: Testing strategy and rules
  - release.md: Packaging, installers, CI/CD, installation, configuration, updates...
    - High-level overview of release process and mechanisms
    - Detailes must be in the specs inder /specs/release folder
  - features.md: Overview of key project features
  - requirements.md: High-level functional and non-functional requirements
  - structure.md: Principles of the project folder structure, bird's eye view
  - tech.md: Technology stack and other technical principles
  - uxui.md: User experience and user interface rules

## Project-related specification categories

For each file in the `specs/project` folder there may be a corresponding specification folder, e.g.:

- `specs/dev`: Describes development-related capabilities like how to set up the dev environment
- `specs/test`: Describes testing-related capabilities like how to run unit/integration tests
- `specs/delivery`: Describes capabilities related packaging, installers, CI/CD, installation, configuration, updates...

## Models


## When to Create New Specifications

New specifications should be created when existing specs do not cover the new requirements.

Do NOT create specs for:

- Implementation details (database schemas, DTOs, state objects) - these belong in design documents
- Temporary or one-off changes
- Bug fixes that don't change contracts or models
- Internal refactoring that doesn't affect architecture or contracts

Example

```markdown
## Specifications

- [mcp/requirements.md](../../../specs/integrations/mcp/requirements.md)
  - [ ] Define the purpose and benefits of MCP server integration
  - [ ] Describe the extension architecture and tool-based approach
  - [ ] Explain how Actions will interact with the MCP server
- [mcp/integration.md](../../../specs/integrations/mcp/integration.md)
  - [ ] MCP protocol version and transport mechanisms (stdio/HTTP)
  - [ ] Brief description of MCP server initialization protocol with link to spec
  - [ ] Brief description of tool listing/discovery protocol with link to spec
  - [ ] Brief description of tool invocation protocol with link to spec
- [mcp/design.md](../../../specs/integrations/mcp/design.md)
  - [ ] Define error handling and fallback mechanisms (retry logic, timeouts)
  - [ ] Specify configuration format for MCP server connection (your internal config structure)
  - [ ] Architecture components (MCPClient, ExtensionRegistry, etc.)
- [mcp-config/requirements.md](../../../specs/models/mcp-config/requirements.md)
  - [ ] Define the need for MCP server configuration tracking
  - [ ] Describe configuration scope (user vs project)
- [mcp-config/model.md](../../../specs/models/mcp-config/model.md)
  - [ ] Specify MCP server configuration file format
  - [ ] Define connection parameters (transport type, endpoint, authentication)
  - [ ] Specify extension registry format
  - [ ] Define configuration file locations for user and project scopes
```
