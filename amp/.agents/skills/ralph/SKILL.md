---
name: ralph
description: Autonomous task executor following the Ralph loop pattern. Use when you need to execute tasks from prd.json following RULES.md with progress logging.
---

# Ralph Skill

Execute the Ralph autonomous loop:

1. **Analyze** - Read RULES.md, prd.json, progress.log
2. **Select** - Choose highest priority incomplete task
3. **Execute** - Implement the task
4. **Verify** - Run tests/typechecks
5. **Record** - Update prd.json, append to progress.log
6. **Commit** - Git commit with conventional format
7. **Repeat** - Continue to next task

## Task Selection

- Always pick the highest priority task that:
  - Has status "pending"
  - Has all dependencies completed
- Only work on ONE task at a time

## Completion Criteria

A task is complete when:
- All acceptance criteria are met
- Tests pass (if applicable)
- Code compiles without errors

## Progress Log Format

```
[YYYY-MM-DD HH:MM:SS] Started task-XXX: Description
[YYYY-MM-DD HH:MM:SS] Completed task-XXX: Summary
[YYYY-MM-DD HH:MM:SS] Git commit: type(scope): message
```
