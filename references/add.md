# Add a New Entry to the Registry

## Context
Register a new skill, agent, prompt, output style, or config in the registry catalog.

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
- IF: source path contains `output-styles/` or user says "output style" → THEN: type is `output-style`
- IF: user says "config" or "statusline", or the source is a non-markdown dotfile destined for `~/.claude/` → THEN: type is `config`
- IF: ambiguous → THEN: ask the user
- Example: source ends in `/deploy/SKILL.md` → type is `skill`
- Example: source ends in `/output-styles/skippy.md` → type is `output-style`

### 3. **Validate the Source**
- **Local path**: Verify the file exists at the given path
- **GitHub URL**: Verify the URL is well-formed (matches browser or raw URL patterns from `./references/source-formats.md`)
- Confirm the source points to a specific file, not a directory
- Example: `https://github.com/org/repo/blob/main/skills/deploy/SKILL.md` → valid GitHub browser URL

### 4. **Parse Dependencies**
Detect dependencies by reading the skill/agent/prompt body content:
- Format as typed references: `skill:name`, `agent:name`, `prompt:name`, `output-style:name`, `config:name`
- Verify each dependency already exists in `./registry.yaml` or warn the user
- IF: dependencies don't exist → THEN: add them to `./registry.yaml` first, recursively
- Detect from body text: look for skill/agent references in Skills sections, workflow steps, and `context: fork` / `agent:` frontmatter wiring
- Do NOT rely on a `skills:` frontmatter field — dependencies are declared in `registry.yaml` only
- IF: not sure → THEN: ask the user if they have any dependencies
- Example: Agent body has `## Skills` listing `browser` → check registry → found → add `requires: [skill:browser]`

### 5. **Add the Entry to registry.yaml**
Read `./registry.yaml`, add the new entry under the correct section:

```yaml
# Under registry.skills, registry.agents, registry.prompts,
# registry.output-styles, or registry.configs
- name: <name>
  description: <description>
  source: <source>
  requires: [<typed:refs>]  # omit if no dependencies
  settings:                 # omit unless the asset needs settings.json activation
    <settings.json keys to merge on install>
```

**YAML formatting rules:**
- 2-space indentation
- List items use `- ` prefix
- Properties are indented under the list item
- Keep entries alphabetically sorted by name within each section
- For skills reference the `.../<skill-name>/SKILL.md` file
- For agents reference the `.../<agent name>.md` file
- For prompts reference the `.../<prompt name>.md` file
- For output styles reference the `.../output-styles/<style name>.md` file
- For configs reference the config file itself (its basename is preserved on install)
- Example: Adding `deploy` skill → insert alphabetically between `doc-cache` and `elevenlabs`

**The `settings:` field** (output styles and configs, mostly): if activating the asset requires `settings.json` keys — an output style's `outputStyle`, a statusline's `statusLine` — capture them here so `use` can merge them automatically (see **Settings Merge Workflow** in `./references/source-formats.md`). Values must be machine-portable: `~`-based paths, never `/Users/<name>/...`. Ask the user for the activation wiring if the asset plausibly needs one and none was given.

### 6. **Commit and Push**
```bash
git add registry.yaml
git commit -m "registry: added <type> <name>"
git push
```
Example: `git commit -m "registry: added skill deploy"` → pushed

### 7. **Confirm**
Tell the user the entry has been added and is now available via `/registry use <name>`.
