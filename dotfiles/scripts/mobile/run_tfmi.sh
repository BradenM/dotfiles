#!/usr/bin/env bash

PROJECT_DIR="$HOME/projects/tfmi"
LOGFILE="$PROJECT_DIR/tfmi.log"
PROJECT_ENV="$PROJECT_DIR/.env"

PYTHON_BIN="$HOME/.cache/pypoetry/virtualenvs/tfmi-HZt-uIiK-py3.7/bin/python"

echo_log() {
    msg="[REMOTE] $1"
    echo "$msg"
    echo "$msg" >>"$LOGFILE"
}

echo_log "Storing PID: $$"

echo "$$" >/tmp/tfmi.pid

echo_log "Executing TFMI"

. "$PROJECT_ENV"

echo_log "Loaded project env"
echo_log "GOOGLE_KEY=$GOOGLE_KEY"

echo_log "Running Script..."
"$PYTHON_BIN" "$PROJECT_DIR/main.py"

echo_log "Done."
