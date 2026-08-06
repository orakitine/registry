# Use a Skill from the Registry

## Context
Pull a skill, agent, prompt, output style, or config from the catalog into the local environment. If already installed locally, overwrite with the latest from the source (refresh).

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
- Search across `registry.skills`, `registry.agents`, `registry.prompts`, `registry.output-styles`, and `registry.configs`
- Match by name (exact) or description (fuzzy/keyword match)
- IF: multiple matches → THEN: show them and ask the user to pick one
- IF: no match → THEN: tell the user and suggest `/registry search`
- Example: "browser" → exact match on `browser` skill

### 3. **Resolve Dependencies**
- IF: entry has a `requires` field → THEN: for each typed reference (`skill:name`, `agent:name`, `prompt:name`, `output-style:name`, `config:name`):
  - Look it up in `./registry.yaml`
  - IF: found → THEN: recursively run the `use` workflow for that dependency first
  - IF: not found → THEN: warn: "Dependency <ref> not found in registry catalog"
- Process all dependencies before the requested item
- Example: `browser-review` requires `[skill:browser, agent:browser-qa]` → pull both first

### 4. **Determine Target Directory**
- Read `default_dirs` from `./registry.yaml`
- IF: user said "global" or "globally" → THEN: use the `global` path
- IF: user specified a custom path → THEN: use that path
- OTHERWISE: use the `default` path
- Select the correct section based on type (skills/agents/prompts/output-styles/configs)
- Example: "use browser globally" → target is `~/.claude/skills/`
- Example: "use statusline globally" → type is config → target is `~/.claude/`

### 5. **Fetch from Source**
Follow the **Fetch Workflow** in `./references/source-formats.md` for the entry's source type (local or GitHub).
- Example: GitHub source → clone, copy parent dir, clean up

### 6. **Merge Settings Fragment**
- IF: the entry has a `settings:` field → THEN: run the **Settings Merge Workflow** in `./references/source-formats.md` for the chosen install scope (global → `~/.claude/settings.json`, project → `.claude/settings.json`)
- Example: `statusline` has `settings.statusLine` → merge into `~/.claude/settings.json`, preserving all other keys

### 7. **Verify Installation**
- Confirm the target directory exists
- Confirm the main file (SKILL.md, agent .md, prompt file, output-style .md, or the config's own basename) exists in it
- IF: settings were merged → THEN: confirm the settings file now carries the entry's keys
- Example: `ls ~/.claude/skills/browser/SKILL.md` → exists → success
- Example: `ls ~/.claude/statusline.sh` → exists, `statusLine` present in settings → success

### 8. **Confirm**
Tell the user:
- What was installed and where
- Which settings keys were merged (with old → new values), or "settings already up to date"
- Any dependencies that were also installed
- If this was a refresh (overwrite), mention that
