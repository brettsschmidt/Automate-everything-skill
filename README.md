# Workflow Automator — Claude Code Plugin

A Claude Code plugin that analyzes your project's tech stack, identifies automation gaps, and delivers a prioritized report with **ready-to-copy implementations** for every suggestion.

## Installation

```bash
# Install locally for development / testing
claude --plugin-dir /path/to/Automate-everything-skill
```

## Usage

Open any project in Claude Code and run:

```
/automate
```

Optionally focus on a specific area:

```
/automate ci
/automate git hooks
/automate releases
/automate testing
```

## What It Does

1. **Scans your project** — reads live data: directory listing, package manifests, CI files, git hooks, Dockerfiles, and recent commits
2. **Asks at most 3 questions** about things it couldn't infer
3. **Produces a Workflow Automation Report** with:
   - Your detected tech stack
   - Prioritized opportunities (High / Medium / Low) with full working implementations
   - Quick wins to do today (< 5 min each)
   - Shell & git aliases to add right now
   - A "Today / This Week / This Month" action plan

## Plugin Structure

```
.claude-plugin/
  plugin.json              ← Plugin manifest
commands/
  automate.md              ← /automate slash command (live context + task)
skills/
  workflow-analysis/
    SKILL.md               ← Analysis logic loaded by the command
scripts/
  detect-stack.sh          ← Standalone stack detector (outputs JSON)
  suggest.sh               ← Standalone suggestion printer
templates/
  pre-commit-config.yaml   ← Pre-commit hooks (all major stacks)
  github-actions-ci.yml    ← CI pipeline (Node / Python / Go / Rust)
  github-actions-release.yml  ← Semantic release + optional publishing
  github-actions-auto-merge.yml ← Auto-merge safe Dependabot PRs
  dependabot.yml           ← Weekly dependency + Actions updates
  Taskfile.yml             ← Unified task runner
  aliases.sh               ← Shell & git aliases
  conventional-commits.md  ← Commit convention guide + enforcement
README.md
```

## Automation Categories Covered

| Category | Examples |
|----------|---------|
| **Git workflow** | Pre-commit hooks, commit message enforcement, auto-tagging |
| **Code quality** | Lint, format, type-check on every commit |
| **Testing** | Watch mode, coverage thresholds, fail-fast CI |
| **CI/CD** | Dependency caching, matrix builds, preview deploys, auto-deploy |
| **Dependencies** | Dependabot, Renovate, vulnerability scanning, license checks |
| **Releases** | Semantic versioning, auto-changelog, npm/PyPI/Docker publishing |
| **Dev environment** | Devcontainers, env var validation, DB seed/reset |
| **Documentation** | Auto-generated API docs, stale doc detection, README badges |
| **Notifications** | Slack/Discord webhooks on deploy, failure alerts |
| **Housekeeping** | Build artifact cleanup, log rotation, cache purge |

## Standalone Scripts

The detection and suggestion scripts work independently of Claude Code:

```bash
# Print a JSON profile of your project's stack
bash scripts/detect-stack.sh

# Get automation suggestions (reads stack JSON from stdin)
bash scripts/detect-stack.sh | bash scripts/suggest.sh

# Analyze a specific directory
bash scripts/detect-stack.sh /path/to/project | bash scripts/suggest.sh
```

Example output:

```
╔══════════════════════════════════════════════════════════╗
║          Workflow Automation Suggestions                 ║
╚══════════════════════════════════════════════════════════╝

   1. [pre-commit-hooks    ] Install the pre-commit framework to run linters/formatters before every commit.
   2. [dependabot          ] Add .github/dependabot.yml to auto-update dependencies weekly.
   3. [ruff                ] Use Ruff for lightning-fast Python linting and formatting.
   4. [mypy                ] Add mypy for static type checking.
   5. [taskfile            ] Add a Taskfile.yml to unify dev commands: test, lint, build, deploy.
```

## Templates

Every suggestion in the report references a ready-made template in `templates/`. Copy the relevant file into your project:

| Template | Purpose |
|----------|---------|
| `pre-commit-config.yaml` | Drop-in pre-commit config for JS/TS, Python, Go, Rust |
| `github-actions-ci.yml` | Parallel CI with caching and security scanning |
| `github-actions-release.yml` | Fully automated semantic release + publishing |
| `github-actions-auto-merge.yml` | Auto-merge safe Dependabot patch/minor PRs |
| `dependabot.yml` | Weekly dependency + GitHub Actions updates |
| `Taskfile.yml` | Unified task runner with dev, lint, test, build targets |
| `aliases.sh` | Shell, git, npm, Python, Docker aliases |
| `conventional-commits.md` | Commit convention guide with three enforcement options |

## Stack Support

| Language | Linting | Formatting | Testing | CI template |
|----------|---------|------------|---------|-------------|
| JavaScript / TypeScript | ESLint | Prettier | Jest / Vitest | ✓ |
| Python | Ruff | Ruff | pytest | ✓ |
| Go | golangci-lint | gofmt | go test | ✓ |
| Rust | Clippy | rustfmt | cargo test | ✓ |

## Contributing

To add a new automation category:

1. Add detection logic to `scripts/detect-stack.sh`
2. Add suggestion logic to `scripts/suggest.sh`
3. Add a template file to `templates/`
4. Add the category to the checklist in `skills/workflow-analysis/SKILL.md`

## Author

Brett Schmidt · v0.1.0 · MIT License
