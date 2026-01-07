#!/bin/bash
# Set debug mode
# set -x

# Configuration
ITERATIONS="auto"
DRY_RUN=false
PRD_FILE="prd.json"
PROGRESS_FILE="progress.txt"
RULES_FILE="RULES.md"
THREAD_ID=""

# The Command Template
AMP_COMMAND="amp --execute --dangerously-allow-all --mode smart --no-notifications --stream-json"

# Define the prompt content - always use full prompt for every iteration
PROMPT_CONTENT=$(cat <<EOF
Context: @$RULES_FILE @$PRD_FILE @$PROGRESS_FILE

**YOUR MISSION:**
You are an autonomous coding agent adhering to the **Ralph Wiggum** workflow. Your goal is to incrementally implement features from a @$PRD_FILE backlog while maintaining a strictly clean working state.

**INSTRUCTIONS:**
1. **Analyze:** Read @$RULES_FILE to ensure you stick to the project's tech stack and conventions.
2. **Select:** Find the highest-priority task in @$PRD_FILE that is NOT yet done ("passes": false).
3. **Execute:** Implement the code or fix required for that SINGLE task.
4. **Verify:** Run tests or type-checks to ensure it works.
5. **Record:** Update @$PRD_FILE (set "passes": true) and @$PROGRESS_FILE.
6. **Commit:** Run 'git commit --no-gpg-sign -am "Ralph: [Task Description]"'

**EXIT CONDITION:**
When you complete a task, output: <promise>TASK_COMPLETE</promise>
If ALL tasks in @$PRD_FILE are marked true, output: <promise>ALL_COMPLETE</promise>
EOF
)

# JQ Filter for stream formatting
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

# JQ filter to extract session_id from stream
read -r -d '' JQ_SESSION_EXTRACTOR <<'JQ'
select(.type == "system" and .subtype == "init") | .session_id
JQ

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dry-run|-d) DRY_RUN=true ;;
    *) 
      if [[ $1 =~ ^[0-9]+$ ]] || [[ $1 == "auto" ]]; then
        ITERATIONS=$1
      else
        echo "❌ Unknown argument: $1"
        exit 1
      fi
      ;;
  esac
  shift
done

# Sanity Check
if [ ! -f "$PRD_FILE" ]; then
  echo "❌ Missing $PRD_FILE. Run ./ralph_init.sh first."
  exit 1
fi

if [ ! -f "$RULES_FILE" ]; then
  echo "❌ Missing $RULES_FILE. Run ./ralph_init.sh first."
  exit 1
fi

if [ ! -f "$PROGRESS_FILE" ]; then
  echo "❌ Missing $PROGRESS_FILE. Run ./ralph_init.sh first."
  exit 1
fi


if [[ $ITERATIONS == "auto" ]]; then
  # Count number of tasks in prd.json
  ITERATIONS=$(jq '[.backlog[] | select(.passes == false)] | length' "$PRD_FILE")
  echo "Automatically detected $ITERATIONS tasks in $PRD_FILE"
fi

echo "🚂 Starting Ralph Loop (max $ITERATIONS iterations)"
[[ "$DRY_RUN" == true ]] && echo "🌵 DRY RUN MODE ENABLED"

# Check if all tasks are complete before starting
all_complete=$(jq '[.backlog[] | select(.passes == false)] | length == 0' "$PRD_FILE")
if [[ "$all_complete" == "true" ]]; then
  echo "✅ All tasks already complete!"
  exit 0
fi

# Main loop
for ((i=1; i<=$ITERATIONS; i++)); do
  echo "----------------------------------------"
  echo "► Iteration $i / $ITERATIONS"
  echo "----------------------------------------"

  if [ "$DRY_RUN" = true ]; then
    # Only print informations if dry run is enabled
    echo "🔍 echo \"[PROMPT_CONTENT]\" | $AMP_COMMAND"
    echo "----------------------------------------"
    echo "🔍 $PROMPT_CONTENT"
    echo "----------------------------------------"
    echo ""
    echo "Exiting after first dry run iteration."
    exit 0
  else
    # Each iteration starts a fresh thread with full prompt
    # Fork the stream: display live formatted output AND capture raw for processing
    # Using process substitution - cleaner and more portable than fd3
    raw_output=$(echo "$PROMPT_CONTENT" | $AMP_COMMAND | tee >(jq -r "$JQ_STREAM_FILTER"))
    THREAD_ID=$(echo "$raw_output" | jq -r "$JQ_SESSION_EXTRACTOR" | head -n1)
    echo ""
    echo "📌 Thread ID: $THREAD_ID"

    # Check for task completion in raw output
    if [[ "$raw_output" == *"<promise>TASK_COMPLETE</promise>"* ]]; then
      echo "✅ Task completed! Checking for more tasks..."
      
      # Check if all tasks are now complete
      all_complete=$(jq '[.backlog[] | select(.passes == false)] | length == 0' "$PRD_FILE")
      if [[ "$all_complete" == "true" ]]; then
        echo "🎉 All tasks in backlog are complete!"
        exit 0
      fi
      
      echo "➡️  Moving to next task in new thread..."
      sleep 2
      continue
    fi

    # Check for all complete signal
    if [[ "$raw_output" == *"<promise>ALL_COMPLETE</promise>"* ]]; then
      echo "🎉 Ralph has finished all tasks!"
      exit 0
    fi
  fi

  sleep 1
done

echo "⚠️  Reached maximum iterations ($ITERATIONS). Some tasks may remain incomplete."