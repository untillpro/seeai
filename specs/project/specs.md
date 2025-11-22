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
