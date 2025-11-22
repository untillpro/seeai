# Change: Add project scope tests to mega tests

## Why

The current mega test in test_user_scope_installs.bats only covers user scope installations. Project scope installations are not tested at all, leaving a significant gap in test coverage for the installation script. This includes testing file installation, VersionInfo creation, and ACF (Agents Config File) creation/update logic.

## How

Create a new test file test_project_scope_installs.bats with a mega test for project scope that tests all combinations of agents (auggie, claude, copilot), versions (latest, main, v0.0.9), and modes (remote, local). Add three separate focused tests for ACF update scenarios using two agents (auggie, claude), one version (latest), and remote mode. The tests verify that all 6 files (Commands + Actions) are correctly installed in project scope directories, VersionInfo is created at specs/agents/seeai/seeai-version.yml, ACF is created or updated with triggering instructions, and includes negative assertions to verify Actions are NOT installed in user scope.
