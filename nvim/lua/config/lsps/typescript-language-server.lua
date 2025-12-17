return {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  setup = function(capabilities)
    vim.lsp.config['ts_ls'] = {
      capabilities = capabilities,
    }
    vim.lsp.enable('ts_ls')
  end,
}

