---
description: Deep initialization for large projects using Architect-Builder pattern
---

# Deep Initialization

User request: $ARGUMENTS

Load the Ralph skill.

## Phase 1: Architect

Analyze the request and identify 6 distinct functional groups.
Create `architecture.json` with group definitions.

## Phase 2: Builders

For each group in architecture.json:
1. Create detailed task breakdown
2. Save to `prd-partial-{group-id}.json`

## Phase 3: Assembly

1. Merge all prd-partial-*.json into prd.json
2. Validate final JSON structure
3. Create RULES.md with project context
4. Create progress.log

Report: "Deep init complete. Run '/ralph-loop' to start."
