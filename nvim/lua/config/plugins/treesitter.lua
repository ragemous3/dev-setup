return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {
        ensure_installed = { "c", "lua", "vim", "gotmpl", "vimdoc", "query", "markdown", "markdown_inline", "rust", "typescript" },
        auto_install = false,
      }

      -- Highlighting is now built-in in Neovim 0.10+
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  }
}
