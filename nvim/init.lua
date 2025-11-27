require("config.lazy")

vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.g.have_nerd_font = false
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

local job_id = 0
vim.keymap.set("n", "<space>to", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 5)

  job_id = vim.bo.channel
end)

local current_command = ""
vim.keymap.set("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input("Command: ")
  end

  vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)
-- get into normal mode when in terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

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

vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- or "E"/"W" if you prefer
    source = true, -- show source of the diagnostic (lua-language-server)
  },
  signs = true, -- keep signs in the gutter
  underline = true, -- underline the problematic code
  update_in_insert = false,
})

if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
