#!/usr/bin/env bash
set -euo pipefail

ensure_clone() {
  local repo="$1"
  local dest="$2"
  if [ ! -d "$dest/.git" ]; then
    git clone --depth 1 "$repo" "$dest"
  fi
}

echo "==> [zsh] Installing base packages"
sudo apt install -y zsh curl git ca-certificates

echo "==> [zsh] Installing Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

echo "==> [zsh] Installing plugins and theme"
ensure_clone "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"
ensure_clone "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
ensure_clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
ensure_clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
ensure_clone "https://github.com/marlonrichert/zsh-autocomplete.git" "$ZSH_CUSTOM/plugins/zsh-autocomplete"
ensure_clone "https://github.com/ntnyq/omz-plugin-pnpm.git" "$ZSH_CUSTOM/plugins/pnpm"
ensure_clone "https://github.com/MichaelAquilina/zsh-you-should-use.git" "$ZSH_CUSTOM/plugins/you-should-use"
ensure_clone "https://github.com/Aloxaf/fzf-tab.git" "$ZSH_CUSTOM/plugins/fzf-tab"

echo "==> [zsh] Installing pnpm-shell-completion"
if [ ! -d "$ZSH_CUSTOM/plugins/pnpm-shell-completion" ]; then
  TMP_DIR="$(mktemp -d)"
  cleanup() {
    rm -rf "$TMP_DIR"
  }
  trap cleanup EXIT

  curl -L -o "$TMP_DIR/pnpm-sugestion.zip" "https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.5/pnpm-shell-completion_x86_64-unknown-linux-gnu.tar.gz"
  tar -xzf "$TMP_DIR/pnpm-sugestion.zip" -C "$TMP_DIR"

  INSTALLER_PATH="$(find "$TMP_DIR" -type f -name install.zsh | head -n 1)"
  if [ -z "$INSTALLER_PATH" ]; then
    echo "pnpm-shell-completion installer not found after extraction"
    exit 1
  fi

  INSTALLER_DIR="$(dirname "$INSTALLER_PATH")"
  (
    cd "$INSTALLER_DIR"
    ./install.zsh "$ZSH_CUSTOM/plugins"
  )

  trap - EXIT
  cleanup
fi

echo "==> [zsh] Done"
