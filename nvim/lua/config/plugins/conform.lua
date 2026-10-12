return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
	javascript = { "prettierd" },
	typescript = { "prettierd" },
	javascriptreact = { "prettierd" },
	gotmpl = { "prettierd" },
	gohtmltmpl = { "prettierd" },
	typescriptreact = { "prettierd" },
	svelte = { "prettierd" },
	css = { "prettierd" },
	html = { "prettierd" },
	json = { "prettierd" },
	yaml = { "prettierd" },
	markdown = { "prettierd" },
	graphql = { "prettierd" },
	lua = { "stylua" },
	python = { "isort", "black" },
      },
      format_on_save = function(bufnr)
	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "oil" then
	  return
	end
	return {
	  lsp_format = "fallback",
	  timeout_ms = 2500,
	}
      end,
    })
  end,
}
