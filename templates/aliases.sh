#!/usr/bin/env bash
# aliases.sh — Productivity shell aliases and git shortcuts.
#
# Usage:
#   # Add to your ~/.bashrc or ~/.zshrc:
#   source /path/to/this/aliases.sh
#
#   # Or copy individual aliases you want into your shell config.

# ── Git aliases ───────────────────────────────────────────────────────────────
alias gs='git status -sb'                    # Short status with branch info
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'     # Amend last commit (same message)
alias gp='git push'
alias gpl='git pull --rebase'                # Pull with rebase (cleaner history)
alias gf='git fetch --all --prune'           # Fetch all remotes, clean stale refs
alias gl='git log --oneline --graph --decorate --all'  # Visual branch graph
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gsw='git switch'
alias gcb='git switch -c'                    # Create and switch to new branch

# Quickly undo the last commit (keeps changes staged)
alias greset='git reset --soft HEAD~1'

# Clean up merged local branches
alias gclean='git branch --merged main | grep -v "^\*\|main\|master\|develop" | xargs -r git branch -d'

# Show recent branches you've worked on
alias gbrecent='git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short) | %(committerdate:relative)" | head -10'

# Stash with a message
gstash() { git stash push -m "${*:-wip}"; }

# ── GitHub CLI shortcuts (requires `gh`) ──────────────────────────────────────
alias ghpr='gh pr create --web'              # Open PR creation in browser
alias ghprl='gh pr list'
alias ghprv='gh pr view --web'
alias ghruns='gh run list --limit 10'        # Recent CI runs
alias ghwatch='gh run watch'                 # Watch the latest run

# ── Node / npm shortcuts ──────────────────────────────────────────────────────
alias ni='npm install'
alias nid='npm install --save-dev'
alias nci='npm ci'
alias nr='npm run'
alias nrd='npm run dev'
alias nrt='npm run test'
alias nrb='npm run build'
alias nrl='npm run lint'

# ── Python shortcuts ──────────────────────────────────────────────────────────
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'
alias pt='pytest'
alias ptv='pytest -v'
alias ptw='ptw .'                            # pytest-watch

# ── Docker shortcuts ──────────────────────────────────────────────────────────
alias dk='docker'
alias dkc='docker compose'
alias dkcu='docker compose up -d'
alias dkcd='docker compose down'
alias dkcr='docker compose restart'
alias dkcl='docker compose logs -f'
alias dkclean='docker system prune -af --volumes'

# ── Directory navigation ──────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ll='ls -lAh'
alias la='ls -A'

# ── Misc productivity ─────────────────────────────────────────────────────────
# Copy to clipboard (Linux: xclip, macOS: pbcopy — adjust as needed)
alias copy='xclip -selection clipboard'

# Open current dir in VS Code
alias code.='code .'

# Quick HTTP server in current directory
alias serve='python3 -m http.server 8080'

# Show which process is using a port
port() { lsof -i :"${1:-3000}"; }

# Create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" || return; }

# Run a command and notify when done (Linux with notify-send)
notify-when-done() {
  "$@" && notify-send "Done" "$* succeeded" || notify-send "Failed" "$* failed"
}

# ── Git global config suggestions ────────────────────────────────────────────
# Run these once to improve your git experience:
#
# git config --global alias.lg "log --oneline --graph --decorate --all"
# git config --global alias.undo "reset --soft HEAD~1"
# git config --global alias.wip "commit -am 'wip: checkpoint'"
# git config --global core.autocrlf input      # LF on checkout (Linux/Mac)
# git config --global push.autoSetupRemote true  # Auto-set upstream on push
# git config --global pull.rebase true          # Rebase instead of merge on pull
# git config --global fetch.prune true          # Auto-clean stale remote refs
