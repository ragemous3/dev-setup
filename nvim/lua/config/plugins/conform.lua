return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        gotmpl = { "prettier" },
        gohtmltmpl = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      format_on_save = function(bufnr)
        if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "oil" then
          return
        end
        local filetype = vim.bo[bufnr].filetype
        local timeout_ms = 2500
        if filetype == "markdown" or filetype == "markdown.mdx" then
          timeout_ms = 8000
        end

        return {
          lsp_format = "fallback",
          timeout_ms = timeout_ms,
        }
      end,
    })
  end,
}
