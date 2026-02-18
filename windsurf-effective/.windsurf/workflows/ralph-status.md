---
description: Show current Ralph project status
---

# Status Workflow

Display current project state without modifying any files.

## Steps

1. **Check for project files**:
   - If no `prd.json`: Report "No project found, run /ralph-init"
   - If exists: Continue

2. **Read project data**:
   - `prd.json` for task statistics
   - `progress.log` for recent activity (last 20 lines)
   - `AGENTS.md` for tech stack overview

3. **Calculate statistics**:
   - Total tasks
   - Completed (with percentage)
   - In progress
   - Pending
   - Blocked (pending with unmet dependencies)
   - Cancelled

4. **Identify next task**:
   - Highest priority pending task with all dependencies met

5. **Generate visual report**:
   - Progress bar
   - Task breakdown with emoji indicators
   - Current task details
   - Next task details
   - Recent activity log
   - Blocked tasks with dependency chains
   - Tech stack summary

## Output Format

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
[Details if in-progress]

## Next Task
[Details of next pending task]

## Recent Activity
[Last 5 log entries]

## Blocked Tasks
[Tasks waiting on dependencies]

## Tech Stack
[From AGENTS.md]
```

## Read-Only

This workflow does not modify any files.
