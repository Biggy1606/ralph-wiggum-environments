---
description: Deep initialization for large projects using Architect-Builder pattern
---

# Deep Initialization (Architect-Builder)

**User request:** $ARGUMENTS

For large projects that exceed token limits, use the Architect-Builder pattern to decompose into manageable pieces.

## Phase 1: The Architect

Analyze the request and identify 6 distinct functional groups.

Example groups for a web application:
- Authentication & Authorization
- API Layer
- Database Schema
- Frontend UI
- DevOps & Deployment
- Testing Infrastructure

Create `architecture.json`:

```json
{
  "project": "Project name",
  "description": "High-level project description",
  "groups": [
    {
      "id": "group-001",
      "name": "Authentication",
      "description": "User authentication with JWT",
      "dependencies": []
    },
    {
      "id": "group-002",
      "name": "API Layer",
      "description": "RESTful API endpoints",
      "dependencies": ["group-001"]
    }
  ]
}
```

## Phase 2: The Builders

For each group in architecture.json:

1. Create detailed task breakdown for that group only
2. Save to `prd-partial-{group-id}.json`
3. Use same structure as prd.json
4. Ensure valid JSON

Each partial file:

```json
{
  "group_id": "group-001",
  "group_name": "Authentication",
  "tasks": [
    {
      "id": "task-001",
      "title": "Set up JWT library",
      "priority": "high",
      "status": "pending",
      "dependencies": [],
      "acceptance_criteria": ["JWT library installed", "Basic token generation works"]
    }
  ]
}
```

## Phase 3: The Assembly

Merge all partial files into final deliverables:

1. Combine all `prd-partial-*.json` into `prd.json`
   - Preserve task IDs (prefix with group ID if needed)
   - Resolve cross-group dependencies
   - Validate final JSON structure

2. Create `AGENTS.md` with:
   - Technology stack for entire project
   - Build/test commands
   - Code style standards
   - Project structure

3. Create `progress.log` with header:
   ```
   # Ralph Wiggum Progress Log
   # Started: [timestamp]
   # Mode: Deep Init (6 groups)
   ```

## Completion

Report:

```
Deep init complete.

Created:
- architecture.json (6 functional groups)
- prd-partial-group-001.json through prd-partial-group-006.json
- prd.json (merged, X total tasks)
- AGENTS.md
- progress.log

Run '/ralph-loop' to start autonomous execution.
```
