vim.opt.shortmess = vim.opt.shortmess + "ltToOCFI"

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

require("lazy").setup({
  'Olical/aniseed',

  'Olical/conjure',

  'Olical/fennel.vim',

  'nvim-telescope/telescope.nvim',

  'nvim-telescope/telescope-file-browser.nvim',

  'tpope/vim-commentary',

  'tpope/vim-repeat',

  'tpope/vim-vinegar',

  'tpope/vim-surround',

  'tpope/vim-sexp-mappings-for-regular-people',

  'nvim-lua/plenary.nvim',

  'chrisbra/NrrwRgn',

  'hylang/vim-hy',

  'sbdchd/neoformat',

  'nvim-orgmode/orgmode',

  'guns/vim-sexp',

  'farmergreg/vim-lastplace',

  'rafcamlet/nvim-luapad',

  'andymass/vim-matchup',

  'SirVer/ultisnips',
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          terminal_colors = true,
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          }
        }
      })
      vim.cmd("colorscheme carbonfox")
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.cmd("colorscheme carbonfox")
      require('lualine').setup({
        options = {
          icons_enabled = true,
        }
      })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require 'cmp'

      cmp.setup({
        preselect = cmp.PreselectMode.None,
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
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-g>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.config.disable
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
    end
  },
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.cmd("colorscheme carbonfox")
      end,
      set_light_mode = function()
        vim.cmd("colorscheme dayfox")
      end,
      update_interval = 3000,
      fallback = "dark"
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        ensure_installed = {
          "vimdoc",
          "luadoc",
          "vim",
          "lua",
          "markdown",
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")

      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" }, -- it will not add a pair on that treesitter node
          javascript = { "template_string" },
          java = false, -- don't check treesitter on java
        },
      })

      local ts_conds = require("nvim-autopairs.ts-conds")

      -- press % => %% only while inside a comment or string
      npairs.add_rules({
        Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
        Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
      })
    end,
  },
  {
    "https://git.sr.ht/~swaits/scratch.nvim",
    lazy = true,
    keys = {
      { "<leader>bs", "<cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
      { "<leader>bS", "<cmd>ScratchSplit<cr>", desc = "Scratch Buffer (split)", mode = "n" },
    },
    cmd = {
      "Scratch",
      "ScratchSplit",
    },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      spec = {
        { "<leader>b", group = "Buffers", mode = { "n", "x" } },
        { "<leader>c", group = "Code", mode = { "n", "x" } },
        { "<leader>d", group = "Document", mode = { "n" } },
        { "<leader>f", group = "File", mode = { "n", "x" } },
        { "<leader>fe", group = "Config", mode = { "n", "x" } },
        { "<leader>w", group = "Window", mode = { "n" } },
        { "<leader>r", group = "Rename", mode = { "n" } },
        { "<leader>s", group = "Search", mode = { "n", "x" } },
        { "<leader>w", group = "Window", mode = { "n" } },
        { "<leader>t", group = "Toggle", mode = { "n" } },
        { "<leader>g", group = "Git", mode = { "n", "v" } },
        { "<leader>q", group = "Quit", mode = { "n" } },
      },
    },
  },
})

function make_noremap_opts(description)
  return { noremap = true, desc = description }
end
local opts = { noremap = true }

vim.keymap.set("n", "<leader>!", ":!", make_noremap_opts("Shell Command"))
vim.keymap.set("n", "<leader>[", ":tabprev<cr>", make_noremap_opts("Previous Tab"))
vim.keymap.set("n", "<leader>]", ":tabnext<cr>", make_noremap_opts("Next Tab"))
vim.keymap.set("n", "<leader>.", ":tabnew<cr>", make_noremap_opts("Open Tab"))
vim.keymap.set("n", "<leader>,", ":tabclose<cr>", make_noremap_opts("Close Tab"))
vim.keymap.set("n", "<leader>o", ":Telescope find_files<cr>", make_noremap_opts("Find File"))
vim.keymap.set("n", "<leader>;", ":vs<cr>", make_noremap_opts("Split Window Right"))
vim.keymap.set("n", "<leader>'", ":sp<cr>", make_noremap_opts("Split Window Below"))

local i = 1
while i <= 9 do
  vim.keymap.set("n", "<leader>" .. i, ":" .. i .. " wincmd w<cr>", opts)
  i = i + 1
end

-- Buffers ==========================================
-- ==================================================

