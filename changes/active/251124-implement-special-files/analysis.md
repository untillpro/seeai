# Analysis: Implement action should handle vision.md and design.md specially

## Specifications

None - this change only affects internal SeeAI Action implementation, not user-facing specifications.

## File changes

- create: [.seeai/rules/vision-structure.md](../../../.seeai/rules/vision-structure.md)
  - [x] Define required sections for vision.md (Why, What, How, Stories if applicable)
  - [x] Specify content requirements for each section (conciseness, format, examples)
  - [x] Define validation rules for structure and content completeness
  - [x] Provide guidance for generating new vision.md files
  - [x] Include examples of well-formed vision.md files
- [x] 👀
- create: [.seeai/rules/design-structure.md](../../../.seeai/rules/design-structure.md)
  - [ ] Define required sections for design.md (Overview, Architecture, Flows, References, etc.)
  - [ ] Specify content requirements and format for each section
  - [ ] Define validation rules for component naming, paths, and structure
  - [ ] Provide guidance for generating new design.md files
  - [ ] Include examples of well-formed design.md sections
- [ ] 👀
- update: [.seeai/actions/implement.md](../../../.seeai/actions/implement.md)
  - [ ] Add filename detection logic in Step 1 to identify vision.md and design.md files
  - [ ] Add rules loading logic to load corresponding rules file (.seeai/rules/vision-structure.md or .seeai/rules/design-structure.md) when special file detected
  - [ ] Update Step 2 processing to apply loaded rules for validation and generation
  - [ ] Add guidance on how to use rules for structure validation and content generation
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Add vision-structure.md, design-structure.md, and specs-structure.md to SPEC_FILES array
  - [x] Renamed rules files to use -structure suffix to avoid conflicts with commands

## Notes

- Rules files are internal SeeAI implementation details, not user-facing specifications
- Similar to how specs-structure.md guides the analyze action, vision-structure.md and design-structure.md will guide implement action
- Rules files renamed to use -structure suffix to avoid naming conflicts with command files (e.g., .seeai/commands/design.md)
- Rules files will be distributed via seeai.sh installation script to project scope only
- Extensible pattern allows adding more file type rules in future (models.md, integration.md, etc.)
