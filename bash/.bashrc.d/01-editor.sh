# Specify which editor to use by default

VIM=$(which vim)
VI=$(which vi)
JOE=$(which joe)
NANO=$(which nano)

if [ -n "$VIM" ] && [ -x "$VIM" ]; then
  if [ -t 0 ]; then echo "Default Editor: ${VIM}"; fi
  export EDITOR=${VIM}
  export VISUAL=${VIM}
  alias v='vim'
elif [ -n "$VI" ] && [ -x "$VI" ]; then
  if [ -t  0 ]; then echo "Default Editor: ${VI} :\\"; fi
  export EDITOR=${VI}
  export VISUAL=${VI}
  alias v='vi'
elif [ -n "$JOE" ] && [ -x "$JOE" ]; then
  if [ -t  0 ]; then echo "Default Editor: ${JOE} :/"; fi
  export EDITOR=${JOE}
  export VISUAL=${JOE}
  alias v='joe'
elif [ -n "$NANO" ] && [ -x "$NANO" ]; then
  if [ -t  0 ]; then echo "Default Editor: ${NANO} :("; fi
  export EDITOR=${NANO}
  export VISUAL=${NANO}
  alias v='nano'
else
  if [ -t  0 ]; then echo "No known editor installed (x_x)"; fi
  unset EDITOR
  unset VISUAL
fi

