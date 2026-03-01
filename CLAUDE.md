# Automate Everything — Claude Code Plugin

This repository provides the `/automate` skill for Claude Code.
When a user types `/automate` in any project, Claude will:

1. Detect the project's tech stack
2. Identify automation gaps
3. Produce a prioritized report with ready-to-copy implementations

## Available Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| Workflow Automator | `/automate` | Analyzes your project and suggests workflow automations |

## Project Layout

```
.claude/skills/
  automate.md          ← Skill prompt definition
scripts/
  detect-stack.sh      ← Detects languages, tools, and CI systems
  suggest.sh           ← Prints automation suggestions from stack JSON
templates/
  pre-commit-config.yaml       ← Pre-commit hook config (all stacks)
  github-actions-ci.yml        ← CI pipeline (Node/Python/Go/Rust)
  github-actions-release.yml   ← Automated semantic release
  github-actions-auto-merge.yml← Auto-merge Dependabot PRs
  dependabot.yml               ← Dependabot config
  Taskfile.yml                 ← Unified task runner
  aliases.sh                   ← Shell & git aliases
  conventional-commits.md      ← Conventional commits guide + setup
```

## Using the Scripts Standalone

```bash
# Detect your current project's stack (outputs JSON)
bash scripts/detect-stack.sh

# Get automation suggestions for the current project
bash scripts/detect-stack.sh | bash scripts/suggest.sh

# Detect a different project
bash scripts/detect-stack.sh /path/to/project | bash scripts/suggest.sh
```
