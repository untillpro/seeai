# Change: Analysis should stop if there are specifications to modify

## Why

The analysis Action currently continues through all steps even when specifications need to be modified. This creates unnecessary work and potential confusion, as implementers should first update specifications before proceeding with implementation.

## How

Modify the analyze Action to check after Step 5 if there are any specifications to create or update. If specifications are found, stop immediately after generating the "Specifications to create/update" sections without generating the "Affected files and tests" section. Create a partial analysis.md with specs sections only to preserve the analysis work. Show a clear actionable message: "Specifications need to be created/updated. Please update specifications first, then re-run analysis to continue with implementation planning."
