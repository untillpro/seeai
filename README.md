# SeeAI (/siː aɪ/)

Software Engineering, Empowered by AI

## Quick Start

### Install

Run a command for the agent you want to install SeeAI for. You will be prompted before applying any changes.

<details>
<summary>auggie</summary>

Latest stable release:
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install --agent auggie
```

Main branch (unstable):
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main --agent auggie
```

</details>

<details>
<summary>claude</summary>

Latest stable release:
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install --agent claude
```

Main branch (unstable):
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install main --agent claude
```

</details>

<details>
<summary>copilot</summary>

Latest stable release:
```bash
curl -fsSL https://raw.githubusercontent.com/untillpro/seeai/main/scripts/seeai.sh | bash -s install --agent copilot
```

Main branch (unstable):
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
- Describe you problem. E.g.:

```bash
$ cat > myproblem.md << 'EOF'
# Tetrust

A Tetris board game implemented in Rust, with simple synthesized sound effects.
EOF
```

- Start the CLI agent (auggie, claude, copilot)
- For agents like claude and auggie use `@` to tag the problem file:

```text
> /seeai:design @myfeature.md
```

- For agents like copilot use `#`:

```text
> /seeai:design #myfeature.md
```

- As a result you will the `myproblem-design.md file`
- Review the design, apply changes, if needed
- Ask you agent to implement the design
