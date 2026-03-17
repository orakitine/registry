# Source Formats & Parsing Reference

Reference material for how the registry resolves source URLs and handles fetching/pushing. Loaded by cookbooks on demand.

## Source Format

The `source` field in `registry.yaml` supports these formats (auto-detected):

- `/absolute/path/to/SKILL.md` — local filesystem
- `https://github.com/org/repo/blob/main/path/to/SKILL.md` — GitHub browser URL
- `https://raw.githubusercontent.com/org/repo/main/path/to/SKILL.md` — GitHub raw URL

**Important:** The source points to a specific file (SKILL.md, AGENT.md, or prompt file). Always pull the entire parent directory, not just the file.

## Source Parsing Rules

**Local paths** start with `/` or `~`:
- Use the path directly. Copy the parent directory of the referenced file.

**GitHub browser URLs** match `https://github.com/<org>/<repo>/blob/<branch>/<path>`:
- Parse: `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://github.com/<org>/<repo>.git`
- File location within repo: `<path>`

**GitHub raw URLs** match `https://raw.githubusercontent.com/<org>/<repo>/<branch>/<path>`:
- Parse: `org`, `repo`, `branch`, `file_path`
- Clone URL: `https://github.com/<org>/<repo>.git`
- File location within repo: `<path>`

## GitHub Workflow

Prefer `gh api` for accessing single files. For pulling entire skill directories, clone into a temp dir.

**Fetching:**
1. Clone: `git clone --depth 1 --branch <branch> <clone_url> "$tmp_dir"`
2. Copy parent directory of the file to target
3. Clean up: `rm -rf "$tmp_dir"`

**If clone fails (private repo)**, try SSH:
```bash
git clone --depth 1 --branch <branch> git@github.com:<org>/<repo>.git "$tmp_dir"
```

**Pushing:**
1. Clone the repo into a temp dir
2. Overwrite the skill directory with local version
3. `git add <skill_directory_path>`
4. `git commit -m "registry: updated <skill name> <what changed>"`
5. `git push`
6. Clean up temp dir

## Typed Dependencies

The `requires` field uses typed references:
- `skill:name` — references a skill in the catalog
- `agent:name` — references an agent in the catalog
- `prompt:name` — references a prompt in the catalog

Resolve recursively: pull all dependencies before the requested item.

## Target Directories

Read `default_dirs` from `registry.yaml`:
- If user says "global" or "globally" → use the `global` path
- If user specifies a custom path → use that
- Otherwise → use `default` path

## Registry Repo Sync

The registry skill is a git repo. When modifying `registry.yaml` (add/remove):
1. `git pull` first
2. Make changes
3. `git add registry.yaml && git commit && git push`
