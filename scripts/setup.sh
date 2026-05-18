#!/usr/bin/env bash

if [ -z "${BASH_VERSION:-}" ]; then
  echo "Error: this script must be run with bash, not sh" >&2
  exit 1
fi

set -euo pipefail

: "${HOME:?HOME is unset}"

if ! command -v stow &>/dev/null; then
  echo "Error: GNU stow is not installed."
  echo "Install it with your package manager (e.g. 'apt install stow', 'brew install stow', 'pacman -S stow')."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

for f in bash/.bashrc tmux/.tmux.conf vim/.vimrc; do
  if [ ! -f "$PROJECT_ROOT/$f" ]; then
    echo "Error: $f not found — are you running from the project root?"
    exit 1
  fi
done

cd "$PROJECT_ROOT" || { echo "Error: could not cd to $PROJECT_ROOT" >&2; exit 1; }

for dir in bash tmux vim; do
  echo "Stowing $dir..."
  stow -t "$HOME" "$dir"
done

echo "Done."
