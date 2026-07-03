return {
  setup = function(capabilities)
    vim.lsp.config("lua_ls", {
      cmd = { "lua-language-server" },
      capabilities = capabilities,
      filetypes = { "lua" },
      root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          runtime = {
            version = "LuaJIT",
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")
  end,
}
