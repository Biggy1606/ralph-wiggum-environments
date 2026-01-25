#!/bin/bash
set -euo pipefail

# ==============================================================
# Ralph Ultimate Init (v2 – KISS Hardened) GPT 5.2
# ==============================================================

# -----------------------------
# CONFIG
# -----------------------------
DRY_RUN=false
USER_REQUEST=""
TEMP_DIR="ralph-init-temp"

MIN_GROUPS=8
MAX_GROUPS=12
MIN_TASKS_PER_GROUP=5
MAX_TASKS_PER_GROUP=10

OPENCODE_MODEL=${OPENCODE_MODEL:-"deepseek/deepseek-reasoner"}
OPENCODE_COMMAND="opencode run -m $OPENCODE_MODEL --format json"

# -----------------------------
# Templates
# -----------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

if [[ ! -f "$TEMPLATE_DIR/prd-template.json" || ! -f "$TEMPLATE_DIR/progress-template.md" || ! -f "$TEMPLATE_DIR/rules-template.md" ]]; then
	echo "❌ Missing templates in $TEMPLATE_DIR. Run from the opencode folder or restore templates." >&2
	exit 1
fi

PRD_SCHEMA=$(cat "$TEMPLATE_DIR/prd-template.json")
PROGRESS_SCHEMA=$(cat "$TEMPLATE_DIR/progress-template.md")
RULES_SCHEMA=$(cat "$TEMPLATE_DIR/rules-template.md")

# -----------------------------
# HELPERS
# -----------------------------
check_jq() {
	command -v jq >/dev/null 2>&1 || {
		echo "❌ jq is required."
		exit 1
	}
}

log() {
	echo "[$(date +%H:%M:%S)] $1" | tee -a "$TEMP_DIR/init_progress.txt"
}

run_opencode() {
	local prompt="$1"
	if [[ "$DRY_RUN" == true ]]; then
		echo "----- PROMPT -----"
		echo "$prompt"
		echo "------------------"
	else
		$OPENCODE_COMMAND "$prompt" | jq -c '.'
	fi
}

validate_json() {
	jq empty "$1" || {
		echo "❌ Invalid JSON: $1"
		exit 1
	}
}

# -----------------------------
# ARGUMENTS
# -----------------------------
check_jq

while [[ $# -gt 0 ]]; do
	case "$1" in
	--dry-run | -d) DRY_RUN=true ;;
	*) USER_REQUEST="$1" ;;
	esac
	shift
done

if [[ -z "$USER_REQUEST" ]]; then
	echo "🚂 Ralph Ultimate Init"
	read -p "What do you want to build? > " USER_REQUEST
fi

mkdir -p "$TEMP_DIR"
: >"$TEMP_DIR/init_progress.txt"

log "Init started for: $USER_REQUEST"

# ==============================================================
# PHASE 1 – ARCHITECT
# ==============================================================

log "Phase 1: Architecture analysis"

if [[ ! -f "progress.md" ]]; then
	echo "$PROGRESS_SCHEMA" >progress.md
	log "Created progress.md"
fi

PHASE_1_PROMPT=$(
	cat <<EOF
Analyze the project request:

"$USER_REQUEST"

Output ONLY valid JSON with:
{
  "tech_stack": {
    "language": "...",
    "framework": "...",
    "package_manager": "...",
    "testing": "..."
  },
  "groups": [
    "Group name 1",
    "Group name 2",
    ...
  ]
}

Constraints:
- groups count: $MIN_GROUPS–$MAX_GROUPS
- include infra, testing, deployment, docs if applicable
- no markdown
EOF
)

run_opencode "$PHASE_1_PROMPT" >"$TEMP_DIR/phase1.json"
validate_json "$TEMP_DIR/phase1.json"

jq '.groups' "$TEMP_DIR/phase1.json" >"$TEMP_DIR/groups.json"
validate_json "$TEMP_DIR/groups.json"

GROUP_COUNT=$(jq 'length' "$TEMP_DIR/groups.json")
log "Architecture locked with $GROUP_COUNT groups"

