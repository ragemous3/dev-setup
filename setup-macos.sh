#!/bin/bash
set -euo pipefail

# macOS development environment bootstrap (Apple Silicon / arm64).
#
# Adapted from setup-arch.sh / setup-ubuntu.sh for macOS WITHOUT admin rights.
# Instead of system package managers (pacman/apt) + sudo, this script uses:
#   - Miniforge/conda-forge for most CLI tooling (installs into $HOME, no sudo)
#   - Official GitHub release tarballs for tools not on conda-forge
#   - npm (global) for the JavaScript/TypeScript language servers & formatters
#
# Usage:
#   ./setup-macos.sh "Your Name" you@example.com
#
# This script is intentionally non-destructive: it will not overwrite a
# non-symlink ~/.config/nvim, and it leaves existing git identity config alone
# (this repo already uses per-directory includeIf-based identities).

if [ -z "${1:-}" ]; then
  echo "Need to specify your name as first argument"
  exit 1
fi

if [ -z "${2:-}" ]; then
  echo "Need to specify your email as second argument"
  exit 1
fi

GIT_NAME="$1"
GIT_EMAIL="$2"

ARCH="$(uname -m)"
if [ "$ARCH" != "arm64" ]; then
  echo "WARNING: this script targets Apple Silicon (arm64). Detected: $ARCH."
  echo "Download URLs below assume arm64; adjust if you are on Intel."
fi

# ---------------------------------------------------------------------------
# Locate / bootstrap conda (Miniforge). We reuse an existing ~/miniforge3 if
# present, otherwise install it into $HOME without admin.
# ---------------------------------------------------------------------------
CONDA_ROOT="$HOME/miniforge3"
CONDA="$CONDA_ROOT/bin/conda"
ENV_NAME="devtools"
ENV_BIN="$CONDA_ROOT/envs/$ENV_NAME/bin"

if [ ! -x "$CONDA" ]; then
  echo "Miniforge not found at $CONDA_ROOT. Installing (no admin required)..."
  curl -fsSL -o /tmp/miniforge.sh \
    "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh"
  bash /tmp/miniforge.sh -b -p "$CONDA_ROOT"
  rm -f /tmp/miniforge.sh
else
  echo "Using existing Miniforge at $CONDA_ROOT"
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

link_managed_symlink() {
  local source="$1"
  local target="$2"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Cannot create symlink at $target because it already exists and is not a symlink."
    echo "Move or remove it manually, then run this setup script again."
    exit 1
  fi
  ln -sfn "$source" "$target"
}

# ---------------------------------------------------------------------------
# Core tooling via conda-forge (prebuilt binaries, no compiler, no sudo).
# NOTE: the conda-forge "neovim" package is the Python client (pynvim), NOT the
# editor, so the Neovim editor is installed from the official GitHub release
# further down.
# ---------------------------------------------------------------------------
echo "Installing core CLI tooling via conda-forge into env '$ENV_NAME'..."
"$CONDA" create -y -n "$ENV_NAME" -c conda-forge \
  git \
  gnupg \
  pinentry \
  gh \
  ripgrep \
  fzf \
  nodejs \
  lua-language-server \
  stylua \
  black \
  isort \
  make

echo "Ensuring $ENV_BIN and ~/.local/bin are on PATH via ~/.zprofile"
if ! grep -q "envs/$ENV_NAME/bin" "$HOME/.zprofile" 2>/dev/null; then
  cat >> "$HOME/.zprofile" <<EOF
# macOS dev-setup tooling (conda-forge, no-admin)
export PATH="\$HOME/.local/bin:\$HOME/miniforge3/envs/$ENV_NAME/bin:\$PATH"
EOF
fi
export PATH="$ENV_BIN:$HOME/.local/bin:/usr/local/bin:$PATH"
mkdir -p "$HOME/.local/bin"
hash -r

# ---------------------------------------------------------------------------
# Neovim editor from the official GitHub release (macOS arm64).
# ---------------------------------------------------------------------------
echo "Installing Neovim (editor) from official GitHub release..."
NVIM_DIR="$HOME/.local/nvim-macos-arm64"
curl -L "https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz" \
  -o /tmp/nvim-macos-arm64.tar.gz
rm -rf "$NVIM_DIR"
mkdir -p "$NVIM_DIR"
# strip the top-level nvim-macos-arm64/ directory
tar xzf /tmp/nvim-macos-arm64.tar.gz -C "$NVIM_DIR" --strip-components 1
rm -f /tmp/nvim-macos-arm64.tar.gz
# macOS Gatekeeper quarantines downloaded binaries; clear the attribute so it runs.
xattr -dr com.apple.quarantine "$NVIM_DIR" 2>/dev/null || true
ln -sf "$NVIM_DIR/bin/nvim" "$HOME/.local/bin/nvim"

