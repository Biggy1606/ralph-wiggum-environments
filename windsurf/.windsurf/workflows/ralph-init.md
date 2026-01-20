---
name: Initialize Ralph
description: Checks environment health and prepares the backlog.
auto_execution_mode: 1
---
# Initialize Ralph

## Step 1: Environment Sanity Check

Check if `prd.json` and `progress.md` exist. If they do, ask the user if they want to overwrite them. If not, exit.

`prd.json` (use `.windsurf/skills/ralph-initialize/prd-template.json` as schema)

`progress.md` (use `.windsurf/skills/ralph-initialize/progress-template.md` as schema)

## Step 2: Goal Acquisition

Ask the user: "What do you want to build? Please describe the project, its goals, and key features in detail." Wait for the user's response. If user already passed the goal acquisition step, skip this step with infromation "ℹ️ User already passed the goal acquisition step."

## Step 3: Technical Architecture

Check `.windsurf/rules/tech-stack.md`. If it doesn't exist, create it using `.windsurf/skills/ralph-initialize/tech-stack-template.md`. Ask the user: "What is your preferred tech stack (Language, Framework, Testing Library)?" Write the response into `.windsurf/rules/tech-stack.md`.

## Step 4: Backlog Generation (Initializer Agent)

Analyze the user's project description from Step 2. Break the project down into small, atomic implementation tasks. Populate `prd.json` with these tasks using the template schema.

**Constraints:**

- Ensure every task has `passes: false` status
- Include clear acceptance criteria with a test method
- The first task should always be "Setup basic project structure/repository scaffolding"
