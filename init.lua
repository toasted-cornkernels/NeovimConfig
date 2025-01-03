vim.opt.shortmess = "I"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
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

vim.encoding = "utf-8"
vim.fileencoding = "utf-8"
vim.mouse = "a"
vim.opt.showmode = false
vim.opt.showcmd = false
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
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.tabstop = 2
vim.softtabstop = 2
vim.expandtab = true
vim.shiftwidth = 2
vim.inccommand = "split"
vim.cursorline = false
vim.scrolloff = 3
vim.sidescrolloff = 5
vim.list = true
vim.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.history = 1000
vim.opt.fillchars = { eob = ' ' }

-- Neoformat config
vim.g.neoformat_enabled_python = { "black" }

vim.api.nvim_create_user_command("W", "<line1>,<line2>write<bang> <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("Write", "<line1>,<line2>write<bang> <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("Wq", "<line1>,<line2>wq<bang> <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("WQ", "<line1>,<line2>wq<bang> <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("WQall", "wqa<bang>", { bar = true, bang = true })
vim.api.nvim_create_user_command("We", "<line1>,<line2>w<bang> | e <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("Wnext", "<count>wnext<bang> <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("Wprevious", "<count>wprevious<bang> <args>",
  { bar = true, nargs = "*", complete = "file", range = "%", bang = true })
vim.api.nvim_create_user_command("E", "edit<bang> <args>", { bar = true, nargs = "*", complete = "file", bang = true })
vim.api.nvim_create_user_command("Edit", "edit<bang> <args>", { bar = true, nargs = "*", complete = "file", bang = true })
vim.api.nvim_create_user_command("Q", "quit<bang>", { bar = true, bang = true })
vim.api.nvim_create_user_command("Quit", "quit<bang>", { bar = true, bang = true })
vim.api.nvim_create_user_command("Qall", "qall<bang>", { bar = true, bang = true })
vim.api.nvim_create_user_command("Set", "set <args>", { bar = true, nargs = "?", complete = "option" })
vim.api.nvim_create_user_command("Help", "help <args>", { bar = true, nargs = "?", complete = "help" })
vim.api.nvim_create_user_command("Make", "make<bang> <args>", { bar = true, nargs = "*", complete = "file", bang = true })
vim.api.nvim_buf_create_user_command(0, "Bdel", "bdel<bang> <args>", { bar = true, nargs = "*", bang = true })
vim.api.nvim_buf_create_user_command(0, "Bwipe", "bwipe<bang> <args>", { bar = true, nargs = "*", bang = true })
vim.api.nvim_create_user_command("Mksession", "mksession<bang> <args>",
  { bar = true, nargs = "*", complete = "file", bang = true })
vim.api.nvim_create_user_command("Cd", "cd<bang> <args>", { bar = true, nargs = "*", complete = "dir", bang = true })
vim.api.nvim_create_user_command("Messages", "messages", { bar = true })
vim.api.nvim_create_user_command("Source", "source", { bar = true, nargs = "+", complete = "file", bang = true })

vim.g.sexp_filetypes = "clojure,scheme,lisp,timl,fennel,janet"
