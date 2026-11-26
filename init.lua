-- Neovim config.
--
-- Stock first: whatever Neovim 0.12 ships (vim.pack, LSP client, completion,
-- tree-sitter, commenting, statusline, undotree, :restart, ...) is used
-- directly; plugins fill the remaining gaps.
--
-- Keymaps mirror ~/.emacs.d/init.el: SPC is general.el's `global-leader`, `,`
-- is its `local-leader`.
--
-- Tree-sitter parsers are provisioned by Nix (LambdaMachine
-- Common/modules/neovim-treesitter.nix) into stdpath("data")/site/parser.

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Must be set before vim-sexp's plugin/ script is sourced.
vim.g.sexp_filetypes = "clojure,scheme,lisp,timl,fennel,janet,hy,racket"

local api, fn = vim.api, vim.fn
local augroup = api.nvim_create_augroup("init", { clear = true })

local function autocmd(event, opts)
  opts.group = augroup
  return api.nvim_create_autocmd(event, opts)
end

local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Like map(), but for commands that need further typing on the cmdline.
local function cmdline(mode, lhs, text, desc)
  vim.keymap.set(mode, lhs, ":" .. text, { desc = desc })
end

-- Options ==========================================
-- ==================================================

-- These must all go through vim.opt/vim.o. A bare `vim.foo = ...` just sets a
-- field on the vim table and is silently ignored.
vim.opt.shortmess:append("ltToOCFI")
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.showcmd = false
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.undofile = true
vim.o.number = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.inccommand = "split"
vim.o.cursorline = false
vim.o.scrolloff = 3
vim.o.sidescrolloff = 5
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.history = 1000
vim.opt.fillchars = { eob = " " }
vim.o.winborder = "rounded"
vim.o.wildoptions = "pum"
-- Like recentf-exclude: keep throwaway paths out of :oldfiles.
vim.opt.shada:append({ "r/tmp", "r/private/var/folders" })
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"

-- Tree-sitter folding; buffers without a parser simply get no folds.
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.foldlevelstart = 99

-- Plugins (vim.pack) ===============================
-- ==================================================
-- Revisions are pinned in nvim-pack-lock.json next to this file. Update with
-- :lua vim.pack.update(), commit the lockfile afterwards.

local function gh(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  -- Libraries
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("MunifTanjim/nui.nvim"),

  -- Kept for its query corpus only; parsers come from Nix, so :TSInstall is
  -- never used. Pinned because the Nix module pins grammar revisions to match
  -- this commit's queries -- bump both together.
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "9a168f6357ed21c3a636e1727bc7d382abc451b8" },
  -- Server configs for the stock client (vim.lsp.config/enable).
  gh("neovim/nvim-lspconfig"),

  -- UI
  { src = gh("catppuccin/nvim"), name = "catppuccin" },
  gh("f-person/auto-dark-mode.nvim"),
  gh("folke/which-key.nvim"),
  gh("folke/flash.nvim"),

  -- Pickers
  gh("nvim-telescope/telescope.nvim"),
  gh("nvim-telescope/telescope-file-browser.nvim"),
  gh("nvim-telescope/telescope-project.nvim"),

  -- Git
  gh("lewis6991/gitsigns.nvim"),
  gh("NeogitOrg/neogit"),
  gh("sindrets/diffview.nvim"),

  -- Editing
  gh("windwp/nvim-autopairs"),
  gh("tpope/vim-repeat"),
  gh("tpope/vim-surround"),
  gh("tpope/vim-vinegar"),
  gh("guns/vim-sexp"),
  gh("tpope/vim-sexp-mappings-for-regular-people"),
  gh("hylang/vim-hy"),
  gh("chrisbra/NrrwRgn"),
  gh("rafcamlet/nvim-luapad"),

  -- Org. Pinned because it requires an exact tree-sitter-org version, which
  -- the Nix module pins too (currently 2.0.4) -- bump both together.
  { src = gh("nvim-orgmode/orgmode"), version = "3bfd89bcfb210c5768be41f00c51f3f4721e55e7" },

  -- CodeQL
  gh("jeongsoolee09/codeql.nvim"),

  -- AI: Copilot CLI beside the editor (tmux split or terminal), and Copilot
  -- CLI as an in-editor agent over ACP (`copilot --acp`).
  gh("folke/sidekick.nvim"),
  gh("olimorris/codecompanion.nvim"),
}, { confirm = false })

-- Stock plugins shipped with Neovim but not loaded by default.
vim.cmd.packadd("nvim.undotree")

-- Expose nvim-treesitter's bundled queries for every language directly.
-- Normally :TSInstall copies these per-language into its install_dir.
vim.opt.runtimepath:append(vim.fs.joinpath(fn.stdpath("data"), "site/pack/core/opt/nvim-treesitter/runtime"))

-- Colorscheme ======================================
-- ==================================================
-- Matches Emacs' catppuccin mocha/latte, transparent like the old setup.

require("catppuccin").setup({
  background = { light = "latte", dark = "mocha" },
  transparent_background = true,
  term_colors = true,
  styles = {
    comments = { "italic" },
    keywords = { "bold" },
    types = { "italic", "bold" },
  },
  integrations = {
    diffview = true,
    flash = true,
    gitsigns = true,
    neogit = true,
    telescope = { enabled = true },
    which_key = true,
  },
})
vim.cmd.colorscheme("catppuccin")

-- Follows macOS appearance (works inside tmux too).
require("auto-dark-mode").setup({
  set_dark_mode = function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("catppuccin")
  end,
  set_light_mode = function()
    vim.o.background = "light"
    vim.cmd.colorscheme("catppuccin")
  end,
  update_interval = 3000,
  fallback = "dark",
})

-- Tree-sitter ======================================
-- ==================================================

-- Highlight every filetype that has a parser available (Nix-provided or
-- bundled with Neovim); others keep regex syntax.
autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

-- LSP ==============================================
-- ==================================================
-- Configs come from nvim-lspconfig's lsp/*.lua; enable only servers that are
-- actually installed so missing ones don't spam errors.

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- No longer shipped by nvim-lspconfig.
vim.lsp.config("codeqlls", {
  cmd = { "codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q" },
  filetypes = { "ql" },
  root_markers = { "qlpack.yml", "codeql-pack.yml", ".git" },
})

for _, server in ipairs({
  "bashls",
  "clangd",
  "clojure_lsp",
  "codeqlls",
  "gopls",
  "jsonls",
  "lua_ls",
  "nixd",
  "ocamllsp",
  "pyright",
  "ruff",
  "rust_analyzer",
  "ts_ls",
  "yamlls",
}) do
  local cmd = (vim.lsp.config[server] or {}).cmd
  if type(cmd) == "function" or (type(cmd) == "table" and fn.executable(cmd[1]) == 1) then
    vim.lsp.enable(server)
  end
end

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  float = { source = true },
})

-- Completion =======================================
-- ==================================================
-- Stock 'autocomplete' drives the popup. Like corfu + cape, where the first
-- capf with results wins: LSP buffers complete from the server only (see
-- LspAttach), others from words in visible windows (cape-dabbrev). Prefix
-- matching like the `basic` completion style; no fuzzy noise.

vim.o.autocomplete = true
vim.o.autocompletedelay = 200
vim.o.complete = ".,w"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
-- Silences ins-completion messages ("Pattern not found", "match 1 of 2"),
-- which 'autocomplete' would otherwise flash on every keystroke.
vim.opt.shortmess:append("c")

autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      -- Sets 'omnifunc' and handles snippets/additionalTextEdits on accept;
      -- triggering is left to 'autocomplete'.
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
      vim.bo[args.buf].complete = "o"
    end
  end,
})

-- <Tab> confirms the popup selection, selecting the first entry if none is
-- highlighted yet; otherwise it inserts a plain tab.
vim.keymap.set("i", "<Tab>", function()
  if fn.pumvisible() == 0 then
    return "<Tab>"
  end
  return fn.complete_info({ "selected" }).selected == -1 and "<C-n><C-y>" or "<C-y>"
end, { expr = true })

