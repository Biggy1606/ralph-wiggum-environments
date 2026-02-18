# Ralph Wiggum for Windsurf

> *"I'm helping!"* — Ralph Wiggum

Effective implementation of the Ralph autonomous task executor for Windsurf/Cascade.

## What is Ralph?

Ralph transforms interactive AI coding agents into autonomous workers via a feedback loop with a persistent task list. It provides structure for:

- **Systematic execution** — One task at a time, verified before marking complete
- **Traceability** — All actions logged to `progress.log`
- **Standards compliance** — Follows `AGENTS.md` project context

## Files

### Rules

| File | Purpose |
|------|---------|
| `.windsurf/rules/ralph.md` | Core agent behavior (manual trigger) |

### Skills (Slash Commands)

| File | Command | Purpose |
|------|---------|---------|
| `.windsurf/skills/ralph/SKILL.md` | `/ralph` | Execute autonomous loop |
| `.windsurf/skills/ralph-init/SKILL.md` | `/ralph-init` | Initialize new project |
| `.windsurf/skills/ralph-deep-init/SKILL.md` | `/ralph-deep-init` | Large project initialization |
| `.windsurf/skills/ralph-add-task/SKILL.md` | `/ralph-add-task` | Add task mid-project |
| `.windsurf/skills/ralph-sync/SKILL.md` | `/ralph-sync` | Reconcile changed objectives |
| `.windsurf/skills/ralph-status/SKILL.md` | `/ralph-status` | Show project status |

### Workflows

| File | Purpose |
|------|---------|
| `.windsurf/workflows/ralph-init.md` | Initialization steps |
| `.windsurf/workflows/ralph-loop.md` | Loop execution steps |
| `.windsurf/workflows/ralph-deep-init.md` | Deep init steps |
| `.windsurf/workflows/ralph-add-task.md` | Add task steps |
| `.windsurf/workflows/ralph-sync.md` | Sync steps |
| `.windsurf/workflows/ralph-status.md` | Status display steps |

## Usage

### Initialize Project

```
/ralph-init "Build user authentication with JWT"
```

Creates `AGENTS.md`, `prd.json`, `progress.log`.

### Execute Loop

```
/ralph
```

Runs autonomous loop until all tasks complete.

### Check Status

```
/ralph-status
```

Shows progress, current task, next task, blocked tasks.

### Add Task Mid-Project

```
/ralph-add-task "Add password reset functionality after email system is complete"
```

Inserts new task with proper dependencies.

### Change Objectives

```
/ralph-sync "Switch from REST to GraphQL API, add real-time subscriptions"
```

Reconciles existing project with new requirements.

### Large Projects

```
/ralph-deep-init "Build complete e-commerce platform"
```

Decomposes into 6 functional groups, creates partial task files, assembles into final `prd.json`.

## Key Improvements Over Original

1. **Uses `AGENTS.md`** — Universal standard supported by 20+ AI coding tools (not `RULES.md`)
2. **Detailed workflows** — Complete instructions, not just outlines
3. **Task selection algorithm** — Explicit dependency resolution
4. **Completion criteria** — Clear definition of "done"
5. **Error handling** — Stops after 3 failed verification attempts

## AGENTS.md Sections (Priority Order)

Based on GitHub's analysis of 2,500+ repositories:

1. Build & Test Commands
2. Testing Requirements
3. Project Structure
4. Code Style
5. Git Workflow
6. Security Considerations

## Git Commit Format

```
type(scope): description

Types: feat, fix, refactor, test, docs, chore
```

## References

- [RALPH_IMPLEMENTATION.md](../RALPH_IMPLEMENTATION.md) — Full implementation guide
- [Original Ralph Concept](https://ghuntley.com/ralph/)
