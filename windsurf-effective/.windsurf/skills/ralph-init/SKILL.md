---
name: /ralph-init
description: Initialize Ralph environment. Creates AGENTS.md, prd.json, progress.log from a project description.
---

# Initialize Ralph Environment

You are initializing the Ralph Wiggum autonomous loop environment.

**Task:** Create initial project files based on: $ARGUMENTS

## Files to Create

### 1. AGENTS.md — Project Context

Include these sections in priority order:

```markdown
# Project Name

## Project Overview
Brief description of architecture and purpose

## Build & Test Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Technology Stack
- Framework: [e.g., Next.js 14]
- Language: [e.g., TypeScript]
- Database: [e.g., PostgreSQL]

## Project Structure
- `src/` - Source code
- `tests/` - Test files

## Code Style
- [Standard 1]
- [Standard 2]

## Testing Requirements
- [Requirement 1]
- [Requirement 2]

## Git Workflow
- Branch strategy
- Commit format

## Security Considerations
- API key handling patterns
- What NOT to do with sensitive data
```

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

```text
# Ralph Wiggum Progress Log
# Started: [current timestamp]
```

## Completion

Report: "Ralph environment initialized. Run '/ralph' to start autonomous execution."
