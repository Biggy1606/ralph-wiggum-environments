#!/bin/bash
# DEBUG FLAG
# set -x

# File Schemas
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

if [[ ! -f "$TEMPLATE_DIR/prd-template.json" || ! -f "$TEMPLATE_DIR/progress-template.md" || ! -f "$TEMPLATE_DIR/rules-template.md" ]]; then
	echo "❌ Missing templates in $TEMPLATE_DIR. Run from the opencode folder or restore templates." >&2
	exit 1
fi

PRD_SCHEMA=$(cat "$TEMPLATE_DIR/prd-template.json")
PROGRESS_SCHEMA=$(cat "$TEMPLATE_DIR/progress-template.md")
RULES_SCHEMA=$(cat "$TEMPLATE_DIR/rules-template.md")

# Global variables
USER_REQUEST=""
DRY_RUN=false
# OPENCODE_MODEL="opencode/glm-4.7-free"
# OPENCODE_MODEL="opencode/big-pickle"
OPENCODE_MODEL=${OPENCODE_MODEL:-"deepseek/deepseek-reasoner"}
OPENCODE_COMMAND="opencode run -m $OPENCODE_MODEL --format json"

# Check dry run
while [[ "$#" -gt 0 ]]; do
	case $1 in
	--dry-run | -d) DRY_RUN=true ;;
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
	echo "🧠 delegating to OpenCode..."
	echo -e " └> Selected Model:\033[32m $OPENCODE_MODEL\033[0m"
fi

# 2. The Mega-Prompt
# We construct one clear set of instructions for OpenCode to execute autonomously.
PROMPT=$(
	cat <<EOF
You are an initialization agent. Your goal is to prepare the environment for the "Ralph Wiggum" autonomous loop.

**1. ANALYZE:** Scan the current directory to understand the existing file structure, tech stack, and project state.

**2. EXECUTE:**
Based on your scan and the user's request: "$USER_REQUEST"

Perform the following file operations (use your file creation/editing tools):

* **progress.md**:
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
# We send the instructions to OpenCode in non-interactive mode.

if [[ "$DRY_RUN" == true ]]; then
	echo "$OPENCODE_COMMAND \"$PROMPT\""
	echo "--------------------------------"
	echo "🔍 DRY RUN COMPLETE - No files were modified"
else
	$OPENCODE_COMMAND "$PROMPT" | tee
	echo "✅ Initialization complete."
fi
