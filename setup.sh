#!/bin/bash

if [ -z "$1" ]; then
  echo "Need to specify your username as first argument"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Need to specify your email as second argument"
  exit 1
fi

echo "Adding profile and editor configuration"

ln -sf "$PWD/.bash_profile" "$HOME/.bash_profile"
mkdir -p "$HOME/.config"
ln -sfn "$PWD/nvim" "$HOME/.config/nvim"

# System packages (consider running separately)
sudo pacman -Syu
sudo pacman -S lua-language-server base-devel fzf clang ripgrep python make openssh less

# Build telescope-fzf-native
( cd "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim" && make )

# Install Rust (run as normal user)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Generate SSH key if missing
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$2"
fi

# Configure Git
git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor nvim
git config --global init.defaultBranch main
