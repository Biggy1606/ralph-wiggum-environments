# Windsurf Ralph Environment (v2)

> *"I'm helping!"* — Ralph Wiggum

Ralph transforms Windsurf/Cascade into an autonomous task executor via a feedback loop with a persistent task list.

---

## Structure

```
windsurf-v2/
└── .windsurf/
    ├── rules/
    │   └── ralph.md                          # Core Ralph persona (model_decision trigger)
    ├── skills/
    │   ├── ralph-executor/SKILL.md           # Detailed execution protocol
    │   ├── ralph-init/SKILL.md               # File creation templates
    │   ├── ralph-deep-init/SKILL.md          # Architect-Builder pattern
    │   └── ralph-project-ops/SKILL.md        # Shared project modification patterns
    └── workflows/
        ├── ralph-init.md                     # Initialize Ralph environment
        ├── ralph-loop.md                     # Run the autonomous loop
        ├── ralph-deep-init.md                # Deep init for large projects
        ├── ralph-add-task.md                 # Add tasks to existing project
        ├── ralph-pivot.md                    # Change project direction
        └── ralph-revise.md                   # Surgical edits to objectives/files
```

---

## Installation

Copy `.windsurf/` to your project root:

```bash
cp -r .windsurf/ /path/to/your/project/
```

---

## Usage

In Cascade Panel (`Ctrl+L` / `Cmd+L`):

### Initialize a project

```
# Small/medium project
/ralph-init "Build a REST API with JWT authentication"

# Large project (20+ tasks, multiple domains)
/ralph-deep-init "Build a complete e-commerce platform"
```

### Run the autonomous loop

```
/ralph-loop
```

### Add a new task to an existing project

```
/ralph-add-task "Add rate limiting to all API endpoints"
```

Does not touch existing tasks. Assigns next sequential task ID, infers priority and dependencies from project context.

### Change project direction (pivot)

```
/ralph-pivot "Switch from REST to GraphQL"
```

Cancels obsolete tasks (keeps them for traceability), updates `AGENTS.md`, adds new tasks. Shows impact summary before making changes. Warns if any task is `in-progress`.

### Modify objectives or generated files (revise)

```
/ralph-revise "The acceptance criteria for task-003 are too vague, make them binary"
/ralph-revise "Add TypeScript strict mode to AGENTS.md code style"
/ralph-revise "task-007 is no longer needed"
```

Surgical edits only — does not regenerate files. Warns before touching `complete` or `in-progress` tasks. Offers to add a corrective task if a `complete` task's criteria change.

---

## Workflow Decision Guide

| Scenario | Workflow |
|----------|----------|
| Fresh project, no files yet | `/ralph-init` |
| Fresh project, 20+ tasks, multiple domains | `/ralph-deep-init` |
| Execute pending tasks | `/ralph-loop` |
| Add work item to existing project | `/ralph-add-task` |
| Major direction change (stack, scope, audience) | `/ralph-pivot` |
| Fix criteria, update constraints, cancel a task | `/ralph-revise` |

---

## What Ralph Creates

| File | Purpose |
|------|---------|
| `AGENTS.md` | Project context: commands, stack, standards, git workflow |
| `prd.json` | Task list with priorities, dependencies, acceptance criteria |
| `progress.log` | Append-only execution history |

---

## Design Decisions

### Why `model_decision` trigger on the rule?

The existing `windsurf/` implementation uses `trigger: manual`, requiring explicit `@ralph` mention. `model_decision` with a clear `description` lets Cascade activate Ralph automatically when the user invokes a Ralph workflow — one less friction point.

**Trade-off:** `model_decision` means Ralph activates based on Cascade's judgment, which could misfire. If the rule is activating in contexts where it shouldn't, switch to `trigger: manual`.

### Why three skills instead of one fat rule?

Skills in `.windsurf/skills/` are loaded only when invoked. This keeps context lean when Ralph is not running. The rule stays compact (always potentially loaded); verbose execution detail lives in `ralph-executor/SKILL.md` and is only pulled in during loop execution.

**Trade-off:** More files to maintain. If Windsurf's skill loading proves unreliable or the context overhead is acceptable, consolidating into the rule is simpler.

### Why detailed workflows?

The existing `windsurf/` workflows are skeletal (12 lines for `ralph-loop.md`). The model gets too little guidance and must infer the protocol. Detailed workflows are self-contained — even if skill loading fails, the workflow itself is actionable.

**Trade-off:** Longer workflows consume more context tokens per invocation. This is acceptable because workflows are short-lived (loaded once, executed, discarded).

### Why `AGENTS.md` instead of `RULES.md`?

The existing `windsurf/` implementation references `RULES.md` throughout — this is wrong. `AGENTS.md` is the universal standard readable by 20+ AI coding tools (Cursor, Claude Code, Amp, GitHub Copilot, etc.). Ralph's core value proposition is the universal format; breaking it defeats the purpose.

---

## Critical Limitations

### Windsurf has no native skill invocation syntax

Unlike Claude Code (`/skill-name`) or Antigravity, Windsurf has no documented `@skill-name` invocation syntax. Skills in `.windsurf/skills/` are referenced by convention — the workflow text says "Load the `@ralph-executor` skill" but there is no guaranteed mechanism for Cascade to discover and inject that file automatically.

**Mitigation:** The workflows are written to be self-sufficient even without skill loading. The skills act as reference documents that Cascade may or may not load. If skills are not loading, manually reference them with `@ralph-executor` in the Cascade panel before running the loop.

### No per-task token budget control

Ralph may run many tasks in sequence, accumulating context. Windsurf has no native mechanism to reset context between tasks (unlike Claude Code's `--continue` flag). For very long loops, context degradation is a real risk.

**Mitigation:** Use `ralph-deep-init` to break large projects into manageable batches, or restart the loop periodically with `/ralph-loop`.

### Workflow `$ARGUMENTS` support is unverified

The `RALPH_IMPLEMENTATION.md` suggests workflows support `$ARGUMENTS`. The existing `windsurf/` implementation uses this in `ralph-init.md`. Windsurf's workflow spec (as of the time of writing) does not explicitly document `$ARGUMENTS` substitution. The workflows here do not rely on it — they prompt the user for input directly instead.

---

## Comparison with `windsurf/` (original)

| Aspect | `windsurf/` | `windsurf-v2/` |
|--------|------------|----------------|
| Context file | `RULES.md` ❌ | `AGENTS.md` ✅ |
| Rule trigger | `manual` | `model_decision` + description |
| Skills | None | 3 skills (executor, init, deep-init) |
| `ralph-loop.md` | 12 lines, vague | Detailed 7-step protocol |
| `ralph-init.md` | 12 lines, vague | Full file templates in skill |
| `ralph-deep-init.md` | 18 lines, vague | Full 3-phase protocol in skill |
| Workflow frontmatter | Missing | `description:` field present |
| Task selection algorithm | Not specified | Explicit in rule |
| Error handling | Not specified | Explicit halt + log protocol |
| Acceptance criteria enforcement | Not specified | Required before marking complete |
