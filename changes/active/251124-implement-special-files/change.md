# Change: Implement action should handle vision.md and design.md specially

## Why

The implement action currently treats all markdown files uniformly, but vision.md and design.md files have special structures and purposes that require different handling - vision.md defines high-level requirements while design.md contains detailed implementation specifications with specific sections.

## How

Extend the implement action to detect vision.md and design.md files and apply special processing rules for each, using:

- .seeai/rules/vision-structure.md to validate structure and guide content for vision.md files
- .seeai/rules/design-structure.md to validate structure and guide content for design.md files

### Detection and invocation

When implement action starts processing, detect filename (ends with vision.md or design.md) and load corresponding rules file at start, applying rules throughout processing.

### Rules scope

Rules cover both structure requirements (required sections, order, format) and content requirements (what each section should contain, validation criteria).
