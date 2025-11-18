# 👀SeeAI (/siː aɪ/)

Software Engineering, Empowered by AI

A lightweight framework for AI-powered software design and implementation.

## Quick Start

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

### Design and implement a solution for your problem

- cd `<your-project-folder>`
- Describe your problem. E.g.:

```bash
$ cat > myproblem.md << 'EOF'
# Tetrust

A Tetris board game implemented in Rust, with simple synthesized sound effects.
EOF
```

- Start the CLI agent (auggie, claude, copilot)
- Invoke the design command with your problem file tagged (`@` for claude/auggie, `#` for copilot):

```text
> /seeai:design @myfeature.md

or

> /seeai:design #myfeature.md
```

- As a result you will get the `myproblem-design.md` file
- Now see AI, 👀 the design, apply changes, if needed
- Ask your agent to implement the design
