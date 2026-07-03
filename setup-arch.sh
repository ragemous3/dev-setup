#!/bin/bash

# This script sets up a development environment on Arch Linux.
# useradd -m -G wheel -s /bin/bash <name>
# Please add a user, do not run as root, -m is home and wheel is for sudo capabilities.

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
sudo pacman -S neovim lua-language-server base-devel fzf clang ripgrep python make openssh less npm lsof

npm i -g vscode-langservers-extracted eslint_d typescript typescript-language-server pyright
# The eslint_d is a global daemon for eslint so formatting is faster.

# ltex-ls-plus (grammar/spell checking LSP)
curl -L https://github.com/ltex-plus/ltex-ls-plus/releases/download/18.7.0/ltex-ls-plus-18.7.0-linux-x64.tar.gz -o /tmp/ltex-ls-plus.tar.gz
sudo rm -rf /opt/ltex-ls-plus
sudo mkdir -p /opt/ltex-ls-plus
sudo tar xzf /tmp/ltex-ls-plus.tar.gz -C /opt --no-same-owner --no-same-permissions
sudo mv /opt/ltex-ls-plus-18.7.0/* /opt/ltex-ls-plus/ 2>/dev/null || sudo mv /opt/ltex-ls-plus-*/* /opt/ltex-ls-plus/ 2>/dev/null
rm /tmp/ltex-ls-plus.tar.gz

# Build telescope-fzf-native - see post-setup-arch.sh

ask_and_run "Rust" \
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

# Installing prettier and prettier plugin go template for formatting html files
ask_and_run "Hugo" \
  "sudo pacman -S hugo go && npm i -g prettier prettier-plugin-go-template"

ask_and_run "Nvm" \
  "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"

ask_and_run "Typescript" \
  "sudo pacman -S typescript"

ask_and_run "Python" \
  "sudo pacman -S python"

ask_and_run "Marksman lsp" \
  "sudo pacman -S marksman dotnet-sdk"

ask_and_run "Codex CLI" \
  "npm i -g @openai/codex"

ask_and_run "Snap" \
  "git clone https://aur.archlinux.org/snapd.git && sudo pacman -S squashfs-tools apparmor && cd snapd && makepkg -si && sudo systemctl enable --now snapd.socket"

ask_and_run "Snap Confinement (security, does not work in WSL2.0)" \
  "sudo systemctl enable --now snapd.apparmor.service"

# https://snapcraft.io/docs/installing-snap-on-arch-linux

# Configure git
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "$2"
fi

# https://github.com/artempyanykh/marksman/blob/main/docs/install.md

echo "Setting git config"
git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor nvim
git config --global init.defaultBranch main
