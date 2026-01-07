# How to use?

**Requirements**

- `amp` installed
- `jq` installed
- `git` installed

1. Run `ralph_init.sh`
    - Answer the questions, it will create `prd.json`, `progress.md` and populate `.windsurf/rules/tech-stack.md`
    - You can use `--dry` flag to see what command will be executed without actually running it

## Optionals

- Configure `ralph.sh` - I use limit of 10 iterations, but you can change it to your liking. (Didn't have much credits to test without limiting)
- Configure `RULES.md` - AMP generates it with `ralph_init.sh` but you can change it to your liking.
- Configure `prd.json` - is possible to manually write tasks there, but I recommend to use `ralph_init.sh`

## TODO

- Add loading spinner (?)
