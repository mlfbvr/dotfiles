LESS=$(which less)

if [ -n "$LESS" ] && [ -x "$LESS" ]; then
  alias more='less'
fi
