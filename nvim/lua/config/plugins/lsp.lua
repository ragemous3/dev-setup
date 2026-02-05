return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require('config.lsps.eslint').setup(capabilities)
      require('config.lsps.typescript-language-server').setup(capabilities)
      require('config.lsps.lua').setup(capabilities)
      require('config.lsps.marksman').setup(capabilities)

      vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
	  local c = vim.lsp.get_client_by_id(args.data.client_id)
	  if not c then return end

	  local opts = { buffer = args.buf, silent = true }

	  -- Common mappings for all LSPs
	  vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions)
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
