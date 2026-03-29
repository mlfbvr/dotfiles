# Specify which editor to use by default

VIM=$(which vim)
VI=$(which vi)
JOE=$(which joe)
NANO=$(which nano)

if [ -n "$VIM" ] && [ -x "$VIM" ]; then
  echo "Default Editor: ${VIM}"
  export EDITOR=${VIM}
  export VISUAL=${VIM}
elif [ -n "$VI" ] && [ -x "$VI" ]; then
  echo "Default Editor: ${VI} :\\"
  export EDITOR=${VI}
  export VISUAL=${VI}
elif [ -n "$JOE" ] && [ -x "$JOE" ]; then
  echo "Default Editor: ${JOE} :/"
  export EDITOR=${JOE}
  export VISUAL=${JOE}
elif [ -n "$NANO" ] && [ -x "$NANO" ]; then
  echo "Default Editor: ${NANO} :("
  export EDITOR=${NANO}
  export VISUAL=${NANO}
else
  echo "No known editor installed (x_x)"
  unset EDITOR
  unset VISUAL
fi

