# Analysis: Use xargs to download files in parallel

## Specifications

All specifications are up to date; no changes needed.

## System changes

No system changes required.

## Project changes

No project changes required.

## File changes

- update: [scripts/seeai.sh](../../../scripts/seeai.sh)
  - [x] Refactor remote download loop (lines 674-705) to use xargs with -P 4 flag for parallel downloads
  - [x] Create download function that takes file path and downloads to target location
  - [x] Pipe files_to_install array to xargs to execute downloads in parallel
  - [x] Preserve fail-fast behavior by using xargs exit code handling
  - [x] Keep local mode sequential (lines 639-672) as file copying is already fast
- update: [tests/mocks/curl](../../../tests/mocks/curl)
  - [x] Ensure mock curl handles concurrent invocations correctly
  - [x] Verify mock can handle multiple simultaneous file writes without conflicts
- test: Parallel download functionality
  - [x] Run `bats tests/test_project_scope_installs.bats` to verify parallel downloads work correctly
  - [x] Run `bats tests/test_user_scope_installs.bats` to verify user scope remote downloads work with parallelism
  - [x] Verify all files are downloaded successfully in parallel mode
  - [x] Verify validation catches missing files after parallel download

## Notes

- Parallel downloads only apply to remote mode where curl downloads from GitHub
- Local mode remains sequential as cp operations are already fast
- Using 4 parallel downloads balances speed with resource usage
- xargs -P flag spawns multiple curl processes simultaneously
- Fail-fast behavior ensures installation stops on first download error

