# Conventional Commits Quick Reference

Conventional Commits is a lightweight convention on top of commit messages.
It provides an easy set of rules for creating an explicit commit history that
powers automated changelog generation and semantic versioning.

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

| Type       | When to use                                      | Version bump |
|------------|--------------------------------------------------|--------------|
| `feat`     | A new feature for the user                       | MINOR        |
| `fix`      | A bug fix for the user                           | PATCH        |
| `docs`     | Documentation changes only                       | —            |
| `style`    | Formatting, whitespace (no logic changes)        | —            |
| `refactor` | Code restructure (not a feature or bug fix)      | —            |
| `perf`     | A performance improvement                        | PATCH        |
| `test`     | Adding or updating tests                         | —            |
| `build`    | Changes to build system or external dependencies | —            |
| `ci`       | Changes to CI/CD configuration files             | —            |
| `chore`    | Other changes that don't modify src or test files| —            |
| `revert`   | Reverts a previous commit                        | —            |

## Breaking Changes → MAJOR bump

Append `!` after the type, or add `BREAKING CHANGE:` in the footer:

```
feat!: remove legacy API endpoint

BREAKING CHANGE: The /v1/users endpoint has been removed. Use /v2/users instead.
```

## Examples

```bash
# Simple feature
git commit -m "feat: add dark mode toggle"

# Bug fix with scope
git commit -m "fix(auth): handle expired JWT tokens correctly"

# Documentation
git commit -m "docs: update API authentication guide"

# Breaking change
git commit -m "feat(api)!: change response envelope format"

# Commit with body and footer
git commit -m "fix(payments): retry failed Stripe webhooks

Previously, failed webhook deliveries were silently dropped.
Now they are retried with exponential backoff up to 5 times.

Closes #142"
```

## Setup: Enforce Conventional Commits

### Option A — commitlint (Node.js projects)

```bash
# Install
npm install --save-dev @commitlint/cli @commitlint/config-conventional

# Configure: commitlint.config.js
echo "export default { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js

# Add to pre-commit-config.yaml (already included in templates/pre-commit-config.yaml)
```

### Option B — pre-commit hook (any project)

Already included in `templates/pre-commit-config.yaml`:

```yaml
- repo: https://github.com/compilerla/conventional-pre-commit
  rev: v3.4.0
  hooks:
    - id: conventional-pre-commit
      stages: [commit-msg]
```

### Option C — git commit template

```bash
# Create the template file
cat > ~/.gitmessage << 'EOF'
# <type>[scope]: <short summary> (max 72 chars)
# |<----  Using a maximum of 72 characters  ---->|
#
# [optional body — explain WHY, not WHAT]
#
# [optional footer: Closes #123, BREAKING CHANGE: ...]
#
# Types: feat fix docs style refactor perf test build ci chore revert
EOF

# Set it as your global commit template
git config --global commit.template ~/.gitmessage
```

## Tools that use Conventional Commits

- **semantic-release** — Fully automated versioning and release
- **python-semantic-release** — Same, for Python projects
- **conventional-changelog** — Generate changelogs
- **release-please** (Google) — GitHub Action that opens release PRs
- **changesets** — Popular in monorepos (used by Remix, etc.)
