cd ~
alias clip='clip.exe'
. "$HOME/.cargo/env"

export PATH="$HOME/.local/bin:/usr/local/node/bin:/opt/ltex-ls-plus/bin:$PATH"

if [ -d /mnt/wslg/runtime-dir ]; then
    echo "changing XDG_RUNTIME_DIR"
    export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
    export WAYLAND_DISPLAY=wayland-0
fi
