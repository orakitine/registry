---
name: registry
description: Skill registry for distributing skills, agents, and prompts across devices, projects, and teams. Use when the user wants to install, use, add, push, remove, sync, list, or search for skills, agents, or prompts from their registry catalog. Triggers on /registry commands or mentions of registry, skill distribution, or agentic management.
argument-hint: [command or prompt] [name or details]
---

# The Registry

A skill registry for private-first distribution of skills, agents, and prompts across agents, devices, and teams.

## Variables

> Update these after forking and cloning the registry repo.

- **REGISTRY_REPO_URL**: `https://github.com/orakitine/registry.git`
- **REGISTRY_YAML_PATH**: `~/.claude/skills/registry/registry.yaml`
- **REGISTRY_SKILL_DIR**: `~/.claude/skills/registry/`

## How It Works

The Registry is a catalog of references to your skills, agents, and prompts. The `registry.yaml` file points to where they live (local filesystem or GitHub repos). Nothing is fetched until you ask for it.

**The `registry.yaml` is a catalog, not a manifest.** Entries define what's *available* — not what gets installed. You pull specific items on demand with `/registry use <name>`.

## Commands

| Command                      | Purpose                                  |
| ---------------------------- | ---------------------------------------- |
| `/registry install`          | First-time setup: fork, clone, configure |
| `/registry add <details>`    | Register a new entry in the catalog      |
| `/registry use <name>`       | Pull from source (install or refresh)    |
| `/registry push <name>`      | Push local changes back to source        |
| `/registry remove <name>`    | Remove from catalog and optionally local |
| `/registry list`             | Show full catalog with install status    |
| `/registry sync`             | Re-pull all installed items from source  |
| `/registry search <keyword>` | Find entries by keyword                  |

## Cookbook

Each command has a detailed step-by-step guide. **Read the relevant cookbook file before executing a command.**

| Command | Cookbook                                  | Use When                                                     |
| ------- | ---------------------------------------- | ------------------------------------------------------------ |
| install | [cookbook/install.md](cookbook/install.md) | First-time setup on a new device                             |
| add     | [cookbook/add.md](cookbook/add.md)         | User wants to register a new skill/agent/prompt in catalog   |
| use     | [cookbook/use.md](cookbook/use.md)         | User wants to pull or refresh a skill from the catalog       |
| push    | [cookbook/push.md](cookbook/push.md)       | User improved a skill locally and wants to update the source |
| remove  | [cookbook/remove.md](cookbook/remove.md)   | User wants to remove an entry from the catalog               |
| list    | [cookbook/list.md](cookbook/list.md)       | User wants to see what's available and what's installed       |
| sync    | [cookbook/sync.md](cookbook/sync.md)       | User wants to refresh all installed items at once            |
| search  | [cookbook/search.md](cookbook/search.md)   | User is looking for a skill but doesn't know the exact name  |

**When a user invokes a `/registry` command, read the matching cookbook file first, then execute the steps.**

## Source Format

The `source` field in `registry.yaml` supports these formats (auto-detected):

- `/absolute/path/to/SKILL.md` — local filesystem
- `https://github.com/org/repo/blob/main/path/to/SKILL.md` — GitHub browser URL
- `https://raw.githubusercontent.com/org/repo/main/path/to/SKILL.md` — GitHub raw URL

Both GitHub URL formats are supported. Parse org, repo, branch, and file path from the URL structure. For private repos, use SSH or `GITHUB_TOKEN` for auth automatically.

**Important:** The source points to a specific file (SKILL.md, AGENT.md, or prompt file). We always pull the entire parent directory, not just the file.

## Source Parsing Rules

**Local paths** start with `/` or `~`:
- Use the path directly. Copy the parent directory of the referenced file.

**GitHub browser URLs** match `https://github.com/<org>/<repo>/blob/<branch>/<path>`:
- Parse: `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://github.com/<org>/<repo>.git`
- File location within repo: `<path>`

**GitHub raw URLs** match `https://raw.githubusercontent.com/<org>/<repo>/<branch>/<path>`:
- Parse: `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://github.com/<org>/<repo>.git`
- File location within repo: `<path>`

## GitHub Workflow

When working with GitHub sources, prefer `gh api` for accessing single files (e.g., reading a SKILL.md to check metadata). For pulling entire skill directories, clone into a temp dir per the steps below.

**Fetching (use):**
1. Clone the repo with `git clone --depth 1 <clone_url>` into a temporary directory
2. Navigate to the parent directory of the referenced file
3. Copy that entire directory to the target local directory
4. The temporary directory is cleaned up automatically

**Pushing (push):**
1. Clone the repo with `git clone --depth 1 <clone_url>` into a temporary directory
2. Overwrite the skill directory in the clone with the local version
3. Stage only the relevant changes: `git add <skill_directory_path>`
4. Commit with message: `registry: updated <skill name> <what changed>`
5. Push to remote
6. The temporary directory is cleaned up automatically

## Typed Dependencies

The `requires` field uses typed references to avoid ambiguity:
- `skill:name` — references a skill in the registry catalog
- `agent:name` — references an agent in the registry catalog
- `prompt:name` — references a prompt in the registry catalog

When resolving dependencies: look up each reference in `registry.yaml`, fetch all dependencies first (recursively), then fetch the requested item.

## Target Directories

By default, items are installed to the **default** directory from `registry.yaml`:

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
```

- If the user says "global" or "globally", use the `global` directory.
- If the user specifies a custom path, use that path.
- Otherwise, use the `default` directory.

## Registry Repo Sync

The registry skill itself lives in `<REGISTRY_SKILL_DIR>` as a cloned git repo. When running `add` (which modifies `registry.yaml`), always:
1. `git pull` in the registry directory first to get latest
2. Make the changes
3. `git add registry.yaml && git commit && git push`

This keeps the catalog in sync across devices.

## Example Filled Registry File

```yaml
default_dirs:
  skills:
    - default: .claude/skills/
    - global: ~/.claude/skills/
  agents:
    - default: .claude/agents/
    - global: ~/.claude/agents/
  prompts:
    - default: .claude/prompts/
    - global: ~/.claude/prompts/

registry:
  skills:
    - name: firecrawl
      description: Scrape, crawl, and search websites using Firecrawl CLI
      source: /Users/me/projects/tools/skills/firecrawl/SKILL.md

    - name: meta-skill
      description: Creates new Agent Skills following best practices
      source: /Users/me/projects/tools/skills/meta-skill/SKILL.md

    - name: diagram-kroki
      description: Generate diagrams via Kroki HTTP API supporting 28+ languages
      source: https://github.com/myorg/private-skills/blob/main/skills/diagram-kroki/SKILL.md
      requires: [skill:firecrawl]

    - name: green-screen-captions
      description: Generate and burn AI-powered captions onto green screen videos
      source: https://raw.githubusercontent.com/myorg/video-tools/main/skills/green-screen-captions/SKILL.md
      requires: [agent:video-processor, prompt:caption-style]

  agents:
    - name: video-processor
      description: Processes video files with ffmpeg and whisper transcription
      source: /Users/me/projects/tools/agents/video-processor/AGENT.md

    - name: code-reviewer
      description: Reviews code for quality, security, and performance
      source: https://github.com/myorg/agent-configs/blob/main/agents/code-reviewer/AGENT.md

  prompts:
    - name: caption-style
      description: Style guide for generating video captions
      source: /Users/me/projects/content/prompts/caption-style.md

    - name: commit-message
      description: Standardized commit message format for all projects
      source: https://github.com/myorg/team-prompts/blob/main/prompts/commit-message.md
```
