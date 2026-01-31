# Antigravity Ralph Environment

> *"I'm helping!"* — Ralph Wiggum

This directory contains the Ralph Wiggum agent preset for **Antigravity (Google)**.

## 📁 Structure

```
antigravity/
└── .agent/
    ├── skills/
    │   └── ralph/
    │       └── SKILL.md       # Ralph skill definition
    └── workflows/
        ├── ralph-init.md      # Initialize Ralph environment
        ├── ralph-loop.md      # Execute autonomous loop
        └── ralph-deep-init.md # Deep init for large projects
```

## 🚀 Installation

Copy the `.agent/` directory to your project root:

```bash
cp -r .agent/ /path/to/your/project/
```

For global availability:
```bash
cp -r .agent/skills/* ~/.gemini/skills/
cp -r .agent/workflows/* ~/.gemini/antigravity/global_workflows/
```

> **Note:** Antigravity discovers skills/workflows from workspace root and walks up the directory tree.

## 📖 Usage

### Initialize Ralph

In chat:
```
/ralph-init "Build a user authentication system with JWT"
```

This creates:
- `RULES.md` - Project context and coding standards
- `prd.json` - Task breakdown with priorities
- `progress.log` - Execution history

### Run the Loop

```
/ralph-loop
```

Ralph will autonomously:
1. Read context files
2. Select highest priority incomplete task
3. Implement the task
4. Verify with tests
5. Update prd.json and progress.log
6. Git commit
7. Move to next task

### Deep Init (Large Projects)

For complex projects that would exceed token limits:

```
/ralph-deep-init "Build complete e-commerce platform with payment processing"
```

## 🔧 Skill Metadata

The skill includes:
- **Name:** `ralph`
- **Version:** `1.0.0`
- **Tags:** `automation`, `task-execution`, `loop`

Modify `.agent/skills/ralph/SKILL.md` to customize.
