cd ~
alias clip='clip.exe'
. "$HOME/.cargo/env"

# Created by `pipx` on 2026-01-21 14:15:53
export PATH="$PATH:/root/.local/bin"

# The package below is for grammar checks in general, its an lsp I use in nvim.
## Need to curl a version from https://github.com/ltex-plus/ltex-ls-plus
## Then put it into below path and the tar -xzv ...the-tar.. 
export PATH="/opt/ltex-ls-plus/bin:$PATH"

