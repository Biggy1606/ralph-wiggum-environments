---
name: Ralph Deep Init
description: A multi-stage initialization that builds a massive backlog by iterating through architectural groups.
auto_execution_mode: 1
---

# Phase 1: Architecture

**Goal:** Initialize the project structure and define the architectural map.

1. **Analyze Request:** Ask the user: "What do you want to build?" if you haven't already.
2. **Create Files:**
    * `progress.md` (Standard Ralph Log)
    * `.windsurf/rules/tech-stack.md` (Tech Stack & Conventions, use `.windsurf/skills/ralph-initialize/tech-stack-template.md`)
    * `init_progress.txt` (Log entry: "Phase 1 Complete")
3. **Generate Architecture:**
    * Identify **6 distinct functional groups** (e.g., Auth, Database, UI) needed for this project.
    * Create a file `groups.json` containing ONLY a JSON array of these string names.
    * Use `.windsurf/skills/ralph-deep-init/groups-template.json` as reference.
    * *Example:* `["Auth", "Database", "API", "Frontend", "Testing", "DevOps"]`

# Phase 2: Expansion (Iteration 1)

**Goal:** Expand the first group.

1. **Read Context:** Read `groups.json`.
2. **Select Target:** Pick the **1st** group from the array.
3. **Generate Tasks:**
    * Create 3-5 detailed implementation tasks for this group.
    * Include acceptance criteria with test methods.
    * Write them to a new file `partial_1.json`.
    * Use `.windsurf/skills/ralph-deep-init/task-examples.json` as reference.

# Phase 2: Expansion (Iteration 2)

**Goal:** Expand the second group.

1. **Select Target:** Pick the **2nd** group from `groups.json`.
2. **Generate Tasks:**
    * Create 3-5 detailed tasks with acceptance criteria and test methods.
    * Write them to `partial_2.json` (same schema as above).

# Phase 2: Expansion (Iteration 3)

1. **Select Target:** Pick the **3rd** group from `groups.json`.
2. **Generate Tasks:** Write to `partial_3.json` (same schema as above).

# Phase 2: Expansion (Iteration 4)

1. **Select Target:** Pick the **4th** group from `groups.json`.
2. **Generate Tasks:** Write to `partial_4.json` (same schema as above).

# Phase 2: Expansion (Iteration 5)

1. **Select Target:** Pick the **5th** group from `groups.json`.
2. **Generate Tasks:** Write to `partial_5.json` (same schema as above).

# Phase 2: Expansion (Iteration 6)

1. **Select Target:** Pick the **6th** group from `groups.json`.
2. **Generate Tasks:** Write to `partial_6.json` (same schema as above).

# Phase 3: Assembly

**Goal:** Compile the final Product Requirements Document.

1. **Create PRD:**
    * Create `prd.json` using `.windsurf/skills/ralph-initialize/prd-template.json` as schema.
    * Read all `partial_*.json` files.
    * Merge all `tasks` arrays into the `backlog` field of `prd.json`.
    * Ensure the final JSON is valid.
2. **Cleanup:** Delete `groups.json` and all `partial_*.json` files.
3. **Report:** Announce "Initialization Complete. Backlog created with [X] tasks."
