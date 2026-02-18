---
name: ralph-project-ops
description: Shared patterns for modifying an existing Ralph project environment. Load when adding tasks, pivoting project direction, or revising objectives.
---

# Ralph Project Operations Skill

Load this skill when modifying an existing Ralph environment (add-task, pivot, revise).

## Reading Existing State

Before any modification, read all three files:
1. `prd.json` — note highest task ID, status counts (pending/in-progress/complete/cancelled)
2. `AGENTS.md` — understand current stack, standards, and commands
3. `progress.log` — understand execution history and what has already shipped

## Task ID Assignment

When adding new tasks, continue from the highest existing task ID:
- Find the maximum numeric suffix across all existing task IDs
- New tasks start at max + 1
- Example: if highest is `task-007`, new tasks are `task-008`, `task-009`, ...

## prd.json Task Statuses

Valid statuses and their semantics:

| Status | Meaning |
|--------|---------|
| `pending` | Not started, eligible for Ralph execution |
| `in-progress` | Currently being worked on |
| `complete` | Done, verified, committed |
| `cancelled` | No longer needed — kept for traceability |

**Never delete tasks from prd.json.** Mark them `cancelled` instead. Deletion breaks the correlation between `progress.log` entries and task IDs, and destroys git history traceability.

## Impact Analysis for Changes

When objectives change, categorize affected existing tasks:

- **`pending` tasks** — may be kept, cancelled, or have acceptance criteria revised
- **`in-progress` tasks** — warn the user before modifying; Ralph may be mid-execution
- **`complete` tasks** — if their output is invalidated by the change, create a new corrective task (e.g., `"Revise user model per new authentication requirements"`) rather than un-completing them
- **`cancelled` tasks** — can be re-activated by setting back to `pending` if relevant again

## Progress Log Format for Project Operations

Append to `progress.log` for every project-level change:

```
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] add-task: Added task-XXX "Title" (priority: high, deps: [task-003])
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] pivot: Switched from REST to GraphQL — 4 tasks cancelled, 6 tasks added
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] revise: Updated AGENTS.md security section; revised acceptance criteria for task-005
```

## AGENTS.md Edit Rules

When modifying `AGENTS.md`:
- Edit the relevant section in place — do not regenerate the whole file
- Preserve all sections that were not mentioned by the user
- If a new section is needed, append it rather than inserting it mid-file
- All commands must remain real and runnable — never revert to placeholders
