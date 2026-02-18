---
description: Initialize Ralph environment with AGENTS.md and prd.json
---

# Initialize Ralph Environment

**User request:** $ARGUMENTS

Create the Ralph Wiggum autonomous loop environment.

## Files to Create

### 1. AGENTS.md — Project Context

Include these sections in priority order:

- **Project Overview** — Brief description of architecture and purpose
- **Build & Test Commands** — Exact commands agents will run
- **Technology Stack** — Framework, language, database
- **Project Structure** — Directory layout, where things live
- **Code Style** — Language-specific patterns, linter config
- **Testing Requirements** — Framework, coverage thresholds
- **Git Workflow** — Branch naming, PR conventions, commit format
- **Security Considerations** — What NOT to do, API key patterns

### 2. prd.json — Task Breakdown

```json
{
  "project": "Project Name",
  "description": "Project overview",
  "tasks": [
    {
      "id": "task-001",
      "title": "Task description",
      "priority": "high|medium|low",
      "status": "pending",
      "dependencies": [],
      "acceptance_criteria": [
        "Criterion 1",
        "Criterion 2"
      ]
    }
  ]
}
```

- Break down the user request into complete task list
- Set proper priorities (high for blockers, medium for features, low for nice-to-have)
- Define clear acceptance criteria for each task
- Set up dependency chains where needed

### 3. progress.log — Execution Log

```
# Ralph Wiggum Progress Log
# Started: [current timestamp]
```

## Completion

Report: "Ralph environment initialized. Run '/ralph-loop' to start autonomous execution."
