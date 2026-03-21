#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system"
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y

sudo apt install -y stow

echo "==> Running package setups"
for dir in packages/*; do
  if [ -f "$dir/setup.sh" ]; then
    echo "==> Running $dir/setup.sh"
    bash "$dir/setup.sh"
  fi
done

echo "==> Applying dotfiles with stow"
stow bash git zsh tmux bin vscode

echo "Setup completed"
