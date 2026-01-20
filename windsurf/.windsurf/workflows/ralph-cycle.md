---
name: Ralph Cycle (Single)
description: Picks the highest priority failing task, codes it, verifies it, and commits it.
auto_execution_mode: 1
---

# Ralph Cycle

## Step 1: Smart Context Selection

Read `prd.json` and `progress.md`. Analyze the backlog to determine the most logical next step.

**Selection Logic:** Do not simply pick the first item or the highest priority number. Select the task that:

- Is currently failing (`passes: false`)
- Is unblocked by other tasks (dependencies are met)
- Makes the most sense to implement given the current state of the code

Announce: "I have selected [task name] because [reason]."

**Constraint:** PICK ONLY ONE TASK AT A TIME! Do not skip tasks unless blocked. If blocked, document the blocking reason in `progress.md`.

## Step 2: Planning & Journaling

Append a new entry to `progress.md` with the header "## Working on". Write a brief plan of execution in the log, including what files will be modified, your approach, potential challenges, and how you'll verify completion.

**Constraint:**

- Do not modify code yet.

## Step 3: Implementation

Implement the feature described in the selected task using the smallest change that satisfies the acceptance criteria.

**Constraints:**

- Work ONLY on this specific task. Do not refactor unrelated code
- Modify only files required for the selected task
- Adhere to the standards in `.windsurf/rules/tech-stack.md`

## Step 4: Verification

Execute the verification command (e.g., `npm test`, `pytest` etc.) relevant to this task. If `.windsurf/rules/tech-stack.md` does not list any, infer minimal verification and document it in `progress.md`.

If the command fails (repeat up to 3 times):

1. Read the error
2. Attempt to fix the code
3. Re-run verification

If it still fails after 3 tries, document the failure and next hypothesis in `progress.md`, then stop.

## Step 5: Completion & Commit

If verification passes:

1. Update `prd.json`: set `passes` to `true` for this task
2. Update `progress.md`: Append "**Result:** Success"
3. Run `git add .`
4. Run `git commit --no-gpg-sign -m "feat: [task description]"`
