#!/bin/bash
# Set debug mode
# set -x

# Configuration
ITERATIONS="auto"
DRY_RUN=false
PRD_FILE="prd.json"
PROGRESS_FILE="progress.txt"
RULES_FILE="RULES.md"

# The Command Template
OPENCODE_MODEL='opencode/glm-4.7-free'
OPENCODE_COMMAND="opencode run -m $OPENCODE_MODEL --format json"

# Define the prompt content - always use full prompt for every iteration
PROMPT_CONTENT=$(
	cat <<EOF
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

# Parse arguments
while [[ "$#" -gt 0 ]]; do
	case $1 in
	--dry-run | -d) DRY_RUN=true ;;
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

all_tasks_complete() {
	all_complete=$(jq '[.backlog[] | select(.passes == false)] | length == 0' "$PRD_FILE")
	if [[ "$all_complete" == "true" ]]; then
		echo "✅ All tasks already complete!"
		exit 0
	fi
}

# Main loop
for ((i = 1; i <= $ITERATIONS; i++)); do

	# Check if all tasks are complete before starting
	all_tasks_complete()

	echo "----------------------------------------"
	echo "► Iteration $i / $ITERATIONS"
	echo "----------------------------------------"

	if [ "$DRY_RUN" = true ]; then
		# Only print informations if dry run is enabled
		echo "🔍 $OPENCODE_COMMAND \"[PROMPT_CONTENT]\""
		echo "----------------------------------------"
		echo "🔍 $PROMPT_CONTENT"
		echo "----------------------------------------"
		echo ""
		echo "Exiting after first dry run iteration."
		exit 0
	else
		# Each iteration starts a fresh thread with full prompt
		# Fork the stream: display live formatted output AND capture raw for processing
		raw_output=$($OPENCODE_COMMAND "$PROMPT_CONTENT")

		# Check for task completion in raw output
		if [[ "$raw_output" == *"<promise>TASK_COMPLETE</promise>"* ]]; then
			echo "✅ Task completed! Checking for more tasks..."

			# Check if all tasks are now complete
			all_tasks_complete()

			echo "➡️  Moving to next task in new thread..."
			sleep 2
			continue
		fi

		# Check for all complete signal (from raw_output)
		if [[ "$raw_output" == *"<promise>ALL_COMPLETE</promise>"* ]]; then
			echo "🎉 Ralph has finished all tasks!"
			exit 0
		fi
	fi

	sleep 1
done

echo "⚠️  Reached maximum iterations ($ITERATIONS). Some tasks may remain incomplete."
