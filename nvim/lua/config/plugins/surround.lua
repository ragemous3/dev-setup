--[[
cs"'    → "hello" → 'hello'
cs({    → (hello) → {hello}
ds"     → delete quotes
ysiw"   → wrap word in quotes
va"S(   → wrap " with a ()
]]
return {
  -- Surround (change/delete/add brackets, quotes, etc.)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Autopairs (auto close brackets while typing)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
	check_ts = true, -- use treesitter if available (better behavior)
      })
    end,
  },
}
