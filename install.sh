#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="${REPO_OWNER:-JulioC090}"
REPO_NAME="${REPO_NAME:-dotfiles-wsl}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
ARCHIVE_URL="${ARCHIVE_URL:-https://codeload.github.com/${REPO_OWNER}/${REPO_NAME}/tar.gz/refs/heads/${DOTFILES_BRANCH}}"

for cmd in bash curl tar; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd"
    exit 1
  fi
done

echo "==> Downloading dotfiles from $ARCHIVE_URL"
TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/dotfiles.tar.gz"
tar -xzf "$TMP_DIR/dotfiles.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [ -z "$EXTRACTED_DIR" ]; then
  echo "Could not find extracted dotfiles directory"
  exit 1
fi

if [ -d "$DOTFILES_DIR" ] && [ "$(find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 2>/dev/null | head -n 1)" ]; then
  BACKUP_DIR="${DOTFILES_DIR}.bak-$(date +%Y%m%d-%H%M%S)"
  echo "==> Existing dotfiles found. Creating backup at $BACKUP_DIR"
  mv "$DOTFILES_DIR" "$BACKUP_DIR"
fi

mkdir -p "$DOTFILES_DIR"
cp -a "$EXTRACTED_DIR"/. "$DOTFILES_DIR"/

chmod +x "$DOTFILES_DIR/setup.sh"

echo "==> Running setup"
bash "$DOTFILES_DIR/setup.sh"
