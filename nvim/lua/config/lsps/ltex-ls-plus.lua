-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ltex_plus
return {
  setup = function(capabilities)
    vim.lsp.config["ltex_plus"] = {
      capabilities = capabilities,
      settings = {
	ltex = {
	  language = "en-GB",
	  enabled = { "asciidoc", "bib", "context", "gitcommit", "html", "markdown", "org", "pandoc", "plaintex", "quarto", "mail", "mdx", "rmd", "rnoweb", "rst", "tex", "latex", "text", "typst", "xhtml" }
	},
      },
    }
    vim.lsp.enable("ltex_plus");
  end,
}