-- Formatting =======================================
-- ==================================================
-- A CLI formatter if one is configured and installed, else the LSP server.
-- Runs off-buffer so a failing formatter never clobbers the text.

local formatters = {
  python = { "ruff", "format", "--stdin-filename", "%" },
  sh = { "shfmt", "-" },
  bash = { "shfmt", "-" },
  nix = { "nixfmt" },
  lua = { "stylua", "--stdin-filepath", "%", "-" },
  javascript = { "prettier", "--stdin-filepath", "%" },
  typescript = { "prettier", "--stdin-filepath", "%" },
  json = { "prettier", "--stdin-filepath", "%" },
  yaml = { "prettier", "--stdin-filepath", "%" },
  markdown = { "prettier", "--stdin-filepath", "%" },
  css = { "prettier", "--stdin-filepath", "%" },
  html = { "prettier", "--stdin-filepath", "%" },
}

local function format_buffer()
  local buf = api.nvim_get_current_buf()
  local cmd = formatters[vim.bo[buf].filetype]
  if cmd and fn.executable(cmd[1]) == 1 then
    local name = api.nvim_buf_get_name(buf)
    cmd = vim.tbl_map(function(arg)
      return arg == "%" and (name ~= "" and name or "stdin") or arg
    end, cmd)
    local input = table.concat(api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
    local result = vim.system(cmd, { stdin = input, text = true }):wait()
    if result.code ~= 0 then
      vim.notify(cmd[1] .. ": " .. vim.trim(result.stderr or ""), vim.log.levels.ERROR)
      return
    end
    local lines = vim.split(result.stdout:gsub("\n$", ""), "\n", { plain = true })
    if not vim.deep_equal(lines, api.nvim_buf_get_lines(buf, 0, -1, false)) then
      local view = fn.winsaveview()
      api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      fn.winrestview(view)
    end
  elseif #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/formatting" }) > 0 then
    vim.lsp.buf.format({ bufnr = buf })
  else
    local view = fn.winsaveview()
    vim.cmd("normal! gg=G")
    fn.winrestview(view)
  end
end

-- Pickers & navigation =============================
-- ==================================================

local telescope = require("telescope")
local fb_actions = require("telescope._extensions.file_browser.actions")

-- Opens the directory being browsed in netrw, like find-file on a directory
-- opening dired.
local function fb_open_in_netrw(prompt_bufnr)
  local path = require("telescope.actions.state").get_current_picker(prompt_bufnr).finder.path
  require("telescope.actions").close(prompt_bufnr)
  vim.cmd.edit(fn.fnameescape(path))
end

telescope.setup({
  extensions = {
    -- Mirrors Emacs find-file + dired (`ls -al --group-directories-first`)
    -- with vertico-directory keys.
    file_browser = {
      hijack_netrw = false, -- netrw stays for vim-vinegar's `-`
      grouped = true,
      hidden = { file_browser = true, folder_browser = true },
      respect_gitignore = false,
      no_ignore = true,
      prompt_path = true,
      mappings = {
        i = {
          ["<C-l>"] = fb_actions.goto_parent_dir,
          ["<M-CR>"] = fb_open_in_netrw,
        },
        n = {
          ["-"] = fb_actions.goto_parent_dir,
          ["<M-CR>"] = fb_open_in_netrw,
        },
      },
    },
  },
})
telescope.load_extension("file_browser")
telescope.load_extension("project")
local tb = require("telescope.builtin")

local function file_browser(opts)
  telescope.extensions.file_browser.file_browser(opts)
end

-- The buffer's directory with symlinks resolved, so ~/.config/nvim/init.lua
-- maps to its real repo (NeovimConfig) rather than the Nix store link.
local function buffer_dir(buf)
  buf = buf or 0
  local name = api.nvim_buf_get_name(buf)
  if name == "" or vim.bo[buf].buftype ~= "" then
    return fn.getcwd()
  end
  local dir = vim.fs.dirname(vim.uv.fs_realpath(name) or name)
  return vim.uv.fs_realpath(dir) or dir
end

local function project_root()
  return vim.fs.root(buffer_dir(), ".git") or fn.getcwd()
end

-- Each file's window works from that file's directory, like default-directory.
api.nvim_create_autocmd("BufEnter", {
  group = api.nvim_create_augroup("BufferDirectory", { clear = true }),
  callback = function(ev)
    local name = api.nvim_buf_get_name(ev.buf)
    if name == "" or vim.bo[ev.buf].buftype ~= "" or fn.isdirectory(name) == 1 then
      return
    end
    local dir = buffer_dir(ev.buf)
    if fn.isdirectory(dir) == 1 and dir ~= fn.getcwd() then
      vim.cmd.lcd(fn.fnameescape(dir))
    end
  end,
})

require("flash").setup({
  -- Only on explicit SPC j j; f/t/F/T and / stay stock.
  modes = { search = { enabled = false }, char = { enabled = false } },
})

-- Git ==============================================
-- ==================================================

require("neogit").setup({ popup = { kind = "split" } })

require("gitsigns").setup({
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function bmap(mode, lhs, rhs, desc)
      map(mode, lhs, rhs, desc, { buffer = buf })
    end
    local function next_hunk()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end
    local function prev_hunk()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end
    local function next_preview()
      gs.nav_hunk("next", { preview = true })
    end
    local function prev_preview()
      gs.nav_hunk("prev", { preview = true })
    end

    bmap("n", "]c", next_hunk, "Next Hunk")
    bmap("n", "[c", prev_hunk, "Previous Hunk")
    -- diff-hl local-leader bindings
    bmap("n", "<localleader>vj", next_hunk, "Next Hunk")
    bmap("n", "<localleader>vk", prev_hunk, "Previous Hunk")
    bmap("n", "<localleader>vn", next_hunk, "Next Hunk")
    bmap("n", "<localleader>vp", prev_hunk, "Previous Hunk")
    bmap("n", "<localleader>vJ", next_preview, "Show Next Hunk")
    bmap("n", "<localleader>vK", prev_preview, "Show Previous Hunk")
    bmap("n", "<localleader>vN", next_preview, "Show Next Hunk")
    bmap("n", "<localleader>vP", prev_preview, "Show Previous Hunk")
    bmap("n", "<localleader>va", gs.stage_hunk, "Stage Hunk")
    bmap("n", "<localleader>vs", gs.stage_hunk, "Stage Hunk")
    bmap("x", "<localleader>vs", function()
      gs.stage_hunk({ fn.line("."), fn.line("v") })
    end, "Stage Lines")
    bmap("n", "<localleader>vS", gs.stage_buffer, "Stage Buffer")
    bmap("n", "<localleader>vr", gs.reset_hunk, "Revert Hunk")
    bmap("x", "<localleader>vr", function()
      gs.reset_hunk({ fn.line("."), fn.line("v") })
    end, "Revert Lines")
    bmap("n", "<localleader>v.", gs.preview_hunk, "Show Hunk")
    bmap({ "o", "x" }, "ih", gs.select_hunk, "Hunk")
  end,
})

-- Opens the file (or a line range of it) on GitHub via `gh browse`.
local function gh_browse(flags, range)
  local root = vim.fs.root(0, ".git")
  local name = api.nvim_buf_get_name(0)
  if not root or name == "" then
    vim.notify("Not visiting a file in a git repository", vim.log.levels.WARN)
    return
  end
  local target = vim.fs.relpath(root, name)
  if range then
    target = target .. ":" .. range[1] .. (range[2] ~= range[1] and ("-" .. range[2]) or "")
  end
  local cmd = vim.list_extend({ "gh", "browse", target }, flags)
  local result = vim.system(cmd, { cwd = root, text = true }):wait()
  if result.code ~= 0 then
    vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
  elseif vim.tbl_contains(flags, "-n") then
    local url = vim.trim(result.stdout)
    fn.setreg("+", url)
    vim.notify("Copied " .. url)
  end
end

local function current_range()
  local a, b = fn.line("v"), fn.line(".")
  if fn.mode():match("[vV\22]") then
    return { math.min(a, b), math.max(a, b) }
  end
  return { b, b }
end

-- Editing ==========================================
-- ==================================================

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")
npairs.setup({
  check_ts = true,
  ts_config = {
    lua = { "string" }, -- it will not add a pair on that treesitter node
    javascript = { "template_string" },
    java = false, -- don't check treesitter on java
  },
})
-- press % => %% only while inside a comment or string
npairs.add_rules({
  Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
  Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
})

-- Jump to the last cursor position when reopening a file (vim-lastplace).
autocmd("BufReadPost", {
  callback = function(args)
    if vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[args.buf].filetype) then
      return
    end
    local mark = api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= api.nvim_buf_line_count(args.buf) then
      pcall(api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zz")
    end
  end,
})

-- Make scripts with a shebang executable on save
-- (executable-make-buffer-file-executable-if-script-p).
autocmd("BufWritePost", {
  callback = function(args)
    local first = api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
    if first:sub(1, 2) == "#!" then
      local path = api.nvim_buf_get_name(args.buf)
      local perm = fn.getfperm(path)
      if perm ~= "" and perm:sub(3, 3) ~= "x" then
        fn.setfperm(path, perm:sub(1, 2) .. "x" .. perm:sub(4, 5) .. "x" .. perm:sub(7, 8) .. "x")
      end
    end
  end,
})

autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Org ==============================================
-- ==================================================

local org_dir = "~/Org"
local tagged_entry = "** %?          :%^{Tag}:\n\nEntered on %U\n%a\n"
local thought_record = vim.fs.joinpath(vim.env.HOME, ".emacs.d/CaptureTemplates/Org/ThoughtRecordTemplate.org")

local capture_templates = {
  t = {
    description = "TODO",
    template = "** TODO %?          :%^{Tag}:\n\nEntered on %U\n%a\n",
    target = org_dir .. "/TODO.org",
    headline = "Tasks",
  },
  l = { description = "TIL", template = tagged_entry, target = org_dir .. "/TIL.org", headline = "TIL" },
  c = {
    description = "Clipboard",
    template = tagged_entry,
    target = org_dir .. "/Clipboard.org",
    headline = "Clipboard",
  },
  a = { description = "Journal", template = "** %U\n\n%?\n", target = org_dir .. "/Journal.org", datetree = true },
  n = {
    description = "ShowerThoughts",
    template = tagged_entry,
    target = org_dir .. "/ShowerThoughts.org",
    headline = "ShowerThoughts",
  },
}
if vim.uv.fs_stat(thought_record) then
  capture_templates.T = {
    description = "Thought Record",
    template = table.concat(fn.readfile(thought_record), "\n"),
    target = org_dir .. "/ThoughtRecord.org",
    headline = "Thought Record",
  }
end

-- tree-sitter-org comes from Nix. Without it orgmode would compile its own
-- copy into its plugin dir, which then conflicts with Nix's once installed.
if #api.nvim_get_runtime_file("parser/org.so", false) == 0 then
  local ok, installer = pcall(require, "orgmode.utils.treesitter.install")
  if ok then
    installer.install = function()
      vim.notify("tree-sitter-org not found; switch to the latest Nix generation", vim.log.levels.WARN)
      return false
    end
  end
end

require("orgmode").setup({
  org_agenda_files = org_dir .. "/**/*",
  org_default_notes_file = org_dir .. "/notes.org",
  org_capture_templates = capture_templates,
  mappings = {
    prefix = "<localleader>",
    -- Defaults are <prefix>a/<prefix>c, which would claim `,a`/`,c` globally.
    global = { org_agenda = "<leader>aoo", org_capture = "<leader>aoc" },
    capture = {
      org_capture_finalize = { "<C-c>", "<localleader><localleader>", "<localleader>c" },
      org_capture_kill = { "<localleader>k", "<localleader>a" },
    },
  },
})

-- Copilot CLI companion ============================
-- ==================================================
-- Neovim runs in a tmux pane next to `copilot`.
--
-- 1. Files Copilot edits are reloaded automatically.
-- 2. This instance advertises its RPC socket as the tmux window option
--    @nvim_server, so Copilot (or anything in the window) can open files here:
--      nvim --server "$(tmux show -wv @nvim_server)" --remote-tab FILE
-- 3. SPC L drives Copilot CLI: beside the editor via sidekick.nvim, or
--    in-editor over ACP via CodeCompanion (Emacs' agent-shell).

vim.o.autoread = true
autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  callback = function()
    if fn.getcmdwintype() == "" then
      vim.cmd("silent! checktime")
    end
  end,
})
-- FocusGained doesn't fire while focus stays in the Copilot pane, so poll too.
local reload_timer = vim.uv.new_timer()
reload_timer:start(
  1000,
  1000,
  vim.schedule_wrap(function()
    if api.nvim_get_mode().mode == "n" and fn.getcmdwintype() == "" then
      vim.cmd("silent! checktime")
    end
  end)
)
autocmd("FileChangedShellPost", {
  callback = function(args)
    -- Deferred so the :silent around checktime doesn't swallow it.
    vim.schedule(function()
      vim.notify("Reloaded " .. fn.fnamemodify(args.file, ":~:."), vim.log.levels.INFO)
    end)
  end,
})

