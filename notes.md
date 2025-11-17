## What to install

```
sudo pacman -S base-devel fzf clang ripgrep python make /
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

```

## Lsp's

``` 
sudo pacman -S lua-language-server
```

## Plugins good to know

### Telescope

Need to run the below to make fzf search work (that is after including it).
```
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim\
make
```


## Commands

- v% 
Marks everything from start to finish (can be combined with yank or delete etc)
