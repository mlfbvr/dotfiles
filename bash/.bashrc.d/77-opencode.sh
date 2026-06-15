 # Setup opencode-related configurations
 OPENCODE=$(which opencode)

 if [ -n "$OPENCODE" ]; then
  # Set the OPENCODE environment variable to the path of the opencode executable
  alias o=${OPENCODE}
fi
