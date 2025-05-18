return {
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

  'hrsh7th/cmp-nvim-lua',

  'hrsh7th/cmp-nvim-lsp',

  'hrsh7th/cmp-buffer',

  'hrsh7th/cmp-path',

  'hrsh7th/cmp-cmdline',

  'PaterJason/cmp-conjure',

  'quangnguyen30192/cmp-nvim-ultisnips',
}
