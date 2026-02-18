---
description: Add a new task to an existing Ralph project
---

# Add Task Workflow

Add a new task to `prd.json` without disrupting current execution.

## Steps

1. **Parse task description** from user input
2. **Read `prd.json`** to understand existing structure and find next available ID
3. **Determine priority**:
   - high: blocks other work, critical path
   - medium: core functionality
   - low: nice-to-have
4. **Identify dependencies**:
   - Check for keywords: "after", "requires", "based on"
   - Check if any existing tasks should depend on this new one
5. **Generate acceptance criteria** based on task description
6. **Insert task** into `prd.json` with proper structure
7. **Log change** to `progress.log`

## Output

```json
{
  "id": "task-XXX",
  "title": "Task description",
  "priority": "high|medium|low",
  "status": "pending",
  "dependencies": [],
  "acceptance_criteria": []
}
```

## Log Entry

```text
[YYYY-MM-DD HH:MM:SS] Added task-XXX: Description
```
