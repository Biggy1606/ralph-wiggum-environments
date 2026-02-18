---
name: ralph-deep-init
description: Deep project initialization using the Architect-Builder pattern. Use for large projects (20+ tasks, multiple domains) where a single task breakdown would be unwieldy or exceed context limits.
---

# Ralph Deep Init Skill

Load this skill when running `/ralph-deep-init`. Splits initialization across three phases to manage scope and context.

## When to Use

Use deep init instead of standard init when:
- The project has 20+ distinct tasks
- Work spans 4+ independent domains (auth, API, UI, infra, etc.)
- A single `prd.json` would be difficult to reason about in one pass

## Phase 1: Architect

Analyze the full project scope. Identify **exactly 6** distinct functional groups that together cover the entire project without overlap.

Good group examples: Authentication & Authorization, API Layer, Database Schema & Migrations, Frontend UI, DevOps & Deployment, Testing Infrastructure

Create `architecture.json`:

```json
{
  "project": "Project name",
  "description": "What this project builds",
  "groups": [
    {
      "id": "group-001",
      "name": "Authentication & Authorization",
      "description": "User login, JWT, RBAC, session management",
      "estimated_tasks": 6
    },
    {
      "id": "group-002",
      "name": "API Layer",
      "description": "REST endpoints, validation, error handling",
      "estimated_tasks": 8
    }
  ]
}
```

Report: "Architecture defined: [list all 6 groups with estimated task counts]"

## Phase 2: Builders

For each group in `architecture.json`, create a partial task file.

Filename: `prd-partial-{group-id}.json`

```json
{
  "group_id": "group-001",
  "group_name": "Authentication & Authorization",
  "tasks": [
    {
      "id": "task-001",
      "title": "Set up JWT token generation and validation",
      "priority": "high",
      "status": "pending",
      "dependencies": [],
      "acceptance_criteria": [
        "JWT tokens are generated with configurable expiry",
        "Token validation rejects expired and malformed tokens",
        "Unit tests pass for both generation and validation paths"
      ]
    }
  ]
}
```

**Cross-group dependencies:** Use format `group-002/task-005` — these will be resolved in Phase 3.

Create all 6 partial files before proceeding to Phase 3.

## Phase 3: Assembly

1. Read all `prd-partial-*.json` files
2. Merge all `tasks` arrays into a single list
3. Renumber task IDs sequentially: `task-001`, `task-002`, ...
4. Resolve all cross-group dependency references to final sequential task IDs
5. Sort tasks: `high` priority first within dependency constraints
6. Write final `prd.json`
7. Create `AGENTS.md` — use the ralph-init skill structure
8. Create `progress.log` with header
9. Delete all `prd-partial-*.json` files
10. Delete `architecture.json`

Report:

> Deep init complete.
> - `AGENTS.md` — ready
> - `prd.json` — [N] total tasks ([N] high, [N] medium, [N] low priority)
> - `progress.log` — ready
>
> Run `/ralph-loop` to start.
