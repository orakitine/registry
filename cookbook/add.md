# Add a New Entry to the Registry

## Context
Register a new skill, agent, or prompt in the registry catalog.

## Input
The user provides: name, description, source, and optionally type and dependencies.

## Steps

### 1. Sync the Registry Repo
**Pull first — do NOT read registry.yaml until this completes.**
```bash
cd <REGISTRY_SKILL_DIR>
git pull
```

### 2. Determine the Type
Figure out the type from the user's prompt or the source path:
- If the source path contains `SKILL.md` or user says "skill" → type is `skill`
- If the source path contains `AGENT.md` or user says "agent" → type is `agent`
- If user says "prompt" → type is `prompt`
- If ambiguous, ask the user

### 3. Validate the Source
- **Local path**: Verify the file exists at the given path
- **GitHub URL**: Verify the URL is well-formed (matches browser or raw URL patterns)
- Confirm the source points to a specific file, not a directory

### 4. Parse Dependencies
Detect dependencies by looking through the skill/agent/prompt files, format them as typed references:
- `skill:name`, `agent:name`, `prompt:name`
- Verify each dependency already exists in `registry.yaml` if or warn the user
  - If they don't exist add them to `registry.yaml` first. If those files have dependencies, add them recursively.
  - You can detect these sometimes by looking at the frontmatter, and then in the file content look for `/<prompt|agent|skill>:name` references. If you're not sure, ask the user the user if they have any dependencies.

### 5. Add the Entry to registry.yaml
Read `registry.yaml`, add the new entry under the correct section:

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
- For skills reference the `.../<skill-name>/SKILL.md` file,
- For agents reference the `.../<agent name>.md` file,
- For prompts reference the `.../<prompt name>.md` file (installed to `.claude/commands/`),
- Remember we'll be adding a absolute path or a github url (https or ssh)

### 6. Commit and Push
```bash
cd <REGISTRY_SKILL_DIR>
git add registry.yaml
git commit -m "registry: added <type> <name>"
git push
```

### 7. Confirm
Tell the user the entry has been added and is now available for others to use via `/registry use <name>`.
