# Amp Ralph Environment

> *"I'm helping!"* — Ralph Wiggum

This directory contains the Ralph Wiggum agent preset for **Amp (Sourcegraph)**.

## 📁 Structure

```
amp/
├── AGENTS.md                    # Main agent instructions
└── .agents/
    └── skills/
        └── ralph/
            └── SKILL.md         # Ralph skill (reusable)
```

## 🚀 Installation

Copy files to your project root:

```bash
cp AGENTS.md /path/to/your/project/
cp -r .agents/ /path/to/your/project/
```

For global availability:
```bash
cp AGENTS.md ~/.config/amp/AGENTS.md
# OR
cp AGENTS.md ~/.config/AGENTS.md

cp -r .agents/skills/* ~/.config/agents/skills/
```

> **Note:** Amp automatically discovers `AGENTS.md` files up the directory tree to `$HOME`.

## 📖 Usage

### Initialize Ralph

```bash
amp -x "Initialize Ralph environment for: Build user authentication with JWT

Create:
1. RULES.md (project context with tech stack, standards, testing, git workflow)
2. prd.json (task breakdown with priorities and acceptance criteria)
3. progress.log (empty with timestamp header)

Report when complete."
```

### Run the Loop

```bash
amp -x "Execute the Ralph loop from AGENTS.md. 
Continue until all tasks in prd.json are complete or you encounter an error."
```

### Deep Init (Large Projects)

```bash
amp -x "Deep init for: Build an e-commerce platform

Phase 1: Create architecture.json with 6 functional groups
Phase 2: Create prd-partial-{id}.json for each group
Phase 3: Merge into prd.json, create RULES.md, progress.log

Use the Ralph skill pattern."
```

## 🔧 Tips

- Use `amp` (interactive mode) for conversational usage
- Use `amp -x "prompt"` for one-shot execution
- Add `--dangerously-allow-all` for fully autonomous execution
