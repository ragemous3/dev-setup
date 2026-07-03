alias clip='clip.exe'

path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "/usr/local/bin"
export PATH

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

if [ -d /mnt/wslg/runtime-dir ]; then
    echo "changing XDG_RUNTIME_DIR"
    export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
    export WAYLAND_DISPLAY=wayland-0
fi
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
