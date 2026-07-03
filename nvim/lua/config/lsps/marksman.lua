-- https://github.com/artempyanykh/marksman
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
-- https://github.com/artempyanykh/marksman/blob/main/docs/configuration.md ((how to configure your markdown using this lsp))
return {
  setup = function(capabilities)
    vim.lsp.config["marksman"] = {
      cmd = { vim.fn.expand("~/.local/bin/marksman"), "server" },
      filetypes = { "markdown", "markdown.mdx" },
      root_markers = { ".marksman.toml", ".git" },
      capabilities = capabilities,
    }
    vim.lsp.enable("marksman");
  end,
}
