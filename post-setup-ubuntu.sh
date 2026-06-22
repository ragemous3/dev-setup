#!/bin/bash

# Run this after setup-ubuntu.sh and after opening Neovim once (so lazy.nvim has cloned plugins).

# TODO: This might not be needed — lazy.nvim already runs `build = 'make'` for telescope-fzf-native automatically.
( cd "$HOME/.local/share/nvim/lazy/telescope-fzf-native.nvim" && make )
