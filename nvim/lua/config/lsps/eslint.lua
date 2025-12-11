return {
  setup = function(capabilities)
    vim.lsp.config['eslint'] = {
      capabilities = capabilities,
    }
    vim.lsp.enable('eslint')
  end,
}

