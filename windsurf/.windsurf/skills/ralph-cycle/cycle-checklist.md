# Ralph Cycle Checklist

Use this quick reference during each development cycle.

## Pre-Implementation

- [ ] Read `prd.json` and identify failing tasks
- [ ] Select ONE task based on dependencies and logical order (do not skip unless blocked)
- [ ] Review acceptance criteria for the selected task
- [ ] Append planning entry to `progress.md`

## Implementation

- [ ] Create/modify only files relevant to this task
- [ ] Follow conventions in `.windsurf/rules/tech-stack.md`
- [ ] Implement all acceptance criteria
- [ ] Add appropriate tests if required

## Verification

- [ ] Run verification command from `.windsurf/rules/tech-stack.md` (or infer minimal verification and log it)
- [ ] All tests pass
- [ ] No linting errors
- [ ] Acceptance criteria are met

## Completion

- [ ] Update `prd.json`: set task `passes: true`
- [ ] Update `progress.md`: append "**Result:** Success"
- [ ] Stage changes: `git add .`
- [ ] Commit: `git commit --no-gpg-sign -m "feat: [description]"`

## Troubleshooting

**Tests Failing?**

- Review error output carefully
- Fix the specific issue
- Re-run tests
- Retry up to 3 times before documenting failure and next hypothesis in `progress.md`

**Unclear Requirements?**

- Re-read acceptance criteria in `prd.json`
- Check previous entries in `progress.md`
- Ask user for clarification

**Blocked by Dependencies?**

- Select a different task that is unblocked
- Document the blocking relationship in `progress.md`
