## What to install

```
sudo pacman -S base-devel fzf clang ripgrep python make /
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

```

## Lsp's

[All lsps included in nvin-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.txt)

``` 
sudo pacman -S lua-language-server
```

Run `:help lspconfig-all` to get help on certain configurations for certain lsps. 

### Eslint

Project needs a eslint configuration file to work and also the npm packages installed locally or globally.

    "eslint": "^9.39.1"
    "@typescript-eslint/eslint-plugin": "^8.48.0",
    "@typescript-eslint/parser": "^8.48.0",
    "typescript-eslint": "^8.48.0"



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

- CTRL + . 
Copies a whole block of code and inserts it again.

## Oil

Press `g.` to show hidden files.
