# Dev setup

This repo is my personal Linux development environment bootstrap. It contains
setup scripts for Arch Linux and Ubuntu, a Neovim configuration, WSL helper
files, optional Codex skill setup, and Docker-based smoke tests for the setup
scripts.

The setup scripts install core CLI tooling, Node through `nvm`, Neovim and LSP
dependencies, optional language/tooling stacks, SSH keys, and global Git
defaults. They also symlink this repo's shell/editor configuration into the
user's home directory.

## Setup

Run the script that matches the target distro:

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

## Tests

The test scripts build a Docker image with a non-root `tester` user, mount this
repo read-only at `/home/tester/dev-setup`, run the matching setup script with
pre-filled prompts, and verify that the login shell can load the installed
environment.

Run the Ubuntu smoke test:

```sh
./test/run-ubuntu.sh
```

Run the Arch smoke test:

```sh
./test/run-arch.sh
```

## Interactive Docker Shell

Use these commands when you want to inspect or debug the test container
manually.

Ubuntu:

```sh
docker build -f test/docker/ubuntu.Dockerfile -t dev-setup-test-ubuntu .
docker run --rm -it -v "$PWD:/home/tester/dev-setup:ro" dev-setup-test-ubuntu bash -l
```

Arch:

```sh
docker build -f test/docker/arch.Dockerfile -t dev-setup-test-arch .
docker run --rm -it -v "$PWD:/home/tester/dev-setup:ro" dev-setup-test-arch bash -l
```

Inside the container, run the setup script just like the automated test does:

```sh
printf 'n\nn\nn\nn\ny\ny\nn\nn\n' | ./setup-ubuntu.sh 'Test User' tester@example.com
./test/verify-login-shell.sh
```

For Arch, replace `setup-ubuntu.sh` with `setup-arch.sh`.


