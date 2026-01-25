---
name: ralph-deep-init
description: Build a comprehensive project backlog through multi-stage architectural analysis. Creates 6 functional groups and generates detailed tasks for each. Use when you need a large, well-organized backlog for complex projects.
---

# Ralph Deep Initialization

This skill performs a comprehensive, multi-stage project initialization that generates a large, well-organized backlog by breaking down the project into functional architectural groups.

## When to Use This Skill

Use ralph-deep-init instead of ralph-initialize when:

- Building a complex project with many features
- Need 20-40+ detailed tasks in the backlog
- Want tasks organized by architectural concerns
- Project has multiple distinct functional areas

## Prerequisites

- Git repository initialized
- No existing `prd.json` (or user approves overwrite)
- Clear understanding of project requirements

## Multi-Stage Process

### Phase 1: Architecture

**Goal:** Initialize the project structure and define the architectural map.

1. **Analyze Request**
   - Ask: "What do you want to build?" if not already provided
   - Gather comprehensive project requirements

2. **Create Foundation Files**
   - `progress.md` - Standard Ralph progress log
   - `.windsurf/rules/tech-stack.md` - Tech stack & conventions
   - `init_progress.txt` - Temporary initialization tracking

3. **Generate Architecture**
   - Identify **6 distinct functional groups** needed for this project
   - Examples: Auth, Database, API, Frontend, Testing, DevOps
   - Create `groups.json` containing ONLY a JSON array of these string names
   - Format: `["Group1", "Group2", "Group3", "Group4", "Group5", "Group6"]`

### Phase 2: Expansion (6 Iterations)

**Goal:** Generate detailed tasks for each functional group.

For each of the 6 groups (iterate 1 through 6):

1. **Select Target:** Pick group N from `groups.json`
2. **Generate Tasks:** Create 3-5 detailed implementation tasks for this group
3. **Write to File:** Save to `partial_N.json`

**Task Template:**

Use `.windsurf/skills/ralph-deep-init/task-examples.json` as the reference schema for each `partial_N.json`.

### Phase 3: Assembly

**Goal:** Compile the final Product Requirements Document.

1. **Create PRD**
   - Create `prd.json` (use `.windsurf/skills/ralph-initialize/prd-template.json` as reference)
   - Read all `partial_*.json` files
   - Merge all `tasks` arrays into the `backlog` field
   - Ensure valid JSON structure

2. **Cleanup**
   - Delete `groups.json`
   - Delete all `partial_*.json` files
   - Keep `init_progress.txt` for reference

3. **Report**
   - Announce: "Initialization Complete. Backlog created with [X] tasks."
   - Summarize task breakdown by group

## Supporting Resources

Reference these files:

- `architecture-examples.md` - Sample functional group breakdowns
- `task-examples.json` - Well-formed task examples
- `groups-template.json` - Template for groups array

## Success Criteria

Deep initialization is complete when:

- ✅ `prd.json` exists with 20+ tasks
- ✅ Tasks are organized by functional groups
- ✅ All tasks have `passes: false`
- ✅ Each task has clear acceptance criteria
- ✅ `progress.md` exists
- ✅ Temporary files are cleaned up

## Tips

- Choose groups that represent distinct technical concerns
- Ensure tasks within a group are cohesive
- Order tasks to respect dependencies
- Include infrastructure/testing as separate groups
- Aim for 3-5 tasks per group (total: 18-30 tasks)
