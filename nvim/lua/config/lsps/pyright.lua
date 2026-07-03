return {
  setup = function(capabilities)
    vim.lsp.config["pyright"] = {
      capabilities = capabilities,
    }
    vim.lsp.enable("pyright")
  end,
}
