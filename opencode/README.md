# Ralph Wiggum for OpenCode

Ralph Wiggum is an autonomous coding agent that incrementally implements features from a product requirements document (PRD) backlog while maintaining a strictly clean working state. It's designed to work seamlessly with OpenCode models.

## Installation

### Prerequisites

- OpenCode CLI installed
- `jq` command-line JSON processor
- Bash shell (Linux/macOS/WSL)

### Setup

1. Clone or download this repository to your local machine
2. Make the scripts executable:

   ```bash
   chmod +x ralph_init.sh ralph_deep_init.sh ralph.sh
   ```

## Usage

### Getting Started

#### Standard Initialization

1. **Initialize Ralph** for a new project or task:

   ```bash
   ./ralph_init.sh "Create a new React project"  # or any other task description
   ```

   This will create the necessary configuration files:
   - `prd.json` - Product requirements document with task backlog
   - `RULES.md` - Tech stack and coding conventions
   - `progress.txt` - Project progress log

#### Deep Initialization (Large Projects)

For complex projects that need comprehensive task breakdown:

1. **Run Deep Init**:

   ```bash
   ./ralph_deep_init.sh "Build a full-stack e-commerce platform"
   ./ralph_deep_init.sh --dry-run  # Preview without executing
   ```

   The **Architect-Builder** workflow:
   - **Phase 1**: Creates 6 architectural groups (e.g., Auth, Database, API)
   - **Phase 2**: Expands each group into 3-5 specific tasks via separate loops
   - **Phase 3**: Merges all partial files into final `prd.json`

   This approach prevents token overflow and generates larger, more comprehensive backlogs.

#### Run Ralph

1. **Execute tasks autonomously**:

   ```bash
   ./ralph.sh                    # Auto-detects remaining tasks
   ./ralph.sh 3                  # Run specific number of iterations
   ./ralph.sh auto               # Auto mode (default)
   ./ralph.sh --dry-run          # Preview without executing
   ```

### Workflow

Ralph follows a 6-step workflow for each task:

1. **Analyze**: Read RULES.md to understand tech stack and conventions
2. **Select**: Find highest-priority task in prd.json that's not completed
3. **Execute**: Implement the required code or fix
4. **Verify**: Run tests or type-checks to ensure it works
5. **Record**: Update prd.json (set "passes": true) and progress.txt
6. **Commit**: Run `git commit --no-gpg-sign -am "Ralph: [Task Description]"`

### Configuration

The default model is set to `opencode/big-pickle` but can be changed in the scripts:

```bash
# In ralph.sh and ralph_init.sh
OPENCODE_MODEL="opencode/your-preferred-model"
```
