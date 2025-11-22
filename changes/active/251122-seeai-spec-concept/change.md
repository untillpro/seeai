# Change: Introduce SeeAI Spec Concept

## Why

SeeAI Actions need a way to reference and use reusable specification templates that define common patterns and structures, but currently there is no formal concept or storage location for these shared specifications.

## How

- Introduce a new "SeeAI Spec" concept that defines reusable specification templates stored in the /specs/agents/seeai/specs folder, which can be referenced and used by SeeAI Actions to maintain consistency across different workflows
- Move /specs/project/specs.md to /specs/agents/seeai/specs/specs.md
- Use /specs/agents/seeai/specs/specs.md from the actions instead of /specs/project/specs.md
- SeeAI Specs will not be versioned separately - they evolve with Actions
- Actions will reference specs using relative path `@/specs/agents/seeai/specs/specs.md`
- Keep all specification structure guidance in a single specs.md file
- Distribute specs.md to project scope only (where Actions are installed)
- Add new SPEC_FILES array in seeai.sh for spec file distribution
- Install specs.md in subdirectory structure (specs/specs.md under seeai directory)
- Installation script automatically creates specs directory structure
