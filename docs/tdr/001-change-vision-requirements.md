# TDR-001: Problem/Solution/Approach structure for change, requirements, and vision documents

- Date: 2025-11-25
- Status: Accepted
- Updated: 2025-11-25 (changed from vision.md to requirements.md with overview section)

## Context

The SeeAI framework uses change.md and requirements.md documents that describe problems and solutions. There was ambiguity about what naming convention to use for sections.

## Decision

Use Problem/Solution/Approach sections instead of Why/What/How in change.md and requirements.md documents.

### Common structure

Both change.md and requirements.md use the same Problem/Solution/Approach structure:

- Problem: 1-3 sentences with optional references to supporting evidence
- Solution: Introductory sentence followed by brief bullet list of capabilities
- Approach: High-level technical approach (optional, when not obvious)

### change.md

```text
# Change: [Title]

## Problem
[1-3 sentences with optional references]

## Approach
[High-level approach]
```

### requirements.md

```text
# Requirements: [Feature name]

## Overview

### Problem
[1-3 sentences with optional references]

### Solution
[Introductory sentence + brief bullet list]

### Approach (optional, when not obvious)
[High-level approach]

## Functional requirements
[Can be minimal for simple features]

## Non-functional requirements
[Can be omitted if not applicable]
```

### No vision.md

Do not create vision.md files. Use requirements.md instead. Existing vision.md files remain intact.

## Rationale

- Technical clarity: Problem/Solution/Approach is more explicit than Why/What/How
- Industry standard: Aligns with RFC and ADR conventions
- No file proliferation: requirements.md includes overview instead of separate vision.md
- Flexibility: Simple features have minimal requirements, complex features have detailed requirements
- DRY principle: Structure defined once in .seeai/rules/psa-structure.md and reused by all actions

## Consequences

- Existing vision.md files remain intact (yet)
- New work uses requirements.md with Problem/Solution/Approach sections
- change.md uses Problem/Approach sections
- Tooling needs updates to generate requirements.md instead of vision.md
- Single source of truth: .seeai/rules/psa-structure.md defines structure for all document types
