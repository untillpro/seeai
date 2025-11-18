# 👀SeeAI (/siː aɪ/)

Software Engineering, Empowered by AI

An extremely lightweight framework for AI-powered software design and implementation.

## Quick Start

### Prerequisites

- Bash
- Git

Windows: install [Git for Windows](https://git-scm.com/download/win) to get both Git and Git Bash.

### Install

Run the command below for your preferred AI agent. You'll be prompted before any changes are applied.

<details>
<summary>auggie</summary>

Main branch:
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main --agent auggie
```

</details>

<details>
<summary>claude</summary>

Main branch:
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main --agent claude
```

</details>

<details>
<summary>copilot</summary>

Main branch:
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main --agent copilot
```

</details>

### List installed files

```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s list
```

### Describe your problem in a written form

- cd `<your-project-folder>`
- Prepare a description. E.g.:

```bash
$ cat > myproblem.md << 'EOF'
# Tetrust

A Tetris board game implemented in Rust, with simple synthesized sound effects.
EOF
```

### Design the solution

- Start the CLI agent (auggie, claude, copilot)
- Invoke the design command with your problem file tagged (`@` for claude/auggie, `#` for copilot):

```text
> /seeai:design @myfeature.md

or

> /seeai:design #myfeature.md
```

- As a result you will get the `myproblem-design.md` file
- Now see AI, 👀 the design, apply changes, if needed

### Implement the solution

- Ask your agent to implement the design
- Run and see 👀, provide feedback to AI
- Iterate until satisfied
- Happy vibecoding! 🚀
