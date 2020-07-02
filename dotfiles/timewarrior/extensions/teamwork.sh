#!/usr/bin/env bash

PROJ_PATH="$HOME/projects/work/arroyodev/scripts/timewarrior-teamwork"
pushd "$PROJ_PATH"

poetry run python teamwork.py

popd