local function tmux(args, input)
  local result = vim.system(vim.list_extend({ "tmux" }, args), { stdin = input, text = true }):wait()
  if result.code ~= 0 then
    return nil, vim.trim(result.stderr or "")
  end
  return vim.trim(result.stdout)
end

if vim.env.TMUX and vim.env.TMUX_PANE then
  autocmd("VimEnter", {
    callback = function()
      tmux({ "set-option", "-w", "-t", vim.env.TMUX_PANE, "@nvim_server", vim.v.servername })
    end,
  })
  autocmd("VimLeavePre", {
    callback = function()
      tmux({ "set-option", "-wu", "-t", vim.env.TMUX_PANE, "@nvim_server" })
    end,
  })
end

local function current_file()
  local name = api.nvim_buf_get_name(0)
  if name == "" or vim.bo.buftype ~= "" then
    vim.notify("Not visiting a file", vim.log.levels.WARN)
    return nil
  end
  return name
end

-- sidekick.nvim runs `copilot` in a tmux split next to this pane (or a
-- Neovim terminal outside tmux), attaches to one already running, and renders
-- context as Copilot @-mentions ({file}, {position}, {selection}, ...).
require("sidekick").setup({
  nes = { enabled = false }, -- needs copilot-language-server
  cli = {
    watch = false, -- the autoread timer above already reloads edited files
    mux = { enabled = vim.env.TMUX ~= nil, create = "split" },
    picker = "telescope",
    tools = {
      -- Copilot's prompt drops the trailing newline sidekick sends, which
      -- would glue consecutive sends together.
      copilot = {
        format = function(_, str)
          return str .. " "
        end,
      },
    },
  },
})
local sidekick = require("sidekick.cli")

-- Prefers an already running `copilot` (e.g. the pane next to this one, ideally
-- in this cwd) so sidekick attaches instead of asking whether to start another.
local function copilot_filter()
  local State = require("sidekick.cli.state")
  for _, filter in ipairs({
    { name = "copilot", started = true, cwd = true },
    { name = "copilot", started = true },
  }) do
    if #State.get(filter) == 1 then
      return filter
    end
  end
  return { name = "copilot" }
end

local function copilot_send(msg)
  return function()
    sidekick.send({ filter = copilot_filter(), msg = msg, focus = true })
  end
end

local function copilot_yank_reference()
  if current_file() then
    local ref = vim.trim(sidekick.render("{position}"))
    api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    fn.setreg("+", ref)
    vim.notify("Copied " .. ref)
  end
end

