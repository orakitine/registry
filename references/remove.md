# Remove an Entry from the Registry

## Context
The user wants to remove a skill, agent, or prompt from the registry catalog and optionally delete the local copy.

## Input
The user provides a skill name or description.

## Steps

### 1. **Sync the Registry Repo**
Pull first — do NOT read registry.yaml until this completes.
```bash
git pull
```
After the pull finishes, read `./registry.yaml` and find the entry.
- Example: `git pull` → `Already up to date.` → read ./registry.yaml

### 2. **Find the Entry**
- Search across all sections for the matching entry
- Determine the type (skill, agent, or prompt)
- IF: no match → THEN: tell the user the item wasn't found in the catalog
- Example: "remove old-skill" → found in skills section

### 3. **Confirm with User**
Show the entry details and ask:
- "Remove **<name>** from the registry catalog?"
- IF: installed locally → THEN: also ask: "Also delete the local copy at `<path>`?"
- Example: "Remove **old-skill** from the catalog? Also delete ~/.claude/skills/old-skill/?"

### 4. **Remove from registry.yaml**
- Remove the entry from the appropriate section (`registry.skills`, `registry.agents`, or `registry.prompts`)
- IF: other entries depend on this one (via `requires`) → THEN: warn the user before proceeding
- Example: `browser-review` requires `skill:browser` → warn before removing `browser`

### 5. **Delete Local Copy (if requested)**
- IF: user confirmed local deletion → THEN:
  - Check the default and global directories for the type (from `default_dirs`)
  - Remove the directory or file:
    ```bash
    rm -rf <target_directory>/<name>
    ```
- Example: `rm -rf ~/.claude/skills/old-skill` → deleted

### 6. **Commit and Push**
```bash
git add registry.yaml
git commit -m "registry: removed <type> <name>"
git push
```

### 7. **Confirm**
Tell the user:
- The entry has been removed from the catalog
- Whether the local copy was also deleted
- If other entries depended on it, remind them to update those entries
