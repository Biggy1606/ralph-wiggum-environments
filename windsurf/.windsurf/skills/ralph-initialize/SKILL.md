---
name: ralph-initialize
description: Initialize a new project with Ralph methodology by creating prd.json backlog, progress.md log, and tech-stack configuration. Use when starting a new project or setting up Ralph for the first time.
---

# Ralph Project Initialization

This skill guides you through initializing a project with the Ralph Wiggum Methodology for incremental feature development.

## Prerequisites Check

Before starting, verify:

- Git repository is initialized
- No existing `prd.json` or `progress.md` (or user approves overwrite)

## Initialization Steps

### 1. Environment Sanity Check

Check if `prd.json` and `progress.md` exist. If they do, ask the user if they want to overwrite them. If not, exit.

### 2. Goal Acquisition

Ask the user: "What do you want to build? Please describe the project, its goals, and key features in detail."

Wait for the user's response before proceeding.

### 3. Technical Architecture

Check `.windsurf/rules/tech-stack.md`. If it doesn't exist, create it.

Ask the user: "What is your preferred tech stack (Language, Framework, Testing Library)?"

Write the response into `.windsurf/rules/tech-stack.md` using the template provided in this skill folder.

### 4. Backlog Generation

Analyze the user's project description. Break the project down into small, atomic implementation tasks. Populate `prd.json` with these tasks using the template provided.

**Constraints:**

- Ensure every task has a `passes: false` status
- Include clear acceptance criteria for each task
- The first task should always be "Setup basic project structure/repository scaffolding"

## Output Files

Use these template files from this skill folder:

- `.windsurf/skills/ralph-initialize/prd-template.json` - Product Requirements Document structure
- `.windsurf/skills/ralph-initialize/progress-template.md` - Progress log format
- `.windsurf/skills/ralph-initialize/tech-stack-template.md` - Tech stack documentation format

## Success Criteria

Initialization is complete when:

- ✅ `prd.json` exists with valid backlog
- ✅ `progress.md` exists with initial entry
- ✅ `.windsurf/rules/tech-stack.md` exists with tech stack details
- ✅ All tasks in backlog have `passes: false`
