#!/usr/bin/env bash
set -euo pipefail

echo "==> [zsh] Post-install: setting default shell"
ZSH_BIN="$(command -v zsh || true)"

if [ -z "$ZSH_BIN" ]; then
  echo "zsh not found in PATH. Skipping shell change."
  exit 0
fi

CURRENT_SHELL="${SHELL:-}"
if [ "$CURRENT_SHELL" = "$ZSH_BIN" ]; then
  echo "Default shell already set to zsh."
  exit 0
fi

if chsh -s "$ZSH_BIN" "$USER"; then
  echo "Default shell changed to $ZSH_BIN. Log out and in again to apply."
else
  echo "Could not change default shell automatically. Run: chsh -s $ZSH_BIN"
fi
