# Install The Registry

## Context
First-time setup of The Registry on a new device. The user either has the repo cloned directly, or has already forked it to their own repo.

## Steps

### 1. **Check Prerequisites**
- Verify `git` is installed: `git --version`
- Verify the global skills directory exists or can be created: `~/.claude/skills/`
- Example: `git --version` → `git version 2.43.0` → ready to proceed

### 2. **Determine Fork Status**
Ask the user: **"Is this the template repo or your own fork?"**

- IF: template repo (hasn't forked yet) → THEN: Instruct the user to create a fork on GitHub, then update the remote:
  ```bash
  git remote set-url origin <fork_url>
  ```
  Verify with: `git remote -v`
- IF: already forked → THEN: Skip — the remote already points to their fork
- Example: User says "my fork" → skip to step 3

### 3. **Clone to Global Skills Directory**
- IF: repo isn't already cloned locally → THEN: Clone it:
  ```bash
  mkdir -p ~/.claude/skills
  git clone <fork_url> ~/.claude/skills/registry
  ```
- IF: already cloned (e.g., user cloned the template first) → THEN: just update the remote per step 2
- Example: `ls ~/.claude/skills/registry/SKILL.md` → file exists → already cloned

### 4. **Update Variables**
- Open `./SKILL.md` in the registry directory
- Update the `## Variables` section:
  - **REGISTRY_REPO_URL**: Set to the user's fork URL (used for git sync operations)
- Example: `REGISTRY_REPO_URL: https://github.com/jsmith/registry.git`

### 5. **Verify Installation**
- Confirm `./SKILL.md` exists
- Confirm `./registry.yaml` exists
- Confirm the `/registry` command is now available
- Example: Read ./SKILL.md → frontmatter has `name: registry` → verified

### 6. **Done**
Tell the user:
- The Registry is now globally available
- `/registry list` will show the catalog
- `/registry add` to start adding skills, agents, and prompts
- The `justfile` in the registry directory has shorthand commands
