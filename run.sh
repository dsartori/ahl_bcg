#!/bin/sh
# Wrapper script for the Docker image.
# If no argument is supplied, list available BASIC programs and show usage.
if [ -z "$1" ]; then
  echo "Available BASIC programs:"
  ls *.bas
  echo "Usage: docker run --rm -it sst-basic <program.bas>"
  exit 0
fi

# Execute the requested BASIC program with PC‑BASIC.
pcbasic "$@"