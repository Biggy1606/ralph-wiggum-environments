# AI Coding Tools & Approaches Research

A comprehensive overview of modern tools, conventions, and approaches used in AI coding assistants (Windsurf, Cursor, Claude Code, OpenCode, AMP, etc.).

---

## The AGENTS.md Standard

**AGENTS.md** is emerging as the universal convention for AI coding agents - a simple, open format for guiding coding agents, similar to how README.md serves human contributors.

### Why AGENTS.md?

- **Separation of concerns**: README.md is for humans; AGENTS.md is for AI agents
- **Cross-tool compatibility**: One file works across 20+ AI coding tools
- **Predictable location**: Agents know where to find instructions

### Supported Tools

- OpenAI Codex, Google Jules, Cursor, Windsurf, Amp, Devin
- Aider, Goose, Zed, Warp, VS Code, RooCode
- GitHub Copilot Coding Agent, Gemini CLI, Kilo Code, Phoenix, Semgrep

### Recommended Content Structure

```markdown
# Project Name

## Project Overview
Brief description of architecture and purpose

## Build & Test Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Code Style Guidelines
- TypeScript strict mode
- Functional components for React
- Snake_case for database columns

## Project Structure
- `packages/` - Workspace packages
- `src/` - Source code organization

## Testing Instructions
Test framework and coverage requirements

## Security Considerations
API key handling, sensitive data patterns
```

---

## Tool-Specific Conventions

### Claude Code (Anthropic)

**Memory System** - Three-tier hierarchy:

```
./CLAUDE.md              # Project memory
./.claude/CLAUDE.md      # Alternative project location
./.claude/rules/*.md     # Modular rules
~/.claude/CLAUDE.md      # User-level preferences
~/.claude/projects/<project>/memory/MEMORY.md  # Auto-memory
```

**Skills System** (`~/.claude/skills/<skill-name>/SKILL.md`):

```yaml
---
name: /slash-command
description: When to use this skill
---

Skill instructions in markdown...
```

**Key Features**:

- **Progressive disclosure**: Skills load only when relevant
- **Path-specific rules**: Apply to specific file patterns
- **Auto-memory**: Claude remembers conversation context
- **Subagents**: Run skills in isolated contexts

---

### Windsurf (Codeium/Cognition)

**Memories & Rules System**:

```
~/.codeium/windsurf/global_rules.md    # Global rules
./.windsurf/rules/                     # Workspace rules
  ├── coding.md
  ├── testing.md
  └── security.md
./.windsurf/rules/subdir/              # Subdirectory-specific rules
```

**Skills** (`.windsurf/skills/<skill-name>/SKILL.md`):

- Bundle prompts, templates, scripts, checklists
- Progressive disclosure for intelligent invocation
- Multi-step workflow automation

**Workflows** (`.windsurf/workflows/<name>.md`):

```yaml
---
description: Short title
---
Step-by-step instructions for the workflow
```

**Key Features**:

- **Cascade agent**: Deep codebase understanding
- **Hooks**: Pre/post action hooks for automation
- **Worktrees**: Isolated git worktrees for parallel work
- **Codemaps**: Code structure visualization

---

### Cursor

**Rules System**:

```
.cursor/rules/                    # Project rules (recommended)
  ├── code-style.md
  └── testing.md
.cursorrules                      # Legacy (being deprecated)
AGENTS.md                         # Simple alternative
```

**Rule Format**:

```yaml
---
description: "Rule description"
globs: ["src/**/*.ts"]           # File patterns
alwaysApply: false               # Auto-apply or manual
---

Rule content...
```

**Rule Types**:

1. **Always Apply**: Included in every request
2. **Agent-Decided**: AI decides when to apply based on description
3. **Manual**: Invoked via @mention

**Team Rules**: Dashboard-managed rules for organizations with enforcement options

**Key Features**:

- **@-mentions**: Reference files, docs, URLs
- **Agent Skills**: Import from open standard
- **Remote Rules**: Import from GitHub repos

---

### OpenCode

**Rules System**:

```
./AGENTS.md                       # Project rules
~/.config/opencode/AGENTS.md      # Global rules
./CLAUDE.md                       # Claude Code compatibility fallback
~/.claude/CLAUDE.md               # Claude Code global fallback
```

