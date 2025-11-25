# Problem/Solution/Approach structure

## Section definitions

### Problem

Explains the problem being solved.

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

### Solution

Describes what is being created or implemented.

Content requirements:

- Start with an introductory sentence describing the feature/system/capability
- Follow with a brief list of specific capabilities (if applicable)
- Focus on capabilities and outcomes
- Avoid implementation details
- Answer: What are we building? What capabilities does it provide?

Format:

```markdown
## Solution

[Feature/system name] with the following capabilities:

- Capability 1
- Capability 2
- Capability 3
```

### Out of Scope (optional)

What is explicitly NOT included in this change.

Content requirements:

- Brief bullet list (3-5 items maximum)
- Only include items that might reasonably be expected
- Answer: What related features are NOT included?

### Approach (optional, when approach is not obvious)

High-level approach or mechanism.

Content requirements:

- Brief description of the approach
- Can include key technologies or patterns
- Keep it high-level (details belong in design.md)
- Answer: How will this work at a high level?

## Validation rules

Structure validation:

- Must have "Problem" section
- Must have "Solution" section
- "Out of Scope" section is optional
- "Approach" section is optional
- NO other top-level sections are allowed (no Stories, no References as separate section, no Requirements, etc.)
- References should be included within the Problem section, not as a separate top-level section

Content validation:

- Problem section: 1-3 sentences, no implementation details, optional references to supporting evidence
- Solution section: Must start with introductory sentence, followed by brief list (if applicable)
- Out of Scope section: Brief bullet list (3-5 items maximum), only reasonably expected items
- Approach section: High-level only, no code or detailed steps

## Examples

### Deposit feature

```markdown
## Problem

Parents need a way to add money to their children's digital accounts without handling physical cash.

References:

- [JIRA-456: Digital deposit feature request](https://jira.example.com/browse/JIRA-456)

## Solution

Deposit feature with the following capabilities:

- Deposit money to child accounts
- Transaction history
- Instant notifications

## Out of Scope

- Withdrawal functionality
- Multi-currency support
- Scheduled/recurring deposits

## Approach

- REST API endpoint for deposits
- Database transaction with balance update
- Push notification service integration
```

### Payment API contract

```markdown
## Problem

External partners need a standardized way to process payments through our platform.

References:

- [Partner integration requirements doc](https://docs.example.com/partner-requirements)

## Solution

Payment API contract providing:

- REST API for payment processing
- Authentication and authorization
- Webhook notifications for payment status

## Out of Scope

- Refund processing
- Subscription management
- Fraud detection

## Approach

- OAuth 2.0 for authentication
- JSON request/response format
- Idempotency keys for safe retries
```
