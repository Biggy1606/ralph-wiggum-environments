#!/bin/bash
# ralph_ultimate_init.sh
# The "Best of Both Worlds" initialization script.
# Combines User's robust control flow with "Partial File" safety.

# DEBUG FLAG
# set -x

# ------------------------------------------------------------------
# 1. CONFIGURATION
# ------------------------------------------------------------------

# File Schemas (Preserved from original)
PRD_SCHEMA='{"project_meta":{"name":"project_name","version":"version","ralph_type":"opencode","opencode_session_id":"session_id"},"backlog":[]}'

read -r -d '' PROGRESS_SCHEMA <<'EOF'
# Project Progress Log

## [phase] task_name

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
EOF

# Model Config
USER_REQUEST=""
DRY_RUN=false
# OPENCODE_MODEL="opencode/big-pickle" # Change as needed
OPENCODE_MODEL="opencode/glm-4.7-free"
OPENCODE_COMMAND="opencode run -m $OPENCODE_MODEL --format json"

# ------------------------------------------------------------------
# 2. HELPER FUNCTIONS
# ------------------------------------------------------------------

check_jq() {
    if ! command -v jq >/dev/null 2>&1; then
        echo "❌ Error: jq is required but not installed."
        exit 1
    fi
}

run_opencode() {
    local prompt="$1"
    if [[ "$DRY_RUN" == true ]]; then
        echo "--- OPENCODE PROMPT ---"
        echo "$prompt"
        echo "-----------------------"
    else
        $OPENCODE_COMMAND "$prompt"
    fi
}

# ------------------------------------------------------------------
# 3. SETUP & ARGUMENTS
# ------------------------------------------------------------------

check_jq

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dry-run|-d) DRY_RUN=true ;;
    *) USER_REQUEST="$1" ;;
  esac
  shift
done

if [ -z "$USER_REQUEST" ]; then
    [[ "$DRY_RUN" == true ]] && echo "🌵 DRY RUN MODE"
    echo "🚂 Ralph Ultimate Initialization"
    echo "--------------------------------"
    echo "What do you want to build?"
    read -p "> " USER_REQUEST
fi

if [[ "$DRY_RUN" == false ]]; then
    echo "🧠 Delegating to OpenCode ($OPENCODE_MODEL)..."
fi

# ------------------------------------------------------------------
# 4. PHASE 1: THE ARCHITECT (Drafting the Plan)
# ------------------------------------------------------------------
# Goal: Create conventions, logs, and a list of generic "Groups" to implement.

echo "--------------------------------"
echo "🔹 Phase 1: Analyzing Architecture..."

