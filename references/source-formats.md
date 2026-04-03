# Source Formats, Fetching & Pushing

Shared procedures for resolving source URLs and executing fetch/push operations across all registry commands.

## Source Format

The `source` field in `registry.yaml` supports these formats (auto-detected):

- `/absolute/path/to/SKILL.md` — local filesystem
- `https://github.com/org/repo/blob/main/path/to/SKILL.md` — GitHub browser URL
- `https://raw.githubusercontent.com/org/repo/main/path/to/SKILL.md` — GitHub raw URL

**Important:** The source points to a specific file (SKILL.md, agent .md, or prompt file). Always pull the entire parent directory for skills, or just the file for agents/prompts.

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

## Fetch Workflow

This is the shared procedure for pulling an asset from its source to a target directory. Both `use` and `sync` references delegate here.

### Local Source (path starts with `/` or `~`)

1. Resolve `~` to the home directory
2. Get the parent directory of the referenced file
3. Copy based on type:
   - **Skills**: copy the entire parent directory
     ```bash
     cp -R <parent_directory>/ <target_directory>/<name>/
     ```
   - **Agents**: copy just the agent file
     ```bash
     cp <agent_file> <target_directory>/<agent_name>.md
     ```
   - **Prompts**: copy just the prompt file
     ```bash
     cp <prompt_file> <target_directory>/<prompt_name>.md
     ```
4. If the agent or prompt is nested in a subdirectory, copy the subdirectory to the target as well

### GitHub Source

1. Parse the URL to extract: `org`, `repo`, `branch`, `file_path`
   - Browser URL: `https://github.com/<org>/<repo>/blob/<branch>/<path>`
   - Raw URL: `https://raw.githubusercontent.com/<org>/<repo>/<branch>/<path>`
2. Clone URL: `https://github.com/<org>/<repo>.git`
3. Parent directory path within the repo: everything before the filename
4. Clone into a temporary directory:
   ```bash
   tmp_dir=$(mktemp -d)
   git clone --depth 1 --branch <branch> https://github.com/<org>/<repo>.git "$tmp_dir"
   ```
5. Copy based on type:
   - **Skills**: copy the parent directory of the file
     ```bash
     cp -R "$tmp_dir/<parent_path>/" <target_directory>/<name>/
     ```
   - **Agents**: copy just the file
     ```bash
     cp "$tmp_dir/<file_path>" <target_directory>/<agent_name>.md
     ```
   - **Prompts**: copy just the file
     ```bash
     cp "$tmp_dir/<file_path>" <target_directory>/<prompt_name>.md
     ```
6. Clean up:
   ```bash
   rm -rf "$tmp_dir"
   ```

**If clone fails (private repo)**, try SSH:
```bash
git clone --depth 1 --branch <branch> git@github.com:<org>/<repo>.git "$tmp_dir"
```

## Push Workflow

Shared procedure for pushing local changes back to a source.

### Local Source

- Copy the entire local directory to the source location, overwriting:
  ```bash
  cp -R <local_directory>/ <source_parent_directory>/
  ```

### GitHub Source

1. Clone the repo to a temp dir (shallow):
   ```bash
   tmp_dir=$(mktemp -d)
   git clone --depth 1 --branch <branch> <clone_url> "$tmp_dir"
   ```
2. Remove the old skill directory in the clone:
   ```bash
   rm -rf "$tmp_dir/<skill_path_in_repo>"
   ```
3. Copy the local version into the clone:
   ```bash
   cp -R <local_directory>/ "$tmp_dir/<skill_path_in_repo>/"
   ```
4. Stage only the relevant changes:
   ```bash
   cd "$tmp_dir"
   git add <skill_path_in_repo>
   ```
5. Commit:
   ```bash
   git commit -m "registry: updated <name> <brief description>"
   ```
6. Push and clean up:
   ```bash
   git push
   rm -rf "$tmp_dir"
   ```

## Typed Dependencies

The `requires` field uses typed references:
- `skill:name` — references a skill in the catalog
- `agent:name` — references an agent in the catalog
- `prompt:name` — references a prompt in the catalog

Resolve recursively: pull all dependencies before the requested item.

## Target Directories

Read `default_dirs` from `./registry.yaml`:
- If user says "global" or "globally" → use the `global` path
- If user specifies a custom path → use that
- Otherwise → use `default` path

## Registry Repo Sync

The registry skill is a git repo. When modifying `registry.yaml` (add/remove):
1. `git pull` first
2. Make changes
3. `git add registry.yaml && git commit && git push`
