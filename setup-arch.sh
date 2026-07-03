#!/bin/bash
set -euo pipefail

# This script sets up a development environment on Arch Linux.
# useradd -m -G wheel -s /bin/bash <name>
# Please add a user, do not run as root, -m is home and wheel is for sudo capabilities.

if [ -z "${1:-}" ]; then
  echo "Need to specify your username as first argument"
  exit 1
fi

if [ -z "${2:-}" ]; then
  echo "Need to specify your email as second argument"
  exit 1
fi

ask_and_run() {
  local message="$1"
  local cmd="$2"

  read -p "Do you want $message installed? (y/n): " answer

  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    eval "$cmd"
  else
    echo "Skipped."
  fi
}

install_docker() {
  sudo pacman -S --needed --noconfirm docker

  echo "Adding $USER to the docker group. This allows Docker without sudo and is root-equivalent on this machine."
  read -p "Do you want to add $USER to the docker group? (y/n): " answer
  if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    sudo usermod -aG docker "$USER"
    echo "Docker group membership requires a new login session before docker works without sudo."
    echo "In WSL, run from PowerShell: wsl --shutdown"
  else
    echo "Skipped docker group membership. Use sudo docker, or add the user later with: sudo usermod -aG docker \"$USER\""
  fi
}

link_managed_symlink() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Cannot create symlink at $target because it already exists and is not a symlink."
    echo "Move or remove it manually, then run this setup script again."
    exit 1
  fi

  ln -sfnT "$source" "$target"
}

install_codex_cli() {
  curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh

  mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
  link_managed_symlink "$PWD/skills/caveman" "${CODEX_HOME:-$HOME/.codex}/skills/caveman"
  echo "Installed caveman skill to ${CODEX_HOME:-$HOME/.codex}/skills/caveman"
}

ensure_opt_access() {
  sudo install -d -o root -g root -m 755 /opt
}

echo "Adding profile and editor configuration"

link_managed_symlink "$PWD/.bash_profile" "$HOME/.bash_profile"
mkdir -p "$HOME/.config" "$HOME/.local/bin"
link_managed_symlink "$PWD/nvim" "$HOME/.config/nvim"
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

echo "Updating pacman and installing packages"
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm neovim lua-language-server base-devel curl fzf clang git ripgrep python make openssh less lsof tar gzip
hash -r

echo "Installing nvm and latest Node LTS"
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'
nvm use default

npm i -g vscode-langservers-extracted eslint_d typescript typescript-language-server pyright
# The eslint_d is a global daemon for eslint so formatting is faster.

# ltex-ls-plus (grammar/spell checking LSP)
curl -L https://github.com/ltex-plus/ltex-ls-plus/releases/download/18.7.0/ltex-ls-plus-18.7.0-linux-x64.tar.gz -o /tmp/ltex-ls-plus.tar.gz
ensure_opt_access
sudo rm -rf /opt/ltex-ls-plus
sudo mkdir -p /opt/ltex-ls-plus
sudo tar xzf /tmp/ltex-ls-plus.tar.gz -C /opt --no-same-owner --no-same-permissions
sudo mv /opt/ltex-ls-plus-18.7.0/* /opt/ltex-ls-plus/ 2>/dev/null || sudo mv /opt/ltex-ls-plus-*/* /opt/ltex-ls-plus/ 2>/dev/null
sudo chmod -R a+rX /opt/ltex-ls-plus
rm /tmp/ltex-ls-plus.tar.gz
ln -sf /opt/ltex-ls-plus/bin/ltex-ls-plus "$HOME/.local/bin/ltex-ls-plus"

# Build telescope-fzf-native - see post-setup-arch.sh

ask_and_run "Rust" \
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

# Installing prettier and prettier plugin go template for formatting html files
ask_and_run "Hugo" \
  "sudo pacman -S --needed --noconfirm hugo go && npm i -g prettier prettier-plugin-go-template"

ask_and_run "Python" \
  "sudo pacman -S --needed --noconfirm python"

ask_and_run "Marksman lsp" \
  "curl -L https://github.com/artempyanykh/marksman/releases/download/2026-02-08/marksman-linux-x64 -o \"\$HOME/.local/bin/marksman\" && chmod +x \"\$HOME/.local/bin/marksman\""

ask_and_run "Codex CLI" \
  "install_codex_cli"

ask_and_run "Docker" \
  "install_docker"

ask_and_run "Snap" \
  "tmpdir=\$(mktemp -d) && git clone https://aur.archlinux.org/snapd.git \"\$tmpdir/snapd\" && sudo pacman -S --needed --noconfirm squashfs-tools apparmor && cd \"\$tmpdir/snapd\" && makepkg -si --noconfirm && sudo systemctl enable --now snapd.socket"

ask_and_run "Snap Confinement (security, does not work in WSL2.0)" \
  "sudo systemctl enable --now snapd.apparmor.service"

# https://snapcraft.io/docs/installing-snap-on-arch-linux

# Configure git
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$2" -N "" -f "$HOME/.ssh/id_ed25519"
fi

# https://github.com/artempyanykh/marksman/blob/main/docs/install.md

echo "Setting git config"
git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor nvim
git config --global init.defaultBranch main

echo "Verifying installed commands"
command -v nvim >/dev/null
command -v node >/dev/null
command -v npm >/dev/null
command -v nvm >/dev/null
command -v lua-language-server >/dev/null
command -v ltex-ls-plus >/dev/null
nvim --version >/dev/null
ltex-ls-plus --version >/dev/null
