# Vision Document Structure

## Purpose

This document defines the structure, content requirements, and validation rules for vision.md files. Vision documents explain the purpose and high-level approach for features, models, integrations, and contracts.

## Required sections

### Why

Explains the motivation and problem being solved.

Content requirements:

- 1-3 sentences maximum describing the problem or need
- Focus on the problem or need
- Avoid implementation details
- Answer: What problem does this solve? Why is it needed?
- Include references to supporting evidence (optional but recommended):
  - Jira/Linear/GitHub issues
  - User feedback or research
  - Business requirements documents
  - Customer tickets or support requests
  - Related decisions (ADRs/TDRs)

References can be:

- Inline links within the problem statement
- Listed after the problem statement in a "References:" subsection
- Both (brief inline + full list)

### What

Describes what is being created or implemented.

Content requirements:

- Brief list or 1-2 sentences
- Focus on capabilities and outcomes
- Avoid implementation details
- Answer: What are we building? What capabilities does it provide?

### How (optional)

High-level approach or mechanism.

Content requirements:

- Brief description of the approach
- Can include key technologies or patterns
- Keep it high-level (details belong in design.md)
- Answer: How will this work at a high level?

## Validation rules

Structure validation:

- Must have "Why" section
- Must have "What" section
- "How" section is optional
- NO other top-level sections are allowed (no Stories, no References as separate section, no Requirements, etc.)
- References should be included within the Why section, not as a separate top-level section

Content validation:

- Why section: 1-3 sentences, no implementation details, optional references to supporting evidence
- What section: Brief list or 1-2 sentences
- How section: High-level only, no code or detailed steps

## Examples

### Deposit feature

```markdown
## Why

Parents need a way to add money to their children's digital accounts without handling physical cash.

References:

- [JIRA-456: Digital deposit feature request](https://jira.example.com/browse/JIRA-456)

## What

- Deposit money to child accounts
- Transaction history
- Instant notifications

## How

- REST API endpoint for deposits
- Database transaction with balance update
- Push notification service integration
```

### Payment API contract

```markdown
## Why

External partners need a standardized way to process payments through our platform.

References:

- [Partner integration requirements doc](https://docs.example.com/partner-requirements)

## What

- REST API for payment processing
- Authentication and authorization
- Webhook notifications for payment status

## How

- OAuth 2.0 for authentication
- JSON request/response format
- Idempotency keys for safe retries
```
