-- https://github.com/mattn/vim-gotmpl/blob/main/README.md
return {
  "mattn/vim-gotmpl",
  ft = "gohtmltmpl",
  init = function()
    -- for HUGO html files
    vim.filetype.add({
      pattern = {
	[".*/layouts/.+%.html"] = "gohtmltmpl",
      },
    })
  end,
}
