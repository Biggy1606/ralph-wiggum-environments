# How to use?

Set Cascade to `Code` mode, select AI model of your choice.

**Important** Better model (more expensive) = better results.

1. Run `/init-ralph` in Cascade chat
    * Answer the questions, it will create `prd.json`, `progress.md` and populate `.windsurf/rules/tech-stack.md`
2. Run Ralph
    A. Run `/ralph-batch` in Cascade (multi-cycle)
    B. Run `/ralph-cycle` in Cascade (single-cycle)

## Optionals

* Configure `hooks.json` to add your own.

## Issues

* Often `.windsurf/rules/tech-stack.md` is not updated by `/init-ralph`. You have to do it manually.
* Sometimes Ralph require user input to continue.
* If you want Ralph to use web, use `@web` next to the command.
