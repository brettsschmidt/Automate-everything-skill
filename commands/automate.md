---
description: Analyze your project and produce a prioritized workflow automation report with ready-to-copy implementations
argument-hint: Optional focus area, e.g. "ci", "git hooks", "testing", "releases"
allowed-tools: ["Read", "Bash", "Glob", "Grep", "Skill", "TodoWrite", "AskUserQuestion"]
---

## Context

- Directory listing: !`ls -la`
- package.json: !`cat package.json 2>/dev/null || echo "<not present>"`
- Python config: !`cat pyproject.toml 2>/dev/null || cat setup.py 2>/dev/null || echo "<not present>"`
- requirements.txt: !`cat requirements.txt 2>/dev/null || echo "<not present>"`
- go.mod: !`cat go.mod 2>/dev/null || echo "<not present>"`
- Cargo.toml: !`cat Cargo.toml 2>/dev/null || echo "<not present>"`
- Makefile/Taskfile: !`ls Makefile Taskfile.yml Taskfile.yaml justfile 2>/dev/null || echo "<none>"`
- Existing CI workflows: !`ls .github/workflows/ 2>/dev/null || echo "<none>"`
- Pre-commit config: !`cat .pre-commit-config.yaml 2>/dev/null || echo "<not present>"`
- Dependabot config: !`cat .github/dependabot.yml 2>/dev/null || echo "<not present>"`
- Active git hooks: !`ls .git/hooks/ 2>/dev/null | grep -v '\.sample$' || echo "<none>"`
- Recent commits: !`git log --oneline -15 2>/dev/null || echo "<not a git repo>"`
- Git remotes: !`git remote -v 2>/dev/null || echo "<none>"`
- Docker files: !`ls Dockerfile docker-compose.yml docker-compose.yaml .devcontainer 2>/dev/null || echo "<none>"`

## Your task

Load the `workflow-automator:workflow-analysis` skill using the Skill tool, then follow its instructions to produce a complete Workflow Automation Report for this project.

The user's optional focus area: $ARGUMENTS

Use the context gathered above as your primary data source. Do not re-run discovery commands the skill asks for if the data is already present above.
