# Search the Registry

## Context
Find entries in the catalog by keyword when the user doesn't remember the exact name.

## Input
The user provides a keyword or description.

## Steps

### 1. **Sync the Registry Repo**
Pull first — do NOT read registry.yaml until this completes.
```bash
git pull
```
After the pull finishes, read `./registry.yaml` and parse all entries.
- Example: `git pull` → `Already up to date.` → read ./registry.yaml

### 2. **Search**
- Match the keyword (case-insensitive) against entry `name` and `description`
- A match is any entry where the keyword appears as a substring in either field
- Collect all matches across all types
- Example: "browser" → matches `browser`, `browser-review`, `browser-workflow`, `browser-operator`, `browser-qa`

### 3. **Display Results**
- IF: matches found → THEN: format as:
  ```
  ## Search Results for "<keyword>"

  | Type | Name | Description | Source |
  |------|------|-------------|--------|
  | skill | browser | Headless browser automation... | github.com/... |
  | agent | browser-qa | UI validation agent... | github.com/... |
  ```
- IF: no matches → THEN:
  ```
  No results found for "<keyword>".

  Tip: Try broader keywords or run `/registry list` to see the full catalog.
  ```

### 4. **Suggest Next Step**
- IF: matches were found → THEN: suggest `Run /registry use <name> to install one of these.`
- Example: "Found 3 results → Run `/registry use browser` to install"
