#!/usr/bin/env bash
set -euo pipefail

echo "==> [tmux] Post-install: installing tmux plugins"
TPM_INSTALL="$HOME/.tmux/plugins/tpm/bin/install_plugins"

if [ ! -x "$TPM_INSTALL" ]; then
  echo "TPM install script not found. Skipping plugin installation."
  exit 0
fi

if [ ! -f "$HOME/.tmux.conf" ]; then
  echo "~/.tmux.conf not found. Run stow first. Skipping plugin installation."
  exit 0
fi

tmux start-server || true
TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" "$TPM_INSTALL"

echo "==> [tmux] Plugins installed"
