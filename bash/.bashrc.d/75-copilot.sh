# Copilot-specific bash configurations

COPILOT=$(which copilot)

if [ -n "$COPILOT" ] && [ -x "$COPILOT" ]; then
  alias copilot='${COPILOT} --allow-all-tools --add-dir .'
  alias yolopilot='${COPILOT} --allow-all'
else
  MESSAGE="copilot is not installed"
  alias copilot='echo ${MESSAGE}'
  alias yolopilot='copilot'
fi