PHASE_1_PROMPT=$(cat <<EOF
You are a Senior System Architect.
Your goal is to outline the structure for a large project based on this request:
"$USER_REQUEST"

**1. ANALYZE:**
Scan the directory. Understand the tech stack.

**2. EXECUTE:**
Perform the following file operations:

* **init_progress.txt**:
    * Create file.
    * Write text: "Phase 1: Architecture planned for '$USER_REQUEST'"

* **progress.txt**:
    * Create file using this template:
\`\`\`
$PROGRESS_SCHEMA
\`\`\`

* **RULES.md**: 
    * Create/Update file with detected tech stack using this template:
\`\`\`
$RULES_SCHEMA
\`\`\`

* **groups.json**:
    * Identify exactly 6 distinct, high-level "Functional Groups" or "Modules" needed for this project.
    * Output a simple JSON ARRAY of strings.
    * Example: ["Auth System", "Database Layer", "API Endpoints", "Frontend UI", "Testing", "Deployment"]

**CONSTRAINT:**
Do not generate the backlog yet. ONLY generate the files above.
EOF
)

run_opencode "$PHASE_1_PROMPT" | tee /dev/tty > /dev/null

# ------------------------------------------------------------------
# 5. PHASE 2: THE BUILDERS (Expanding the Plan)
# ------------------------------------------------------------------
# Goal: Iterate through the groups defined in Phase 1 and generate tasks.

# Extract groups safely
if [[ "$DRY_RUN" == false ]]; then
    if [ ! -f "groups.json" ]; then
        echo "❌ Critical Error: groups.json was not created. Aborting."
        exit 1
    fi
    # Read groups into a bash array (Plan-Locking)
    mapfile -t TOPIC_GROUPS < <(jq -r '.[]' groups.json)
    
    echo "📋 Architecture Locked. Found ${#TOPIC_GROUPS[@]} groups."
else
    TOPIC_GROUPS=("Mock Group 1" "Mock Group 2" "Mock Group 3")
fi

# Prepare for merging
rm -f partial_tasks_*.json

LOOP_IDX=1
TOTAL_LOOPS=${#TOPIC_GROUPS[@]}

for GROUP in "${TOPIC_GROUPS[@]}"; do
    echo "--------------------------------"
    echo "🔹 Phase 2 (Loop $LOOP_IDX/$TOTAL_LOOPS): Detailing '$GROUP'..."
    
    # Create a safe filename for the partial JSON
    SAFE_NAME=$(echo "$GROUP" | sed 's/[^a-zA-Z0-9]/_/g' | tr '[:upper:]' '[:lower:]')
    PARTIAL_FILE="partial_tasks_${SAFE_NAME}.json"

    EXPAND_PROMPT=$(cat <<EOF
You are a Technical Product Owner.
Your goal is to generate detailed backlog tasks for ONE specific group.

**Context:**
- Project: "$USER_REQUEST"
- Current Group: "$GROUP"

**Instruction:**
1. Break the group "$GROUP" down into 3-5 specific, implementable coding tasks.
2. Output **ONLY** a JSON Object containing the tasks in a "tasks" array.
3. Do not include markdown code blocks. Just raw JSON.
4. Save the output to **$PARTIAL_FILE**.

**Output Format for $PARTIAL_FILE:**
{
  "tasks": [
    {
      "group": "$GROUP",
      "feature": "<feature name>",
      "description": "<technical description>",
      "acceptance_criteria": ["<criterion 1>", "<criterion 2>"],
      "passes": false
    },
    ...
  ]
}

**Update Log:**
Append "Loop $LOOP_IDX: Generated tasks for $GROUP" to init_progress.txt.
EOF
)

    run_opencode "$EXPAND_PROMPT" | tee /dev/tty > /dev/null
    
    ((LOOP_IDX++))
done

# ------------------------------------------------------------------
# 6. PHASE 3: FINAL ASSEMBLY
# ------------------------------------------------------------------
# Goal: Merge all partial files into the final valid prd.json.

echo "--------------------------------"
echo "🔹 Phase 3: Assembling PRD..."

if [[ "$DRY_RUN" == false ]]; then
    # 1. Create the base PRD structure
    echo "$PRD_SCHEMA" | jq '.' > prd.json
    
    # 2. Merge all partial task arrays
    # We look for all files matching partial_tasks_*.json
    if ls partial_tasks_*.json 1> /dev/null 2>&1; then
        # Combine all .tasks arrays into one big list
        ALL_TASKS=$(jq -s '[.[].tasks] | flatten' partial_tasks_*.json)
        
        # Inject into prd.json
        # We use a temp file to ensure atomic write
        jq --argjson tasks "$ALL_TASKS" '.backlog = $tasks' prd.json > prd.json.tmp && mv prd.json.tmp prd.json
        
        echo "✅ Merged $(echo "$ALL_TASKS" | jq 'length') tasks into prd.json"
        
        # Cleanup
        rm partial_tasks_*.json groups.json
    else
        echo "⚠️  Warning: No partial task files found. PRD is empty."
    fi
else
    echo "🔍 DRY RUN: Would merge partial_tasks_*.json into prd.json"
fi

echo "--------------------------------"
echo "🎉 Initialization Complete!"
echo "   - View Backlog: prd.json"
echo "   - View Rules: RULES.md"
echo "   - View Log: init_progress.txt"