#!/usr/bin/env bash
set -euo pipefail

EXT_FILE="packages/vscode/.vscode/vscode-extensions.txt"

echo "==> [vscode] Installing extensions"
if ! command -v code >/dev/null 2>&1; then
  echo "VS Code CLI 'code' not found. Skipping extension installation."
  exit 0
fi

if [ -f "$EXT_FILE" ]; then
  xargs -r -n 1 code --install-extension < "$EXT_FILE"
else
  echo "Extension list not found at $EXT_FILE. Skipping."
fi

echo "==> [vscode] Done"
