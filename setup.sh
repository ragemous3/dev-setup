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

echo "Updating pacman and installing packages"
sudo pacman -Syu
sudo pacman -S lua-language-server base-devel fzf clang ripgrep python make openssh less npm lsof
npm i -g vscode-langservers-extracted eslint_d
# This above vscode and eslint is for nvim. The eslint_d is a global daemon for eslint so formatting is faster. 

# Build telescope-fzf-native
( cd "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim" && make )

read -p "Do you want Rust installed? (y/n): " rust_answer

if [ "$rust_answer" = "y" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

read -p "Do you want Hugo installed? (y/n): " hugo_answer

if [ "$hugo_answer" = "y" ]; then
  sudo pacman -S hugo go
fi

read -p "Do you want typescript installed? (y/n): " typescript_answer

if [ "$typescript_answer" ]; then
  sudo pacman -S typescript typescript-language-server
fi

read -p "Do you want python installed? (y/n): " typescript_answer

if [ "$typescript_answer" ]; then
  sudo pacman -S python python-pip
fi

# Configure git 
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$2"
fi

git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor nvim
git config --global init.defaultBranch main
