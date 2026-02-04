return {
  setup = function(capabilities)
    vim.lsp.config['eslint'] = {
      capabilities = capabilities,
      on_attach = function(client, bufnr) client.server_capabilities.documentFormattingProvider = true end,
    }
    vim.lsp.enable('eslint')
  end,
}
