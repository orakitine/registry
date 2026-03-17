---
name: registry
description: Skill registry for distributing skills, agents, and prompts across devices, projects, and teams. Use when installing, distributing, syncing, or managing skills from a catalog.
argument-hint: "[command] [name or details]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---

# Purpose

A catalog-based distribution system for skills, agents, and prompts. The `registry.yaml` stores pointers (local paths and GitHub URLs) to where assets live. Nothing is fetched until you ask for it. Pull specific items on demand.

## Variables

REGISTRY_REPO_URL: https://github.com/orakitine/registry.git          # Remote URL for the registry repo
REGISTRY_YAML_PATH: ${CLAUDE_SKILL_DIR}/registry.yaml                  # Path to the catalog file
REGISTRY_SKILL_DIR: ${CLAUDE_SKILL_DIR}                                # Where the registry skill is installed

## Workflow

1. **Parse Command**
   - Determine which subcommand from `$ARGUMENTS`
   - IF: "install" → first-time setup
   - IF: "add" → register a new entry
   - IF: "use" → pull from source
   - IF: "push" → push local changes back
   - IF: "remove" → remove from catalog
   - IF: "list" → show catalog with install status
   - IF: "sync" → re-pull all installed items
   - IF: "search" → find by keyword
   - Example: "/registry use browser globally" → use command, name=browser, target=global
   - Example: "/registry add deploy skill from https://github.com/..." → add command

2. **Read the Catalog**
   - Read `${CLAUDE_SKILL_DIR}/registry.yaml` for current entries and `default_dirs`
   - For source format details, see `${CLAUDE_SKILL_DIR}/reference/source-formats.md`
   - Example: Catalog has 5 skills, 2 agents → ready to route
   - Tool: Read

3. **Route to Cookbook**
   - Read the matching cookbook file, then execute its steps
   - Example: "use" → read and execute `${CLAUDE_SKILL_DIR}/cookbook/use.md`
   - Tool: Read

## Cookbook

### Install (First-Time Setup)

- IF: User wants to set up the registry on a new device
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/install.md`
- EXAMPLES:
  - "/registry install"

### Add Entry

- IF: User wants to register a new skill, agent, or prompt in the catalog
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/add.md`
- EXAMPLES:
  - "/registry add deploy skill from https://github.com/org/repo/blob/main/skills/deploy/SKILL.md"
  - "/registry add browser-qa agent from ~/Documents/toolbox/agents/browser-qa.md"

### Use (Pull from Source)

- IF: User wants to pull or refresh a skill from the catalog
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/use.md`
- EXAMPLES:
  - "/registry use browser"
  - "/registry use browser-qa globally"

### Push (Local → Source)

- IF: User improved a skill locally and wants to update the source
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/push.md`
- EXAMPLES:
  - "/registry push browser"

### Remove

- IF: User wants to remove an entry from the catalog
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/remove.md`
- EXAMPLES:
  - "/registry remove old-skill"

### List

- IF: User wants to see the full catalog with install status
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/list.md`
- EXAMPLES:
  - "/registry list"

### Sync (Re-Pull All)

- IF: User wants to refresh all installed items from their sources
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/sync.md`
- EXAMPLES:
  - "/registry sync"

### Search

- IF: User is looking for a skill but doesn't know the exact name
- THEN: Read and execute `${CLAUDE_SKILL_DIR}/cookbook/search.md`
- EXAMPLES:
  - "/registry search browser"
  - "/registry search QA"
