# Dev setup

This repo is my personal development environment bootstrap. It contains
setup scripts for Arch Linux, Ubuntu, and macOS (Apple Silicon), a Neovim
configuration, WSL helper files, optional Codex skill setup, and Docker-based
tests for the setup scripts.

The setup scripts install core CLI tooling, Node, Neovim and LSP
dependencies, optional language/tooling stacks, SSH keys, and global Git
defaults. They also symlink this repo's shell/editor configuration into the
user's home directory.

## Setup

Run the setup script that matches the target distro:

```sh
./setup-arch.sh "Your Name" you@example.com
```

```sh
./setup-ubuntu.sh "Your Name" you@example.com
```

On macOS (Apple Silicon / arm64):

```sh
./setup-macos.sh "Your Name" you@example.com
```

### macOS notes

`setup-macos.sh` is designed to run **without admin rights** (no `sudo`,
no system package manager). Instead of `pacman`/`apt` it uses:

- **Miniforge / conda-forge** for most CLI tooling (installs into
  `~/miniforge3`, no admin). If Miniforge is not already present the script
  downloads and installs it into `$HOME` automatically.
- **Official GitHub release tarballs** for the Neovim editor
  (`nvim-macos-arm64`) and `ltex-ls-plus` (`mac-aarch64`). Note: the
  conda-forge `neovim` package is the Python client (pynvim), *not* the
  editor, which is why the editor comes from GitHub.
- **npm (global)** for the JavaScript/TypeScript language servers and the
  `prettierd` / `eslint_d` formatter daemons.

Everything is placed under `~/.local/bin` and the conda env `devtools`, both of
which the script adds to `PATH` via `~/.zprofile`. Open a new terminal after
running so the `PATH` changes take effect.

Unlike the Linux scripts, `setup-macos.sh` does **not** set a global git
`user.name` / `user.email`, so it is safe to use alongside per-directory
`includeIf` git identities (e.g. separate personal/work accounts).

JavaScript/TypeScript formatting uses the **`prettierd` daemon** (configured in
`nvim/lua/config/plugins/conform.lua`) rather than plain `prettier`, for
near-instant formatting — the same daemon approach as `eslint_d`.

After setup, open Neovim once so `lazy.nvim` can install plugins. If needed,
run the matching post-setup script to build `telescope-fzf-native`:

```sh
./post-setup-arch.sh
```

```sh
./post-setup-ubuntu.sh
```

## Non-Interactive Smoke Tests

The test scripts build a Docker image with a non-root `tester` user, mount this
repo read-only at `/home/tester/dev-setup`, run the matching setup script with
pre-filled prompt answers, and verify that the login shell can load the
installed environment.

Run the Ubuntu smoke test:

```sh
./test/run-ubuntu.sh
```

Run the Arch smoke test:

```sh
./test/run-arch.sh
```

## Interactive Docker Shell

Use these commands to start a disposable Docker shell and run a setup script
manually. The container uses a non-root `tester` user with passwordless `sudo`
and mounts this repo read-only at `/home/tester/dev-setup`.

Ubuntu:

```sh
docker build -f test/docker/ubuntu.Dockerfile -t dev-setup-test-ubuntu .
docker run --rm -it -v "$PWD:/home/tester/dev-setup:ro" dev-setup-test-ubuntu bash -l
```

Inside the Ubuntu container:

```sh
./setup-ubuntu.sh "Test User" tester@example.com
exec bash -l
nvim
```

Arch:

```sh
docker build -f test/docker/arch.Dockerfile -t dev-setup-test-arch .
docker run --rm -it -v "$PWD:/home/tester/dev-setup:ro" dev-setup-test-arch bash -l
```

Inside the Arch container:

```sh
./setup-arch.sh "Test User" tester@example.com
exec bash -l
nvim
```
