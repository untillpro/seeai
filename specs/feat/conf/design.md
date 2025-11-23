# Design: SeeAI Configuration Script

## Overview

[scripts/seeai.sh](../../../scripts/seeai.sh) - Installation script for SeeAI prompt templates supporting multiple agents (Augment, Claude, Copilot) and scopes (user, project).

## Principles

- Ask before installing - default to user scope with option to switch to project scope
- Support both interactive and non-interactive modes
- Validate all installations and fail fast with clear error messages
- Maintain backward compatibility with legacy installation locations

## Models

The script applies the following models:

- [mconf-files/models.md](../../models/mconf-files/models.md)
- [mconf/models.md](../../models/mconf/models.md)

## References

- [Installation File Structure Model](../../models/mconf-files/vision.md)
- [Natural Language Invocation Design](../nli/design.md)
- [Configuration Version Tracking Model](../../models/mconf/vision.md)
- [Development Guide](../../../docs/devguide.md) - Implementation details and testing
