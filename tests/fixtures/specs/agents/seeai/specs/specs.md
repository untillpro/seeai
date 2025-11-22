# Specification Structure

## Overview

- specs
  - agents: Specifications for agents
  - contracts: Specifications for project-defined contracts, like API, protocols, workflows
    - vision.md, contract.md
  - feat: Feature specifications
    - vision.md, scenarious.feature
  - integrations: Specifications for integrations with external systems
    - vision.md, integration.md
  - models: Specifications related to data models, see below
    - vision.md, model.md
  - project: Project-level specifications that must be followed across the codebase

## Models

- User-facing structures: what end users see, create, or interact with
- Examples: Configuration file formats, folder structures, version files, UI data displays
- Not included: Implementation details (database schemas, DTOs, state objects) - these belong in design documents

## When to Create New Specifications

Create new specs in these scenarios:

- specs/models: User-facing data structures (config files, folder structures, version files, UI data formats)
- specs/feat: New user-facing features or capabilities
- specs/contracts: APIs, protocols, or workflows that multiple components must follow
- specs/integrations: Integration with external systems or third-party services
- specs/agents: New agent behaviors or prompts
- specs/project: New project-wide rules or standards
- Architectural components without user-visible behavior that need to be documented as part of the system architecture

Do NOT create specs for:

- Implementation details (database schemas, DTOs, state objects) - these belong in design documents
- Temporary or one-off changes
- Bug fixes that don't change contracts or models
- Internal refactoring that doesn't affect architecture or contracts

Example

```markdown
## Specifications to create

- [specs/integrations/mcp/vision.md](../../../specs/integrations/mcp/vision.md)
  - [ ] Define the purpose and benefits of MCP server integration
  - [ ] Describe the extension architecture and tool-based approach
  - [ ] Explain how Actions will interact with the MCP server
- [specs/integrations/mcp/integration.md](../../../specs/integrations/mcp/integration.md)
  - [ ] Specify MCP protocol version and transport mechanisms (stdio/HTTP)
  - [ ] Define extension discovery protocol and tool listing format
  - [ ] Specify extension invocation protocol and response handling
  - [ ] Define error handling and fallback mechanisms
  - [ ] Specify configuration format for MCP server connection
- [specs/models/mcp-config/vision.md](../../../specs/models/mcp-config/vision.md)
  - [ ] Define the need for MCP server configuration tracking
  - [ ] Describe configuration scope (user vs project)
- [specs/models/mcp-config/model.md](../../../specs/models/mcp-config/model.md)
  - [ ] Specify MCP server configuration file format
  - [ ] Define connection parameters (transport type, endpoint, authentication)
  - [ ] Specify extension registry format
  - [ ] Define configuration file locations for user and project scopes
```

