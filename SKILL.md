---
name: registry
description: >-
  Skill registry for distributing skills, agents, and prompts across devices,
  projects, and teams. Use when installing, distributing, syncing, or managing
  skills from a catalog.
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

A catalog-based distribution system for skills, agents, and prompts. The `./registry.yaml` stores pointers (local paths and GitHub URLs) to where assets live. Nothing is fetched until you ask for it. Pull specific items on demand.

## Variables

REGISTRY_REPO_URL: https://github.com/orakitine/registry.git   # Remote URL for the registry repo

## Workflow

1. **Parse Command**
   - Determine which subcommand from `$ARGUMENTS`
   - IF: "install" → THEN: first-time setup
   - IF: "add" → THEN: register a new entry
   - IF: "use" → THEN: pull from source
   - IF: "push" → THEN: push local changes back
   - IF: "remove" → THEN: remove from catalog
   - IF: "list" → THEN: show catalog with install status
   - IF: "sync" → THEN: re-pull all installed items
   - IF: "search" → THEN: find by keyword
   - Example: "/registry use browser globally" → Route to use reference, name=browser, target=global

2. **Route to Reference**
   - Read the matching reference file, then execute its steps
   - Each reference handles its own catalog read (after git pull)
   - For source format details, references delegate to `./references/source-formats.md`
   - Example: "use" → Read and execute `./references/use.md`
   - Tool: Read

## References

### Install (First-Time Setup)

- IF: User wants to set up the registry on a new device
- THEN: Read and execute `./references/install.md`
- EXAMPLES:
  - "/registry install"

### Add Entry

- IF: User wants to register a new skill, agent, or prompt in the catalog
- THEN: Read and execute `./references/add.md`
- EXAMPLES:
  - "/registry add deploy skill from https://github.com/org/repo/blob/main/skills/deploy/SKILL.md"
  - "/registry add browser-qa agent from ~/Documents/toolbox/agents/browser-qa.md"

### Use (Pull from Source)

- IF: User wants to pull or refresh a skill from the catalog
- THEN: Read and execute `./references/use.md`
- EXAMPLES:
  - "/registry use browser"
  - "/registry use browser-qa globally"

### Push (Local to Source)

- IF: User improved a skill locally and wants to update the source
- THEN: Read and execute `./references/push.md`
- EXAMPLES:
  - "/registry push browser"

### Remove

- IF: User wants to remove an entry from the catalog
- THEN: Read and execute `./references/remove.md`
- EXAMPLES:
  - "/registry remove old-skill"

### List

- IF: User wants to see the full catalog with install status
- THEN: Read and execute `./references/list.md`
- EXAMPLES:
  - "/registry list"

### Sync (Re-Pull All)

- IF: User wants to refresh all installed items from their sources
- THEN: Read and execute `./references/sync.md`
- EXAMPLES:
  - "/registry sync"

### Search

- IF: User is looking for a skill but doesn't know the exact name
- THEN: Read and execute `./references/search.md`
- EXAMPLES:
  - "/registry search browser"
  - "/registry search QA"
