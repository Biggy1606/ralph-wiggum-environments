# Ralph Wiggum for OpenCode

Autonomous coding agent that incrementally implements features from a PRD backlog.

## Prerequisites

- OpenCode CLI
- `jq` JSON processor
- Bash shell

## Setup

```bash
chmod +x ralph_init.sh ralph_deep_init.sh ralph.sh
```

## Usage

### Initialize

**Standard init** (for small projects):

```bash
./ralph_init.sh "Create a new React project"
```

**Deep init** (for large projects - generates 8-12 groups, 5-10 tasks each):

```bash
./ralph_deep_init.sh "Build a full-stack e-commerce platform"
```

Both scripts accept `--dry-run` flag to preview without executing.

**Files created:**

- `prd.json` - Task backlog
- `RULES.md` - Tech stack and conventions
- `progress.txt` - Progress log

### Run Ralph

```bash
./ralph.sh          # Auto-detect remaining tasks (default)
./ralph.sh 3        # Run 3 iterations
./ralph.sh --dry-run
```

## Workflow

For each task:

1. **Analyze**: Read RULES.md
2. **Select**: Pick highest-priority uncompleted task
3. **Execute**: Implement the task
4. **Verify**: Run tests/type-checks
5. **Record**: Update prd.json and progress.txt
6. **Commit**: `git commit --no-gpg-sign -am "Ralph: [Task]"`

## Configuration

Default model: `deepseek/deepseek-chat` (ralph.sh) or `deepseek/deepseek-reasoner` (ralph_init.sh, ralph_deep_init.sh)

Change in scripts:

```bash
OPENCODE_MODEL="opencode/your-model"
```
