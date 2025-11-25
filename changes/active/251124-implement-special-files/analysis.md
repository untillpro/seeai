# Analysis: Implement action should handle vision.md and design.md specially

## Specifications

None - this change only affects internal SeeAI Action implementation, not user-facing specifications.

## File changes

- create: [.seeai/rules/vision.md](../../../.seeai/rules/vision.md)
  - [ ] Define required sections for vision.md (Why, What, How, Stories if applicable)
  - [ ] Specify content requirements for each section (conciseness, format, examples)
  - [ ] Define validation rules for structure and content completeness
  - [ ] Provide guidance for generating new vision.md files
  - [ ] Include examples of well-formed vision.md files
- create: [.seeai/rules/design.md](../../../.seeai/rules/design.md)
  - [ ] Define required sections for design.md (Overview, Architecture, Flows, References, etc.)
  - [ ] Specify content requirements and format for each section
  - [ ] Define validation rules for component naming, paths, and structure
  - [ ] Provide guidance for generating new design.md files
  - [ ] Include examples of well-formed design.md sections
- update: [.seeai/actions/implement.md](../../../.seeai/actions/implement.md)
  - [ ] Add filename detection logic in Step 1 to identify vision.md and design.md files
  - [ ] Add rules loading logic to load corresponding rules file when special file detected
  - [ ] Update Step 2 processing to apply loaded rules for validation and generation
  - [ ] Add guidance on how to use rules for structure validation and content generation
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [ ] Add vision.md and design.md to SPEC_FILES array
  - [ ] Update ALL_FILES array to include new rule files

## Notes

- Rules files are internal SeeAI implementation details, not user-facing specifications
- Similar to how specs.md guides the analyze action, vision.md and design.md will guide implement action
- Rules files will be distributed via seeai.sh installation script to project scope only
- Extensible pattern allows adding more file type rules in future (models.md, integration.md, etc.)