-- CodeCompanion is the agent-shell counterpart: Copilot CLI as an in-editor
-- agent over ACP (`copilot --acp`), chat in a buffer, edits applied through
-- Neovim. Defaults mirror Emacs' agent-shell-github-* settings.
require("codecompanion").setup({
  adapters = {
    acp = {
      copilot_acp = function()
        return require("codecompanion.adapters").extend("copilot_acp", {
          defaults = {
            session_config_options = {
              model = "claude-opus-5.5",
              mode = "https://agentclientprotocol.com/protocol/session-modes#autopilot",
            },
          },
        })
      end,
    },
  },
  interactions = {
    chat = { adapter = "copilot_acp" },
  },
  display = {
    chat = { window = { layout = "vertical", position = "right" } },
  },
})

-- Buffers & sessions ===============================
-- ==================================================

-- Deletes a buffer without closing the windows showing it (kill-current-buffer).
local function buffer_delete()
  local buf = api.nvim_get_current_buf()
  local force = false
  if vim.bo[buf].modified then
    local choice = fn.confirm(("Save changes to %q?"):format(fn.bufname(buf)), "&Yes\n&No\n&Cancel", 3)
    if choice == 1 then
      vim.cmd.write()
    elseif choice == 2 then
      force = true
    else
      return
    end
  end
  for _, win in ipairs(fn.win_findbuf(buf)) do
    api.nvim_win_call(win, function()
      local alt = fn.bufnr("#")
      if alt > 0 and alt ~= buf and fn.buflisted(alt) == 1 then
        vim.cmd.buffer(alt)
      else
        pcall(vim.cmd.bprevious)
        if api.nvim_get_current_buf() == buf then
          vim.cmd.enew()
        end
      end
    end)
  end
  if api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd.bdelete, { buf, bang = force })
  end
end

local function scratch_buffer()
  local buf = fn.bufnr("*scratch*")
  if buf == -1 then
    buf = api.nvim_create_buf(true, true)
    api.nvim_buf_set_name(buf, "*scratch*")
    vim.bo[buf].bufhidden = "hide"
    vim.bo[buf].filetype = "org"
  end
  api.nvim_set_current_buf(buf)
end

local function rename_file()
  local old = current_file()
  if not old then
    return
  end
  vim.ui.input({ prompt = "Rename to: ", default = old, completion = "file" }, function(new)
    if not new or new == "" or new == old then
      return
    end
    if fn.rename(old, new) ~= 0 then
      vim.notify("Failed to rename " .. old, vim.log.levels.ERROR)
      return
    end
    vim.cmd("silent keepalt file " .. fn.fnameescape(new))
    vim.cmd("silent edit!")
  end)
end

local function delete_file()
  local file = current_file()
  if file and fn.confirm("Delete " .. fn.fnamemodify(file, ":~") .. "?", "&Yes\n&No", 2) == 1 then
    if fn.delete(file) == 0 then
      buffer_delete()
    else
      vim.notify("Failed to delete " .. file, vim.log.levels.ERROR)
    end
  end
end

-- desktop.el equivalents on top of :mksession.
local session_dir = vim.fs.joinpath(fn.stdpath("state"), "sessions")
local session_file = vim.fs.joinpath(session_dir, "default.vim")

local function session_save()
  fn.mkdir(session_dir, "p")
  vim.cmd.mksession({ fn.fnameescape(session_file), bang = true })
  vim.notify("Session saved")
end

local function session_read()
  if vim.uv.fs_stat(session_file) then
    vim.cmd.source(fn.fnameescape(session_file))
  else
    vim.notify("No saved session", vim.log.levels.WARN)
  end
end

local function session_remove()
  if fn.delete(session_file) == 0 then
    vim.notify("Session removed")
  end
end

local function session_clear()
  vim.cmd("silent! %bdelete")
end

local function project_terminal()
  vim.cmd("botright split")
  vim.cmd.lcd(fn.fnameescape(project_root()))
  vim.cmd.terminal()
end

-- Which-key ========================================
-- ==================================================

require("which-key").setup({
  delay = 200,
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
    { "<leader>a", group = "Utilities" },
    { "<leader>ao", group = "Org" },
    { "<leader>at", group = "Terminal" },
    { "<leader>ats", group = "Shell" },
    { "<leader>b", group = "Buffers" },
    { "<leader>c", group = "Compile/Dir" },
    { "<leader>D", group = "Desktop" },
    { "<leader>f", group = "Files", mode = { "n", "x" } },
    { "<leader>fb", group = "Bookmarks" },
    { "<leader>fD", group = "Delete" },
    { "<leader>fe", group = "Config" },
    { "<leader>fg", group = "Find/Grep" },
    { "<leader>g", group = "Git", mode = { "n", "x" } },
    { "<leader>gf", group = "File" },
    { "<leader>gl", group = "Links", mode = { "n", "x" } },
    { "<leader>h", group = "Help" },
    { "<leader>hd", group = "Describe" },
    { "<leader>i", group = "Imenu" },
    { "<leader>j", group = "Jump" },
    { "<leader>k", group = "Lisp" },
    { "<leader>L", group = "Copilot CLI", mode = { "n", "x" } },
    { "<leader>$", group = "Agent Shell", mode = { "n", "x" } },
    { "<leader>$s", group = "Start" },
    { "<leader>p", group = "Project" },
    { "<leader>q", group = "Quit" },
    { "<leader>s", group = "Search", mode = { "n", "x" } },
    { "<leader>S", group = "Packages" },
    { "<leader>Sp", group = "Package" },
    { "<leader>t", group = "Tabs" },
    { "<leader>T", group = "Toggles" },
    { "<leader>w", group = "Windows" },
    { "<leader>x", group = "Text" },
    { "<leader>xi", group = "Insert" },
    { "<leader>xw", group = "Word" },
    { "<leader>y", group = "Yank" },
    { "<localleader>a", group = "LSP" },
    { "<localleader>v", group = "Diff-hl" },
  },
})

-- Global leader (SPC) ==============================
-- ==================================================

map("n", "<leader><leader>", tb.commands, "Commands")
map("n", "<leader><Tab>", "<C-^>", "Last Buffer")
cmdline("n", "<leader>!", "!", "Shell Command")
cmdline("n", "<leader>:", "lua ", "Eval Lua")
map("n", "<leader><C-r>", "<Cmd>edit!<CR>", "Revert Buffer")
map("n", "<leader>;", "<Cmd>vsplit<CR>", "Split Window Right")
map("n", "<leader>'", "<Cmd>split<CR>", "Split Window Below")
for i = 1, 9 do
  map("n", "<leader>" .. i, "<Cmd>" .. i .. "wincmd w<CR>", "Window " .. i)
end
map("n", "<leader>o", function()
  file_browser({ path = buffer_dir(), select_buffer = true })
end, "Find File")
map("n", "<leader>/", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, "Next Diagnostic")
map("n", "<leader>\\", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, "Previous Diagnostic")

-- Tabs (tab-bar)
map("n", "<leader>.", "<Cmd>tabnew<CR>", "New Tab")
map("n", "<leader>,", "<Cmd>tabclose<CR>", "Close Tab")
map("n", "<leader>[", "<Cmd>tabprevious<CR>", "Previous Tab")
map("n", "<leader>]", "<Cmd>tabnext<CR>", "Next Tab")
map("n", "<leader>{", "<Cmd>-tabmove<CR>", "Move Tab Left")
map("n", "<leader>}", "<Cmd>+tabmove<CR>", "Move Tab Right")

-- a: utilities
map("n", "<leader>ai", function()
  vim.notify(os.date("%A, %B %d, %Y %H:%M"))
end, "Current Time")
map("n", "<leader>aoa", function()
  require("orgmode").action("agenda.agenda")
end, "Agenda List")
map("n", "<leader>aot", function()
  require("orgmode").action("agenda.todos")
end, "TODO List")
map("n", "<leader>aom", function()
  require("orgmode").action("agenda.tags")
end, "Tags View")
map("n", "<leader>aos", function()
  require("orgmode").action("agenda.search")
end, "Search View")
map("n", "<leader>atst", "<Cmd>botright split | terminal<CR>", "Shell")

