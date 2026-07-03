# Dev setup

This repo is my personal Linux development environment bootstrap. It contains
setup scripts for Arch Linux and Ubuntu, a Neovim configuration, WSL helper
files, optional Codex skill setup, and Docker-based tests for the setup
scripts.

The setup scripts install core CLI tooling, Node through `nvm`, Neovim and LSP
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
```

Arch:

```sh
docker build -f test/docker/arch.Dockerfile -t dev-setup-test-arch .
docker run --rm -it -v "$PWD:/home/tester/dev-setup:ro" dev-setup-test-arch bash -l
```

Inside the Arch container:

```sh
./setup-arch.sh "Test User" tester@example.com
```
