# Windsurf Ralph Environment

> *"I'm helping!"* — Ralph Wiggum

This directory contains the Ralph Wiggum agent preset for **Windsurf/Cascade**.

## 📁 Structure

```
windsurf/
└── .windsurf/
    ├── rules/
    │   └── ralph.md           # Ralph rule (manual trigger)
    └── workflows/
        ├── ralph-init.md      # Initialize Ralph environment
        ├── ralph-loop.md      # Execute autonomous loop
        └── ralph-deep-init.md # Deep init for large projects
```

## 🚀 Installation

Copy the `.windsurf/` directory to your project root:

```bash
cp -r .windsurf/ /path/to/your/project/
```

For global rules, add to:
```
~/.codeium/windsurf/memories/global_rules.md
```

> **Note:** Add `.windsurfrules` to `.gitignore` if you don't want rules committed.

## 📖 Usage

### Initialize Ralph

In Cascade Panel (Cmd+L):
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

Ralph will autonomously cycle through tasks.

### Deep Init (Large Projects)

```
/ralph-deep-init "Build complete e-commerce platform"
```

## 🔧 Activation Modes

The Ralph rule uses `trigger: manual` (activated via @ralph mention).

Other options:
- `always` - Always applied
- `model_decision` - Model decides based on description
- `glob: "**/*.ts"` - Applied to files matching pattern

Modify `.windsurf/rules/ralph.md` to customize.
