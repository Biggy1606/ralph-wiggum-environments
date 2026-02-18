---
name: ralph-init
description: Creates AGENTS.md, prd.json, and progress.log to initialize the Ralph environment. Use when setting up a new project for autonomous execution.
---

# Ralph Init Skill

Load this skill when running `/ralph-init`. Creates the three required Ralph files.

## File 1: AGENTS.md

Universal project context file. Must contain real, runnable commands — no placeholders.

Structure:

```markdown
# [Project Name]

## Project Overview
[2-3 sentences: what it does, main architecture, primary users]

## Build & Test Commands
- Build: `[exact command]`
- Test: `[exact command]`
- Lint: `[exact command]`
- Typecheck: `[exact command]`
- Dev server: `[exact command]`

## Technology Stack
- Language: [e.g., TypeScript 5.x]
- Framework: [e.g., Next.js 14]
- Database: [e.g., PostgreSQL 16 via Prisma]
- Testing: [e.g., Vitest + Testing Library]
- Styling: [e.g., Tailwind CSS 3.x]

## Project Structure
- `src/` — Source code
- `src/components/` — UI components
- `src/lib/` — Shared utilities
- `tests/` — Test files (mirrors src/ structure)

## Code Style
- [Specific rules, e.g., "Use Zod for all API input validation"]
- [Naming conventions, e.g., "React components in PascalCase, utilities in camelCase"]
- [File conventions]

## Testing Requirements
- Unit tests required for all business logic
- [Coverage threshold if applicable]
- Integration tests for all API endpoints

## Git Workflow
- Branches: `feature/description`, `fix/description`
- Commits: `type(scope): description` (conventional commits)
- No direct commits to `main`

## Security
- API keys via environment variables only — never hardcoded
- [Other project-specific boundaries]
```

## File 2: prd.json

Complete task breakdown. Be exhaustive. Each task should be 15-60 minutes of work.

```json
{
  "project": "Project Name",
  "description": "What this project builds",
  "tasks": [
    {
      "id": "task-001",
      "title": "Specific, actionable task title",
      "priority": "high",
      "status": "pending",
      "dependencies": [],
      "acceptance_criteria": [
        "Concrete, binary criterion — either it passes or it does not",
        "Another specific, testable criterion"
      ]
    }
  ]
}
```

**Task quality rules:**
- `high` priority: core functionality that blocks other tasks
- `medium` priority: features and functionality
- `low` priority: polish, docs, optional improvements
- Acceptance criteria must be binary (pass/fail), never subjective ("looks good")
- Dependencies must reference real task IDs defined in the same file
- Sequence tasks so that infrastructure comes before features

## File 3: progress.log

```
# Ralph Wiggum Progress Log
# Project: [Project Name]
# Started: [YYYY-MM-DD HH:MM:SS]
```

## Completion

After creating all three files, report:

> Ralph environment initialized.
> - `AGENTS.md` — [N] sections
> - `prd.json` — [N] tasks ([N] high, [N] medium, [N] low priority)
> - `progress.log` — ready
>
> Run `/ralph-loop` to start.
