-- https://github.com/artempyanykh/marksman
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
-- https://github.com/artempyanykh/marksman/blob/main/docs/configuration.md ((how to configure your markdown using this lsp))
return {
  setup = function(capabilities)
    vim.lsp.config["marksman"] = {
      filetypes = { "markdown" },
      capabilities = capabilities,
      flags = {
	debounce_text_changes = 500,
      },
    }
    vim.lsp.enable("marksman");
  end,
}
