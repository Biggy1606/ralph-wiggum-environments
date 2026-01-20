---
name: ralph-cycle
description: Execute a single Ralph development cycle by selecting a failing task, implementing it, verifying with tests, and committing. Use when ready to implement the next feature from the backlog.
---

# Ralph Development Cycle

This skill executes a single development cycle following the Ralph Wiggum Methodology: pick one task, implement it, verify it, commit it.

## Prerequisites

Before starting a cycle:

- ✅ `prd.json` exists with backlog
- ✅ `progress.md` exists
- ✅ `.windsurf/rules/tech-stack.md` exists

## Cycle Steps

### Step 1: Smart Context Selection

Read `prd.json` and `progress.md`. Analyze the backlog to determine the most logical next step.

**Selection Logic:** Do not simply pick the first item. Select the task that:

- Is currently failing (`passes: false`)
- Is unblocked by other tasks (dependencies are met)
- Makes the most sense to implement given the current state of the code

**Announce:** "I have selected [task name] because [reason]."

**Constraint:** PICK ONLY ONE TASK AT A TIME! Do not skip tasks unless blocked. If blocked, document the blocking reason in `progress.md`.

### Step 2: Planning & Journaling

Append a new entry to `progress.md` with the header "## Working on [Task Name]"

Write a brief plan of execution in the log including:

- What files will be modified/created
- What approach you'll take
- Any potential challenges
- How you'll verify completion

**Constraint:** Do not modify code yet.

### Step 3: Implementation

Implement the feature described in the selected task using the smallest change that satisfies the acceptance criteria.

**Constraints:**

- Work ONLY on this specific task
- Do not refactor unrelated code
- Modify only files required for the selected task
- Adhere to the standards in `.windsurf/rules/tech-stack.md`
- Follow the acceptance criteria from `prd.json`

### Step 4: Verification

Execute the verification command (e.g., `npm test`, `pytest`, etc.) relevant to this task.

Reference `.windsurf/rules/tech-stack.md` for the correct verification commands. If it does not list any, infer minimal verification and document it in `progress.md`.

**Retry Logic:**

If the command fails:

1. Read the error output
2. Attempt to fix the code
3. Re-run verification
4. Repeat up to 3 times

If it still fails after 3 tries, document the failure and next hypothesis in `progress.md`, then stop.

### Step 5: Completion & Commit

If verification passes:

1. Update `prd.json`: set `passes` to `true` for this task
2. Update `progress.md`: Append "**Result:** Success"
3. Run `git add .`
4. Run `git commit --no-gpg-sign -m "feat: [task description]"`

## Supporting Resources

Reference these files for guidance:

- `cycle-checklist.md` - Quick reference checklist
- `verification-examples.md` - Common verification patterns

## Anti-Patterns to Avoid

❌ Do not work on multiple tasks simultaneously
❌ Do not mark task as passing without running verification
❌ Do not commit code that fails tests
❌ Do not refactor unrelated code during implementation
