---
name: ralph-executor
description: Detailed Ralph execution guidance. Load when running the Ralph autonomous loop to get step-by-step implementation protocol.
---

# Ralph Executor Skill

Supplements the Ralph rule with detailed execution protocol. Load this skill when running `/ralph-loop`.

## Pre-Execution Checklist

Before starting any task, verify:
- `AGENTS.md` exists and contains build/test commands
- `prd.json` exists with at least one `pending` task
- `progress.log` exists — if missing, create it:
  ```
  # Ralph Wiggum Progress Log
  # Started: [YYYY-MM-DD HH:MM:SS]
  ```

## Implementing a Task

1. Read the task's `acceptance_criteria` — these are your binary exit conditions
2. Verify all `dependencies` have `status == "complete"` in `prd.json`
3. Read all relevant existing files before making any edits
4. Apply changes incrementally — one logical change at a time
5. Run the verification command from `AGENTS.md` after each significant change

## prd.json Status Transitions

When starting a task:
```json
{ "id": "task-XXX", "status": "in-progress" }
```

When completing a task:
```json
{ "id": "task-XXX", "status": "complete" }
```

Only transition to `complete` after verification passes.

## Verification Protocol

Run the test/typecheck/lint command from `AGENTS.md`.

**If it passes:**
- Update `prd.json` → `"complete"`
- Append completion entry to `progress.log`
- Create git commit

**If it fails:**
1. Read the full error output — do not skim
2. Identify root cause, not just the error message location
3. Apply one targeted fix
4. Re-run verification
5. If still failing: append `[ERROR]` to `progress.log`, halt, report to user

## Writing to progress.log

Always **append** (never overwrite). Use exact format:

```
[2026-01-30 14:22:05] Started task-001: Implement user model
[2026-01-30 14:35:12] Completed task-001: User entity with bcrypt hashing, all tests pass
[2026-01-30 14:35:30] Git commit: feat(auth): implement user model with password hashing
[2026-01-30 14:36:00] [ERROR] task-002: TypeScript type mismatch in auth middleware — halted
```

## Quality Rules

From Arize Research (10-15% SWE-bench improvement):

- Never modify code without first reading and understanding it
- Never apply a workaround that hides an error from the compiler or test runner
- Do not delete or weaken existing tests to make CI pass
- Backwards compatibility is assumed unless the task explicitly states otherwise
- Commit messages must explain WHAT changed, not HOW it was changed
- Error messages must remain technically accurate — never swallow exceptions silently
