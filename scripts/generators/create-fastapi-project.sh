#!/usr/bin/env bash

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

PYTHON3=$(which python3)

if [ -n "$PYTHON3" ] && [ -x "$PYTHON3" ]; then
    echo -e "${BLUE}${BOLD}Setting up Python3 + FastAPI project${RESET}"
    echo -e "${BLUE}─────────────────────────────────────${RESET}"
	${PYTHON3} -m venv .venv
	source .venv/bin/activate
	pip install "fastapi[standard]" 1>/dev/null
	pip freeze > requirements.txt

    cat > main.py<<EOF
from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}
EOF

	echo -e "${GREEN}${BOLD}✓ Python3 + FastAPI project ready${RESET}"
    echo ""
    echo -e "${BOLD}Next steps:${RESET}"
    echo -e "${YELLOW}1. Activate the venv:${RESET} source .venv/bin/activate"
    echo -e "${YELLOW}2. Run the dev server:${RESET} uvicorn main:app --reload"
else
    echo -e "${RED}${BOLD}✗ Python3 not found on this system${RESET}"
fi