# Write RULES.md (shell owns file I/O)
# Read values from JSON
LANG=$(jq -r '.tech_stack.language' "$TEMP_DIR/phase1.json")
FRAMEWORK=$(jq -r '.tech_stack.framework' "$TEMP_DIR/phase1.json")
PKG_MGR=$(jq -r '.tech_stack.package_manager' "$TEMP_DIR/phase1.json")
TESTING=$(jq -r '.tech_stack.testing' "$TEMP_DIR/phase1.json")

# Replace placeholders in template
RULES_CONTENT="$RULES_SCHEMA"
RULES_CONTENT="${RULES_CONTENT//\[detected_language\]/$LANG}"
RULES_CONTENT="${RULES_CONTENT//\[detected_framework\]/$FRAMEWORK}"
RULES_CONTENT="${RULES_CONTENT//\[detected_package_manager\]/$PKG_MGR}"
RULES_CONTENT="${RULES_CONTENT//\[detected_testing_library\]/$TESTING}"

# Handle conventions (default to TBD for now as they aren't in phase1.json)
RULES_CONTENT="${RULES_CONTENT//\[convention_1\]/TBD}"
RULES_CONTENT="${RULES_CONTENT//- \[convention_2\]/}"
RULES_CONTENT="${RULES_CONTENT//- \[convention_n\]/}"

echo "$RULES_CONTENT" >RULES.md

# ==============================================================
# PHASE 2 – BUILDERS
# ==============================================================

mapfile -t TOPIC_GROUPS < <(jq -r '.[]' "$TEMP_DIR/groups.json")
#rm -f "$TEMP_DIR"/partial_tasks_*.json

IDX=1
TOTAL=${#TOPIC_GROUPS[@]}

for GROUP in "${TOPIC_GROUPS[@]}"; do
	log "Phase 2 ($IDX/$TOTAL): $GROUP"

	SAFE_NAME=$(echo "$GROUP" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')
	PARTIAL_FILE="$TEMP_DIR/partial_tasks_$SAFE_NAME.json"

	EXPAND_PROMPT=$(
		cat <<EOF
Project: "$USER_REQUEST"
Group: "$GROUP"

Generate backlog tasks.

Output ONLY JSON:
{
  "tasks": [
    {
      "group": "$GROUP",
      "feature": "...",
      "description": "...",
      "acceptance_criteria": ["..."],
      "passes": false
    }
  ]
}

Constraints:
- tasks count: $MIN_TASKS_PER_GROUP–$MAX_TASKS_PER_GROUP
- atomic, testable tasks
- no markdown
EOF
	)

	run_opencode "$EXPAND_PROMPT" >"$PARTIAL_FILE"
	validate_json "$PARTIAL_FILE"

	TASK_COUNT=$(jq '.tasks | length' "$PARTIAL_FILE")
	if ((TASK_COUNT < MIN_TASKS_PER_GROUP || TASK_COUNT > MAX_TASKS_PER_GROUP)); then
		echo "❌ $GROUP task count $TASK_COUNT out of bounds"
		exit 1
	fi

	log "Generated $TASK_COUNT tasks for $GROUP"
	((IDX++))
done

# ==============================================================
# PHASE 3 – ASSEMBLY
# ==============================================================

log "Phase 3: PRD assembly"

echo "$PRD_SCHEMA" | jq '.' >prd.json

ALL_TASKS=$(jq -s '[.[].tasks] | flatten' "$TEMP_DIR"/partial_tasks_*.json)
jq --argjson tasks "$ALL_TASKS" '.backlog = $tasks' prd.json >"$TEMP_DIR/prd.tmp"
mv "$TEMP_DIR/prd.tmp" prd.json

TOTAL_TASKS=$(echo "$ALL_TASKS" | jq 'length')
log "Merged $TOTAL_TASKS tasks into prd.json"

log "Initialization complete 🎉"

echo
echo "Artifacts:"
echo "- prd.json"
echo "- RULES.md"
echo "- Logs: $TEMP_DIR/init_progress.txt"
