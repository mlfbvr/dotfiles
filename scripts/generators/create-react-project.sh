#!/usr/bin/env bash

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

PNPM=$(which pnpm)

if [ -n "$PNPM" ] && [ -x "$PNPM" ]; then
    echo -e "${BLUE}${BOLD}Setting up React project${RESET}"
    echo -e "${BLUE}─────────────────────────────────────${RESET}"
    ${PNPM} create vite . --no-interactive  --template react-ts 1>/dev/null
    ${PNPM} install

    echo -e "${GREEN}${BOLD}✓ React project ready${RESET}"
    echo ""
    echo -e "${BOLD}Next steps:${RESET}"
    echo -e "${YELLOW}1. Start the dev server:${RESET} ${PNPM} dev"
else
    echo -e "${RED}${BOLD}✗ PNPM not found on this system${RESET}"
fi
