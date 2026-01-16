#!/bin/bash
# ==============================================================
# ralph_ultimate_init.sh
#
# "Best of Both Worlds" initialization script
# - Strong control flow in Bash
# - Delegated reasoning and file generation via OpenCode
# - Partial-file safety for large backlogs
# ==============================================================

# DEBUG
# set -x

# ==============================================================
# 1. CONFIGURATION
# ==============================================================

# ------------------------------
# PRD Schema (LLM replaces <placeholders>)
# ------------------------------
read -r -d '' PRD_SCHEMA <<'EOF'
{
    "project_meta": {
        "name": "<project_name>",
        "version": "<version>",
        "ralph_type": "opencode",
        "opencode_session_id": "<session_id>"
    },
    "backlog": [
        {
            "group": "<group_name>",
            "feature": "<feature_name>",
            "description": "<detailed_description>",
            "acceptance_criteria": [
                "<criterion_1> (<method_of_testing>)",
                "<criterion_2> (<method_of_testing>)",
                "<criterion_n> (<method_of_testing>)"
            ],
            "passes": false
        }
    ]
}
EOF

# ------------------------------
# Progress Log Schema
# ------------------------------
read -r -d '' PROGRESS_SCHEMA <<'EOF'
# Project Progress Log

## [phase] task_name

* **Note:** notes_about_task
* **Status:** status
EOF

# ------------------------------
# Rules / Tech Stack Schema
# ------------------------------
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
EOF

# ------------------------------
# Runtime Configuration
# ------------------------------
USER_REQUEST=""
DRY_RUN=false

# Model selection (override via env if needed)
OPENCODE_MODEL=${OPENCODE_MODEL:-"deepseek/deepseek-reasoner"}
OPENCODE_COMMAND="opencode run -m $OPENCODE_MODEL --format json"

# Temporary workspace
TEMP_DIR="ralph-init-temp"

# Task generation bounds
MIN_GROUPS=8
MAX_GROUPS=12
MIN_TASKS_PER_GROUP=5
MAX_TASKS_PER_GROUP=10

# ==============================================================
# 2. HELPER FUNCTIONS
# ==============================================================

check_jq() {
	if ! command -v jq >/dev/null 2>&1; then
		echo "❌ Error: jq is required but not installed."
		exit 1
	fi
}

run_opencode() {
	local prompt="$1"

	if [[ "$DRY_RUN" == true ]]; then
		echo "----- OPENCODE PROMPT -----"
		echo "$prompt"
		echo "---------------------------"
	else
		$OPENCODE_COMMAND "$prompt"
	fi
}

# ==============================================================
# 3. SETUP & ARGUMENT PARSING
# ==============================================================

check_jq

while [[ "$#" -gt 0 ]]; do
	case "$1" in
	--dry-run | -d)
		DRY_RUN=true
		;;
	*)
		USER_REQUEST="$1"
		;;
	esac
	shift
done

if [[ -z "$USER_REQUEST" ]]; then
	[[ "$DRY_RUN" == true ]] && echo "🌵 DRY RUN MODE"
	echo "🚂 Ralph Ultimate Initialization"
	echo "--------------------------------"
	echo "What do you want to build?"
	read -p "> " USER_REQUEST
fi

if [[ "$DRY_RUN" == false ]]; then
	echo "🧠 Delegating to OpenCode ($OPENCODE_MODEL)..."
	mkdir -p "$TEMP_DIR"
fi

# ==============================================================
# 4. PHASE 1 — THE ARCHITECT
# Goal: Define structure, rules, logs, and functional groups
# ==============================================================

echo "--------------------------------"
echo "🔹 Phase 1: Architecture Analysis"

PHASE_1_PROMPT=$(
	cat <<EOF
You are a Senior System Architect.

Project request:
"$USER_REQUEST"

1. Analyze the current directory and infer the tech stack.

2. Perform the following file operations:

- Create **$TEMP_DIR/init_progress.txt**
  Write:
  "Phase 1: Architecture planned for '$USER_REQUEST'"

- Create **progress.txt** using this template:
$PROGRESS_SCHEMA

- Create or update **RULES.md** using this template:
$RULES_SCHEMA

- Create **$TEMP_DIR/groups.json**
  * Identify $MIN_GROUPS–$MAX_GROUPS functional groups/modules
  * Include infra, testing, deployment, and docs if applicable
  * Output ONLY a JSON array of strings

Example:
["Infrastructure", "Auth", "Database", "API", "Frontend", "Testing", "Deployment", "Docs"]

Constraints:
- Do NOT generate backlog tasks yet
- ONLY generate the files listed above
EOF
)

