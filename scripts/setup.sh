#!/usr/bin/env bash

# Ensure the script is run with bash, not sh
if [ -z "${BASH_VERSION:-}" ]; then
  echo "Error: this script must be run with bash, not sh" >&2
  exit 1
fi

set -euo pipefail

# Guard against unset HOME
: "${HOME:?HOME is unset}"

# Verify GNU stow is available
if ! command -v stow &>/dev/null; then
  echo "Error: GNU stow is not installed."
  echo "Install it with your package manager (e.g. 'apt install stow', 'brew install stow', 'pacman -S stow')."
  exit 1
fi

# Resolve project root from the script's own location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Validate we're at the repo root by checking for expected stow packages
for f in bash/.bashrc tmux/.tmux.conf vim/.vimrc; do
  if [ ! -f "$PROJECT_ROOT/$f" ]; then
    echo "Error: $f not found — are you running from the project root?"
    exit 1
  fi
done

cd "$PROJECT_ROOT" || { echo "Error: could not cd to $PROJECT_ROOT" >&2; exit 1; }

# Stow each package to $HOME
for dir in bash tmux vim; do
  echo "Stowing $dir..."
  stow -t "$HOME" "$dir"
done

echo "Done."
