---
description: Deep initialize Ralph for large projects using the Architect-Builder pattern
---

# Deep Initialize Ralph Environment

Use this when the project is too large for a single task breakdown (20+ tasks, multiple domains).

## Input

The user provides a project description. If none given, ask:
> "What would you like to build? Describe the project, its scale, and main domains."

## Steps

Load the `@ralph-deep-init` skill.

### Phase 1 — Architect

Analyze the full project scope. Identify exactly 6 distinct functional groups covering the entire project without overlap.

Create `architecture.json` per the skill template.

Report: "Architecture defined:" followed by the 6 groups and estimated task counts.

### Phase 2 — Builders

For each group in `architecture.json`, in sequence:
1. Analyze what tasks are needed for this specific group
2. Create `prd-partial-{group-id}.json` with full task breakdown
3. Confirm file created before moving to next group

Use the task structure from the `@ralph-deep-init` skill. Cross-group dependencies use format `group-XXX/task-YYY`.

### Phase 3 — Assembly

1. Read all `prd-partial-*.json` files
2. Merge into a single `prd.json` with sequentially renumbered task IDs
3. Resolve all cross-group dependency references to final task IDs
4. Create `AGENTS.md` using `@ralph-init` skill structure (real commands, no placeholders)
5. Create `progress.log` with timestamp header
6. Delete all `prd-partial-*.json` and `architecture.json`

Report:
> Deep init complete.
> - `AGENTS.md` — ready
> - `prd.json` — [N] total tasks ([N] high, [N] medium, [N] low priority)
> - `progress.log` — ready
>
> Run `/ralph-loop` to start.
