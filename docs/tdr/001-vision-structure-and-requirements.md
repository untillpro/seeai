# TDR-001: Vision Document Structure and Requirements Placement

- Date: 2025-11-25
- Status: Accepted

## Context

The SeeAI framework uses multiple specification document types (vision.md, scenarios.feature, design.md, requirements.md) across different specification categories (features, models, integrations, contracts). There was ambiguity about:

1. What sections should be included in vision.md
2. Where user stories/scenarios should be documented
3. Whether requirements.md should be used for individual features
4. The relationship between vision.md and requirements.md

## Decision

### `vision.md` structure

`vision.md` files should contain only:

- Why: Problem statement (1-3 sentences) with optional references to supporting evidence (Jira/GitHub issues, user feedback, business requirements, customer tickets, related ADRs/TDRs)
- What: High-level capabilities (brief list or 1-2 sentences)
- How: High-level approach (optional, when approach is not obvious)

Stories section is REMOVED from vision.md.

### User Stories and Scenarios

User stories and scenarios belong in scenarios.feature files (Gherkin format), not in vision.md.

Structure by specification category:

- Features: vision.md, scenarios.feature, design.md
- Integrations: vision.md, integration.md, scenarios.feature, design.md
- Contracts: vision.md, contract.md, scenarios.feature
- Models: vision.md, models.md (no scenarios)

### `requirements.md` usage

requirements.md is OPTIONAL

## Rationale

### Why remove stories from `vision.md`

1. Duplication: scenarios.feature already provides user scenarios in a more formal, testable format (Gherkin)
2. Separation of concerns: Vision is strategic (why/what), scenarios are behavioral (how users interact)
3. Consistency: Aligns with BDD practices where scenarios are separate from vision
4. Clarity: Each document has a single, clear purpose

### Why include references in Why section

1. Traceability: Links vision directly to the source of the problem/need
2. Validation: Provides evidence that the problem is real and worth solving
3. Context: Allows readers to dive deeper into the background
4. Accountability: Shows decisions are based on actual requirements, not assumptions
5. Audit trail: Helps future developers understand the original motivation

### Why requirements.md is optional

1. Avoids redundancy: Requirements are already captured in vision.md + scenarios.feature + design.md
2. Reduces file proliferation: Fewer files to maintain for individual features
3. Project-level only: System-wide requirements need a central location, but feature-level requirements fit naturally in existing documents
4. Flexibility: Teams can add requirements.md at project level when cross-cutting requirements emerge

### Document hierarchy

- vision.md: Strategic (30 seconds to read, answers "should we build this?")
- scenarios.feature: Behavioral (user interactions, testable scenarios)
- design.md: Technical (implementation details, architecture, acceptance criteria)
- requirements.md: System-wide (only at project level for cross-cutting concerns)

## Consequences

### Positive

- Clear separation between strategic vision and behavioral scenarios
- No duplication between Stories and scenarios.feature
- Simpler structure for most features (no requirements.md needed)
- vision.md stays concise and focused
- Aligns with BDD best practices

### Negative

- Existing vision.md files with Stories section need to be migrated
- .seeai/rules/vision.md needs to be updated to remove Stories section
- Teams familiar with having stories in vision may need to adjust

## References

- https://www.scrum.org/resources/blog/why-how-what-product-vision-task
  - What you are doing
  - How you are doing it
  - Why you are doing it
  