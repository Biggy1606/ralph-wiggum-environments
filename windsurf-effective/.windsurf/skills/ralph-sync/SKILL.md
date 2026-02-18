---
name: /ralph-sync
description: Reconcile project with changed objectives. Updates AGENTS.md and prd.json when requirements shift.
---

# Sync Ralph Project with New Objectives

Reconcile existing project with changed or expanded requirements.

**New/changed objectives:** $ARGUMENTS

## Process

### 1. Analyze Current State

Read all project files:
- `AGENTS.md` — Current tech stack, standards, structure
- `prd.json` — Current task list and completion status
- `progress.log` — What's been done so far

### 2. Analyze New Objectives

Parse `$ARGUMENTS` to identify:
- New features to add
- Features to remove/replace
- Tech stack changes (e.g., "switch from REST to GraphQL")
- Priority shifts

### 3. Generate Diff

Compare current state vs new objectives:

| Change Type | Action |
|-------------|--------|
| New feature | Add new tasks to `prd.json` |
| Removed feature | Mark obsolete tasks as `status: "cancelled"` |
| Tech stack change | Update `AGENTS.md`, add migration tasks |
| Priority shift | Update `priority` fields in `prd.json` |

### 4. Update AGENTS.md

If tech stack or standards changed:

```markdown
## Technology Stack
- Framework: [updated]
- Language: [updated]
- Database: [updated]

## Build & Test Commands
- Build: [updated command]
- Test: [updated command]
```

### 5. Update prd.json

```json
{
  "project": "Project Name",
  "description": "Updated description",
  "tasks": [
    // Existing tasks (preserve completion status)
    // New tasks (status: "pending")
    // Cancelled tasks (status: "cancelled")
  ]
}
```

### 6. Log the Sync

Append to `progress.log`:

```text
[YYYY-MM-DD HH:MM:SS] === SYNC EVENT ===
[YYYY-MM-DD HH:MM:SS] New objectives: [summary]
[YYYY-MM-DD HH:MM:SS] Tasks added: X
[YYYY-MM-DD HH:MM:SS] Tasks cancelled: Y
[YYYY-MM-DD HH:MM:SS] AGENTS.md updated: [yes/no]
[YYYY-MM-DD HH:MM:SS] ==================
```

## Handling In-Progress Work

If a task is `status: "in-progress"` but now cancelled:
- Mark as `status: "cancelled"`
- Add note to progress.log about incomplete work
- Do NOT delete the work — preserve for potential reuse

## Completion

Report:

```text
Sync complete.

Changes:
- Tasks added: X
- Tasks cancelled: Y
- Tasks modified: Z
- AGENTS.md updated: [sections changed]

Next: Run '/ralph' to continue with updated objectives.
```
