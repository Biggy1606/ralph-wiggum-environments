---
name: /ralph-add-task
description: Add a new task to an existing Ralph project. Use when requirements change during execution.
---

# Add Task to Ralph Project

Add a new task to the existing `prd.json` without disrupting current execution.

**Task to add:** $ARGUMENTS

## Process

1. **Read current state** — Load `prd.json` to understand existing tasks and structure
2. **Analyze new task** — Determine:
   - Priority level (high/medium/low)
   - Dependencies on existing tasks
   - Which tasks depend on this new one
3. **Generate task ID** — Use next available ID (e.g., `task-007` if last is `task-006`)
4. **Insert into prd.json** — Add task with proper structure:

```json
{
  "id": "task-XXX",
  "title": "Task description from $ARGUMENTS",
  "priority": "high|medium|low",
  "status": "pending",
  "dependencies": ["task-YYY"],
  "acceptance_criteria": [
    "Criterion 1",
    "Criterion 2"
  ]
}
```

5. **Update dependencies** — If existing tasks should depend on this new one, update their `dependencies` arrays
6. **Log the change** — Append to `progress.log`:

```text
[YYYY-MM-DD HH:MM:SS] Added task-XXX: Task description
[YYYY-MM-DD HH:MM:SS] Dependencies: [list of dependencies]
```

## Priority Assignment

- **high** — Blocks other tasks, critical path, security-related
- **medium** — Core functionality, user-facing features
- **low** — Nice-to-have, optimization, documentation

## Dependency Detection

Look for keywords in task description:
- "after X" → depends on X
- "before X" → X depends on this
- "requires X" → depends on X
- "based on X" → depends on X

## Completion

Report:

```text
Added task-XXX: [title]
Priority: [high/medium/low]
Dependencies: [list or "none"]
Dependents: [tasks that now depend on this, or "none"]

Run '/ralph' to continue execution with updated task list.
```
