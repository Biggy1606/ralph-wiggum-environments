---
name: /ralph-status
description: Show current Ralph project status. Displays task progress, next actions, and recent activity.
---

# Ralph Project Status

Display current state of the Ralph project.

## Process

### 1. Read Project Files

- `prd.json` — Task list and status
- `progress.log` — Recent activity (last 20 lines)
- `AGENTS.md` — Project context (first 30 lines for overview)

### 2. Calculate Statistics

```text
Total tasks: X
Completed: Y (Z%)
In progress: N
Pending: M
Blocked: B (tasks with unmet dependencies)
Cancelled: C
```

### 3. Identify Next Task

Find highest priority task where:
- `status: "pending"`
- All dependencies have `status: "complete"`

### 4. Generate Report

```text
# Ralph Status: [Project Name]

## Progress
[=========>          ] 45% (9/20 tasks)

## Task Breakdown
- ✅ Complete: 9
- 🔄 In Progress: 1
- ⏳ Pending: 8
- 🚫 Blocked: 1
- ❌ Cancelled: 1

## Current Task
task-010: Implement user dashboard
Priority: high
Status: in-progress
Started: [timestamp from progress.log]

## Next Task
task-011: Add dashboard widgets
Priority: medium
Dependencies: task-010 (in progress)

## Recent Activity
[2026-02-18 10:30:00] Completed task-009: User profile page
[2026-02-18 10:30:05] Git commit: feat(profile): add user profile page
[2026-02-18 10:31:00] Started task-010: Implement user dashboard

## Blocked Tasks
task-015: Integration tests
  └─ Blocked by: task-011 (pending)

## Tech Stack
Framework: Next.js 14
Language: TypeScript
Database: PostgreSQL
```

## No Active Project

If `prd.json` doesn't exist:

```text
No Ralph project found in current directory.

Run '/ralph-init "your project description"' to start.
```

## Completion

This is a read-only operation. No files are modified.
