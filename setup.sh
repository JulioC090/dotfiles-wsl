#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system"
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove --purge -y

sudo apt install -y stow

STOW_PACKAGES=(bash git zsh tmux bin)

echo "==> Running package setups"
for dir in packages/*; do
  if [ -f "$dir/setup.sh" ]; then
    echo "==> Running $dir/setup.sh"
    bash "$dir/setup.sh"
  fi
done

echo "==> Cleaning conflicting files before stow"
for pkg in "${STOW_PACKAGES[@]}"; do
  while IFS= read -r entry; do
    rel_path="${entry#packages/$pkg/}"
    target_path="$HOME/$rel_path"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
      if [ ! -d "$target_path" ]; then
        rm -f "$target_path"
      fi
    fi
  done < <(find "packages/$pkg" -mindepth 1 -type f ! -name "setup.sh" ! -name "README.md" ! -name ".gitkeep")
done

echo "==> Applying dotfiles with stow"
stow "${STOW_PACKAGES[@]}"

echo "Setup completed"
