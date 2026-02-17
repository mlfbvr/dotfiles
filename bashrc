# At the end of .bashrc
if [ -d "$HOME/.bashrc.d" ]; then
    for config in "$HOME/.bashrc.d"/*.sh; do
        [ -r "$config" ] && source "$config"
    done
fi
