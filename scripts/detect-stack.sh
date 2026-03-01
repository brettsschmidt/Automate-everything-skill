#!/usr/bin/env bash
# detect-stack.sh — Detect project stack and emit a JSON summary.
# Usage: bash scripts/detect-stack.sh [project-dir]
# Output: JSON object written to stdout

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

# ── helpers ──────────────────────────────────────────────────────────────────
has() { [[ -f "$1" ]] || [[ -d "$1" ]]; }
cmd() { command -v "$1" &>/dev/null; }
json_arr() { printf '%s\n' "$@" | jq -R . | jq -s .; }

# ── detection ─────────────────────────────────────────────────────────────────
LANGUAGES=()
PACKAGE_MANAGERS=()
FRAMEWORKS=()
CI_SYSTEMS=()
TOOLS=()
MISSING_AUTOMATION=()

# Language detection
has package.json        && LANGUAGES+=("javascript") && PACKAGE_MANAGERS+=("npm")
has yarn.lock           && PACKAGE_MANAGERS+=("yarn")
has pnpm-lock.yaml      && PACKAGE_MANAGERS+=("pnpm")
has bun.lockb           && PACKAGE_MANAGERS+=("bun")
has pyproject.toml      && LANGUAGES+=("python")
has setup.py            && LANGUAGES+=("python")
has requirements.txt    && LANGUAGES+=("python") && PACKAGE_MANAGERS+=("pip")
has Pipfile             && PACKAGE_MANAGERS+=("pipenv")
has poetry.lock         && PACKAGE_MANAGERS+=("poetry")
has go.mod              && LANGUAGES+=("go") && PACKAGE_MANAGERS+=("go-modules")
has Cargo.toml          && LANGUAGES+=("rust") && PACKAGE_MANAGERS+=("cargo")
has composer.json       && LANGUAGES+=("php") && PACKAGE_MANAGERS+=("composer")
has Gemfile             && LANGUAGES+=("ruby") && PACKAGE_MANAGERS+=("bundler")
has pom.xml             && LANGUAGES+=("java") && PACKAGE_MANAGERS+=("maven")
has build.gradle        && LANGUAGES+=("java") && PACKAGE_MANAGERS+=("gradle")
has *.csproj 2>/dev/null && LANGUAGES+=("csharp") && PACKAGE_MANAGERS+=("dotnet")

# Framework detection (JS/TS)
if has package.json; then
  PKG=$(cat package.json)
  echo "$PKG" | grep -q '"next"'     && FRAMEWORKS+=("next.js")
  echo "$PKG" | grep -q '"react"'    && FRAMEWORKS+=("react")
  echo "$PKG" | grep -q '"vue"'      && FRAMEWORKS+=("vue")
  echo "$PKG" | grep -q '"svelte"'   && FRAMEWORKS+=("svelte")
  echo "$PKG" | grep -q '"express"'  && FRAMEWORKS+=("express")
  echo "$PKG" | grep -q '"fastify"'  && FRAMEWORKS+=("fastify")
  echo "$PKG" | grep -q '"jest"'     && TOOLS+=("jest")
  echo "$PKG" | grep -q '"vitest"'   && TOOLS+=("vitest")
  echo "$PKG" | grep -q '"eslint"'   && TOOLS+=("eslint")
  echo "$PKG" | grep -q '"prettier"' && TOOLS+=("prettier")
  echo "$PKG" | grep -q '"typescript"' && LANGUAGES+=("typescript")
fi

# Framework detection (Python)
if has pyproject.toml || has requirements.txt; then
  REQS=$(cat pyproject.toml requirements.txt 2>/dev/null || true)
  echo "$REQS" | grep -qi 'django'   && FRAMEWORKS+=("django")
  echo "$REQS" | grep -qi 'fastapi'  && FRAMEWORKS+=("fastapi")
  echo "$REQS" | grep -qi 'flask'    && FRAMEWORKS+=("flask")
  echo "$REQS" | grep -qi 'pytest'   && TOOLS+=("pytest")
  echo "$REQS" | grep -qi 'ruff'     && TOOLS+=("ruff")
  echo "$REQS" | grep -qi 'black'    && TOOLS+=("black")
  echo "$REQS" | grep -qi 'mypy'     && TOOLS+=("mypy")
fi

# CI system detection
has .github/workflows   && CI_SYSTEMS+=("github-actions")
has .gitlab-ci.yml      && CI_SYSTEMS+=("gitlab-ci")
has Jenkinsfile         && CI_SYSTEMS+=("jenkins")
has .circleci           && CI_SYSTEMS+=("circleci")
has .travis.yml         && CI_SYSTEMS+=("travis-ci")
has bitbucket-pipelines.yml && CI_SYSTEMS+=("bitbucket-pipelines")

# Containerization
has Dockerfile          && TOOLS+=("docker")
has docker-compose.yml  && TOOLS+=("docker-compose")
has docker-compose.yaml && TOOLS+=("docker-compose")
has .devcontainer       && TOOLS+=("devcontainer")

# Git tooling
if has .git; then
  TOOLS+=("git")
  has .git/hooks/pre-commit  || MISSING_AUTOMATION+=("pre-commit-hook")
  has .pre-commit-config.yaml && TOOLS+=("pre-commit")
fi
has .github/dependabot.yml || MISSING_AUTOMATION+=("dependabot")
has renovate.json          || has .renovaterc.json || MISSING_AUTOMATION+=("renovate")

# Makefile / task runners
has Makefile            && TOOLS+=("make")
has Taskfile.yml        && TOOLS+=("task")
has justfile            && TOOLS+=("just")

# Emit JSON
jq -n \
  --argjson langs      "$(json_arr "${LANGUAGES[@]+"${LANGUAGES[@]}"}")" \
  --argjson pms        "$(json_arr "${PACKAGE_MANAGERS[@]+"${PACKAGE_MANAGERS[@]}"}")" \
  --argjson frameworks "$(json_arr "${FRAMEWORKS[@]+"${FRAMEWORKS[@]}"}")" \
  --argjson ci         "$(json_arr "${CI_SYSTEMS[@]+"${CI_SYSTEMS[@]}"}")" \
  --argjson tools      "$(json_arr "${TOOLS[@]+"${TOOLS[@]}"}")" \
  --argjson missing    "$(json_arr "${MISSING_AUTOMATION[@]+"${MISSING_AUTOMATION[@]}"}")" \
  '{
    languages: ($langs | unique),
    package_managers: ($pms | unique),
    frameworks: ($frameworks | unique),
    ci_systems: ($ci | unique),
    tools: ($tools | unique),
    missing_automation: ($missing | unique)
  }'
