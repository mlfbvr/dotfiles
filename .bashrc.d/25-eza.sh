# eza (a better ls)
EZA=$(which eza)
if [ -x "$EZA" ] && [ -n "$EZA" ]; then
  alias ls='eza'
  alias ll='eza -al'
else
  alias ll='ls -al'
fi

