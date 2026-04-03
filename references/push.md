# Push a Skill to the Source

## Context
The user has improved a skill locally and wants to push changes back to the source.

## Input
The user provides a skill name or description.

## Steps

### 1. **Sync the Registry Repo**
Pull first — do NOT read registry.yaml until this completes.
```bash
git pull
```
After the pull finishes, read `./registry.yaml`.
- Example: `git pull` → `Already up to date.` → read ./registry.yaml

### 2. **Find the Entry**
- Search across all sections for the matching entry
- IF: no match → THEN: tell the user the item wasn't found in the catalog
- Example: "push browser" → found `browser` in skills section

### 3. **Locate the Local Copy**
- Check the default directory for the type (from `default_dirs`)
- Check the global directory
- IF: found in multiple places → THEN: ask which one to push
- IF: not found locally → THEN: tell the user there's nothing to push
- Example: Found at `~/.claude/skills/browser/` → proceed

### 4. **Check for Conflicts**
- IF: local source → THEN: compare the local installed copy with the source. If the source has been modified since last pull, warn: "The source has changes that aren't in your local copy. Pushing will overwrite them. Continue?"
- IF: GitHub source → THEN: clone the repo to a temp dir (shallow), compare the skill directory. If they differ AND the remote has changes not in the local copy, warn about conflict and ask the user to resolve.
- Example: Diff shows 3 files changed in remote → warn user

### 5. **Push to Source**
Follow the **Push Workflow** in `./references/source-formats.md` for the entry's source type (local or GitHub).
- Example: GitHub source → clone, overwrite, commit, push, clean up

### 6. **Confirm**
Tell the user:
- What was pushed and where
- The commit message used
- If it was a local path push, confirm the overwrite
