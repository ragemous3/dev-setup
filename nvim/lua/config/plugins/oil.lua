return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true
    },
    config = function()
      local conform = require("oil")

      conform.setup({
	delete_to_trash = true
      })

      -- Optional dependencies
      -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    end,
  }
}
