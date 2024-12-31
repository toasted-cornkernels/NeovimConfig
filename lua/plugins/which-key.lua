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

return {
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
}
