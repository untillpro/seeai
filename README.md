# SeeAI

Software Engineering, Empowered by AI

## Quick Start

### Install

<details>
<summary>Augment</summary>

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
<summary>Claude</summary>

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
<summary>Copilot</summary>

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

### Run Agent

- cd `you-project-folder`
- Describe you problem, say, in `myproblem.md`:

```markdown
# Tetrust

A Tetris board game implemented in Rust, with simple synthesized sound effects.
```

- For agents like claude and auggie use `@` to tag the problem file:

```text
> /seeai:design @myfeature.md
```

- Start the CLI agent (auggie, claude, copilot)
- For agents like copilot use `#`:

```text
> /seeai:design #myfeature.md
```
