# Search the Registry

## Context
Find entries in the catalog by keyword when the user doesn't remember the exact name.

## Input
The user provides a keyword or description.

## Steps

### 1. Sync the Registry Repo, then Read the Catalog
**These steps are sequential — do NOT read the file until the pull completes.**

```bash
cd <REGISTRY_SKILL_DIR>
git pull
```

After the pull finishes, read `registry.yaml` and parse all entries from `registry.skills`, `registry.agents`, and `registry.prompts`.

### 3. Search
- Match the keyword (case-insensitive) against:
  - Entry `name`
  - Entry `description`
- A match is any entry where the keyword appears as a substring in either field
- Collect all matches across all types

### 4. Display Results

If matches found, format as:

```
## Search Results for "<keyword>"

| Type | Name | Description | Source |
|------|------|-------------|--------|
| skill | matching-skill | description... | source... |
| agent | matching-agent | description... | source... |
```

If no matches:
```
No results found for "<keyword>".

Tip: Try broader keywords or run `/registry list` to see the full catalog.
```

### 5. Suggest Next Step
If matches were found, suggest: `Run /registry use <name> to install one of these.`
