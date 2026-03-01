#!/usr/bin/env bash
# suggest.sh — Print automation suggestions based on detect-stack output.
# Usage: bash scripts/detect-stack.sh | bash scripts/suggest.sh
#    or: bash scripts/suggest.sh path/to/stack.json

set -euo pipefail

if [[ -n "${1-}" ]]; then
  STACK=$(cat "$1")
else
  STACK=$(cat)
fi

has_tool()     { echo "$STACK" | jq -e --arg t "$1" '.tools[] | select(. == $t)' &>/dev/null; }
missing()      { echo "$STACK" | jq -e --arg t "$1" '.missing_automation[] | select(. == $t)' &>/dev/null; }
has_lang()     { echo "$STACK" | jq -e --arg l "$1" '.languages[] | select(. == $l)' &>/dev/null; }
has_framework(){ echo "$STACK" | jq -e --arg f "$1" '.frameworks[] | select(. == $f)' &>/dev/null; }
has_ci()       { echo "$STACK" | jq -e --arg c "$1" '.ci_systems[] | select(. == $c)' &>/dev/null; }

SUGGESTIONS=()

# ── Git hooks ─────────────────────────────────────────────────────────────────
if missing "pre-commit-hook"; then
  SUGGESTIONS+=("pre-commit-hooks: Install the pre-commit framework to run linters/formatters before every commit.")
fi

# ── Dependency updates ────────────────────────────────────────────────────────
if missing "dependabot" && missing "renovate"; then
  if has_ci "github-actions"; then
    SUGGESTIONS+=("dependabot: Add .github/dependabot.yml to auto-update dependencies weekly.")
  else
    SUGGESTIONS+=("renovate: Add renovate.json for automated dependency update PRs.")
  fi
fi

# ── Language-specific ─────────────────────────────────────────────────────────
if has_lang "javascript" || has_lang "typescript"; then
  has_tool "eslint"   || SUGGESTIONS+=("eslint: Add ESLint to catch JS/TS errors automatically.")
  has_tool "prettier" || SUGGESTIONS+=("prettier: Add Prettier for zero-config code formatting.")
  has_tool "jest" || has_tool "vitest" || SUGGESTIONS+=("testing: Add Vitest (fast, modern) for unit testing.")
fi

if has_lang "python"; then
  has_tool "ruff"  || has_tool "black" || SUGGESTIONS+=("ruff: Use Ruff for lightning-fast Python linting and formatting.")
  has_tool "mypy"  || SUGGESTIONS+=("mypy: Add mypy for static type checking.")
  has_tool "pytest"|| SUGGESTIONS+=("pytest: Use pytest for Python testing with rich plugin ecosystem.")
fi

if has_lang "go"; then
  SUGGESTIONS+=("golangci-lint: Run golangci-lint in CI with a .golangci.yml config.")
fi

if has_lang "rust"; then
  SUGGESTIONS+=("clippy: Add cargo clippy and cargo fmt checks in CI.")
fi

# ── CI/CD ─────────────────────────────────────────────────────────────────────
if ! has_ci "github-actions" && ! has_ci "gitlab-ci" && ! has_ci "circleci"; then
  SUGGESTIONS+=("ci: No CI system detected. Add GitHub Actions for automated testing on every push.")
fi

# ── Task runner ───────────────────────────────────────────────────────────────
has_tool "make" || has_tool "task" || has_tool "just" \
  || SUGGESTIONS+=("taskfile: Add a Taskfile.yml (or Makefile) to unify dev commands: test, lint, build, deploy.")

# ── Output ────────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║          Workflow Automation Suggestions                 ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

if [[ ${#SUGGESTIONS[@]} -eq 0 ]]; then
  echo "  Your stack looks well-automated! Consider reviewing templates/"
  echo "  for any advanced patterns you might be missing."
else
  for i in "${!SUGGESTIONS[@]}"; do
    NUM=$((i + 1))
    KEY="${SUGGESTIONS[$i]%%:*}"
    MSG="${SUGGESTIONS[$i]#*: }"
    printf "  %2d. [%-20s] %s\n" "$NUM" "$KEY" "$MSG"
  done
fi

echo ""
echo "Run: bash scripts/detect-stack.sh | jq . to see your full stack profile."
echo "See: templates/ for ready-to-copy implementation files."
echo ""
