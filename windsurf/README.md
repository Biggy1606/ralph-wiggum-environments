# Ralph Wiggum for Windsurf

Set Cascade to `Code` mode, select AI model of your choice.

**Important:** Better model (more expensive) = better results.

## Quick Start

### Standard Initialization

1. Run `/ralph-init` in Cascade chat
    * Answer the questions, it will create `prd.json`, `progress.md` and populate `.windsurf/rules/tech-stack.md`

### Deep Initialization (Large Projects)

1. Run `/ralph-deep-init` in Cascade chat
    * Uses the **Architect-Builder** workflow
    * Creates 6 architectural groups, then expands each into 3-5 tasks
    * Generates larger `prd.json` files through isolated partial files

### Run Ralph

1. Execute the autonomous loop:
    * Run `/ralph-batch` in Cascade (multi-cycle)
    * Run `/ralph-cycle` in Cascade (single-cycle)

## Using Skills (Recommended)

Skills provide intelligent, context-aware assistance with supporting resources:

1. **Initialize:** `@ralph-initialize` or just ask "Set up Ralph for my [project type]"
2. **Develop:** `@ralph-cycle` to implement tasks incrementally
3. **Complex Projects:** `@ralph-deep-init` for large backlogs with architectural organization

Skills automatically invoke when needed - just describe what you want to do.

See `.windsurf/skills/README.md` for complete documentation.

## Using Workflows (Alternative)

1. Run `/ralph-init` in Cascade chat
    * Answer the questions, it will create `prd.json`, `progress.md` and populate `.windsurf/rules/tech-stack.md`
2. Run Ralph
    A. Run `/ralph-batch` in Cascade (multi-cycle)
    B. Run `/ralph-cycle` in Cascade (single-cycle)

## Configuration

* Configure `hooks.json` to add your own.

## Known Issues

* Often `.windsurf/rules/tech-stack.md` is not updated by `/ralph-init`. You may need to update it manually.
* Sometimes Ralph requires user input to continue.
* If you want Ralph to use web, use `@web` next to the command.
