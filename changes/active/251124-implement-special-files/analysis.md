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
  - [ ] Add rules loading logic to load corresponding rules file (.seeai/rules/psa-structure.md or .seeai/rules/design-structure.md) when special file detected
  - [ ] Update Step 2 processing to apply loaded rules for validation and generation
  - [ ] Add guidance on how to use rules for structure validation and content generation
- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Add psa-structure.md, design-structure.md, and specs-structure.md to SPEC_FILES array
  - [x] Renamed rules files to use -structure suffix to avoid conflicts with commands
  - [x] Renamed vision-structure.md to psa-structure.md for clarity

## Notes

- Rules files are internal SeeAI implementation details, not user-facing specifications
- Similar to how specs-structure.md guides the analyze action, psa-structure.md and design-structure.md will guide implement action
- Rules files renamed to use -structure suffix to avoid naming conflicts with command files (e.g., .seeai/commands/design.md)
- psa-structure.md defines Problem/Solution/Approach structure used by change.md, requirements.md, and vision.md (DRY principle)
- Rules files will be distributed via seeai.sh installation script to project scope only
- Extensible pattern allows adding more file type rules in future (models.md, integration.md, etc.)
