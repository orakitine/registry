# The Registry

## What This Is

A skill registry — a pure-agent application (no scripts, no CLIs) that manages distribution of Claude Code skills, agents, and prompts across devices, projects, and teams. Forked from [disler/the-library](https://github.com/disler/the-library), renamed and rebranded.

- **Repo**: https://github.com/orakitine/registry.git
- **Install location**: `~/.claude/skills/registry/`
- **Slash command**: `/registry`

## Architecture

- `SKILL.md` — the brain, teaches Claude how to execute registry commands
- `registry.yaml` — the catalog of pointers (NOT copies) to skills/agents/prompts
- `cookbook/*.md` — step-by-step recipes for each command (add, use, push, sync, etc.)
- `justfile` — terminal shortcuts for non-interactive use

## Key Design Decisions

- **"Registry" not "Library"** — because it registers where things live, it doesn't hold them. The name was chosen deliberately for LLM semantic clarity.
- **`registry.yaml` not JSON** — this is for agents, not humans. YAML is fine.
- **Source repos are the source of truth** — the registry just stores pointers. Skills live in their source repos (e.g., `engineering-toolbox`). Push writes back to source, use/sync reads from source.
- **Lab stays separate** — `claude-code-lab` is a workbench for experimentation. Proven skills get "graduated" to a dedicated toolbox repo, and the registry points at the toolbox, never at the lab.

## Companion Repos (Planned)

- **engineering-toolbox** — dedicated repo for graduated, stable, reusable skills
- Potentially more specialized repos (e.g., deploy/infra skills)

## Multi-Device Setup

Oleg runs 2 laptops + 1 Linux box. The registry syncs across them via git push/pull on this repo. Skills are fetched from their source repos on demand.

## Editing Guidelines

- All files are markdown — edit markdown, not code
- When renaming concepts, update: SKILL.md, registry.yaml, all cookbook files, justfile, README.md
- Keep the credits line for Dan in README.md
