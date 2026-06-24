#!/bin/bash

# This script sets up a development environment on Ubuntu.
# Converted from Arch Linux (pacman) to Ubuntu (apt).

if [ -z "$1" ]; then
  echo "Need to specify your username as first argument"
  exit 1
fi

if [ -z "$2" ]; then
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

echo "Adding profile and editor configuration"

ln -sf "$PWD/.bash_profile" "$HOME/.bash_profile"
mkdir -p "$HOME/.config"
ln -sfn "$PWD/nvim" "$HOME/.config/nvim"

echo "Updating apt and installing packages"
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential fzf clang ripgrep python3 make openssh-client less npm lsof

# Install latest stable Neovim from GitHub (Ubuntu repos are too old)
curl -Lo /tmp/nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar xzf /tmp/nvim-linux-x86_64.tar.gz -C /opt
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm /tmp/nvim-linux-x86_64.tar.gz

# lua-language-server is not in Ubuntu repos, install from GitHub
mkdir -p "$HOME/.local/lua-language-server"
curl -L https://github.com/LuaLS/lua-language-server/releases/download/3.18.2/lua-language-server-3.18.2-linux-x64.tar.gz | tar xz -C "$HOME/.local/lua-language-server"
ln -sf "$HOME/.local/lua-language-server/bin/lua-language-server" "$HOME/.local/bin/lua-language-server"

npm i -g vscode-langservers-extracted eslint_d
# The eslint_d is a global daemon for eslint so formatting is faster.

# Build telescope-fzf-native - see post-setup-ubuntu.sh

ask_and_run "Rust" \
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

# Installing prettier and prettier plugin go template for formatting html files
ask_and_run "Hugo" \
  "sudo apt install -y hugo golang-go && npm i -g prettier prettier-plugin-go-template"

ask_and_run "Nvm" \
  "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"

ask_and_run "Typescript" \
  "sudo apt install -y node-typescript && npm i -g typescript-language-server"

ask_and_run "Python" \
  "sudo apt install -y python3 python3-pip && npm i -g pyright"

ask_and_run "Marksman lsp" \
  "sudo apt install -y dotnet-sdk-8.0 && sudo snap install marksman"

ask_and_run "Codex CLI" \
  "npm i -g @openai/codex"

ask_and_run "Snap" \
  "sudo apt install -y snapd && sudo systemctl enable --now snapd.socket"

ask_and_run "Snap Confinement (security, does not work in WSL2.0)" \
  "sudo systemctl enable --now snapd.apparmor.service"

# https://snapcraft.io/docs/installing-snap-on-arch-linux

# Configure git
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$2"
fi

echo "Setting git config"
git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor nvim
git config --global init.defaultBranch main
