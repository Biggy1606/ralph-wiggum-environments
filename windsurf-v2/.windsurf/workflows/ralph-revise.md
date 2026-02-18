---
description: Modify AGENTS.md or specific tasks in prd.json to reflect updated or clarified objectives, without changing the overall project direction
---

# Revise Ralph Project

Use this for surgical changes — updating a few tasks, tightening acceptance criteria, adding a constraint to `AGENTS.md`. For direction changes affecting many tasks, use `/ralph-pivot` instead.

## Input

The user describes what needs changing. Examples:
- "The acceptance criteria for task-003 are too vague"
- "Add TypeScript strict mode to AGENTS.md code style"
- "task-007 and task-008 are no longer needed"
- "Switch the testing framework from Jest to Vitest in AGENTS.md"
- "task-004 should also depend on task-006"

If the scope is unclear, ask: "Which file and which section or task should be changed, and what should it say?"

## Pre-flight

Load the `@ralph-project-ops` skill.

Read `AGENTS.md` and `prd.json` before making any edits.

## Steps

### 1 — Identify Scope

Determine what needs to change:
- `AGENTS.md` section(s) only
- Specific task(s) in `prd.json` only
- Both

Do **not** regenerate files from scratch. Make only the edits the user described.

### 2 — Check for Conflicts

Before editing any task in `prd.json`:

- If `status == "in-progress"`: warn the user — Ralph may be mid-execution on this task. Editing acceptance criteria mid-execution may cause confusion. Ask whether to proceed.
- If `status == "complete"`: warn the user — the task has already shipped. Revising its criteria retroactively does not undo the implementation. Offer to add a follow-up corrective task instead of editing the completed one.
- If `status == "cancelled"`: confirm whether the user wants to re-activate it (reset to `"pending"`) or just edit the entry.

### 3 — Apply Changes

**For `AGENTS.md`:** Edit the relevant section in place. Preserve all other sections exactly as-is.

**For `prd.json` tasks:** Edit only the specified fields. Valid fields to revise:

- `title` — if the task description was imprecise
- `acceptance_criteria` — add, remove, or rewrite criteria
- `priority` — change priority level
- `dependencies` — add or remove dependency references
- `status` — only to re-activate a `cancelled` task (set to `"pending"`)

Do **not** change a task's `id`. Do **not** touch tasks not mentioned by the user.

### 4 — Corrective Task (if needed)

If a `complete` task's criteria are being revised in a way that requires re-implementation, append a new corrective task to `prd.json`:

```json
{
  "id": "task-XXX",
  "title": "Revise [component]: [what needs to change]",
  "priority": "high",
  "status": "pending",
  "dependencies": ["task-YYY"],
  "acceptance_criteria": [
    "Updated criterion reflecting the revision"
  ]
}
```

### 5 — Log

Append to `progress.log`:

```
[YYYY-MM-DD HH:MM:SS] [PROJECT-OP] revise: [What was changed and why]
```

### 6 — Report

> Revision complete.
> Changes made:
> - [file/section]: [what changed]
>
> [If corrective task added: "Added task-XXX to implement the revision."]
> [If pending tasks exist: "Run `/ralph-loop` to execute pending tasks."]
