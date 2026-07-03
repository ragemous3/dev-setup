-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ltex_plus
return {
	setup = function(capabilities)
		vim.lsp.config("ltex_plus", {
			cmd = { "env", "JAVA_OPTS=-XX:TieredStopAtLevel=1 -Xmx4096m", "/opt/ltex-ls-plus/bin/ltex-ls-plus" },
			capabilities = capabilities,
			settings = {
				ltex = {
					language = "en-GB",
					checkFrequency = "save",
					completionEnabled = false,
					java = {
						maximumHeapSize = 4096,
					},
				},
			},
		})
		vim.lsp.enable("ltex_plus")
	end,
}
