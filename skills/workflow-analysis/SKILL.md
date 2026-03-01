# Workflow Analysis Skill

Use this skill when a user invokes `/automate` or asks Claude to analyze their project for automation opportunities. It guides Claude through producing a structured, actionable automation report with complete, copy-paste-ready implementations.

Trigger phrases:
- "automate my workflow"
- "what should I automate"
- "find automation opportunities"
- "improve my CI"
- "set up pre-commit hooks"
- "automate my releases"

---

## Step 1 — Interpret the gathered context

The command will have already gathered live project data. Parse it to build a mental model of:

**Languages** — infer from: `package.json` (JS/TS), `pyproject.toml`/`requirements.txt` (Python), `go.mod` (Go), `Cargo.toml` (Rust), `Gemfile` (Ruby), `composer.json` (PHP), `pom.xml`/`build.gradle` (Java).

**Package managers** — `package-lock.json`→npm, `yarn.lock`→yarn, `pnpm-lock.yaml`→pnpm, `bun.lockb`→bun, `poetry.lock`→poetry, `Pipfile`→pipenv.

**Frameworks** — look inside `package.json` dependencies for react, next, vue, svelte, express; look inside Python config for django, fastapi, flask.

**Existing automation** — note what IS already present: CI workflows, pre-commit config, Dependabot, task runners, Docker.

**Missing automation** — note what is ABSENT that should be there.

---

## Step 2 — Ask at most 3 targeted questions

Only ask questions about things you genuinely cannot infer from the context. Good candidates:

- "What are the most repetitive tasks you do in this project day-to-day?"
- "Do you have any manual steps before you deploy or cut a release?"
- "Are there quality checks (lint, test, format) you sometimes forget to run?"

Skip questions if the context already answers them. Never ask more than 3.

---

## Step 3 — Produce the Workflow Automation Report

Apply the user's optional focus area (`$ARGUMENTS`) to order and filter suggestions. Then output the full report using this structure:

---

## Workflow Automation Report

### Detected Stack

List: languages · frameworks · package managers · CI system · existing tools · what's missing.

---

### Automation Opportunities

For each opportunity use this exact format:

#### [PRIORITY: High | Medium | Low] — <Title>

**Problem:** One sentence describing the current manual pain.
**Solution:** One sentence describing the automation.
**Effort:** Tiny (< 5 min) | Small (< 30 min) | Medium (< 2 hours)

<details>
<summary>Implementation — click to expand</summary>

Provide the complete, working implementation:
- Shell scripts with `#!/usr/bin/env bash` and inline comments
- Full YAML files (no placeholders without explanation)
- Config files with every required field filled in
- Exact `npm install`, `pip install`, or `brew install` commands to set it up
- The file path where the snippet should be saved

</details>

---

Cover every applicable category from the checklist below. Skip categories that clearly don't apply.

### Automation Checklist

**Git workflow**
- [ ] Pre-commit hooks (lint, format, type-check, secrets scan before every commit)
- [ ] Commit message enforcement (conventional commits via commitlint or pre-commit hook)
- [ ] Branch naming convention (enforced via hook)
- [ ] Automated changelog generation on release
- [ ] Auto-tagging on version bump

**Code quality**
- [ ] Linter on save / pre-commit (ESLint, Ruff, golangci-lint, clippy)
- [ ] Auto-formatter (Prettier, Ruff format, gofmt, rustfmt)
- [ ] Type checking (tsc --noEmit, mypy)
- [ ] Dead code / unused import detection

**Testing**
- [ ] Watch mode during development
- [ ] Coverage threshold enforced in CI
- [ ] Fail-fast on first failure in CI

**CI/CD**
- [ ] Build caching (node_modules, pip, cargo, go module cache)
- [ ] Matrix builds across versions/OSes
- [ ] Preview deployments on PRs
- [ ] Auto-deploy to staging on merge to main
- [ ] Security scan in CI (Trivy, gitleaks)

**Dependency management**
- [ ] Automated dependency update PRs (Dependabot or Renovate)
- [ ] GitHub Actions version pinning and updates
- [ ] Vulnerability scanning (npm audit, pip-audit, cargo audit)
- [ ] License compliance check

**Releases & versioning**
- [ ] Semantic versioning from conventional commits
- [ ] Automated release notes / changelog
- [ ] Package publishing (npm publish, PyPI, crates.io)
- [ ] Docker image tagging and push on release

**Developer environment**
- [ ] `.devcontainer` / Codespaces setup
- [ ] `.env.example` with validation on startup
- [ ] DB seed and reset scripts
- [ ] One-command project bootstrap

**Documentation**
- [ ] Auto-generated API docs (JSDoc, Sphinx, godoc)
- [ ] README badges (build, coverage, version)
- [ ] Stale doc detection

**Notifications**
- [ ] Slack/Discord webhook on deploy
- [ ] Failure alerts from CI

**Housekeeping**
- [ ] Automated cleanup of build artifacts
- [ ] Log rotation
- [ ] Scheduled cache/temp file purge

---

### Quick Wins — Do These Today

A numbered list of the 3 highest-impact, lowest-effort items from above, each with the exact command(s) needed to get started.

### Suggested Aliases & Shortcuts

Shell aliases, git aliases, and any editor shortcuts the user can paste into their config right now.

### Action Plan

**Today** (< 5 min each):
1. …

**This week** (< 2 hours each):
1. …

**This month** (larger investments):
1. …

---

## Guidance for Implementations

- Be concrete: every suggestion must include working code, not pseudocode.
- Be opinionated: recommend one specific tool rather than listing five options.
- Prefer widely-adopted, well-maintained tools: `pre-commit`, GitHub Actions, Dependabot, `semantic-release` / `python-semantic-release`, Taskfile.
- Prefer GitHub Actions for CI unless another system is already in use.
- Prefer `pre-commit` framework for git hooks unless the stack makes another tool obvious.
- When suggesting a GitHub Actions workflow, always include `concurrency:` to cancel stale runs.
- Reference `templates/` files (in the plugin's `templates/` directory) when a ready-made template already covers the need; tell the user to copy it.
