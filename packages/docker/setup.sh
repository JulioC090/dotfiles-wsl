#!/usr/bin/env bash
set -euo pipefail

echo "==> [docker] Installing prerequisites"
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "==> [docker] Configuring Docker APT repository"
sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
fi
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> [docker] Writing repository source"
ARCH="$(dpkg --print-architecture)"
CODENAME="$(lsb_release -cs)"
DOCKER_LIST="/etc/apt/sources.list.d/docker.list"
DOCKER_LINE="deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${CODENAME} stable"
if [ ! -f "$DOCKER_LIST" ] || ! grep -Fqx "$DOCKER_LINE" "$DOCKER_LIST"; then
  echo "$DOCKER_LINE" | sudo tee "$DOCKER_LIST" >/dev/null
fi

echo "==> [docker] Installing Docker engine and plugins"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> [docker] Enabling service"
sudo systemctl enable docker
sudo systemctl start docker

echo "==> [docker] Adding current user to docker group"
if ! id -nG "$USER" | grep -qw docker; then
  sudo usermod -aG docker "$USER"
  echo "User added to docker group. Log out/in (or run 'newgrp docker') to apply group changes."
fi

echo "==> [docker] Done"
