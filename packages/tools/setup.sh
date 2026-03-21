#!/usr/bin/env bash
set -euo pipefail

echo "==> [tools] Installing apt tools"
sudo apt install -y eza bat fd-find zoxide fzf curl git libatomic1

echo "==> [tools] Linking fd -> fdfind if needed"
mkdir -p "$HOME/.local/bin"
if [ -x "$(command -v fdfind)" ] && [ ! -e "$HOME/.local/bin/fd" ]; then
  ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

echo "==> [tools] Installing nvm"
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

echo "==> [tools] Installing lazydocker"
if ! command -v lazydocker >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

echo "==> [tools] Done"
