---
name: Initialize Ralph
description: Checks environment health and prepares the backlog.
auto_execution_mode: 1
---
# Initialize Ralph

## Step 1: Environment Sanity Check

Check if `prd.json` and `progress.md` exist. If they do, ask the user if they want to overwrite them. If not, exit.

`prd.json`

```json
{
    "project_meta": {
        "name": "<project_name>",
        "version": "<version>"
    },
    "backlog": [{
    "id": <number>,
    "feature": "<feature_name>",
    "description": "<detailed_description>",
    "acceptance_criteria": [
      "<criterion_1>",
      "<criterion_2>",
      "<criterion_n>"
    ],
    "passes": <boolean>
  }]
}
```

`progress.md`

```markdown
# Project Progress Log

## [<phase>] <task_name>

* **Status:** <status>
* **Note:** <notes_about_task>

```

## Step 2: Goal Acquisition

Ask the user: "What do you want to build? Please describe the project, its goals, and key features in detail." Wait for the user's response.

## Step 3: Technical Architecture

Check `.windsurf/rules/tech-stack.md`. If it doesn't exist, create it. Ask the user: "What is your preferred tech stack (Language, Framework, Testing Library)?" Write the response into `.windsurf/rules/tech-stack.md`.

## Step 4: Backlog Generation (Initializer Agent)

Analyze the user's project description from Step 2. Break the project down into small, atomic implementation tasks. Populate `prd.json` with these tasks.

**Constraints:**

- Ensure every task has a `passes: false` status and a priority level
- The first task should always be "Setup basic project structure/repository scaffolding"
