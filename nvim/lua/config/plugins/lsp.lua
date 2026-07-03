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
			require("config.lsps.eslint").setup(capabilities)
			require("config.lsps.typescript-language-server").setup(capabilities)
			require("config.lsps.lua").setup(capabilities)
			require("config.lsps.marksman").setup(capabilities)
			-- Disabled for now: LTEX eventually worked with JVM tuning, but startup and
			-- first diagnostics still took several minutes on this WSL/Pentium setup.
			require("config.lsps.ltex-ls-plus")
			require("config.lsps.pyright").setup(capabilities)


			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local c = vim.lsp.get_client_by_id(args.data.client_id)
					if not c then
						return
					end

					local opts = { buffer = args.buf, silent = true }
					vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
						buffer = args.buf,
						silent = true,
						desc = "LSP code actions",
					})
				end,
			})
		end,
	},
}
