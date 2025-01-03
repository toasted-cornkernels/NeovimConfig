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
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd("colorscheme dayfox")
      end,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd("colorscheme carbonfox")
      end,
    },
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

