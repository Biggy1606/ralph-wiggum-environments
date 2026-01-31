---
description: Execute the Ralph autonomous loop
---

# Ralph Loop

Load the Ralph skill and execute the autonomous loop:

1. Read RULES.md, prd.json, progress.log
2. Select highest priority incomplete task
3. Implement task following RULES.md
4. Verify with tests/typechecks
5. Update prd.json (status: "complete")
6. Append to progress.log
7. Git commit
8. Continue to next task

Stop when all tasks are complete or on error.