-- b: buffers
map("n", "<leader>bb", tb.buffers, "Switch Buffer")
map("n", "<leader>bB", "<Cmd>ls<CR>", "List Buffers")
map("n", "<leader>bd", buffer_delete, "Kill Buffer")
map("n", "<leader>bD", "<Cmd>bdelete<CR>", "Kill Buffer and Window")
map("n", "<leader>bp", "<Cmd>bprevious<CR>", "Previous Buffer")
map("n", "<leader>bn", "<Cmd>bnext<CR>", "Next Buffer")
cmdline("n", "<leader>br", "file ", "Rename Buffer")
map("n", "<leader>bh", "<Cmd>helpclose<CR>", "Close Help")
map("n", "<leader>bs", scratch_buffer, "Scratch Buffer")
map("n", "<leader>be", "<Cmd>%delete _<CR>", "Erase Buffer")
map("n", "<leader>b=", format_buffer, "Format Buffer")

-- c: compile / directories
map("n", "<leader>cdc", "<Cmd>lcd %:p:h<CR>", "lcd to Buffer Dir")
cmdline("n", "<leader>cdt", "lcd ", "lcd")
map("n", "<leader>cC", "<Cmd>make<CR>", "Compile")

-- D: desktop (sessions)
map("n", "<leader>Ds", session_save, "Save Session")
map("n", "<leader>Dr", session_read, "Read Session")
map("n", "<leader>Dd", session_remove, "Remove Session")
map("n", "<leader>Dc", session_clear, "Clear Buffers")
map("n", "<leader>DR", session_read, "Revert to Session")

-- f: files
map("n", "<leader>fs", "<Cmd>write<CR>", "Save File")
map("n", "<leader>fS", "<Cmd>wall<CR>", "Save All Files")
cmdline("n", "<leader>fa", "saveas ", "Save As")
cmdline("n", "<leader>fc", "saveas ", "Copy File")
map("n", "<leader>fR", rename_file, "Rename File")
cmdline("n", "<leader>fi", "read ", "Insert File")
map("n", "<leader>fDD", delete_file, "Delete File and Buffer")
map("n", "<leader>fDd", delete_file, "Delete File")
map("n", "<leader>ff", function()
  file_browser({ path = buffer_dir(), select_buffer = true })
end, "Find File")
map("n", "<leader>fp", function()
  tb.buffers({ cwd = project_root(), cwd_only = true })
end, "Project Buffers")
map("n", "<leader>fr", tb.oldfiles, "Recent Files")
map("n", "<leader>fj", "<Cmd>Explore<CR>", "Dired Jump")
map("n", "<leader>fgd", function()
  tb.find_files({ cwd = buffer_dir() })
end, "Find Files Here")
map("n", "<leader>fgD", function()
  tb.find_files({ cwd = buffer_dir(), hidden = true, no_ignore = true })
end, "Find All Files Here")
map("n", "<leader>fgr", function()
  tb.live_grep({ cwd = buffer_dir() })
end, "Grep Here")
cmdline("n", "<leader>fgR", "grep ", "Grep to Quickfix")
map("n", "<leader>fbb", tb.marks, "Bookmarks")
map("n", "<leader>fed", function()
  vim.cmd.edit(fn.fnameescape(vim.env.MYVIMRC))
end, "Open Config")
map("n", "<leader>feR", "<Cmd>restart<CR>", "Restart Neovim")

-- g: git
map("n", "<leader>gs", function()
  require("neogit").open({ cwd = buffer_dir() })
end, "Status")
map("n", "<leader>gc", "<Cmd>Neogit commit<CR>", "Commit")
map("n", "<leader>gp", "<Cmd>Neogit push<CR>", "Push")
map("n", "<leader>gP", "<Cmd>Neogit pull<CR>", "Pull")
map("n", "<leader>gb", "<Cmd>Gitsigns blame<CR>", "Blame")
map("n", "<leader>gd", "<Cmd>DiffviewOpen<CR>", "Diff")
map("n", "<leader>gfl", "<Cmd>DiffviewFileHistory %<CR>", "File Log")
map("n", "<leader>ga", "<Cmd>Gitsigns stage_buffer<CR>", "Stage File")
map("n", "<leader>gu", "<Cmd>Gitsigns reset_buffer_index<CR>", "Unstage File")
map("n", "<leader>gi", function()
  vim.notify(vim.trim(fn.system({ "git", "-C", buffer_dir(), "init" })))
end, "Init Repository")
map({ "n", "x" }, "<leader>glo", function()
  gh_browse({}, current_range())
end, "Open on GitHub")
map({ "n", "x" }, "<leader>gll", function()
  gh_browse({ "-n" }, current_range())
end, "Copy Link")
map({ "n", "x" }, "<leader>glL", function()
  gh_browse({ "-n", "-c" }, current_range())
end, "Copy Permalink")
map({ "n", "x" }, "<leader>glp", function()
  gh_browse({ "-c" }, current_range())
end, "Open Permalink")

-- h: help
map("n", "<leader>hh", tb.help_tags, "Help")
map("n", "<leader>hk", "<Cmd>helpclose<CR>", "Close Help")
map("n", "<leader>hdb", tb.keymaps, "Describe Bindings")
map("n", "<leader>hdM", tb.keymaps, "Describe Keymap")
map("n", "<leader>hdk", "<Cmd>WhichKey<CR>", "Describe Key")
map("n", "<leader>hdv", tb.vim_options, "Describe Variable")
map("n", "<leader>hdc", tb.commands, "Describe Command")
map("n", "<leader>hd.", "<Cmd>help <cword><CR>", "Help at Point")
map("n", "<leader>hdx", "<Cmd>Inspect<CR>", "Describe Char")

-- i: imenu
map("n", "<leader>ii", function()
  if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/documentSymbol" }) > 0 then
    tb.lsp_document_symbols()
  else
    tb.treesitter()
  end
end, "Imenu")
map("n", "<leader>il", "gO", "Imenu List", { remap = true })

