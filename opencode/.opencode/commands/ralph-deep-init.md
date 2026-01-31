---
description: Deep initialization for large projects using Architect-Builder pattern
agent: ralph
---

Execute deep initialization for: $ARGUMENTS

## Phase 1: The Architect

Analyze the request and identify 6 distinct functional groups.

Example groups:
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
  "groups": [
    {
      "id": "group-001",
      "name": "Authentication",
      "description": "User auth with JWT"
    }
  ]
}
```

## Phase 2: The Builders

For each group in architecture.json:

1. Create detailed task breakdown
2. Save to `prd-partial-{group-id}.json`
3. Use same structure as prd.json
4. Ensure valid JSON

## Phase 3: The Assembly

Merge all partial files:

```bash
# Combine all prd-partial-*.json into prd.json
# Validate final JSON
# Create RULES.md
# Create progress.log
```

Report: "Deep init complete. Run '/ralph-loop' to start."
