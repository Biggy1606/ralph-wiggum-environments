# Ralph Wiggum for OpenCode

Autonomous coding agent that incrementally implements features from a PRD backlog.

## Prerequisites

- OpenCode CLI
- `jq` JSON processor
- Bash shell

## Setup

```bash
chmod +x ralph_init.sh ralph_deep_init.sh ralph.sh
```

## Usage

### Initialize

**Standard init** (for small projects):

```bash
./ralph_init.sh "Create a new React project"
```

**Deep init** (for large projects - generates 8-12 groups, 5-10 tasks each):

```bash
./ralph_deep_init.sh "Build a full-stack e-commerce platform"
```

Both scripts accept `--dry-run` flag to preview without executing.

**Files created:**

- `prd.json` - Task backlog
- `RULES.md` - Tech stack and conventions
- `progress.md` - Progress log

### Run Ralph

```bash
./ralph.sh          # Auto-detect remaining tasks (default)
./ralph.sh 3        # Run 3 iterations
./ralph.sh --dry-run
```

## Workflow

For each task:

1. **Analyze**: Read RULES.md
2. **Select**: Pick highest-priority uncompleted task
3. **Execute**: Implement the task
4. **Verify**: Run tests/type-checks
5. **Record**: Update prd.json and progress.md
6. **Commit**: `git commit --no-gpg-sign -am "Ralph: [Task]"`

### Templates

Template files live in `opencode/templates/`:

- `prd-template.json`
- `rules-template.md`
- `progress-template.md`

## Native Agent Integration

You can also use Ralph as a native OpenCode agent, which allows for deeper integration and more interactive workflows.

### Installation

Copy the agent definitions to your project's `.opencode/agents/` directory:

```bash
mkdir -p .opencode/agents
cp opencode/agents/*.md .opencode/agents/
```

### Usage

1.  **Initialize**:
    *   Invoke `@ralph-init` in chat: `@ralph-init "Create a new React project"`
    *   Or continue using the scripts (`./ralph_init.sh`) as they are compatible.

2.  **Run Tasks**:
    *   Switch to the Ralph agent using the Agent Selector (Tab) or by selecting `ralph`.
    *   Simply ask: "Do the next task" or "Complete the backlog".
    *   Ralph will read the files, pick a task, execute, verify, and commit, just like the script.

## Configuration

Default model: `deepseek/deepseek-chat` (ralph.sh) or `deepseek/deepseek-reasoner` (ralph_init.sh, ralph_deep_init.sh)

**Override via environment variable:**

```bash
OPENCODE_MODEL="opencode/your-model" ./ralph.sh
OPENCODE_MODEL="opencode/your-model" ./ralph_init.sh "Create a new React project"
OPENCODE_MODEL="opencode/your-model" ./ralph_deep_init.sh "Build a full-stack e-commerce platform"
```

**Or change directly in scripts:**

```bash
OPENCODE_MODEL="opencode/your-model"
```
