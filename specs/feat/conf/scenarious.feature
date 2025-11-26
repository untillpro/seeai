@feature-conf
Feature: SeeAI Configuration Management
    As a developer
    I want to install and manage SeeAI configuration files
    So that I can use SeeAI commands and actions in my projects

    # VIEW scenarios
    @conf-1
    Scenario: List installed files when no installations exist
        Given no SeeAI installations exist
        When I run "seeai.sh list"
        Then I should see "No SeeAI installations found."

    @conf-2
    Scenario: List installed files in user scope
        Given I have SeeAI installed in user scope for "auggie"
        When I run "seeai.sh list"
        Then I should see user scope installation:
            | Label         | Version Info        |
            | User (auggie) | remote-main-abc1234 |
        And I should see installed files:
            | File       |
            | design.md  |
            | gherkin.md |

    @conf-3
    Scenario: List installed files in project scope
        Given I have SeeAI installed in project scope
        When I run "seeai.sh list"
        Then I should see project scope installation:
            | Label                | Version Info        |
            | Project (all agents) | remote-main-abc1234 |
        And I should see installed files:
            | File                        |
            | .seeai/actions/register.md  |
            | .seeai/actions/analyze.md   |
            | .seeai/actions/implement.md |
            | .seeai/actions/archive.md   |
            | .seeai/commands/design.md   |
            | .seeai/commands/gherkin.md  |

    # CREATE scenarios
    @conf-4
    Scenario Outline: Install to user scope - happy path
        Given no SeeAI installations exist
        When I run "seeai.sh install <version> --agent <agent> --scope user"
        Then the installation should succeed
        And Commands should be installed to user scope for "<agent>"
        And Actions should not be installed
        And seeai-version.yml should be created in user scope
        And the version should be "<expected_version>"

        Examples:
            | version | agent   | expected_version |
            | main    | auggie  | remote-main-*    |
            | main    | claude  | remote-main-*    |
            | main    | copilot | remote-main-*    |
            | v0.1.0  | auggie  | v0.1.0           |

    @conf-5
    Scenario Outline: Install to project scope - happy path
        Given no SeeAI installations exist
        When I run "seeai.sh install <version> --agent <agent> --scope project"
        Then the installation should succeed
        And all files should be installed to .seeai/:
            | File Type | Count |
            | Commands  | 2     |
            | Actions   | 4     |
            | Specs     | 3     |
        And seeai-version.yml should be created in .seeai/
        And triggering instructions should be added to "<acf_file>"
        And the version should be "<expected_version>"

        Examples:
            | version | agent   | acf_file  | expected_version |
            | main    | auggie  | AGENTS.md | remote-main-*    |
            | main    | claude  | CLAUDE.md | remote-main-*    |
            | main    | copilot | AGENTS.md | remote-main-*    |
            | v0.1.0  | auggie  | AGENTS.md | v0.1.0           |

    @conf-6
    Scenario: Install with interactive scope selection
        Given no SeeAI installations exist
        When I run "seeai.sh install main --agent auggie"
        And I see the user scope preview
        And I enter "w" to switch to project scope
        And I see the project scope preview
        And I enter "Y" to confirm
        Then the installation should succeed
        And all files should be installed to .seeai/

    @conf-7
    Scenario: Install with interactive agent selection
        Given no SeeAI installations exist
        When I run "seeai.sh install main --scope user"
        And I am prompted "Which agent?"
        And I select "1" for auggie
        Then the installation should proceed with auggie

    # VALIDATION scenarios
    @conf-8
    Scenario Outline: Installation validation and error handling
        Given <precondition>
        When I run "seeai.sh install <version> <options>"
        Then I should see an error message "<message>"
        And the installation should be <result>

        Examples:
            | precondition              | version | options         | message                      | result   |
            | no precondition           | latest  | --agent invalid | Invalid agent 'invalid'      | rejected |
            | no precondition           | main    | --scope invalid | Invalid scope 'invalid'      | rejected |
            | no releases exist         | latest  | --agent auggie  | No releases found            | rejected |
            | GitHub API is unavailable | main    | --agent auggie  | One or more downloads failed | rejected |
            | no precondition           | main    | --agent auggie  | Invalid choice               | rejected |

    # CANCEL scenarios
    @conf-9
    Scenario: Cancel installation at user scope prompt
        Given no SeeAI installations exist
        When I run "seeai.sh install main --agent auggie"
        And I see the user scope preview
        And I enter "n" to cancel
        Then the installation should be cancelled
        And no files should be installed

    @conf-10
    Scenario: Cancel installation at project scope prompt
        Given no SeeAI installations exist
        When I run "seeai.sh install main --agent auggie"
        And I see the user scope preview
        And I enter "w" to switch to project scope
        And I see the project scope preview
        And I enter "n" to cancel
        Then the installation should be cancelled
        And no files should be installed

    # UPDATE scenarios
    @conf-11
    Scenario: Reinstall overwrites existing files
        Given I have SeeAI v0.1.0 installed in user scope for "auggie"
        When I run "seeai.sh install main --agent auggie --scope user"
        Then the installation should succeed
        And existing files should be overwritten
        And seeai-version.yml should be updated with new version

    # EDGE CASES
    @conf-12
    Scenario: Install in local mode for development
        Given I am in the SeeAI repository
        When I run "seeai.sh install main -l --agent auggie --scope user"
        Then the installation should succeed
        And files should be copied from local source
        And the version should be "local-*"

    @conf-13
    Scenario: Install for copilot with custom profile
        Given no SeeAI installations exist
        When I run "seeai.sh install main --agent copilot --scope user"
        And I am prompted for copilot profile
        And I select "2" to enter custom profile
        And I enter profile ID "my-profile"
        Then the installation should succeed
        And files should be installed to custom profile directory