run_opencode "$PHASE_1_PROMPT" | tee /dev/tty >/dev/null

# ==============================================================
# 5. PHASE 2 — THE BUILDERS
# Goal: Expand each group into detailed backlog tasks
# ==============================================================

if [[ "$DRY_RUN" == false ]]; then
	if [[ ! -f "$TEMP_DIR/groups.json" ]]; then
		echo "❌ Critical error: $TEMP_DIR/groups.json not found."
		exit 1
	fi

	mapfile -t TOPIC_GROUPS < <(jq -r '.[]' "$TEMP_DIR/groups.json")
	echo "📋 Architecture locked: ${#TOPIC_GROUPS[@]} groups detected."
else
	TOPIC_GROUPS=("Mock Group 1" "Mock Group 2" "Mock Group 3" "Mock Group 4")
fi

rm -f "$TEMP_DIR"/partial_tasks_*.json

LOOP_IDX=1
TOTAL_LOOPS=${#TOPIC_GROUPS[@]}

for GROUP in "${TOPIC_GROUPS[@]}"; do
	echo "--------------------------------"
	echo "🔹 Phase 2 ($LOOP_IDX/$TOTAL_LOOPS): $GROUP"

	SAFE_NAME=$(echo "$GROUP" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]')
	PARTIAL_FILE="$TEMP_DIR/partial_tasks_${SAFE_NAME}.json"

	EXPAND_PROMPT=$(
		cat <<EOF
You are a Technical Product Owner.

Project: "$USER_REQUEST"
Group: "$GROUP"

Instructions:
1. Generate $MIN_TASKS_PER_GROUP–$MAX_TASKS_PER_GROUP atomic, testable tasks
2. Each task must be a single implementation deliverable
3. Include detailed acceptance criteria with test methods
4. Output ONLY raw JSON (no markdown)
5. Save output to: $PARTIAL_FILE

JSON format:
{
  "tasks": [
    {
      "group": "$GROUP",
      "feature": "<feature>",
      "description": "<description>",
      "acceptance_criteria": ["<criterion>"],
      "passes": false
    }
  ]
}

Append progress:
"Loop $LOOP_IDX: Generated tasks for $GROUP"
to $TEMP_DIR/init_progress.txt
EOF
	)

	run_opencode "$EXPAND_PROMPT" | tee /dev/tty >/dev/null
	((LOOP_IDX++))
done

# ==============================================================
# 6. PHASE 3 — FINAL ASSEMBLY
# Goal: Merge partial task files into prd.json
# ==============================================================

echo "--------------------------------"
echo "🔹 Phase 3: PRD Assembly"

if [[ "$DRY_RUN" == false ]]; then
	echo "$PRD_SCHEMA" | jq '.' >prd.json

	if ls "$TEMP_DIR"/partial_tasks_*.json >/dev/null 2>&1; then
		ALL_TASKS=$(jq -s '[.[].tasks] | flatten' "$TEMP_DIR"/partial_tasks_*.json)

		jq --argjson tasks "$ALL_TASKS" \
			'.backlog = $tasks' prd.json \
			>"$TEMP_DIR/prd.json.tmp" &&
			mv "$TEMP_DIR/prd.json.tmp" prd.json

		TASK_COUNT=$(echo "$ALL_TASKS" | jq 'length')
		GROUP_COUNT=$(jq 'length' "$TEMP_DIR/groups.json")

		echo "✅ Merged $TASK_COUNT tasks from $GROUP_COUNT groups"
		mv "$TEMP_DIR/groups.json" "$TEMP_DIR/groups.json.bak" 2>/dev/null || true
	else
		echo "⚠️ Warning: No partial task files found."
	fi
else
	echo "🔍 DRY RUN: Would merge partial task files into prd.json"
fi

echo "--------------------------------"
echo "🎉 Initialization Complete"
echo " - Backlog: prd.json"
echo " - Rules: RULES.md"
echo " - Log: $TEMP_DIR/init_progress.txt"
echo " - Temp: $TEMP_DIR/"
