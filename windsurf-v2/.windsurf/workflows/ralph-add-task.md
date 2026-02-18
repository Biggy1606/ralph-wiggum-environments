---
description: Add one or more new tasks to an existing prd.json without affecting existing tasks or completed work
---

# Add Task to Ralph Project

## Input

The user describes the new task(s) to add. If unclear, ask:
> "What new work item should be added? Describe what needs to be done, and mention any existing tasks it depends on."

## Pre-flight

Verify `prd.json` and `AGENTS.md` exist. If missing, run `/ralph-init` first.

Load the `@ralph-project-ops` skill.

## Steps

### 1 — Read Current State

Read `prd.json` and identify:
- The highest existing task ID (to determine the next sequential ID)
- All existing task titles (to avoid duplicating work already captured)
- Any `in-progress` tasks (note them — the user should know Ralph is mid-execution)

### 2 — Compose New Task(s)

For each new task the user described:
- Assign the next sequential task ID (continuing from the highest existing ID)
- Infer priority:
  - `high` — blocks other work or is core functionality
  - `medium` — a feature or independent improvement
  - `low` — polish, documentation, or optional
- Identify dependencies on **existing** task IDs where applicable
- Write acceptance criteria that are binary (pass/fail) — never subjective

Before writing, confirm the task scope with the user if any ambiguity exists.

### 3 — Update prd.json

Append the new task(s) to the `tasks` array. Do **not** modify any existing task entries.

```json
{
  "id": "task-XXX",
  "title": "Specific, actionable title",
  "priority": "high|medium|low",
  "status": "pending",
  "dependencies": ["task-YYY"],
  "acceptance_criteria": [
    "Binary, testable criterion",
    "Another binary criterion"
  ]
}
```

### 4 — Log

Append to `progress.log` for each added task:

```
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] add-task: Added task-XXX "Title" (priority: X, deps: [Y])
```

### 5 — Report

> Added [N] task(s) to prd.json:
> - `task-XXX`: "Title" (priority: X, deps: [Y])
>
> Total pending tasks: [N]. Run `/ralph-loop` to execute.
