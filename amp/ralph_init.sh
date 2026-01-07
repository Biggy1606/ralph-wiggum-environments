#!/bin/bash

read -r -d '' PRD_SCHEMA <<'EOF'
{
    "project_meta": {
        "name": "project_name",
        "version": "version"
    },
    "backlog": [
        {
            "id": 1,
            "feature": "feature_name",
            "description": "detailed_description",
            "acceptance_criteria": [
                "criterion_1",
                "criterion_2",
                "criterion_n"
            ],
            "passes": false
        }
    ]
}
EOF

read -r -d '' PROGRESS_SCHEMA <<'EOF'
# Project Progress Log

## [YYYY-MM-DD HH:MM] [phase] task_name

* **Note:** notes_about_task
* **Status:** status
EOF

read -r -d '' RULES_SCHEMA <<'EOF'
# Tech Stack and Coding Conventions

## Tech Stack
- Language: [detected_language]
- Framework: [detected_framework] 
- Package Manager: [detected_package_manager]
- Testing: [detected_testing_library]

## Coding Conventions
- [convention_1]
- [convention_2]
- [convention_n]
EOF

# 1. Capture User Intent
USER_REQUEST="$1"
DRY_RUN=""

# Check for --dry flag
if [ "$1" = "--dry" ]; then
    DRY_RUN="true"
    USER_REQUEST="$2"
    echo "🔍 DRY RUN MODE - Showing command without executing"
    echo "--------------------------------"
fi

if [ -z "$USER_REQUEST" ]; then
    echo "🤖 Ralph Initialization"
    echo "--------------------------------"
    echo "What do you want to do?" 
    echo "(e.g., 'Create a new React project', 'Fix the login bug', 'Refactor the API')"
    read -p "> " USER_REQUEST
fi

if [ -z "$DRY_RUN" ]; then
    echo "🧠 delegating to AMP..."
fi

# 2. The Mega-Prompt
# We construct one clear set of instructions for AMP to execute autonomously.
PROMPT=$(cat <<EOF
You are an initialization agent. Your goal is to prepare the environment for the "Ralph" autonomous loop.

**1. ANALYZE:** Scan the current directory to understand the existing file structure, tech stack, and project state.

**2. EXECUTE:**
Based on your scan and the user's request: "$USER_REQUEST"

Perform the following file operations (use your file creation/editing tools):

* **progress.txt**:
    * Create file if missing
    * Append new entry with current timestamp
    * Include: phase, task_name, notes, and status
    * Use format:
\`\`\`
    $PROGRESS_SCHEMA
\`\`\`

* **RULES.md**: 
    * Check if file exists
    * If MISSING: Create file with detected tech stack and coding conventions
    * If EXISTS: Do not modify
    * Scan directory for: package.json, requirements.txt, go.mod, etc.
    * Follow format: 
\`\`\`
    $RULES_SCHEMA
\`\`\`

* **prd.json**:
    * Check if file exists
    * If MISSING: Create new JSON with tasks for user request
    * If EXISTS: Read existing file, prepend new tasks to backlog array
    * Keep tasks small and specific (better than large tasks)
    * Follow exact schema format:
\`\`\`
    $PRD_SCHEMA
\`\`\`

**CONSTRAINT:**
Do not just output text. You MUST write these changes to the actual files on disk.
EOF
)

# 3. Fire and Forget
# We pipe the instructions to AMP. 
# --dangerously-allow-all is REQUIRED so it can write files without asking "Permission to write?" 3 times.

if [ -n "$DRY_RUN" ]; then
    echo "🔍 Expanded command that would be executed:"
    echo "--------------------------------"
    echo "echo \"$PROMPT\" | amp --execute --dangerously-allow-all --mode smart --no-notifications"
    echo "--------------------------------"
    echo "🔍 DRY RUN COMPLETE - No files were modified"
else
    echo "$PROMPT" | amp --execute --dangerously-allow-all --mode smart --no-notifications
    echo "--------------------------------"
    echo "✅ Initialization complete."
fi