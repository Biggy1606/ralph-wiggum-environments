---
description: Execute the Ralph autonomous loop
---

# Execute Ralph Loop

Execute the Ralph autonomous loop until all tasks are complete or an error occurs.

## Loop Steps

1. **Analyze** — Read AGENTS.md for project context, prd.json for task list, progress.log for history
2. **Select** — Choose highest priority task with status "pending" and all dependencies complete
3. **Execute** — Implement the task following standards in AGENTS.md
4. **Verify** — Run tests/typechecks specified in AGENTS.md to confirm correctness
5. **Record** — Update prd.json status to "complete", append execution details to progress.log
6. **Commit** — Git commit with conventional format: `type(scope): description`
7. **Repeat** — Return to step 1 for next task

## Stopping Conditions

- All tasks in prd.json have status "complete"
- Verification fails after 3 attempts (report error and stop)
- User interrupts execution

## Progress Logging

After each task completion, append to progress.log:

```
[YYYY-MM-DD HH:MM:SS] Started task-XXX: Description
[YYYY-MM-DD HH:MM:SS] Completed task-XXX: Summary
[YYYY-MM-DD HH:MM:SS] Git commit: type(scope): message
```

## Final Report

When all tasks complete, report:

```
All tasks in prd.json are complete.

Summary:
- Tasks completed: X
- Commits made: X
- Files modified: X
- Tests passing: Yes/No
```
