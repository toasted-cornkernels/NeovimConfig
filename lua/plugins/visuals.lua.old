return {
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
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    lazy = true,
    opts = {
      buftypes = {
        '!prompt',
        '!popup',
        '!mason',
      },
    },
  },
}

