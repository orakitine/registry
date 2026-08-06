# List Available Skills

## Context
Show the full registry catalog with install status.

## Steps

### 1. **Sync the Registry Repo**
Pull first — do NOT read registry.yaml until this completes.
```bash
git pull
```
After the pull finishes, read `./registry.yaml` and parse all entries from `registry.skills`, `registry.agents`, `registry.prompts`, `registry.output-styles`, and `registry.configs`.
- Example: `git pull` → `Already up to date.` → read ./registry.yaml

### 2. **Check Install Status**
For each entry:
- Determine the type and corresponding default/global directories from `default_dirs`
- Check if a directory matching the entry name exists in the **default** directory
- Check if a directory matching the entry name exists in the **global** directory
- Search recursively for name matches
- For single-file types: an agent/prompt/output-style installs as `<name>.md`; a **config** installs under its source file's basename (e.g. `statusline` → `statusline.sh`) — check for that file, not a directory
- Mark as: `installed (default)`, `installed (global)`, or `not installed`
- Example: `browser` exists at `~/.claude/skills/browser/` → `installed (global)`
- Example: `statusline` → `~/.claude/statusline.sh` exists → `installed (global)`

### 3. **Display Results**
Format the output as a table grouped by type:

```
## Skills
| Name | Description | Source | Status |
|------|-------------|--------|--------|
| browser | Headless browser automation... | github.com/... | installed (global) |
| doc-cache | Transparent read-through... | github.com/... | not installed |

## Agents
| Name | Description | Source | Status |
|------|-------------|--------|--------|
| browser-qa | UI validation agent... | github.com/... | installed (global) |

## Prompts
| Name | Description | Source | Status |
|------|-------------|--------|--------|

## Output Styles
| Name | Description | Source | Status |
|------|-------------|--------|--------|
| skippy | Skippy the Magnificent persona... | github.com/... | installed (global) |

## Configs
| Name | Description | Source | Status |
|------|-------------|--------|--------|
| statusline | Status line script... | github.com/... | installed (global) |
```

- IF: a section is empty → THEN: show `No <type> in catalog.`

### 4. **Summary**
At the bottom, show:
- Total entries in catalog
- Total installed locally
- Total not installed
- Example: `12 entries | 8 installed | 4 not installed`
