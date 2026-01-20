# Ralph Wiggum Skills

This directory contains Cascade Skills for the Ralph Wiggum Methodology - an incremental, test-driven development approach.

## Available Skills

### 🎯 ralph-initialize

**Purpose:** Initialize a new project with Ralph methodology

**When to use:** Starting a new project or setting up Ralph for the first time

**What it does:**

- Creates `prd.json` backlog file
- Creates `progress.md` tracking log
- Sets up `.windsurf/rules/tech-stack.md` with your tech stack
- Generates initial task backlog (typically 5-15 tasks)

**Invocation:**

```text
@ralph-initialize
```

Or let Cascade auto-invoke by asking: "Initialize a new Ralph project for [description]"

### 🔄 ralph-cycle

**Purpose:** Execute a single development cycle

**When to use:** Ready to implement the next feature from the backlog

**What it does:**

- Selects highest-priority failing task
- Plans implementation approach
- Implements the feature
- Runs verification tests
- Commits on success

**Invocation:**

```text
@ralph-cycle
```

Or: "Run a Ralph development cycle"

### 🏗️ ralph-deep-init

**Purpose:** Build comprehensive backlog through architectural analysis

**When to use:** Complex projects needing large, well-organized backlogs (20-40+ tasks)

**What it does:**

- Identifies 6 functional architectural groups
- Generates 3-5 tasks per group
- Creates comprehensive `prd.json`
- Organizes tasks by technical domain

**Invocation:**

```text
@ralph-deep-init
```

Or: "Initialize Ralph with deep architectural analysis for [description]"

## How Skills Work

### Automatic Invocation

Cascade automatically invokes skills when your request matches the skill description. Just describe what you want:

- "I need to set up Ralph for my Node.js API project" → invokes `ralph-initialize`
- "Implement the next task from the backlog" → invokes `ralph-cycle`
- "Create a large backlog for my e-commerce platform" → invokes `ralph-deep-init`

### Manual Invocation

Use `@skill-name` to explicitly invoke a skill:

```text
@ralph-cycle please implement the authentication task
```

### Progressive Disclosure

Skills use progressive disclosure - Cascade reads the SKILL.md file first, then accesses supporting resources only when needed.

## Supporting Resources

Each skill includes reference files:

**ralph-initialize:**

- `prd-template.json` - Product requirements structure
- `progress-template.md` - Progress log format
- `tech-stack-template.md` - Tech stack documentation

**ralph-cycle:**

- `cycle-checklist.md` - Quick reference for each cycle
- `verification-examples.md` - Test commands for various tech stacks

**ralph-deep-init:**

- `architecture-examples.md` - Sample functional group breakdowns
- `task-examples.json` - Well-formed task examples
- `groups-template.json` - Template for architecture groups

## Ralph Methodology Quick Reference

### Core Files

- **`prd.json`** - Product Requirements Document (backlog)
- **`progress.md`** - Development log
- **`.windsurf/rules/tech-stack.md`** - Tech stack and conventions

### Workflow

1. **Initialize:** Use `@ralph-initialize` or `@ralph-deep-init`
2. **Cycle:** Repeatedly use `@ralph-cycle` to implement tasks
3. **Track:** All work is logged in `progress.md`
4. **Verify:** Every task must pass tests before marking complete

### Constraints

- 🎯 One task at a time
- ✅ Tests must pass before commit
- 📝 All work logged to `progress.md`
- 🔒 `prd.json` is the source of truth

## Examples

### Starting a new project

```text
User: Initialize Ralph for a REST API with user authentication
Cascade: [invokes @ralph-initialize automatically]
```

### Running development cycles

```text
User: @ralph-cycle
Cascade: I have selected "User registration endpoint" because...
[implements, tests, commits]
```

### Complex project initialization

```text
User: Set up Ralph for a full-stack e-commerce platform with React and Node.js
Cascade: [invokes @ralph-deep-init automatically]
[Creates 6 architectural groups: Auth, Products, Cart, Payment, Admin, DevOps]
[Generates 25 detailed tasks]
```

## Tips

1. **Start Simple:** Use `@ralph-initialize` for most projects
2. **Use Deep Init for Complexity:** Use `@ralph-deep-init` for projects with 20+ features
3. **Trust the Process:** Let Cascade select tasks based on dependencies
4. **Verify First:** Never skip test verification
5. **One Task Focus:** Resist the urge to work on multiple tasks simultaneously

## Customization

You can customize the skills by editing the SKILL.md files or adding new supporting resources to each skill folder.

## Windsurf File Structure (vs OpenCode)

Windsurf stores configuration and automation files in specific locations:

- **Rules:** `.windsurf/rules/*.md` (workspace) or `global_rules.md` (global)
- **AGENTS.md:** place `AGENTS.md` or `agents.md` in any directory for scoped instructions
- **Workflows:** `.windsurf/workflows/*.md`
- **Hooks:** `.windsurf/hooks.json`
- **Worktrees:** `~/.windsurf/worktrees/<repo_name>` (auto-managed)
- **Memories:** managed in the Cascade UI (not stored as workspace files)

OpenCode scripts use `RULES.md` and `progress.txt`, which are separate from Windsurf's conventions.

## Related Features

- **Workflows:** `.windsurf/workflows/` contains executable workflow files
- **Rules:** `.windsurf/rules/` contains coding conventions
- **Hooks:** `.windsurf/hooks.json` configures lifecycle hooks

Skills provide more structure and supporting resources than workflows, making them ideal for complex, multi-step processes like Ralph cycles.