# ---------------------------------------------------------------------------
# ltex-ls-plus (grammar/spell-checking LSP) from GitHub (mac arm64 build).
# ---------------------------------------------------------------------------
echo "Installing ltex-ls-plus (mac arm64)..."
LTEX_VER="18.7.0"
LTEX_DIR="$HOME/.local/ltex-ls-plus"
curl -L "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${LTEX_VER}/ltex-ls-plus-${LTEX_VER}-mac-aarch64.tar.gz" \
  -o /tmp/ltex-ls-plus.tar.gz
rm -rf "$LTEX_DIR"
mkdir -p "$LTEX_DIR"
# The mac tarball nests everything under ltex-ls-plus-<ver>/; extract as-is and
# then locate the launcher rather than assuming a fixed layout.
tar xzf /tmp/ltex-ls-plus.tar.gz -C "$LTEX_DIR"
rm -f /tmp/ltex-ls-plus.tar.gz
xattr -dr com.apple.quarantine "$LTEX_DIR" 2>/dev/null || true
LTEX_BIN="$(find "$LTEX_DIR" -type f -name ltex-ls-plus -path '*/bin/*' | head -1)"
if [ -z "$LTEX_BIN" ]; then
  echo "ERROR: could not locate ltex-ls-plus launcher after extraction." >&2
  exit 1
fi
ln -sf "$LTEX_BIN" "$HOME/.local/bin/ltex-ls-plus"

# ---------------------------------------------------------------------------
# JavaScript/TypeScript language servers & formatters via npm (global).
# prettierd is the PRETTIER DAEMON (resident process, near-instant formatting),
# used in place of plain prettier. eslint_d is likewise the eslint daemon.
# ---------------------------------------------------------------------------
echo "Installing Node-based language servers and formatter daemons via npm..."
npm i -g \
  vscode-langservers-extracted \
  eslint_d \
  typescript \
  typescript-language-server \
  pyright \
  @fsouza/prettierd

# ---------------------------------------------------------------------------
# Editor/profile configuration symlinks.
# ---------------------------------------------------------------------------
echo "Linking Neovim configuration..."
mkdir -p "$HOME/.config"
link_managed_symlink "$PWD/nvim" "$HOME/.config/nvim"

# ---------------------------------------------------------------------------
# Optional stacks.
# ---------------------------------------------------------------------------
ask_and_run "Rust (rustup)" \
  "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"

ask_and_run "Hugo + Go (for templating) and prettier go-template plugin" \
  "\"$CONDA\" install -y -n \"$ENV_NAME\" -c conda-forge hugo go && npm i -g prettier-plugin-go-template"

ask_and_run "Marksman LSP (markdown)" \
  "\"$CONDA\" install -y -n \"$ENV_NAME\" -c conda-forge marksman"

ask_and_run "Codex CLI" \
  "curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh && \
   mkdir -p \"\${CODEX_HOME:-\$HOME/.codex}/skills\" && \
   link_managed_symlink \"\$PWD/skills/caveman\" \"\${CODEX_HOME:-\$HOME/.codex}/skills/caveman\""

# ---------------------------------------------------------------------------
# Git defaults. We DO NOT set user.name/user.email globally here because this
# repo relies on per-directory includeIf identities (see ~/.gitconfig). We only
# set safe, identity-agnostic defaults, and print the requested identity.
# ---------------------------------------------------------------------------
echo "Setting identity-agnostic git defaults (editor, default branch)..."
git config --global core.editor nvim
git config --global init.defaultBranch main
echo "Requested identity was: $GIT_NAME <$GIT_EMAIL>"
echo "(Left global user.name/user.email untouched to preserve per-folder identities.)"

# ---------------------------------------------------------------------------
# Verify.
# ---------------------------------------------------------------------------
echo "Verifying installed commands..."
command -v nvim >/dev/null && echo "  nvim: $(nvim --version | head -1)"
command -v node >/dev/null && echo "  node: $(node --version)"
command -v npm  >/dev/null && echo "  npm:  $(npm --version)"
command -v rg   >/dev/null && echo "  ripgrep: $(rg --version | head -1)"
command -v fzf  >/dev/null && echo "  fzf: $(fzf --version)"
command -v lua-language-server >/dev/null && echo "  lua-language-server: ok"
command -v ltex-ls-plus >/dev/null && echo "  ltex-ls-plus: ok"
command -v stylua >/dev/null && echo "  stylua: $(stylua --version)"
command -v prettierd >/dev/null && echo "  prettierd (daemon): $(prettierd --version 2>/dev/null || echo installed)"
command -v eslint_d >/dev/null && echo "  eslint_d (daemon): $(eslint_d --version 2>/dev/null || echo installed)"
command -v typescript-language-server >/dev/null && echo "  typescript-language-server: ok"
command -v pyright >/dev/null && echo "  pyright: ok"

echo ""
echo "Done. Open a new terminal (so PATH updates apply) and run 'nvim' once so"
echo "lazy.nvim can install plugins. Treesitter + telescope-fzf-native build"
echo "automatically on first launch."