-- j: jump
map({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, "Jump to Char")
map({ "n", "x", "o" }, "<leader>jc", function()
  require("flash").jump()
end, "Jump to Char")
map("n", "<leader>ju", "g;", "Previous Change")
map("n", "<leader>jU", "g,", "Next Change")
map("n", "<leader>jL", function()
  tb.live_grep({ grep_open_files = true })
end, "Search Open Buffers")

-- L: Copilot CLI beside the editor (sidekick); keys follow Emacs' gptel.
map("n", "<leader>Ll", function()
  sidekick.toggle({ filter = copilot_filter(), focus = true })
end, "Copilot CLI")
map("n", "<leader>Ls", copilot_send("{this}"), "Send Position")
map("x", "<leader>Ls", copilot_send("{selection}"), "Send Selection")
map({ "n", "x" }, "<leader>L.", copilot_send("{position}"), "Add Position")
map("n", "<leader>La", copilot_send("{file}"), "Add File")
map("n", "<leader>Ld", copilot_send("{diagnostics}"), "Add Diagnostics")
map({ "n", "x" }, "<leader>Lm", sidekick.prompt, "Prompt Menu")
map("n", "<leader>Lt", sidekick.select, "Select Tool/Session")
map("n", "<leader>Lq", function()
  sidekick.close({ filter = copilot_filter() })
end, "Close Session")
map({ "n", "x" }, "<leader>Ly", copilot_yank_reference, "Yank Reference")

-- $: in-editor ACP agent (CodeCompanion); keys follow Emacs' agent-shell.
local function cc()
  return require("codecompanion")
end
local function agent_chat()
  if vim.bo.filetype == "codecompanion" then
    return cc().buf_get_chat(api.nvim_get_current_buf())
  end
  return cc().last_chat()
end
local function agent_shell()
  local chat = cc().last_chat()
  if chat then
    cc().restore(chat.bufnr)
  else
    cc().chat()
  end
end
local function agent_start(adapter)
  return function()
    cc().chat({ params = { adapter = adapter } })
  end
end
local function agent_switch_buffer()
  local chats = cc().buf_get_chat()
  if #chats == 0 then
    return vim.notify("No Agent Shell chats", vim.log.levels.WARN)
  end
  vim.ui.select(chats, {
    prompt = "Agent Shell",
    format_item = function(c)
      return string.format("%s [%s]", c.title or ("Chat " .. c.chat.id), c.chat.adapter.formatted_name)
    end,
  }, function(c)
    if c then
      cc().restore(c.chat.bufnr)
    end
  end)
end
-- Runs a built-in slash command (e.g. /resume) against a chat.
local function agent_slash(name, chat)
  chat = chat or agent_chat()
  if not chat then
    return vim.notify("No Agent Shell chat", vim.log.levels.WARN)
  end
  local item = { label = name, config = require("codecompanion.config").interactions.chat.slash_commands[name] }
  require("codecompanion.interactions.chat.slash_commands").new():execute(item, chat)
end
-- Loads a past ACP session into `chat`, in that session's directory.
local function agent_load_session(chat, session)
  local conn = chat.acp_connection
  if session.cwd and fn.isdirectory(session.cwd) == 1 then
    api.nvim_win_call(chat.ui.winnr, function()
      vim.cmd.lcd(fn.fnameescape(session.cwd))
    end)
  end
  local updates = {}
  local ok = conn:load_session(session.sessionId, {
    on_session_update = function(update, opts)
      table.insert(updates, { update = update, session_id = opts and opts.session_id })
    end,
  })
  if not ok then
    return vim.notify("Failed to load session", vim.log.levels.ERROR)
  end
  require("codecompanion.interactions.chat.acp.commands").link_buffer_to_session(chat.bufnr, conn.session_id)
  require("codecompanion.interactions.chat.acp.render").restore_session(chat, updates)
  if session.title then
    chat:set_title(session.title)
  end
end
-- agent-shell-resume-session. Unlike CodeCompanion's /resume, lists sessions
-- from every directory, not just the current one.
local function agent_pick_session(chat, close_on_cancel)
  local function cancel()
    if close_on_cancel then
      chat:close()
    end
  end
  local tries = 0
  local function pick()
    local conn = chat.acp_connection
    -- Wait for the chat's own session first, or it would replace the loaded one.
    if not (conn and conn:is_ready() and conn.session_id) then
      tries = tries + 1
      if tries > 120 then
        cancel()
        return vim.notify("Agent did not connect", vim.log.levels.WARN)
      end
      return vim.defer_fn(pick, 250)
    end
    require("codecompanion.utils.async").sync(function()
      local res = conn:send_rpc_request({ method = "session/list", params = vim.empty_dict(), timeout = 30000 })
      vim.schedule(function()
        local sessions = vim.tbl_filter(function(s)
          return s.sessionId ~= conn.session_id
        end, res and res.sessions or {})
        if #sessions == 0 then
          cancel()
          return vim.notify("No previous sessions", vim.log.levels.INFO)
        end
        table.sort(sessions, function(a, b)
          return (a.updatedAt or "") > (b.updatedAt or "")
        end)
        vim.ui.select(sessions, {
          prompt = "Resume Session",
          format_item = function(s)
            local ts = s.updatedAt and require("codecompanion.utils").timestamp_from_iso(s.updatedAt)
            local when = ts and os.date("%Y-%m-%d %H:%M", ts) or "?"
            return string.format("%s  %s  (%s)", when, s.title or s.sessionId, fn.fnamemodify(s.cwd or "?", ":~"))
          end,
        }, function(s)
          if s then
            agent_load_session(chat, s)
          else
            cancel()
          end
        end)
      end)
    end)()
  end
  pick()
end
local function agent_resume()
  local chat = cc().chat()
  if chat then
    agent_pick_session(chat, true)
  end
end
map("n", "<leader>$$", agent_shell, "Agent Shell")
map("n", "<leader>$t", "<Cmd>CodeCompanionChat Toggle<CR>", "Toggle")
map("n", "<leader>$b", agent_switch_buffer, "Switch Buffer")
map("n", "<leader>$n", "<Cmd>CodeCompanionChat<CR>", "New Shell")
map("n", "<leader>$R", agent_resume, "Resume Session")
map("n", "<leader>$sc", agent_start("copilot_acp"), "Copilot")
map("n", "<leader>$sC", agent_start("claude_code"), "Claude Code")
map("n", "<leader>$so", agent_start("codex"), "Codex")
map("n", "<leader>$sg", agent_start("gemini_cli"), "Gemini")
map("n", "<leader>$f", "<Cmd>%CodeCompanionChat Add<CR>", "Send File")
map("x", "<leader>$r", ":CodeCompanionChat Add<CR>", "Send Region")
map({ "n", "x" }, "<leader>$a", "<Cmd>CodeCompanionActions<CR>", "Actions")

-- Local leader inside the chat buffer (agent-shell-mode-map).
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("AgentShellKeys", { clear = true }),
  pattern = "codecompanion",
  callback = function(ev)
    local function bmap(lhs, rhs, desc)
      map("n", "<localleader>" .. lhs, rhs, desc, { buffer = ev.buf })
    end
    local function with_chat(method)
      return function()
        local chat = agent_chat()
        if chat then
          if method == "submit" then
            vim.cmd("stopinsert")
          end
          chat[method](chat)
        end
      end
    end
    bmap("<CR>", with_chat("submit"), "Submit")
    bmap("k", with_chat("stop"), "Interrupt")
    bmap("f", function()
      agent_slash("fork")
    end, "Fork")
    bmap("sm", function()
      agent_slash("acp_session_options")
    end, "Session Mode/Options")
    bmap("so", function()
      agent_slash("acp_session_options")
    end, "Session Config Option")
    bmap("sv", function()
      require("codecompanion.interactions.chat.keymaps").change_adapter.callback(agent_chat())
    end, "Session Model")
    bmap("sr", function()
      local chat = agent_chat()
      if chat then
        agent_pick_session(chat, false)
      end
    end, "Resume Session")
  end,
})

-- p: project
map("n", "<leader>pp", function()
  telescope.extensions.project.project({})
end, "Switch Project")
map("n", "<leader>pf", function()
  tb.find_files({ cwd = project_root() })
end, "Find File in Project")
map("n", "<leader>p/", function()
  tb.live_grep({ cwd = project_root() })
end, "Grep Project")
map("n", "<leader>pb", function()
  tb.buffers({ cwd = project_root(), cwd_only = true })
end, "Project Buffers")
map("n", "<leader>pc", function()
  vim.cmd.lcd(fn.fnameescape(project_root()))
  vim.cmd.make()
end, "Compile Project")
map("n", "<leader>p!", function()
  vim.ui.input({ prompt = "Shell command in project: ", completion = "shellcmd" }, function(cmd)
    if cmd and cmd ~= "" then
      vim.cmd("botright split | lcd " .. fn.fnameescape(project_root()) .. " | terminal " .. cmd)
    end
  end)
end, "Run Shell Command")
map("n", "<leader>ps", "<Cmd>wall<CR>", "Save Project Buffers")
map("n", "<leader>pv", project_terminal, "Project Terminal")

-- q: quit
map("n", "<leader>qq", "<Cmd>qa!<CR>", "Quit")
map("n", "<leader>qr", "<Cmd>restart<CR>", "Restart")

-- s: search
map("n", "<leader>sc", "<Cmd>nohlsearch<CR>", "Clear Highlight")
map("n", "<leader>saf", tb.grep_string, "Grep Word")
map("n", "<leader>st", vim.lsp.buf.document_symbol, "Document Symbols")
map("n", "<leader>si", tb.lsp_document_symbols, "Search Symbols")
map("n", "<leader>ss", tb.current_buffer_fuzzy_find, "Search Buffer")

