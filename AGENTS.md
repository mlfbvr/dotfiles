# dotfiles — agent instructions

See also `.github/copilot-instructions.md` for workflow conventions (plan mode, subagent strategy, self-improvement loop).

## Interaction guidelines

This is a **learning project** used to explore and experiment with tooling. Every AI interaction must be clear and explicit:

- State what you're doing and why before performing actions
- Avoid silent operations — explain your intent, the command, and expected outcome
- When proposing changes, explain the reasoning, alternatives considered, and trade-offs
- Err on the side of over-communicating; the goal is understanding, not speed

## Structure
- **GNU stow packages:** `bash/`, `tmux/`, `vim/` — each contains dotfiles prefixed with `.`
- **Setup:** `scripts/setup.sh` runs `stow -t ~ <package>` for each package above
- **Also present (not stowed by setup.sh):** `.config/i3`, `.config/i3status`, `.mutt/`, `.wallpapers/`, `.Xmodmap`, `.screenrc`
- **Scripts:** `scripts/random_wallhaven.sh` fetches random wallpaper from wallhaven.cc

## Commands
- **Bootstrap on new machine:** `./scripts/setup.sh` (requires GNU stow; run from repo root)

## Notes
- No test/lint/typecheck framework — CI workflow (`.github/workflows/blank.yml`) is a placeholder
- `random_wallhaven.sh` expects `feh`, `curl`, `jq` installed
- Config for `random_wallhaven.sh`: `~/.random_wallhaven` or `$WALLHAVEN_*` env vars
- Style conventions: bash scripts use `set -euo pipefail`, README is minimal
