# dotfiles
My different dotfiles

## Setup

Clone the repo and run the setup script:

```bash
git clone https://github.com/mlfbvr/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/setup.sh
```

The script checks that [GNU stow](https://www.gnu.org/software/stow/) is installed,
verifies you're in the project root, then symlinks the following packages to `$HOME`:

| Package | Links                  |
|---------|------------------------|
| `bash`  | `.bashrc`, `.bash_profile`, `.bashrc.d/` |
| `tmux`  | `.tmux.conf`           |
| `vim`   | `.vimrc`, `.vimrc-plugins`, `.vimrc-mappings` |


