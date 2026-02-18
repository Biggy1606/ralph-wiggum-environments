---
description: Initialize Ralph environment — creates AGENTS.md, prd.json, and progress.log for a project
---

# Initialize Ralph Environment

## Input

The user provides a project description. If no description was given, ask:
> "What would you like to build? Describe the project and its main requirements."

## Steps

1. Load the `@ralph-init` skill for file structure templates.

2. Analyze the project description and infer:
   - Technology stack (language, framework, database, testing tools)
   - Project structure (directory layout)
   - Key functional areas that need tasks

3. Create `AGENTS.md` following the skill template. Rules:
   - Use **real, runnable commands** for the detected stack — no placeholders like `[command]`
   - Include all sections: overview, commands, stack, structure, style, testing, git, security
   - Be specific: `"Use Zod for all API input validation"` not `"Validate inputs"`

4. Create `prd.json` with a complete task breakdown:
   - Decompose the full project into tasks of 15–60 minutes each
   - Set task IDs sequentially: `task-001`, `task-002`, ...
   - High priority: core infrastructure and blocking tasks
   - Express all dependencies explicitly by task ID
   - Acceptance criteria must be binary (pass/fail) — never subjective

5. Create `progress.log` with a timestamped header.

6. Report completion:
   > Ralph environment initialized.
   > - `AGENTS.md` — [N] sections
   > - `prd.json` — [N] tasks ([N] high, [N] medium, [N] low priority)
   > - `progress.log` — ready
   >
   > Run `/ralph-loop` to start.
