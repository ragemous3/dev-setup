require('config.lazy')
-- MIght need to implement some more here: https://medium.com/unixification/must-have-neovim-keymaps-51c283394070
vim.opt.shiftwidth = 2
vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.g.have_nerd_font = false
vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')
vim.keymap.set('n', '<space>asq', ':%s/"/\'/g<CR>')
local job_id = 0

-- To control the size of a window using keyboard..
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")

vim.keymap.set('n', '<space>to', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd('J')
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
end)

local current_command = ''
vim.keymap.set('n', '<space>te', function()
  current_command = vim.fn.input('Command: ')
end)

vim.keymap.set('n', '<space>tr', function()
  if current_command == '' then
    current_command = vim.fn.input('Command: ')
  end

  vim.fn.chansend(job_id, { current_command .. '\r\n' })
end)
-- get into normal mode when in terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

vim.keymap.set('n', '-', '<cmd>Oil<CR>')

-- In order to have yank and ctrl+v work in windows.
-- cd /usr/local/bin
-- sudo wget https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
-- sudo unzip win32yank-x64.zip
-- sudo chmod +x win32yank.exe
--
--
--
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
-- (from kickstart.nvim https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua)
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set("n", "<space>d", function()
  vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
end, { desc = "Show diagnostics in floating window" })
vim.diagnostic.config({
  virtual_text = false,
  signs = true,     -- keep signs in the gutter
  float = { border = "rounded" },
  underline = true, -- underline the problematic code
  update_in_insert = false,
})

-- so that i do not jump out of visual mode when indenting
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
