-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ltex_plus
return {
  setup = function(capabilities)
    vim.lsp.config["ltex_plus"] = {
      cmd = { vim.fn.expand("~/.local/bin/ltex-ls-plus") },
      filetypes = { "markdown", "markdown.mdx", "mdx", "gitcommit" },
      capabilities = capabilities,
      settings = {
        ltex = {
          language = "en-GB",
          completionEnabled = false,
          checkFrequency = "save",
          sentenceCacheSize = 0,
          java = {
            maximumHeapSize = 4096,
          },
          ["ltex-ls"] = {
            logLevel = "warning",
          },
          enabled = { "gitcommit", "markdown", "mdx" },
        },
      },
    }
    vim.lsp.enable("ltex_plus");
  end,
}
