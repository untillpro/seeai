# Analysis: Implement action should handle vision.md and design.md specially

## Specifications

None - this change only affects internal SeeAI Action implementation, not user-facing specifications.

## File changes

- create: [.seeai/rules/psa-structure.md](../../../.seeai/rules/psa-structure.md)
  - [x] Define required sections for Problem/Solution/Approach structure
  - [x] Specify content requirements for each section (conciseness, format, examples)
  - [x] Define validation rules for structure and content completeness
  - [x] Provide guidance for generating documents with this structure
  - [x] Include examples of well-formed documents
  - [x] Document usage in change.md, requirements.md, and vision.md
- update: [.seeai/rules/specs-structure.md](../../../.seeai/rules/specs-structure.md)
  - [x] Update contracts category to use requirements.md instead of vision.md
  - [x] Update features category to use requirements.md instead of vision.md
  - [x] Update integrations category to use requirements.md instead of vision.md
  - [x] Update models category to use requirements.md instead of vision.md
  - [x] Add note that vision.md is legacy and only for existing files
- update: [.seeai/actions/analyze.md](../../../.seeai/actions/analyze.md)
  - [x] Update specification examples to use requirements.md instead of vision.md
- update: [specs/project/concepts.md](../../../specs/project/concepts.md)
  - [x] Add concept definition for requirements.md
  - [x] Add concept definition for Problem/Solution/Approach structure
  - [x] Reference psa-structure.md as the single source of truth
- test: Verify documentation consistency
  - [x] Run: `grep -r "vision.md" .seeai/ --include="*.md"` to find references in action files
  - [x] Verify all action files reference requirements.md for new work

## Notes

- Existing vision.md files in specs/ remain intact and functional
- All new specifications should use requirements.md with Problem/Solution/Approach structure
- The psa-structure.md file is the single source of truth for document structure
- Actions should guide users to create requirements.md instead of vision.md
- No code changes needed - only documentation and guidance updates