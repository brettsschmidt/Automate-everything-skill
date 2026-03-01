# Automate Everything — Claude Code Plugin

A Claude Code plugin that analyzes your project, identifies automation gaps, and delivers a prioritized report with **ready-to-copy implementations** for every suggestion.

## Quick Start

```bash
# 1. Clone the plugin
git clone https://github.com/your-org/Automate-everything-skill ~/.claude/plugins/automate

# 2. Register it in your global Claude config (~/.claude/settings.json)
{
  "skillPaths": ["~/.claude/plugins/automate/.claude/skills"]
}

# 3. Open any project in Claude Code and run:
/automate
```

## What It Does

Type `/automate` in Claude Code and the plugin will:

1. **Scan your project** — detects languages, frameworks, package managers, CI systems, and existing tooling
2. **Ask targeted questions** — at most 3 questions about things it couldn't infer
3. **Produce an Automation Report** with:
   - Prioritized list of automation opportunities (High / Medium / Low)
   - Complete, working implementations for each (scripts, YAML, configs)
   - Quick wins to do today
   - Shell aliases you can add immediately
   - A "Today / This Week / This Month" action plan

## Automation Categories Covered

| Category | Examples |
|----------|---------|
| **Git workflow** | Pre-commit hooks, commit message enforcement, auto-tagging |
| **Code quality** | Linting, formatting, type-checking on every commit |
| **Testing** | Watch mode, coverage thresholds, fail-fast CI |
| **CI/CD** | Dependency caching, matrix builds, preview deployments, auto-deploy |
| **Dependencies** | Dependabot, Renovate, vulnerability scanning, license checks |
| **Releases** | Semantic versioning, auto-changelog, npm/PyPI publishing |
| **Dev environment** | Devcontainers, env var validation, DB seed/reset scripts |
| **Documentation** | Auto-generated API docs, stale doc detection, badge updates |
| **Notifications** | Slack/Discord webhooks on deploy, error alerting |
| **File operations** | Automated backups, log rotation, build artifact cleanup |

## Templates

Ready-to-use configuration files in `templates/`:

| File | Purpose |
|------|---------|
| `pre-commit-config.yaml` | Pre-commit hooks for all major stacks |
| `github-actions-ci.yml` | CI pipeline (Node, Python, Go, Rust) |
| `github-actions-release.yml` | Automated semantic release + publishing |
| `github-actions-auto-merge.yml` | Auto-merge safe Dependabot PRs |
| `dependabot.yml` | Weekly dependency update PRs |
| `Taskfile.yml` | Unified task runner (`task dev`, `task check`, etc.) |
| `aliases.sh` | Shell & git aliases for daily productivity |
| `conventional-commits.md` | Commit convention guide + enforcement setup |

## Standalone Scripts

The detection and suggestion scripts work without Claude Code:

```bash
# Print a JSON profile of your project's stack
bash scripts/detect-stack.sh

# Get automation suggestions (reads stack JSON from stdin)
bash scripts/detect-stack.sh | bash scripts/suggest.sh

# Analyze a specific directory
bash scripts/detect-stack.sh /path/to/project | bash scripts/suggest.sh
```

### Example output

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

## Stack Support

| Language | Linting | Formatting | Testing | CI template |
|----------|---------|------------|---------|-------------|
| JavaScript / TypeScript | ESLint | Prettier | Jest / Vitest | ✓ |
| Python | Ruff | Ruff | pytest | ✓ |
| Go | golangci-lint | gofmt | go test | ✓ |
| Rust | Clippy | rustfmt | cargo test | ✓ |
| PHP | — | — | — | partial |
| Ruby | — | — | — | partial |
| Java | — | — | — | partial |

## How Suggestions Are Prioritized

- **High** — Zero-effort quality gates that prevent bugs from reaching main (pre-commit hooks, CI)
- **Medium** — Automation that saves meaningful time each week (Dependabot, task runners)
- **Low** — Nice-to-haves with lower ROI or higher setup effort (advanced monitoring, doc generation)

## Contributing

Suggestions and PRs welcome. To add a new automation category:

1. Add detection logic to `scripts/detect-stack.sh`
2. Add suggestion logic to `scripts/suggest.sh`
3. Add a template file to `templates/`
4. Document the new category in `.claude/skills/automate.md`

## License

MIT
