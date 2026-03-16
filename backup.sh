#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Backing up Brewfile..."
brew bundle dump --force --file="$SCRIPT_DIR/install/Brewfile"

echo "Backing up global npm packages..."
npm list -g --depth=0 --parseable 2>/dev/null | tail -n +2 | xargs -I{} basename {} | grep -v '^npm$\|^corepack$' | sort > "$SCRIPT_DIR/install/npmfile"

echo "Backing up mise tools..."
mise list --current 2>/dev/null | awk '{print $1 "@" $2}' > "$SCRIPT_DIR/install/mise-tools"

echo "Done. Review changes with: git -C $SCRIPT_DIR diff"
