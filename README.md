# The Registry

A skill registry for private-first distribution of skills, agents, and prompts across devices, projects, and teams.

## What It Is

The Registry is a single skill whose only job is to manage other skills. It's a catalog of references — local file paths and GitHub repo URLs — that point to where your skills, agents, and prompts live. Nothing is copied or installed until you ask for it.

Think of it as a `package.json` for agent capabilities — but instead of packages, you're managing skills, agents, and prompts. Instead of a registry like npm, you're pointing at your own GitHub repos and local paths.

**This is a pure agent application.** No scripts, no CLIs, no dependencies, no build tools. The entire application is encoded in `SKILL.md` and a set of cookbook instructions that teach the agent what to do. The agent IS the runtime.

## Why It Exists

As you build with AI agents, you accumulate skills, custom agents, and prompts across multiple repos and machines. You need to:

- **Reuse** them across projects without copy-pasting
- **Distribute** them to agents running on other devices
- **Share** them with your team without making everything public
- **Keep them private** — these are specialized capabilities
- **Stay in sync** — one source of truth, not stale copies everywhere

## How It Works

### The Catalog (`registry.yaml`)

```yaml
default_dirs:
  skills:
    - default: .claude/skills/
    - global: ~/.claude/skills/
  agents:
    - default: .claude/agents/
    - global: ~/.claude/agents/
  prompts:
    - default: .claude/commands/
    - global: ~/.claude/commands/

registry:
  skills:
    - name: my-skill
      description: What this skill does
      source: /Users/me/projects/tools/skills/my-skill/SKILL.md
      requires: [agent:helper-agent]
    - name: remote-skill
      description: A skill from a private repo
      source: https://github.com/myorg/private-skills/blob/main/skills/remote-skill/SKILL.md
  agents: []
  prompts: []
```

The catalog stores pointers, not copies. Skills live in their source repos. You pull on demand.

### Source Formats

| Format             | Example                                                            |
| ------------------ | ------------------------------------------------------------------ |
| Local filesystem   | `/absolute/path/to/SKILL.md`                                       |
| GitHub browser URL | `https://github.com/org/repo/blob/main/path/to/SKILL.md`           |
| GitHub raw URL     | `https://raw.githubusercontent.com/org/repo/main/path/to/SKILL.md` |

The source points to a specific file. The system pulls the entire parent directory (skills include scripts, references, assets — not just the markdown file).

For private repos, authentication uses SSH keys or `GITHUB_TOKEN` automatically.

### Typed Dependencies

Dependencies use typed references to avoid name collisions:

```yaml
requires: [skill:base-utils, agent:reviewer, prompt:task-router]
```

Dependencies are resolved and pulled first, recursively.

## Prerequisites

- **Claude Code** (or a compatible agent harness that reads `.claude/skills/`)
- **git** — for cloning sources and syncing the catalog
- **gh** (optional) — GitHub CLI for private repo access. Install: `brew install gh`
- **GitHub SSH key or `GITHUB_TOKEN`** — for private repos (not needed if using `gh auth login`)
- **just** (optional) — for justfile shortcuts. Install: `brew install just`

## Installation

### 1. Clone to Global Skills Directory

Clone into `~/.claude/skills/registry`. This path makes `/registry` available as a global slash command in Claude Code.

```bash
mkdir -p ~/.claude/skills
git clone <your-repo-url> ~/.claude/skills/registry
```

### 2. Configure

Open `~/.claude/skills/registry/SKILL.md` and update the `## Variables` section with your repo URL.

```markdown
- **REGISTRY_REPO_URL**: `https://github.com/yourname/the-registry.git`
```

### 3. Verify

Start a new Claude Code session anywhere. `/registry list` should work and show an empty catalog.

## Quick Start

Typical workflow: **build → catalog → distribute → use**.

### Add a skill to the catalog

```
/registry add deploy skill from https://github.com/yourorg/infra-tools/blob/main/skills/deploy/SKILL.md
```

### Use it in another project

```
/registry use deploy
```

Want it globally available on this machine?

```
/registry use deploy install globally
```

### Push changes back

```
/registry push deploy
```

### Sync everything

```
/registry sync
```

## Commands

| Command                       | What It Does                                               |
| ----------------------------- | ---------------------------------------------------------- |
| `/registry install`           | First-time setup — clone, configure                        |
| `/registry add <details>`     | Register a new entry in the catalog                        |
| `/registry use <name>`        | Pull from source into local directory (install or refresh) |
| `/registry push <name>`       | Push local changes back to the source                      |
| `/registry remove <name>`     | Remove from catalog and optionally delete local copy       |
| `/registry list`              | Show full catalog with install status                      |
| `/registry sync`              | Re-pull all installed items from source                    |
| `/registry search <keyword>`  | Find entries by name or description                        |

### Justfile Shortcuts

```bash
just list                  # List catalog
just use my-skill          # Pull a skill
just push my-skill         # Push changes back
just add "name: foo, description: bar, source: /path/to/SKILL.md"
just sync                  # Re-pull all installed items
just search "keyword"
```

> **Note:** Justfile recipes use `--dangerously-skip-permissions` because the agent needs filesystem and git access to clone, copy, and push.

## Architecture

```
~/.claude/skills/registry/        # The Registry skill (globally installed)
    SKILL.md                       # Agent instructions — the brain
    registry.yaml                  # Your catalog of references
    cookbook/                       # Step-by-step guides for each command
        install.md
        add.md
        use.md
        push.md
        remove.md
        list.md
        sync.md
        search.md
    justfile                       # CLI shorthand for all commands
    README.md                      # This file
```

## Design Principles

- **Private-first**: Built for your specialized skills. Not a public marketplace.
- **Reference-based**: The catalog stores pointers, not copies. Skills live in their source repos.
- **Pure agent**: No scripts, no build tools. The SKILL.md teaches the agent everything.
- **Agent-agnostic**: Default target is `.claude/skills/` but supports any directory for any agent harness.
- **Catalog, not manifest**: Entries define what's available, not what's installed. Pull on demand.

## Credits

Based on [The Library](https://github.com/disler/the-library) by [IndyDevDan](https://github.com/disler).
