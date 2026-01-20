# Ralph Wiggum for Windsurf

This workspace provides a Ralph Wiggum environment for Windsurf/Cascade with skills, workflows, and rules.

## Quick Start (Recommended)

1. **Initialize**
   - Run `@ralph-initialize` or ask: "Set up Ralph for my [project type]"
2. **Develop**
   - Run `@ralph-cycle` to implement one task at a time
3. **Large Projects**
   - Run `@ralph-deep-init` to generate a large, grouped backlog

Skills auto-invoke when the request matches. See `.windsurf/skills/README.md` for full details.

## Workflow-Only Mode (Alternative)

1. Run `/ralph-init` to create:
   - `prd.json`
   - `progress.md`
   - `.windsurf/rules/tech-stack.md`
2. Run `/ralph-cycle` (single task) or `/ralph-batch` (multi-cycle)
3. For deep initialization, run `/ralph-deep-init`

## Core Files (Know These)

- **Backlog:** `prd.json`
- **Backlog template:** `.windsurf/skills/ralph-initialize/prd-template.json`
- **Progress log:** `progress.md`
- **Progress template:** `.windsurf/skills/ralph-initialize/progress-template.md`
- **Rules/stack:** `.windsurf/rules/tech-stack.md`
- **Rules/stack template:** `.windsurf/skills/ralph-initialize/tech-stack-template.md`
- **Agent policy:** `AGENTS.md`

## Where to Look

- **Skills:** `.windsurf/skills/README.md`
- **Workflows:** `.windsurf/workflows/`
- **Rules:** `.windsurf/rules/`

## Notes

- If the tech stack file is missing or outdated, update `.windsurf/rules/tech-stack.md` manually.
- If you need web access, include `@web` in the request.
