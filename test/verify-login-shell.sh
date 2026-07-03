#!/usr/bin/env bash
set -euo pipefail

bash -lc 'command -v nvim'
bash -lc 'command -v node'
bash -lc 'command -v npm'
bash -lc 'command -v codex'
bash -lc 'command -v lua-language-server'
bash -lc 'command -v ltex-ls-plus'
bash -lc 'command -v docker'
bash -lc 'nvm current'
bash -lc 'nvim --version | head -n 1'
bash -lc 'node --version'
bash -lc 'npm --version'
bash -lc 'codex --version'
