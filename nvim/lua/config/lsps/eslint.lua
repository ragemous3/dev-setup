return {
  setup = function(capabilities)
    vim.lsp.config['eslint'] = {
      capabilities = capabilities,
    }
    vim.lsp.enable('eslint')

    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
	-- ESLint integration (plain eslint)
	null_ls.builtins.formatting.eslint_d,
	null_ls.builtins.diagnostics.eslint_d,
	null_ls.builtins.formatting.prettier,
      }});

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function()
	  vim.lsp.buf.format({ async = false })
	end,
      })


    end,
  }

