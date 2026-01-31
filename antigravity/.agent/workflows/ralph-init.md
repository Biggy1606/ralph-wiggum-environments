---
description: Initialize Ralph environment with RULES.md and prd.json
---

# Initialize Ralph

User request: $ARGUMENTS

Load the Ralph skill and create:

1. **RULES.md** - Project context with:
   - Technology stack
   - Coding standards  
   - Testing requirements
   - Git workflow

2. **prd.json** - Complete task breakdown with:
   - All tasks needed
   - Proper priorities (high/medium/low)
   - Clear acceptance criteria
   - Task dependencies

3. **progress.log** - Empty file with header:
   ```
   # Ralph Wiggum Progress Log
   # Started: [current timestamp]
   ```

Report: "Ralph initialized. Run '/ralph-loop' to start."