-- t: tabs
map("n", "<leader>tp", "<Cmd>tabprevious<CR>", "Previous Tab")
map("n", "<leader>th", "<Cmd>tabprevious<CR>", "Previous Tab")
map("n", "<leader>tn", "<Cmd>tabnext<CR>", "Next Tab")
map("n", "<leader>tl", "<Cmd>tabnext<CR>", "Next Tab")
map("n", "<leader>tH", "<Cmd>-tabmove<CR>", "Move Tab Left")
map("n", "<leader>tL", "<Cmd>+tabmove<CR>", "Move Tab Right")
map("n", "<leader>tN", "<Cmd>tabnew<CR>", "New Tab")
map("n", "<leader>tt", "<Cmd>tabs<CR>", "List Tabs")
map("n", "<leader>t<Tab>", "g<Tab>", "Last Tab")
map("n", "<leader>td", "<Cmd>tabclose<CR>", "Close Tab")
map("n", "<leader>tD", "<Cmd>tabonly<CR>", "Close Other Tabs")
cmdline("n", "<leader>tb", "tab sbuffer ", "Buffer in New Tab")
cmdline("n", "<leader>tf", "tabedit ", "File in New Tab")
map("n", "<leader>tF", "<Cmd>Texplore<CR>", "Directory in New Tab")
cmdline("n", "<leader>tm", "tabmove ", "Move Tab")
map("n", "<leader>ty", "<Cmd>tab split<CR>", "Duplicate Tab")
for i = 1, 9 do
  map("n", "<leader>t" .. i, i .. "gt", "Tab " .. i)
end

-- T: toggles
map("n", "<leader>Tl", "<Cmd>setlocal number!<CR>", "Line Numbers (Local)")
map("n", "<leader>TL", "<Cmd>set number!<CR>", "Line Numbers")
map("n", "<leader>Tt", function()
  tb.colorscheme({ enable_preview = true })
end, "Theme")
map("n", "<leader>Tm", function()
  vim.o.laststatus = vim.o.laststatus == 0 and 2 or 0
end, "Statusline")
map("n", "<leader>Tw", "<Cmd>setlocal wrap!<CR>", "Wrap")
map("n", "<leader>Ts", "<Cmd>setlocal spell!<CR>", "Spell")

-- w: windows
map("n", "<leader>w<Tab>", "<C-w>p", "Last Window")
map("n", "<leader>wd", "<C-w>c", "Delete Window")
map("n", "<leader>wx", function()
  buffer_delete()
  pcall(vim.cmd.close)
end, "Kill Buffer and Window")
map("n", "<leader>wD", "<C-w>o", "Delete Other Windows")
map("n", "<leader>wm", "<C-w>o", "Maximize Window")
map("n", "<leader>wv", "<Cmd>vsplit<CR>", "Split Right")
map("n", "<leader>ws", "<Cmd>split<CR>", "Split Below")
map("n", "<leader>w;", "<Cmd>vsplit<CR>", "Split Right")
map("n", "<leader>w'", "<Cmd>split<CR>", "Split Below")
map("n", "<leader>wh", "<C-w>h", "Window Left")
map("n", "<leader>wj", "<C-w>j", "Window Down")
map("n", "<leader>wk", "<C-w>k", "Window Up")
map("n", "<leader>wl", "<C-w>l", "Window Right")
map("n", "<leader>wH", "<C-w>H", "Move Window Left")
map("n", "<leader>wJ", "<C-w>J", "Move Window Down")
map("n", "<leader>wK", "<C-w>K", "Move Window Up")
map("n", "<leader>wL", "<C-w>L", "Move Window Right")
map("n", "<leader>ww", "<C-w>w", "Other Window")
map("n", "<leader>w=", "<C-w>=", "Balance Windows")
map("n", "<leader>wr", "<C-w>r", "Rotate Windows")
map("n", "<leader>wR", "<C-w>R", "Rotate Windows Backward")
map("n", "<leader>wS", "<C-w>x", "Swap Windows")
map("n", "<leader>wM", "<C-w>x", "Swap Windows")

-- x: text
map("n", "<leader>xil", "iλ<Esc>", "Insert Lambda")
map("n", "<leader>xu", "<Cmd>Undotree<CR>", "Undo Tree")
map({ "n", "x" }, "<leader>xc", "g<C-g>", "Count Words")
map("n", "<leader>xwd", function()
  vim.ui.open("dict://" .. fn.expand("<cword>"))
end, "Dictionary")

-- y: yank
map("n", "<leader>yy", tb.registers, "Kill Ring")
map("n", "<leader>yf", function()
  local file = current_file()
  if file then
    fn.setreg("+", file .. "::" .. fn.line("."))
    vim.notify("Copied " .. file .. "::" .. fn.line("."))
  end
end, "Yank File Position")

-- S: packages (Emacs: straight.el)
local function with_plugin(prompt, callback)
  local plugins = vim.pack.get(nil, { info = false })
  table.sort(plugins, function(a, b)
    return a.spec.name:lower() < b.spec.name:lower()
  end)
  vim.ui.select(plugins, {
    prompt = prompt,
    format_item = function(p)
      return p.spec.name .. (p.active and "" or " (inactive)")
    end,
  }, function(choice)
    if choice then
      callback(choice)
    end
  end)
end

map("n", "<leader>Spu", function()
  vim.ui.input({ prompt = "Add plugin (owner/repo or URL): " }, function(src)
    if src and src ~= "" then
      vim.pack.add({ src:match("^%w+://") and src or gh(src) })
      vim.notify("Added for this session; add it to vim.pack.add() in init.lua to keep it")
    end
  end)
end, "Use Package")
map("n", "<leader>Spp", function()
  with_plugin("Update plugin: ", function(p)
    vim.pack.update({ p.spec.name })
  end)
end, "Pull Package")
map("n", "<leader>SpP", function()
  vim.pack.update()
end, "Pull All")
map("n", "<leader>Spb", function()
  with_plugin("Restore plugin to lockfile: ", function(p)
    vim.pack.update({ p.spec.name }, { target = "lockfile" })
  end)
end, "Restore Package to Lockfile")
map("n", "<leader>SpB", function()
  vim.pack.update(nil, { target = "lockfile" })
end, "Restore All to Lockfile")
map("n", "<leader>Spc", function()
  local unused = vim.tbl_map(
    function(p)
      return p.spec.name
    end,
    vim.tbl_filter(function(p)
      return not p.active
    end, vim.pack.get(nil, { info = false }))
  )
  if #unused == 0 then
    vim.notify("No unused plugins")
  elseif fn.confirm("Delete " .. table.concat(unused, ", ") .. "?", "&Yes\n&No", 2) == 1 then
    vim.pack.del(unused)
  end
end, "Remove Unused Plugins")
map("n", "<leader>Spv", function()
  with_plugin("Visit plugin: ", function(p)
    file_browser({ path = p.path })
  end)
end, "Visit Package")
map("n", "<leader>SpV", function()
  with_plugin("Open plugin website: ", function(p)
    vim.ui.open((p.spec.src:gsub("%.git$", "")))
  end)
end, "Visit Package Website")
map("n", "<leader>Spl", function()
  vim.cmd.edit(fn.fnameescape(vim.fs.joinpath(fn.stdpath("log"), "nvim-pack.log")))
end, "Update Log")

