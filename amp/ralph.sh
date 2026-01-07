#!/bin/bash
set -e

# Configuration
ITERATIONS=${1:-10} # Default to 10 iterations if not provided
PRD_FILE="prd.json"
PROGRESS_FILE="progress.txt"
RULES_FILE="RULES.md"

# Sanity Check
if [ ! -f "$PRD_FILE" ]; then
  echo "❌ Missing $PRD_FILE. Run ./ralph_init.sh first."
  exit 1
fi

echo "🚂 Starting Ralph Loop ($ITERATIONS iterations)"
echo "   Context: $RULES_FILE, $PRD_FILE, $PROGRESS_FILE"

for ((i=1; i<=$ITERATIONS; i++)); do
  echo ""
  echo "► Iteration $i / $ITERATIONS"
  echo "---------------------------"

  # The "Executor" Prompt
  # We pipe this strictly to AMP. 
  # We rely on AMP to read the files via the @ syntax.
  
  result=$(cat <<EOF | amp --execute --dangerously-allow-all --mode smart --no-notifications
Context: @$RULES_FILE @$PRD_FILE @$PROGRESS_FILE

**YOUR MISSION:**
You are an autonomous coding agent adhering to the **Ralph Wiggum Methodology**. Your goal is to incrementally implement features from a @$PRD_FILE backlog while maintaining a strictly clean working state.

**INSTRUCTIONS:**
1. **Analyze:** Read @$RULES_FILE to ensure you stick to the project's tech stack and conventions.
2. **Select:** Find the highest-priority task in @$PRD_FILE that is NOT yet done ("passes": false). It must be YOUR choice, not exacly first in the list.
3. **Execute:** Implement the code or fix required for that SINGLE task.
4. **Verify:** Run tests or type-checks to ensure it works.
5. **Record:** - Update @$PRD_FILE to mark the task as "passes": true.
   - Append a concise summary of this action to @$PROGRESS_FILE.
6. **Commit:** Run 'git commit --no-gpg-sign -am "Ralph: [Task Description]"'

**EXIT CONDITION:**
If ALL tasks in @$PRD_FILE are marked true, you MUST output exactly:
<promise>COMPLETE</promise>

**CONSTRAINT:**
Do not ask for permission. Just do the work and update the files.
EOF
  )

  echo "$result"

  # Check for completion signal
  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo "✅ Ralph has finished all tasks!"
    exit 0
  fi

  # Allow file system to sync
  sleep 1
done

echo ""
echo "⚠️  Max iterations reached."