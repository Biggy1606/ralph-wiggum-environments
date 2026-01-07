#!/bin/bash

# File Schemas
PRD_SCHEMA='{"project_meta":{"name":"project_name","version":"version","ralph_type":"amp","amp_thread_id":"thread_id"},"backlog":[{"id":1,"feature":"feature_name","description":"detailed_description","acceptance_criteria":["criterion_1","criterion_2","criterion_n"],"passes":false}]}'

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

# Global variables
USER_REQUEST=""
DRY_RUN=false
AMP_COMMAND="amp --execute --dangerously-allow-all --mode smart --no-notifications --stream-json"

read -r -d '' JQ_STREAM_FILTER <<'JQ'
# Extract first line from text
def first_line: split("\n")[0];

# Clean whitespace
def clean: gsub("^[[:space:]]+|[[:space:]]+$";"");

# Process different message types
if .type == "system" then
  "🔧 SYSTEM (" + .subtype + ")",
  "cwd: " + .cwd,
  "session: " + .session_id,
  "tools available: " + (.tools | length | tostring),
  "--------------------------------"

elif .type == "user" then
  (.message.content[0].text | clean | first_line) as $text |
  if $text != "" then
    "👤 USER (" + .message.role + ")",
    $text,
    "--------------------------------"
  else empty end

elif .type == "assistant" then
  ([.message.content[] | 
    if .type == "text" then .text | clean
    elif .type == "tool_use" then "🧰 tool → " + .name
    else empty end
  ] | map(select(. != "")) | join("\n\n")) as $text |
  if $text != "" then
    "🤖 ASSISTANT",
    $text,
    "--------------------------------"
  else empty end

elif .type == "result" then
  ([.content[] | select(.type == "text") | .text | clean] | 
   map(select(. != "")) | join("\n\n")) as $text |
  if $text != "" then
    "📦 RESULT",
    $text,
    "--------------------------------"
  else empty end

else empty end
JQ

# Check dry run
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dry-run|-d) DRY_RUN=true ;;
    *)
      USER_REQUEST="$1"
      ;;
  esac
  shift
done

if [ -z "$USER_REQUEST" ]; then
    [[ "$DRY_RUN" == true ]] && echo "🌵 DRY RUN MODE - Showing command without executing"
    echo "🤖 Ralph Initialization"
    echo "--------------------------------"
    echo "What do you want to do?" 
    echo "(e.g., 'Create a new React project', 'Fix the login bug', 'Refactor the API')"
    read -p "> " USER_REQUEST
fi

if [[ "$DRY_RUN" == false ]]; then
    echo "🧠 delegating to AMP..."
fi

# 2. The Mega-Prompt
# We construct one clear set of instructions for AMP to execute autonomously.
PROMPT=$(cat <<EOF
You are an initialization agent. Your goal is to prepare the environment for the "Ralph Wiggum" autonomous loop.

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

if [[ "$DRY_RUN" == true ]]; then
    echo "\"$PROMPT\" | $AMP_COMMAND"
    echo "--------------------------------"
    echo "🔍 DRY RUN COMPLETE - No files were modified"
else
    echo "$PROMPT" | $AMP_COMMAND | jq -r "$JQ_STREAM_FILTER"
    echo "✅ Initialization complete."
fi