vim.keymap.set("n", "<leader>bb", ":Telescope buffers<cr>", make_noremap_opts("List buffers"))
vim.keymap.set("n", "<leader>be", ":ggdG", make_noremap_opts("Erase Buffer"))
vim.keymap.set("n", "<leader>bp", ":bp<cr>", make_noremap_opts("Previous Buffer"))
vim.keymap.set("n", "<leader>bn", ":bn<cr>", make_noremap_opts("Next Buffer"))
vim.keymap.set("n", "<leader>bd", ":bw<cr>", make_noremap_opts("Close Buffer"))
vim.keymap.set("n", "<leader>b=", ":Neoformat<cr>", make_noremap_opts("Format Buffer"))

-- Narrowing ========================================
-- ==================================================

vim.keymap.set("n", "<leader>nt", ":tabnew<cr>", opts)

-- Files ============================================
-- ==================================================

vim.keymap.set("n", "<leader>fn", ":next<cr>", make_noremap_opts("Next File"))
vim.keymap.set("n", "<leader>fp", ":prev<cr>", make_noremap_opts("Previous File"))
vim.keymap.set("n", "<leader>fs", ":w<cr>", make_noremap_opts("Write File"))
vim.keymap.set("n", "<leader>ff", ":Telescope fd<cr>", make_noremap_opts("Find File"))
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<cr>", make_noremap_opts("Find Recent File"))
vim.keymap.set("n", "<leader>fed", ":e ~/.config/nvim/init.lua<cr>", make_noremap_opts("Open Config File"))

-- Windows ==========================================
-- ==================================================

vim.keymap.set("n", "<leader>w<tab>", "<C-w>p", opts)
vim.keymap.set("n", "<leader>wd", "<C-w>c", opts)
vim.keymap.set("n", "<leader>wv", ":vs<cr>", opts)
vim.keymap.set("n", "<leader>ws", ":sp<cr>", opts)
vim.keymap.set("n", "<leader>wh", "<C-w>h", opts)
vim.keymap.set("n", "<leader>wj", "<C-w>j", opts)
vim.keymap.set("n", "<leader>wk", "<C-w>k", opts)
vim.keymap.set("n", "<leader>wl", "<C-w>l", opts)
vim.keymap.set("n", "<leader>wr", "<C-w>r", opts)
vim.keymap.set("n", "<leader>w=", "<C-w>=", opts)

-- Search ===========================================
-- ==================================================

vim.keymap.set("n", "<leader>sc", ":noh<cr>", opts)
vim.keymap.set("n", "<leader>saf", ":Telescope grep_string<cr>", opts)
vim.keymap.set("n", "<leader>st", ":CocOutline<cr>", opts)
vim.keymap.set("n", "<leader>si", ":CocList outline<cr>", opts)

-- Git ==============================================
-- ==================================================

vim.keymap.set("n", "<leader>gs", ":Neogit<cr>", opts)
vim.keymap.set("n", "<leader>gc", ":Neogit commit<cr>", opts)
vim.keymap.set("n", "<leader>gpu", ":Neogit push<cr>", opts)

vim.keymap.set("n", "<leader>qq", ":qa!<cr>", opts)

-- Projects =========================================
-- ==================================================

vim.keymap.set("n", "<leader>p/", ":Rg", opts)

vim.keymap.set("n", "<leader>cdc", ":lcd %:p:h<cr>", opts)
vim.keymap.set("n", "<leader>cdt", ":lcd", opts)
vim.keymap.set("n", "<leader>cC", ":make<cr>", opts)

vim.keymap.set("n", "<leader>Tp", ":colorscheme seoul256<cr>", opts)
vim.keymap.set("n", "<leader>Tn", ":colorscheme seoul256-light<cr>", opts)

vim.keymap.set("n", "<leader><leader>", ":Telescope commands<cr>", opts)
vim.keymap.set("n", "<leader><TAB>", "<C-^>", opts)

-- Non-leader Vim keys ==============================
-- ==================================================

vim.keymap.set("n", "ZA", ":wqa!<cr>", opts)

-- Emacs-like keys ==================================
-- ==================================================

vim.keymap.set("n", "<C-x><C-c>", ":wqa!<cr>", opts)
vim.keymap.set("i", "<C-f>", "<right>", opts)
vim.keymap.set("i", "<C-b>", "<left>", opts)
vim.keymap.set("i", "<C-l>", "<esc>zza", opts)
vim.keymap.set("n", "<C-l>", "zz", opts)

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
vim.opt.tabstop = 2
vim.bo.softtabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.inccommand = "split"
vim.cursorline = false
vim.scrolloff = 3
vim.sidescrolloff = 5
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.list = true
vim.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.history = 1000
vim.opt.fillchars = { eob = ' ' }

vim.cmd [[
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none
]]

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
