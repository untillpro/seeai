# Analysis: Analysis should stop if there are specifications to modify

## Specifications to create

None - all necessary specifications already exist.

## Specifications to update

- [specs/contracts/se-workflow/vision.md](../../../specs/contracts/se-workflow/vision.md)
  - [x] Update "Analyze the impact" step to clarify that analysis stops if specifications need to be created or updated
  - [x] Add explicit note that "Prepare specs" step must be completed before "Prepare implementation plan" step
  - [x] Clarify that analysis generates partial output when specifications are found

## Affected files and tests

- update: [.seeai/actions/analyze.md](../../../.seeai/actions/analyze.md)
  - [x] Add new Step 5a after Step 5 to check if specifications need to be created or updated
  - [x] If specifications are found, stop and output only "Specifications to create" and "Specifications to update" sections
  - [x] Add instruction to display message: "Specifications need to be created/updated. Please update specifications first, then re-run analysis to continue with implementation planning."
  - [x] Document that "Affected files and tests" section is only generated after specifications are updated

## Notes

- This change enforces the proper workflow sequence: specifications must be updated before implementation planning
- The analyze Action will create a partial analysis.md with only "Specifications to create" and "Specifications to update" sections when stopping early
- The "Affected files and tests" section will not be generated until specifications are updated and analysis is re-run
- This prevents wasted effort on implementation planning when the specifications (the source of truth) are not yet finalized
- Users will receive a clear message: "Specifications need to be created/updated. Please update specifications first, then re-run analysis to continue with implementation planning."
