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

## Scripts

| Script | Description | Requirements |
|--------|-------------|-------------|
| `setup.sh` | Bootstrap dotfiles with GNU stow | `stow` |
| `random_wallhaven.sh` | Fetch a random wallpaper from wallhaven.cc and set it with `feh` | `feh`, `curl`, `jq` |
| `bashfetch.sh` | Display system info (OS, kernel, CPU, GPU, WM, resolutions) | `xrandr`, `lspci`, `lsb-release` |
| `generators/create-fastapi-project.sh` | Scaffold a FastAPI project with venv, deps, and a hello-world route | `python3` |
| `generators/create-react-project.sh` | Scaffold a React + TypeScript + Vite project | `pnpm` |


