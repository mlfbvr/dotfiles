# dotfiles — Copilot instructions

This is a **learning/experimentation project**. Every AI interaction must be explicit:
- State what you're doing and why before acting
- Explain intent, the command, and expected outcome
- When proposing changes, explain reasoning, alternatives considered, and trade-offs
- Err on the side of over-communicating; the goal is understanding, not speed

## Repository structure

GNU stow–managed dotfiles. Each top-level directory is a stow package whose contents mirror `$HOME`.

| Package | Stowed by `setup.sh`? | Contents |
|---------|----------------------|----------|
| `bash/` | ✅ | `.bashrc`, `.bash_profile`, `.bashrc.d/` (numbered load-order fragments) |
| `tmux/` | ✅ | `.tmux.conf` |
| `vim/` | ✅ | `.vimrc`, `.vimrc-plugins`, `.vimrc-mappings` |
| `i3/` | ❌ manual | `~/.config/i3/config`, `~/.config/i3status/config` |
| `opencode/` | ❌ manual | `~/.config/opencode/` (opencode CLI config + agents) |
| `github/` | ❌ manual | `~/.github/workflows/` (reusable CI snippets) |
| `kitty/`, `mutt/`, `screen/` | ❌ manual | terminal/mail/screen configs |
| `scripts/` | not a stow package | utility scripts (not symlinked) |

## Bootstrap command

```bash
./scripts/setup.sh   # requires GNU stow; run from repo root
```

## CI / lint

Perl scripts are syntax-checked on push/PR (paths `scripts/perl/**/*.pl`):

```bash
# Run locally the same way CI does:
for f in scripts/perl/*.pl; do perl -c "$f"; done
```

No other test or lint framework exists. The CI workflow is in `github/.github/workflows/`.

## Key conventions

- **Bash scripts:** always start with `set -euo pipefail`; use `#!/usr/bin/env bash`; guard `$HOME` with `: "${HOME:?HOME is unset}"`
- **`.bashrc.d/` fragments:** numbered for load order (e.g. `00-bash.sh`, `75-copilot.sh`); each fragment is sourced by `.bashrc` in numeric order
- **Stow package layout:** files sit at the path they should occupy relative to `~` (e.g. `bash/.bashrc` → `~/.bashrc`)
- **`--no-folding`** must be passed to `stow` when the target directory must not be symlinked as a whole (e.g. `opencode`)
- **README is intentionally minimal** — don't expand it with generic content

## Workflow conventions (from `opencode/AGENTS.md`)

### Plan mode
- Enter plan mode for any non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, **stop immediately and re-plan** — don't keep pushing
- Any implemented plan ends with a human-approval review before being marked done

### Subagent strategy
- Offload research, exploration, and parallel analysis to subagents
- One task per subagent for focused execution; keep the main context clean

### Self-improvement loop
- After any correction from the user: update `tasks/lessons.md` with the pattern
- Review lessons at session start for relevant context

### Verification before done
- Never mark a task complete without proving it works
- Any added function or method must include a full set of unit tests

### Elegance check
- For non-trivial changes: pause and ask "is there a more elegant way?"
- Refactor at least once (max 3 times) before presenting a final result

### Task tracking
- Write a plan to `tasks/todo.md` with checkable items; verify before implementing
- Mark items complete as you go; add a review summary when done