**Agents System** (`.opencode/agents/<name>.md`):

```yaml
---
description: Agent purpose
model: claude-3-5-sonnet
temperature: 0.7
tools: [read, write, execute]
---

Agent system prompt...
```

**Built-in Agents**:

- `build` - Code implementation
- `plan` - Analysis without changes
- `explore` - Codebase navigation
- `general` - Default assistant

---

### Amp (Sourcegraph)

**Characteristics**:

- **IDE freedom**: Works in any editor
- **Model flexibility**: Choose any LLM provider
- **Thread sharing**: Collaborate on conversations
- **Enterprise focus**: Audit logs, compliance

**Configuration**:

- Uses AGENTS.md standard
- Supports multiple model providers
- Thread-based collaboration

---

## Comparison Matrix

| Feature | Claude Code | Windsurf | Cursor | OpenCode | Amp |
|---------|-------------|----------|--------|----------|-----|
| **Rules File** | CLAUDE.md | .windsurf/rules/ | .cursor/rules/ | AGENTS.md | AGENTS.md |
| **Skills** | ✅ SKILL.md | ✅ SKILL.md | ✅ Agent Skills | ✅ Agents | ❌ |
| **Memory** | ✅ Auto-memory | ✅ Memories | ❌ | ❌ | ❌ |
| **AGENTS.md** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Team Rules** | ❌ | ✅ Enterprise | ✅ Teams | ❌ | ✅ |
| **Hooks** | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Workflows** | ❌ | ✅ | ❌ | ✅ Modes | ❌ |
| **Subagents** | ✅ | ✅ | ❌ | ✅ | ❌ |

---

## Best Practices

### Rule Writing Guidelines

1. **Be specific, not generic**: "Use Zod for all API validation" > "Validate inputs"
2. **One topic per file**: `testing.md`, `api-design.md`, not `rules.md`
3. **Include examples**: Show expected patterns
4. **Define boundaries**: What NOT to do
5. **Keep rules focused**: 20-50 rules optimal per Arize research

### Content to Cover

Based on GitHub's analysis of 2,500+ repositories:

1. **Commands**: Build, test, lint, deploy
2. **Testing**: Framework, coverage, patterns
3. **Project Structure**: Directory layout, conventions
4. **Code Style**: Language-specific patterns
5. **Git Workflow**: Branch naming, PR conventions
6. **Boundaries**: What to avoid, security considerations

### Optimization Tips (from Arize Research)

Ruleset optimization alone improved GPT-4.1 performance by 10-15% on SWE-bench:

- Ensure code modifications preserve correctness
- Avoid "quick fix" solutions that hide errors
- Maintain backwards/forwards compatibility
- Keep error messages technically accurate
- Never silently discard user data or hooks

---

## File Naming Conventions Summary

| Convention | Purpose | Tools |
|------------|---------|-------|
| `AGENTS.md` | Universal agent instructions | All tools |
| `CLAUDE.md` | Claude Code project memory | Claude Code, OpenCode |
| `MEMORY.md` | Session memory index | Claude Code |
| `SKILL.md` | Reusable skill definition | Claude Code, Windsurf |
| `.cursorrules` | Legacy Cursor rules | Cursor (deprecated) |
| `global_rules.md` | Global user preferences | Windsurf |

---

## When to Use What

### Simple Projects

→ Use **AGENTS.md** alone with build commands and code style

### Team Projects

→ Add **.cursor/rules/** or **.windsurf/rules/** for modular rules

### Complex Workflows

→ Create **Skills** with supporting files (templates, scripts, examples)

### Enterprise/Compliance

→ Use **Team Rules** with enforcement + **System-Level Rules**

### Multi-Step Processes

→ Create **Workflows** with step-by-step instructions

---

## Key Takeaways

1. **AGENTS.md is becoming the standard** - Adopt it for cross-tool compatibility
2. **Rules improve accuracy 10-15%** - Worth investing time to optimize
3. **Progressive disclosure matters** - Only load relevant context
4. **Separate concerns** - Different files for different purposes
5. **Iterate on rules** - Add detail when agents make mistakes
