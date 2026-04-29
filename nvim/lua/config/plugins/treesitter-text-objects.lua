return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local select = require("nvim-treesitter-textobjects.select")
    -- Just some bindings for function calls - commented out because so slow...
    --    require("nvim-treesitter-textobjects").setup({
      --      select = {
	-- lookahead = true,
	-- selection_modes = {
	  --   ["@function.outer"] = "V",
	  --   ["@function.inner"] = "V",
	  --   ["@call.outer"] = "V",
	  --   ["@call.inner"] = "V",
	  -- },
	  -- include_surrounding_whitespace = false,
	  --      },
	  --    })
	  --
	  --    vim.keymap.set({ "x", "o" }, "af", function()
	    --      select.select_textobject("@function.outer", "textobjects")
	    --    end, { desc = "Around function" })
	    --
	    --    vim.keymap.set({ "x", "o" }, "if", function()
	      --      select.select_textobject("@function.inner", "textobjects")
	      --    end, { desc = "Inside function" })
	      --
	      --    vim.keymap.set({ "x", "o" }, "ac", function()
		--      select.select_textobject("@call.outer", "textobjects")
		--    end, { desc = "Around call" })
		--
		--    vim.keymap.set({ "x", "o" }, "ic", function()
		  --      select.select_textobject("@call.inner", "textobjects")
		  --    end, { desc = "Inside call" })
		end,
	      }
