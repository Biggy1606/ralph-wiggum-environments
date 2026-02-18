---
description: Execute the Ralph autonomous loop — works through all pending tasks in prd.json
---

# Execute Ralph Loop

## Pre-flight

Verify these files exist before starting:
- `AGENTS.md` — if missing, run `/ralph-init` first
- `prd.json` — if missing, run `/ralph-init` first
- `progress.log` — create with header if missing

Load the `@ralph` rule and `@ralph-executor` skill.

## Loop

Repeat until no eligible task exists.

### Step 1 — Select Task

Read `prd.json`. Find the first task where:
- `status == "pending"`
- All items in `dependencies[]` have `status == "complete"`
- Sorted by priority: `high` → `medium` → `low`

If no eligible task is found:
- If there are `pending` tasks with incomplete dependencies → report which tasks are blocked and why, then halt
- If all tasks are `complete` → report completion and halt

### Step 2 — Start

Update `prd.json`: set selected task `status` to `"in-progress"`.

Append to `progress.log`:
```
[YYYY-MM-DD HH:MM:SS] Started task-XXX: Task title
```

### Step 3 — Implement

Read all relevant existing files before editing anything.

Implement the task following:
- `AGENTS.md` for coding standards, structure, and conventions
- The task's `acceptance_criteria` as exit conditions
- Never apply workarounds that mask errors

### Step 4 — Verify

Run the test/lint/typecheck command from `AGENTS.md`.

**Pass:** proceed to Step 5.

**Fail:**
1. Read the full error output
2. Identify root cause
3. Apply one targeted fix
4. Re-run verification
5. If still failing:
   - Append to `progress.log`: `[YYYY-MM-DD HH:MM:SS] [ERROR] task-XXX: diagnosis`
   - Report the failure to the user with diagnosis
   - Halt

### Step 5 — Record

Update `prd.json`: set task `status` to `"complete"`.

Append to `progress.log`:
```
[YYYY-MM-DD HH:MM:SS] Completed task-XXX: What was done
```

### Step 6 — Commit

```bash
git add -A
git commit -m "type(scope): description"
```

Append to `progress.log`:
```
[YYYY-MM-DD HH:MM:SS] Git commit: type(scope): message
```

### Step 7 — Repeat

Return to Step 1.

## Completion

When all tasks are `complete`:
> All tasks in prd.json are complete.
