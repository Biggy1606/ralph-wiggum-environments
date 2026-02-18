# 🚂 Ralph Wiggum Environments

> *"I'm helping!"* — Ralph Wiggum

This repository contains "Ralph" harnesses for various AI code editors. The Ralph approach transforms interactive CLI coding agents into autonomous workers by running them in a feedback loop with a persistent task list.

## 📂 Supported Environments

| Editor | Status | Link |
| :--- | :--- | :--- |
| **OpenCode** | ✅ Ready | [View Guide](./opencode/README.md) |
| **Windsurf** | ✅ Ready | [View Guide](./windsurf/README.md) |
| **AMP** | ✅ Ready | [View Guide](./amp/README.md) |
| **Antigravity** | ✅ Ready | [View Guide](./antigravity/README.md) |

> Don't see your favorite tool?
> I encourage you to contribute!

## 🚀 How to Use

Each environment has its own `README.md` file. Pick your favorite editor from the list above and follow the specific instructions in that folder.

## 📝 My modifications

- `ralph_init.sh` scripts that helps prepare the environment for the "Ralph Wiggum" autonomous loop.
- `ralph_deep_init.sh` scripts that helps prepare the environment for the "Ralph Wiggum" autonomous loop in huge projects.

## 🏗️ Deep Initialization (ralph_deep_init)

For complex projects where generating a full backlog in a single pass would hit LLM token limits (truncating `prd.json`), use the **Deep Init** scripts.

**The "Architect-Builder" Workflow:**

1. **Phase 1 (The Architect):** Analyzes the request and "locks in" a plan by identifying 6 distinct functional groups (e.g., Auth, API, Database).
2. **Phase 2 (The Builders):** Iteratively expands each group in separate agent loops, writing safe "partial" task files to avoid context overflow.
3. **Phase 3 (The Assembly):** A bash-controlled merge step combines all partial files into a guaranteed valid `prd.json`.

## 🔄 The Ralph Loop Logic

1. **Analyze** context (read RULES.md, prd.json, and progress log)
2. **Select** highest priority incomplete task from prd.json
3. **Execute** implementation for the selected task
4. **Verify** with tests or typechecks (retry up to 3 times if needed)
5. **Record** success in prd.json (mark task complete) and progress log
6. **Commit** changes to git with descriptive message
7. **Repeat** until all tasks complete or max iterations reached

> [!NOTE]
> I made this for my own use, but I think it's a good idea to share it with the community. PRs are welcome!

## 🤝 Credits

- Inspired by [Matt Pocock's video](https://www.youtube.com/watch?v=_IK18goX4X8)
- Based on the [Ralph workflow by Ghuntley](https://ghuntley.com/ralph/)

### yes

Reddit post where I shared this: <https://www.reddit.com/r/windsurf/comments/1q6y2jz/ralph_wiggum_agent_for_windsurf>
