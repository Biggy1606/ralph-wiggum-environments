# Ralph Wiggum for OpenCode

Autonomous coding agent workflow adapted for [OpenCode](https://opencode.ai/).

## Overview

Ralph Wiggum is an autonomous coding workflow that:
1. Initializes a project backlog from a user request
2. Iteratively implements tasks one at a time
3. Verifies each task before moving to the next
4. Commits changes automatically with descriptive messages

This implementation uses **OpenCode CLI** (`opencode run`) for non-interactive execution.

## Prerequisites

- [OpenCode CLI](https://opencode.ai/docs/cli/) installed and configured
- `jq` for JSON processing
- Git repository initialized

## Files

- **`ralph_init.sh`** - Initialize the Ralph environment and create task backlog
- **`ralph.sh`** - Main autonomous loop that executes tasks
- **`prd.json`** - Product Requirements Document with task backlog (auto-generated)
- **`RULES.md`** - Tech stack and coding conventions (auto-generated)
- **`progress.txt`** - Progress log (auto-generated)

## Usage

### 1. Initialize

```bash
./ralph_init.sh "Your project request here"
```

Or run interactively:

```bash
./ralph_init.sh
```

This will:
- Analyze your project structure
- Create `prd.json` with a task backlog
- Create `RULES.md` with detected tech stack
- Create `progress.txt` for tracking

### 2. Run the Loop

```bash
./ralph.sh
```

Options:
- `./ralph.sh` - Auto-detect number of tasks and run all
- `./ralph.sh 5` - Run exactly 5 iterations
- `./ralph.sh --dry-run` - Preview without executing

### 3. Monitor Progress

Ralph will:
- Pick the highest priority incomplete task
- Implement the code
- Run tests/verification
- Update `prd.json` and `progress.txt`
- Commit with message: `Ralph: [Task Description]`
- Continue to next task

## Key Differences from AMP Version

| Feature | AMP | OpenCode |
|---------|-----|----------|
| Command | `amp --execute --stream-json` | `opencode run` |
| Session tracking | `amp_thread_id` | `opencode_session_id` |
| Output format | JSON stream with JQ filtering | Direct terminal output |
| Context passing | Thread references `@@thread_id` | Session continuation `--session` |
| Flags | `--dangerously-allow-all --mode smart` | Standard `opencode run` flags |

## Configuration

The scripts use these OpenCode CLI features:
- `opencode run` - Non-interactive execution
- `--session` - Continue previous session
- `--format json` - JSON output for parsing (in ralph.sh)

## PRD Schema

```json
{
  "project_meta": {
    "name": "project_name",
    "version": "version",
    "ralph_type": "opencode",
    "opencode_session_id": "session_id"
  },
  "backlog": [
    {
      "id": 1,
      "feature": "feature_name",
      "description": "detailed_description",
      "acceptance_criteria": ["criterion_1", "criterion_2"],
      "passes": false
    }
  ]
}
```

## Exit Conditions

Ralph looks for these signals in OpenCode output:
- `<promise>TASK_COMPLETE</promise>` - Single task done, continue to next
- `<promise>ALL_COMPLETE</promise>` - All tasks done, exit successfully

## Troubleshooting

**OpenCode not found:**
```bash
# Install OpenCode
curl -fsSL https://opencode.ai/install.sh | sh
```

**Authentication issues:**
```bash
# Configure API keys
opencode auth login
```

**Session not continuing:**
- Check that `opencode_session_id` is being captured correctly
- Verify OpenCode session management with `opencode session list`

**Tasks not being marked complete:**
- Ensure OpenCode agent outputs the `<promise>` tags
- Check `prd.json` is being updated correctly

## Best Practices

1. **Small tasks**: Break work into granular, testable units
2. **Clear acceptance criteria**: Define what "done" means for each task
3. **Monitor first run**: Use `--dry-run` to preview before executing
4. **Review commits**: Ralph commits automatically - review git log regularly
5. **Update RULES.md**: Keep tech stack documentation current

## License

MIT
