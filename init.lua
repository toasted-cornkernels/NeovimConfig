vim.opt.shortmess = "I"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("lazy").setup("plugins")

local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<tab>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'ultisnips' },
    { name = 'path' },
  }, {
    { name = 'buffer', keyword_length = 5 },
  })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

vim.encoding = "utf-8"
vim.fileencoding = "utf-8"
vim.clipboard = unnamed
vim.mouse = "a"
vim.showmode = false
vim.signcolumn = "yes"
vim.updatetime = 250
vim.timeoutlen = 300
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.breakindent = true
vim.undofile = true
vim.nonumber = true
vim.guioptions = ""
vim.splitright = true
vim.splitbelow = true
vim.noswapfile = true
vim.ignorecase = tru
vim.smartcase = true
vim.smartindent = true
vim.tabstop = 4
vim.softtabstop = 4
vim.expandtab = true
vim.shiftwidth = 4
vim.inccommand = "split"
vim.cursorline = false
vim.scrolloff = 3
vim.sidescrolloff = 5
vim.list = true
vim.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.history = 1000

-- Neoformat config
vim.g.neoformat_enabled_python = {"black"}

local i = 1
while i <= 9 do
    vim.keymap.set("n", "<leader>" .. i, ":" .. i .. " wincmd w<cr>", opts)
    i = i + 1
end

vim.api.nvim_create_user_command("W", "<line1>,<line2>write<bang> <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("Write", "<line1>,<line2>write<bang> <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("Wq", "<line1>,<line2>wq<bang> <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("WQ", "<line1>,<line2>wq<bang> <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("WQall", "wqa<bang>", {bar = true, bang = true})
vim.api.nvim_create_user_command("We", "<line1>,<line2>w<bang> | e <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("Wnext", "<count>wnext<bang> <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("Wprevious", "<count>wprevious<bang> <args>", {bar = true, nargs = "*", complete = "file", range = "%", bang = true})
vim.api.nvim_create_user_command("E", "edit<bang> <args>", {bar = true, nargs = "*", complete = "file", bang = true})
vim.api.nvim_create_user_command("Edit", "edit<bang> <args>", {bar = true, nargs = "*", complete = "file", bang = true})
vim.api.nvim_create_user_command("Q", "quit<bang>", {bar = true, bang = true})
vim.api.nvim_create_user_command("Quit", "quit<bang>", {bar = true, bang = true})
vim.api.nvim_create_user_command("Qall", "qall<bang>", {bar = true, bang = true})
vim.api.nvim_create_user_command("Set", "set <args>", {bar = true, nargs = "?", complete = "option"})
vim.api.nvim_create_user_command("Help", "help <args>", {bar = true, nargs = "?", complete = "help"})
vim.api.nvim_create_user_command("Make", "make<bang> <args>", {bar = true, nargs = "*", complete = "file", bang = true})
vim.api.nvim_buf_create_user_command(0, "Bdel", "bdel<bang> <args>", {bar = true, nargs = "*", bang = true})
vim.api.nvim_buf_create_user_command(0, "Bwipe", "bwipe<bang> <args>", {bar = true, nargs = "*", bang = true})
vim.api.nvim_create_user_command("Mksession", "mksession<bang> <args>", {bar = true, nargs = "*", complete = "file", bang = true})
vim.api.nvim_create_user_command("Cd", "cd<bang> <args>", {bar = true, nargs = "*", complete = "dir", bang = true})
vim.api.nvim_create_user_command("Messages", "messages", {bar = true})
vim.api.nvim_create_user_command("Source", "source", {bar = true, nargs = "+", complete = "file", bang = true})

vim.g.sexp_filetypes = "clojure,scheme,lisp,timl,fennel,janet"