-- k: lisp state (evil-lisp-state, via vim-sexp)
autocmd("FileType", {
  pattern = vim.split(vim.g.sexp_filetypes, ","),
  callback = function(args)
    local function lmap(lhs, plug, desc, mode)
      map(mode or "n", "<leader>k" .. lhs, "<Plug>(" .. plug .. ")", desc, { buffer = args.buf, remap = true })
    end
    lmap("s", "sexp_capture_next_element", "Slurp Forward")
    lmap("S", "sexp_capture_prev_element", "Slurp Backward")
    lmap("b", "sexp_emit_tail_element", "Barf Forward")
    lmap("B", "sexp_emit_head_element", "Barf Backward")
    lmap("r", "sexp_raise_element", "Raise")
    lmap("W", "sexp_splice_list", "Unwrap")
    lmap("w", "sexp_round_head_wrap_element", "Wrap")
    lmap("t", "sexp_swap_element_forward", "Transpose")
    lmap("c", "sexp_convolute", "Convolute")
    lmap("L", "sexp_move_to_next_element_head", "Forward Sexp")
    lmap("H", "sexp_move_to_prev_element_head", "Backward Sexp")
    lmap("j", "sexp_flow_to_next_close", "Next Closing Paren")
    lmap("k", "sexp_flow_to_prev_open", "Previous Opening Paren")
    lmap("(", "sexp_insert_at_list_head", "Insert at Head")
    lmap(")", "sexp_insert_at_list_tail", "Insert at Tail")
    map("n", "<leader>kU", "[(", "Up Sexp", { buffer = args.buf, remap = true })
    map("n", "<leader>ky", "yaf", "Copy Sexp", { buffer = args.buf, remap = true })
    map("n", "<leader>kdx", "daf", "Kill Sexp", { buffer = args.buf, remap = true })
    map("n", "<leader>k%", "%", "Jump Item", { buffer = args.buf, remap = true })
  end,
})

-- Local leader (,) =================================
-- ==================================================

autocmd("LspAttach", {
  callback = function(args)
    local function lmap(mode, lhs, rhs, desc)
      map(mode, "<localleader>" .. lhs, rhs, desc, { buffer = args.buf })
    end
    lmap({ "n", "x" }, "aa", vim.lsp.buf.code_action, "Code Action")
    lmap("n", "ar", "<Cmd>lsp restart<CR>", "Restart Server")
    lmap("n", "as", tb.lsp_document_symbols, "Document Symbols")
    lmap("n", "aS", tb.lsp_dynamic_workspace_symbols, "Workspace Symbols")
    lmap("n", "at", function()
      vim.lsp.buf.typehierarchy("subtypes")
    end, "Type Hierarchy")
    lmap("n", "ac", vim.lsp.buf.incoming_calls, "Call Hierarchy")
    lmap("n", "an", vim.lsp.buf.rename, "Rename")
    lmap("n", "a=", format_buffer, "Format Buffer")
  end,
})

-- Non-leader keys ==================================
-- ==================================================

map("n", "<Esc>", "<Cmd>nohlsearch<CR>", "Clear Highlight")
map("n", "ZA", "<Cmd>wqa!<CR>", "Save All and Quit")

-- Emacs-like keys
map("n", "<C-x><C-c>", "<Cmd>wqa!<CR>", "Save All and Quit")
map("n", "<C-s>", "/", "Search", { silent = false })
map("n", "<M-;>", "gcc", "Comment Line", { remap = true })
map("x", "<M-;>", "gc", "Comment Region", { remap = true })
map("i", "<M-/>", "<C-n>", "Complete Word")
map("i", "<C-a>", "<Home>", "Line Start")
map("i", "<C-e>", "<End>", "Line End")
map("i", "<C-f>", "<Right>", "Forward Char")
map("i", "<C-b>", "<Left>", "Backward Char")
map("i", "<C-d>", "<Del>", "Delete Char")
map("i", "<C-k>", "<C-o>D", "Kill Line")
map("i", "<C-l>", "<C-o>zz", "Recenter")
map("n", "<C-l>", "zz", "Recenter")

-- Commands =========================================
-- ==================================================
-- Typo-tolerant capitalized variants.

local function command(name, cmd, opts)
  api.nvim_create_user_command(name, cmd, vim.tbl_extend("force", { bar = true }, opts or {}))
end
local file_range = { nargs = "*", complete = "file", range = "%", bang = true }
command("W", "<line1>,<line2>write<bang> <args>", file_range)
command("Write", "<line1>,<line2>write<bang> <args>", file_range)
command("Wq", "<line1>,<line2>wq<bang> <args>", file_range)
command("WQ", "<line1>,<line2>wq<bang> <args>", file_range)
command("WQall", "wqa<bang>", { bang = true })
command("We", "<line1>,<line2>w<bang> | e <args>", file_range)
command("Wnext", "<count>wnext<bang> <args>", file_range)
command("Wprevious", "<count>wprevious<bang> <args>", file_range)
command("E", "edit<bang> <args>", { nargs = "*", complete = "file", bang = true })
command("Edit", "edit<bang> <args>", { nargs = "*", complete = "file", bang = true })
command("Q", "quit<bang>", { bang = true })
command("Quit", "quit<bang>", { bang = true })
command("Qall", "qall<bang>", { bang = true })
command("Set", "set <args>", { nargs = "?", complete = "option" })
command("Help", "help <args>", { nargs = "?", complete = "help" })
command("Make", "make<bang> <args>", { nargs = "*", complete = "file", bang = true })
command("Bdel", "bdel<bang> <args>", { nargs = "*", bang = true })
command("Bwipe", "bwipe<bang> <args>", { nargs = "*", bang = true })
command("Mksession", "mksession<bang> <args>", { nargs = "*", complete = "file", bang = true })
command("Cd", "cd<bang> <args>", { nargs = "*", complete = "dir", bang = true })
command("Messages", "messages")
command("Source", "source <args>", { nargs = "+", complete = "file", bang = true })

-- CodeQL ===========================================
-- ==================================================

do
  local entry_display = require("telescope.pickers.entry_display")
  local previewers = require("telescope.previewers")
  local utils = require("telescope.utils")
  local defaulter = utils.make_default_callable

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 8 }, -- commit
      { width = 8 }, -- lang
      { remaining = true }, -- nwo
    },
  })

  local make_display = function(entry)
    local path = entry.value
    local parts = vim.split(path, "/")
    local db = parts[#parts]
    local nwo = parts[#parts - 2] .. "/" .. parts[#parts - 1]
    local langAndCommit = vim.split(db:gsub("%.zip", ""), "-")
    local lang = langAndCommit[1]
    local commit = langAndCommit[2]
    return displayer({
      { commit, "TelescopeResultsComment" },
      { lang, "TelescopeResultsNumber" },
      { nwo, "TelescopeResultsString" },
    })
  end

  local entry_maker = function(entry)
    return {
      valid = entry,
      value = entry,
      ordinal = entry,
      display = make_display,
    }
  end

  local previewer = defaulter(function(opts)
    return previewers.new_buffer_previewer({
      title = opts.preview_title,
      get_buffer_by_name = function(_, entry)
        return entry.value
      end,
      define_preview = function(self, entry)
        local jsonPath = entry.value:gsub("%.zip", ".json")
        local bufnr = self.state.bufnr
        if self.state.bufname ~= jsonPath or api.nvim_buf_line_count(bufnr) == 1 then
          local json = fn.json_decode(fn.readfile(jsonPath))
          if json then
            api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(vim.inspect(json), "\n"))
          end
          api.nvim_buf_call(bufnr, function()
            pcall(vim.cmd, "set filetype=json")
          end)
        end
      end,
    })
  end).new

  require("codeql").setup({
    find_databases_cmd = { "gh", "qldb", "list" },
    database_list_entry_maker = entry_maker,
    database_list_previewer = previewer,
    telescope_opts = {
      layout_strategy = "vertical",
      layout_config = { height = 50, width = 80 },
    },
    results = {
      max_paths = 15,
      max_path_depth = nil,
    },
    panel = {
      width = 80,
      group_by = "sink",
      show_filename = true,
      long_filename = false,
      context_lines = 3,
    },
    max_ram = 64000,
  })

  -- change summary background color
  autocmd("WinEnter", {
    callback = function()
      if vim.bo.filetype == "codeql_panel" then
        vim.wo.winhighlight = "Normal:NormalAlt"
      end
    end,
  })
end
