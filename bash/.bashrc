# At the end of .bashrc
if [ -d "$HOME/.bashrc.d" ]; then
    for config in "$HOME/.bashrc.d"/*.sh; do
        [ -r "$config" ] && source "$config"
    done
fi

# pnpm
export PNPM_HOME="/home/martin/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
