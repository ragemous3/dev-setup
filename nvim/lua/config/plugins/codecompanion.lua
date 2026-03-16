-- DOCS: https://codecompanion.olimorris.dev/
-- READ: https://codecompanion.olimorris.dev/getting-started
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    adapters = {
      http = {
	openai = function()
	  return require("codecompanion.adapters").extend("openai", {
	    env = {
	      api_key = "OPENAI_API_KEY",
	    },
	    schema = {
	      model = {
		default = "gpt-5.4",
	      },
	    },
	  })
	end,
      },
    },

    interactions = {
      chat = {
	adapter = {
	  name = "openai",
	  model = "gpt-5.4",
	},
      },
      inline = {
	adapter = {
	  name = "openai",
	  model = "gpt-5.4",
	},
      },
      cmd = {
	adapter = {
	  name = "openai",
	  model = "gpt-5.4",
	},
      },
      background = {
	adapter = {
	  name = "openai",
	  model = "gpt-5-mini",
	},
      },
    },

    opts = {

      log_level = "DEBUG", -- or "TRACE"
    },
  },
}
