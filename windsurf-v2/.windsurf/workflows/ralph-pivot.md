---
description: Change the project direction — updates AGENTS.md and prd.json to reflect new objectives, cancelling obsolete tasks and adding new ones
---

# Pivot Ralph Project

## Input

The user describes the new direction. If unclear, ask:
> "What is changing? Describe the new direction and what is no longer needed."

## Pre-flight

Read `AGENTS.md`, `prd.json`, `progress.log`.

Load the `@ralph-project-ops` skill.

Before proceeding, summarize current state to the user:
> - [N] tasks complete, [N] pending, [N] in-progress, [N] cancelled
> - Current stack: [from AGENTS.md Technology Stack section]
> - Proceeding with pivot to: [new direction]

If any task has `status == "in-progress"`: **warn the user** that Ralph may be mid-execution and ask them to confirm before continuing.

## Steps

### 1 — Assess Impact

Read all `pending` and `in-progress` tasks. For each, decide:

- **Keep** — still relevant under the new direction, no criteria changes needed
- **Cancel** — no longer needed
- **Revise** — still needed but acceptance criteria or scope must change

For `complete` tasks: if the new direction invalidates their output, do **not** un-complete them. Instead, add a new corrective task (e.g., `"Migrate user model from REST to GraphQL schema"`).

Present the impact assessment to the user and confirm before making changes.

### 2 — Update AGENTS.md

Apply surgical edits — only modify sections that are affected by the new direction:

- **Technology Stack** — update if tooling changed
- **Build & Test Commands** — update if commands changed
- **Code Style** — update if standards changed
- **Project Structure** — update if directory layout changed
- **Security** — update if new boundaries apply

Do not rewrite sections that were not affected. Do not remove sections unless they are entirely irrelevant to the new direction.

### 3 — Update prd.json

In one edit pass:

1. Set all cancelled tasks to `"status": "cancelled"` — do **not** delete them
2. Update revised tasks: edit `acceptance_criteria` and/or `title` in place; do not change their `id`
3. Add new tasks using the next available sequential IDs (continuing from the highest existing ID)
4. Set correct `dependencies` for new tasks, referencing existing task IDs where applicable

### 4 — Log

Append to `progress.log`:

```
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] pivot: [Brief description of what changed]
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] pivot: N tasks cancelled, N tasks revised, N tasks added — N total pending
```

### 5 — Report

> Pivot complete.
> - `AGENTS.md` — [list of sections updated]
> - `prd.json` — [N] cancelled, [N] revised, [N] new tasks added
> - Pending tasks remaining: [N]
>
> Run `/ralph-loop` to continue.
