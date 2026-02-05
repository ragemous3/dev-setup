#!/bin/bash

# YOU NEED TO INSTALL BASH FIRST
# useradd -m -G wheel -s /bin/bash <name> 
# Please add a user, do not run as root, -m is home and wheel is for sudo capabilities.

# This script is not fully tested as i keep add more and more things. 
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

echo "Updating pacman and installing packages"
sudo pacman -Syu
sudo pacman -S lua-language-server base-devel fzf clang ripgrep python make openssh less npm lsof

npm i -g vscode-langservers-extracted eslint_d
# This above vscode and eslint is for nvim. The eslint_d is a global daemon for eslint so formatting is faster. 

# Build telescope-fzf-native - its for multigrep search
( cd "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim" && make )

ask_and_run "Rust" \ 
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

ask_and_run "Hugo" \ 
  "sudo pacman -S hugo go"

ask_and_run "Typescript" \ 
  "sudo pacman -S typescript typescript-language-server"

ask_and_run "Python" \ 
  "sudo pacman -S python"

ask_and_run "Snap" \ 
  ( "git clone https://aur.archlinux.org/snapd.git \
sudo pacman -S squashfs-tools \
apparmor \
cd snapd \
makepkg -si \
sudo systemctl enable --now snapd.socket )"

ask_and_run "Snap Confinement (security, does not work in WSL2.0)" \
  ( "sudo systemctl enable --now snapd.apparmor.service" )
-- https://snapcraft.io/docs/installing-snap-on-arch-linux

# Configure git 
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$2"
fi
echo "Setting snap packages"
-- https://github.com/artempyanykh/marksman/blob/main/docs/install.md

ask_and_run "Marksman lsp" \ 
  "sudo snap install marksman"



echo "Setting git config"
git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor nvim
git config --global init.defaultBranch main
