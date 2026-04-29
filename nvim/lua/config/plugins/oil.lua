return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    --    dependencies = { { "nvim-mini/mini.icons", opts = {} } }, -- optional
    opts = {
      delete_to_trash = true,
      keymaps = {
	["yc"] = "actions.copy_to_system_clipboard",
	["yp"] = "actions.paste_from_system_clipboard",
	["ym"] = { "actions.paste_from_system_clipboard", opts = { delete_original = true } },
      },
    },
  },
}
