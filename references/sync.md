# Sync All Installed Items

## Context
Refresh every locally installed skill, agent, prompt, output style, and config by re-pulling from its source. A fast "make sure everything is up to date" command.

## Steps

### 1. **Sync the Registry Repo**
Pull first — do NOT read registry.yaml until this completes.
```bash
git pull
```
After the pull finishes, read `./registry.yaml` and parse all entries.
- Example: `git pull` → `Already up to date.` → read ./registry.yaml

### 2. **Find All Installed Items**
For each entry in the catalog:
- Determine the type and corresponding directories from `default_dirs`
- Check if a directory/file matching the entry name exists in the **default** directory
- Check if a directory/file matching the entry name exists in the **global** directory
- For **configs**, match by the source file's basename (e.g. `statusline` → `statusline.sh`); for output-styles, `<name>.md`
- Search recursively for name matches
- Collect every entry that is installed locally (either default or global)
- IF: nothing is installed → THEN: tell the user and exit
- Example: Found 8 skills installed globally, 2 agents installed globally → proceed

### 3. **Re-pull Each Installed Item**
For each installed entry, follow the **Fetch Workflow** in `./references/source-formats.md` for that entry's source type (local or GitHub). Pull to the same location where it's currently installed.
- Example: `browser` installed at `~/.claude/skills/browser/` → re-fetch to same path

After re-pulling, IF the entry has a `settings:` field → THEN: re-run the **Settings Merge Workflow** in `./references/source-formats.md` for the install scope. A refreshed asset may ship changed wiring; the merge is idempotent, so re-running it on unchanged wiring is a safe no-op.

### 4. **Resolve Dependencies**
For each installed entry that has a `requires` field:
- Check if each dependency is also installed
- IF: a dependency is not installed → THEN: pull it as well
- Process dependencies before the items that require them
- Example: `browser-review` requires `skill:browser` → already installed → skip

### 5. **Report Results**
Display a summary table:

```
## Sync Complete

| Type | Name | Status |
|------|------|--------|
| skill | browser | refreshed |
| agent | browser-qa | refreshed |
| skill | doc-cache | failed: clone error |

Synced: X items
Failed: Y items
```

If any items failed (e.g., network error, missing source), list them with the reason.
