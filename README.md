# dotfiles

Personal configuration files managed with [GNU stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone https://github.com/mlfbvr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/setup.sh
```

The script checks that stow is installed, verifies you're in the project root,
then symlinks the following packages to `$HOME`:

| Package | Links |
|---------|-------|
| `bash`  | `.bashrc`, `.bash_profile`, `.bashrc.d/` |
| `tmux`  | `.tmux.conf` |
| `vim`   | `.vimrc`, `.vimrc-plugins`, `.vimrc-mappings` |

## Additional configurations

These packages are present in the repo but not managed by `setup.sh`.

| Package | Links | Command |
|---------|-------|---------|
| `i3` | `~/.config/i3/config`, `~/.config/i3status/config` | `stow -t ~ i3` |

## opencode

Configuration for the [opencode](https://opencode.ai) CLI tool.

### Setup

```bash
# Installation: see https://opencode.ai for instructions
mkdir -p ~/.config/opencode/{agents,skills}
stow -t ~ --no-folding opencode
```

## Scripts

| Script | Description | Requirements |
|--------|-------------|-------------|
| `setup.sh` | Bootstrap dotfiles with GNU stow | `stow` |
| `random_wallhaven.sh` | Fetch a random wallpaper from wallhaven.cc and set it with `feh` | `feh`, `curl`, `jq` |
| `bashfetch.sh` | Display system info (OS, kernel, CPU, GPU, WM, resolutions) | `xrandr`, `lspci`, `lsb-release` |
| `generators/create-fastapi-project.sh` | Scaffold a FastAPI project with venv, deps, and a hello-world route | `python3` |
| `generators/create-react-project.sh` | Scaffold a React + TypeScript + Vite project | `pnpm` |
| `perl/find_duplicates.pl` | Find duplicate files in current directory by MD5 checksum | Core Perl modules |
| `perl/login.pl` | Display login message with mail status and date/time | Core Perl modules |
| `perl/rtm.pl` | Remember The Milk CLI — add/view tasks in a list | Core Perl modules, env vars |
| `perl/download_organizer.pl` | Sort downloads into category folders by file extension | Core Perl modules, env vars |


