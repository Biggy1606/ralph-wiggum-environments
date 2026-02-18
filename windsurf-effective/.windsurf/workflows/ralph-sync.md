---
description: Reconcile project with changed objectives
---

# Sync Workflow

Reconcile existing project with new or changed requirements.

## Steps

### Phase 1: Analyze

1. Read `AGENTS.md`, `prd.json`, `progress.log`
2. Parse new objectives from user input
3. Identify what's changed:
   - New features
   - Removed features
   - Tech stack changes
   - Priority shifts

### Phase 2: Diff

Generate change plan:

| Change Type | Action |
|-------------|--------|
| New feature | Add tasks |
| Removed feature | Cancel tasks |
| Tech stack change | Update AGENTS.md + add migration tasks |
| Priority shift | Update priority fields |

### Phase 3: Execute

1. **Update AGENTS.md** if tech stack or standards changed
2. **Update prd.json**:
   - Add new tasks (status: "pending")
   - Cancel obsolete tasks (status: "cancelled")
   - Modify existing tasks if scope changed
   - Preserve all completed tasks
3. **Log sync event** to progress.log

### Phase 4: Report

Summary of changes made.

## Handling Edge Cases

- **In-progress task now cancelled**: Mark cancelled, note in log, preserve work
- **Completed task conflicts with new direction**: Keep completed, add new "refactor" or "remove" task
- **Dependency chain broken**: Rebuild dependencies for affected tasks
