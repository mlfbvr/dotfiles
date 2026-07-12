# PROGRAM_INSTALL.md

## Introduction

- One section per program with per-distro install commands and short post-install notes.
- Excludes scripts/ and utilities normally present on Linux (bash, coreutils).
- Target: Debian/Ubuntu (apt) and Fedora (dnf).

## tmux

- Debian/Ubuntu: sudo apt update && sudo apt install -y tmux
- Fedora: sudo dnf install -y tmux

### Post-install:

- Install TPM: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
- Start tmux and press prefix + I to install plugins

### Verify: tmux -V

## i3 stack (i3, i3status, i3lock, dmenu, feh, xmodmap, terminator)

- Debian/Ubuntu: sudo apt install -y i3 i3status i3lock dmenu feh x11-xserver-utils terminator
- Fedora: sudo dnf install -y i3 i3status i3lock dmenu feh xorg-x11-utils terminator

### Post-install:

- Place i3 config at ~/.config/i3/config (repo provides i3/.config/i3/config)
- Place i3status config at ~/.config/i3status/config (repo provides i3/.config/i3status/config)
- feh is used to set wallpapers in the i3 startup lines; ensure your wallpaper files exist at the referenced paths (~/.wallpaper\*.png/jpg).
- xmodmap is invoked from the i3 config to load keyboard mappings from ~/.Xmodmap; ensure that file exists or remove the exec line if unused.
- terminator is the terminal started by the i3 keybinding in this config; install it or adjust the config to your preferred terminal emulator.
- i3lock is used for locking the screen and dmenu for the program launcher; ensure both are installed so the keybindings work.

### Verify:

- i3 --version
- i3status --version
- i3lock --version
- feh --version
- xmodmap --version (or run xmodmap --help)
- terminator --version

### Notes:

- Installing the full stack ensures the repository's i3 configuration works without additional manual edits. If you prefer a subset of tools, remove or adapt the corresponding exec/bindsym lines in ~/.config/i3/config.

## vim

- Debian/Ubuntu: sudo apt install -y vim (vim-nox if available)
- Fedora: sudo dnf install -y vim-enhanced

### Notes: .vimrc-plugins lists several plugins and vim-plug is auto-installed by .vimrc; some plugins run npm during install (ensure node/npm installed)

### Verify: vim --version

## GitHub Copilot CLI

- Install via npm or pnpm globally:
  npm install -g @github/copilot
  or
  pnpm add -g @github/copilot

### Prerequisites

- Ensure Node.js and npm (or pnpm) are installed (see the Node.js / npm section).

### Post-install:

- Global npm installs place executables on your npm global bin (commonly /usr/local/bin or ~/.npm-global/bin). Ensure that directory is on your PATH so the 'copilot' command is available.
- Authenticate per the official Copilot CLI docs (the tool may provide a subcommand such as 'copilot auth' or an interactive login flow).
- The repository uses a copilot binary via aliases in bash/.bashrc.d/75-copilot.sh; install via npm/pnpm as documented above and ensure the 'copilot' executable is on PATH so the alias works.

### Verify: copilot --version

## opencode (opencode CLI)

- Install via npm or pnpm globally:
  npm install -g opencode-ai
  or
  pnpm add -g opencode-ai

### Prerequisites

- Ensure Node.js and npm (or pnpm) are installed (see the Node.js / npm section).

### Post-install:

- Global installs place executables on your npm/pnpm global bin. Ensure that directory is on your PATH so the 'opencode' command is available.
- Create config dirs and stow the repo opencode package:
  mkdir -p ~/.config/opencode/{agents,skills}
  stow -t ~ --no-folding opencode

### Verify: opencode --version

### Notes: The repository supplies opencode agent and skill configs under opencode/.config/opencode; after installing the CLI, drop the provided configs into ~/.config/opencode and follow opencode-specific auth/setup workflows.

## mutt

- Debian/Ubuntu: sudo apt install -y mutt
- Fedora: sudo dnf install -y mutt

### Post-install: update ~/.mutt/muttrc with real IMAP/SMTP credentials (repo contains a template)

### Verify: mutt -v

## screen

- Debian/Ubuntu: sudo apt install -y screen
- Fedora: sudo dnf install -y screen

### Post-install: repo includes .screenrc

### Verify: screen --version

## stow (GNU Stow)

- Debian/Ubuntu: sudo apt install -y stow
- Fedora: sudo dnf install -y stow

### Post-install: from repo root run ./scripts/setup.sh (script checks stow exists)

### Verify: stow --version

## nodejs / npm

- Debian/Ubuntu: sudo apt install -y nodejs npm (or install from NodeSource for newer versions)
- Fedora: sudo dnf install -y nodejs npm

### Notes: required for some Vim plugin postinstall steps (prettier, vim-prettier)

### Verify: node --version; npm --version

## kitty (terminal emulator)

- Debian/Ubuntu: sudo apt install -y kitty
- Fedora: sudo dnf install -y kitty

### Post-install: place kitty config at ~/.config/kitty/kitty.conf (repo provides kitty/.config/kitty/kitty.conf)

### Verify: kitty --version

## Notes and caveats

- Package names vary across distros; if a package is missing, search the distro package index.
- i3 and X11 utilities are Linux-only.
- Mutt config contains placeholders — fill credentials before use.
- After installing stow, run ./scripts/setup.sh from the repo root to deploy dotfiles.

If more granular per-distro package names (e.g., Copilot CLI packages or AUR formulas) are desired, specify which platforms and those sections will be expanded.
