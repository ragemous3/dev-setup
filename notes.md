## In order for setup to work

Symlink from .bashprofile to ~/.bash_profile and nvim to ~/.config/nvim needed in order for this setup to work.

## What to install

Use the `setup.sh` bash script.

## Nvim clipboard to work

```bash
sudo pacman -S wl-clipboard
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

- gd
Go to definition (might require you to have the correct LSP installed)

## Oil

Press `g.` to show hidden files.


## Javascript linters and formatters

Using prettier as a formatter and eslint for linting js and ts (UNDER CONSTRUCTION)

Requires the below dependencies:
```
npm install --save-dev --legacy-peer-deps \
  eslint \
  @eslint/js \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin \
  prettier \
  eslint-config-prettier
```


## Commenting in nvim

Using "numToStr/Comment.nvim" plugin one can mark a block of text and click gc to comment!


