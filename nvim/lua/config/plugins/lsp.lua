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
      vim.lsp.config['luals'] = {
	-- Command and arguments to start the server.
	cmd = { 'lua-language-server' },

	-- Filetypes to automatically attach to.
	filetypes = { 'lua' },

	-- Sets the "root directory" to the parent directory of the file in the
	-- current buffer that contains either a ".luarc.json" or a
	-- ".luarc.jsonc" file. Files that share a root directory will reuse
	-- the connection to the same LSP server.
	-- Nested lists indicate equal priority, see |vim.lsp.Config|.
	root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

	-- Specific settings to send to the server. The schema for this is
	-- defined by the server. For example the schema for lua-language-server
	-- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
	  Lua = {
	    diagnostics = {
	      globals = { "vim" },
	    },
	    runtime = {
	      version = 'LuaJIT',
	    },
	  }
	}
      }
      vim.lsp.enable('luals')
      vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
	  local c = vim.lsp.get_client_by_id(args.data.client_id)
	  if not c then return end

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
