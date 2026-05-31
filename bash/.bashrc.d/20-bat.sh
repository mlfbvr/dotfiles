# bat (a better cat)
BATCAT=$(which batcat)
if [ -x "$BATCAT" ] && [ -n "$BATCAT" ]; then
  alias cat='batcat'
fi

