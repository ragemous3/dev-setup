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
      require'config.lsps.eslint'
      require'config.lsps.lua'
    end,
  }
}
