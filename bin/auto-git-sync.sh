#!/bin/bash

set -e

stderr () {
    echo "$1" >&2
}

is_command() {
    command -v "$1" &>/dev/null
}

TARGETDIR="$@"

# default events specified via a mask, see
# https://emcrisostomo.github.io/fswatch/doc/1.14.0/fswatch.html/Invoking-fswatch.html#Numeric-Event-Flags
# default of 414 = MovedTo + MovedFrom + Renamed + Removed + Updated + Created
#                = 256 + 128+ 16 + 8 + 4 + 2
INCOMMAND="fswatch --recursive --event=414 --exclude \"\.git\" --one-event \"$TARGETDIR\""

for cmd in "git" "fswatch" "timeout" "git-sync"; do
    is_command "$cmd" || { stderr "Error: Required command '$cmd' not found"; exit 1; }
done

cd "$TARGETDIR"
echo "$INCOMMAND"

while true; do
    eval "timeout 600 $INCOMMAND" || true
    git-sync
done
