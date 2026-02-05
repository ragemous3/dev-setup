-- https://github.com/artempyanykh/marksman
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
return {
  setup = function(capabilities)
    vim.lsp.config["marksman"] = {
      capabilities = capabilities
    }
    vim.lsp.enable("marksman");
  end,
}
