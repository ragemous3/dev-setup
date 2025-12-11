return {
  setup = function(capabilities)
    vim.lsp.config['ts_ls'] = {
      capabilities = capabilities,
    }
    vim.lsp.enable('ts_ls')
  end,
}

