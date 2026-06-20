#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "WSL detected — using setup.ps1 to create a native Windows junction."
    exec powershell.exe -File "$REPO_DIR/setup.ps1" "$@"
fi

ORCA_BASE="$HOME/.config/OrcaSlicer/user"
ORCA_DIR="$ORCA_BASE/default"

usage() {
    echo "Usage: $0 [--remove]"
    echo "  --remove    Remove symlink instead of creating it"
    exit 0
}

if [[ ! -d "$ORCA_BASE" ]]; then
    echo "Error: OrcaSlicer user config directory not found: $ORCA_BASE"
    exit 1
fi

if [[ "${1:-}" == "--remove" ]]; then
    if [[ -L "$ORCA_DIR" ]]; then
        rm "$ORCA_DIR"
        echo "Removed symlink: $ORCA_DIR"
    elif [[ -d "$ORCA_DIR" ]]; then
        echo "Not a symlink: $ORCA_DIR"
    else
        echo "Not found: $ORCA_DIR"
    fi
    exit 0
fi

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
fi

echo "Creating symlink: OrcaSlicer user default -> $REPO_DIR"

if [[ -L "$ORCA_DIR" ]]; then
    rm "$ORCA_DIR"
    echo "  Removed existing symlink"
elif [[ -d "$ORCA_DIR" ]]; then
    backup="$ORCA_DIR.bak"
    mv "$ORCA_DIR" "$backup"
    echo "  Backed up existing directory to: $backup"
fi

ln -s "$REPO_DIR" "$ORCA_DIR"
echo "  Created symlink: $ORCA_DIR -> $REPO_DIR"
echo "Done. Restart OrcaSlicer to see the profiles."
