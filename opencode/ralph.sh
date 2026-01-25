#!/bin/bash
# Set debug mode
# set -x

# Configuration
ITERATIONS="auto"
DRY_RUN=false
PRD_FILE="prd.json"
PROGRESS_FILE="progress.md"
RULES_FILE="RULES.md"

# The Command Template
# OPENCODE_MODEL='opencode/glm-4.7-free'
# OPENCODE_MODEL="opencode/big-pickle"
OPENCODE_MODEL=${OPENCODE_MODEL:-"deepseek/deepseek-chat"}
OPENCODE_COMMAND="opencode run -m $OPENCODE_MODEL --format json"

# Define the prompt content - always use full prompt for every iteration
PROMPT_CONTENT=$(
	cat <<EOF
Context: @$RULES_FILE @$PRD_FILE @$PROGRESS_FILE

**YOUR MISSION:**
You are an autonomous coding agent adhering to the **Ralph Wiggum** workflow. Implement exactly one task from @$PRD_FILE per iteration, then verify and record.

**INSTRUCTIONS:**
1. **Analyze:** Read @$RULES_FILE for tech stack, conventions, and verification commands.
2. **Select:** Choose the highest-priority task with "passes": false. Do not skip unless blocked.
3. **Scope:** Only modify files required to complete the selected task.
4. **Execute:** Implement the smallest change that satisfies the task’s acceptance criteria.
5. **Verify:** Run the verification commands from @$RULES_FILE. If missing, infer minimal checks and document them.
6. **Record:** Update @$PRD_FILE (set "passes": true) and append a concise entry to @$PROGRESS_FILE describing changes and verification.
7. **Commit:** Only commit after verification passes. Use: git commit --no-gpg-sign -am "Ralph: [Task Description]"

**FAILURE HANDLING:**
- If the same error repeats after multiple attempts, document the failure and next hypothesis in @$PROGRESS_FILE, then output <promise>BLOCKED</promise>.

**EXIT CONDITION:**
- On single-task success: <promise>TASK_COMPLETE</promise>
- If all tasks are complete: <promise>ALL_COMPLETE</promise>
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
if ! command -v jq >/dev/null 2>&1; then
	echo -e "\033[31m❌ jq is not installed. Please install jq to use Ralph.\033[0m"
	exit 1
fi

if [ ! -f "$PRD_FILE" ]; then
	echo -e "\033[31m❌ Missing $PRD_FILE. Run ./ralph_init.sh first.\033[0m"
	exit 1
fi

if [ ! -f "$RULES_FILE" ]; then
	echo -e "\033[31m❌ Missing $RULES_FILE. Run ./ralph_init.sh first.\033[0m"
	exit 1
fi

if [ ! -f "$PROGRESS_FILE" ]; then
	echo -e "\033[31m❌ Missing $PROGRESS_FILE. Run ./ralph_init.sh first.\033[0m"
	exit 1
fi

# Iteration Count
if [[ $ITERATIONS == "auto" ]]; then
	# Count number of tasks in prd.json
	ITERATIONS=$(jq '[.backlog[] | select(.passes == false)] | length' "$PRD_FILE")
	echo -e "Automatically detected \033[32m$ITERATIONS\033[0m non completed tasks in $PRD_FILE"
fi

echo -e "🚂 Starting Ralph Loop (max \033[32m$ITERATIONS\033[0m iterations)"
echo -e " └> Selected Model: \033[32m$OPENCODE_MODEL\033[0m"
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
	all_tasks_complete

	echo -e "----------------------------------------"
	echo -e "  - Iteration $i / $ITERATIONS"
	echo -e "----------------------------------------"

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
		# Fork the stream: display live output AND capture raw for processing
		raw_output=$($OPENCODE_COMMAND "$PROMPT_CONTENT" | tee)

		# Check for blocked signal
		if [[ "$raw_output" == *"<promise>BLOCKED</promise>"* ]]; then
			echo "⛔ Ralph reported BLOCKED. Stopping loop."
			exit 1
		fi

		# Check for task completion in raw output
		if [[ "$raw_output" == *"<promise>TASK_COMPLETE</promise>"* ]]; then
			echo "✅ Task completed! Checking for more tasks..."

			# Check if all tasks are now complete
			all_tasks_complete

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

echo -e "⚠️  Reached maximum iterations (\033[32m$ITERATIONS\033[0m). Some tasks may remain incomplete."
