return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
	"folke/lazydev.nvim",
	opts = {
	  library = {
	    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
	  },
	},
      },
    },
    config = function()
      require'config.lsps.eslint'
      require'config.lsps.typescript-language-server'
      require'config.lsps.lua'

      vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
	  local c = vim.lsp.get_client_by_id(args.data.client_id)
	  if not c then return end

	  local opts = { buffer = args.buf, silent = true }

	  -- Common mappings for all LSPs
	  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)



	  if vim.bo.filetype == "lua" then
	    -- Format the current buffer on save
	    vim.api.nvim_create_autocmd("BufWritePre", {
	      pattern = "*.lua",
	      command = "normal! gg=G",
	    })
	  end
	end,
      })

    end,
  }
}
