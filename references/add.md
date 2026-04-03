# Add a New Entry to the Registry

## Context
Register a new skill, agent, or prompt in the registry catalog.

## Input
The user provides: name, description, source, and optionally type and dependencies.

## Steps

### 1. **Sync the Registry Repo**
Pull first — do NOT read registry.yaml until this completes.
```bash
git pull
```
Example: `git pull` → `Already up to date.` → proceed to read

### 2. **Determine the Type**
Figure out the type from the user's prompt or the source path:
- IF: source path contains `SKILL.md` or user says "skill" → THEN: type is `skill`
- IF: source path contains `AGENT.md` or user says "agent" → THEN: type is `agent`
- IF: user says "prompt" → THEN: type is `prompt`
- IF: ambiguous → THEN: ask the user
- Example: source ends in `/deploy/SKILL.md` → type is `skill`

### 3. **Validate the Source**
- **Local path**: Verify the file exists at the given path
- **GitHub URL**: Verify the URL is well-formed (matches browser or raw URL patterns from `./references/source-formats.md`)
- Confirm the source points to a specific file, not a directory
- Example: `https://github.com/org/repo/blob/main/skills/deploy/SKILL.md` → valid GitHub browser URL

### 4. **Parse Dependencies**
Detect dependencies by looking through the skill/agent/prompt files:
- Format as typed references: `skill:name`, `agent:name`, `prompt:name`
- Verify each dependency already exists in `./registry.yaml` or warn the user
- IF: dependencies don't exist → THEN: add them to `./registry.yaml` first, recursively
- Detect from frontmatter and file content (look for `/<prompt|agent|skill>:name` references)
- IF: not sure → THEN: ask the user if they have any dependencies
- Example: Skill references `agent:browser-qa` → check registry → found → add to `requires`

### 5. **Add the Entry to registry.yaml**
Read `./registry.yaml`, add the new entry under the correct section:

```yaml
# Under registry.skills, registry.agents, or registry.prompts
- name: <name>
  description: <description>
  source: <source>
  requires: [<typed:refs>]  # omit if no dependencies
```

**YAML formatting rules:**
- 2-space indentation
- List items use `- ` prefix
- Properties are indented under the list item
- Keep entries alphabetically sorted by name within each section
- For skills reference the `.../<skill-name>/SKILL.md` file
- For agents reference the `.../<agent name>.md` file
- For prompts reference the `.../<prompt name>.md` file
- Example: Adding `deploy` skill → insert alphabetically between `doc-cache` and `elevenlabs`

### 6. **Commit and Push**
```bash
git add registry.yaml
git commit -m "registry: added <type> <name>"
git push
```
Example: `git commit -m "registry: added skill deploy"` → pushed

### 7. **Confirm**
Tell the user the entry has been added and is now available via `/registry use <name>`.
