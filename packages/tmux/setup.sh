#!/usr/bin/env bash
set -euo pipefail

echo "==> [tmux] Installing tmux"
sudo apt install -y tmux git

echo "==> [tmux] Installing TPM"
if [ ! -d "$HOME/.tmux/plugins/tpm/.git" ]; then
  mkdir -p "$HOME/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> [tmux] Done"
