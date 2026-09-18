
vim.wo.number = true

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('neovim/nvim-lspconfig')
Plug('nvim-treesitter/nvim-treesitter', { 
	['branch'] = 'main',
	['do'] = function()
		vim.fn['nvim-treesitter#TSUpdate']()
	end,
})

Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')

Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')

Plug('nicolasgb/jj.nvim')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-live-grep-args.nvim')

Plug('stevearc/conform.nvim')

Plug('folke/tokyonight.nvim')

-- NUI component library used by hunk.nvim
Plug('MunifTanjim/nui.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('julienvincent/hunk.nvim')

vim.call('plug#end')

vim.cmd([[colorscheme tokyonight-night]])

vim.api.nvim_create_autocmd('User', {
  pattern = 'DiffEditor',
  callback = function()
    require('hunk').setup()
  end,
})


-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
local lspconfig = require('lspconfig')

vim.lsp.enable('pyright')
vim.lsp.enable('ruff')

vim.lsp.enable('clangd')
vim.lsp.enable('rust_analyzer', {
  capabilities = capabilities,
  settings = {
      ['rust-analyzer'] = {
          check = {
              command = "clippy";
          },
          diagnostics = {
              enable = true;
          }
      }
  }
  }
)

vim.lsp.enable('bashls', {
  capabilities = capabilities,
})

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

local builtin = require('telescope.builtin')
local telescope = require('telescope')
telescope.load_extension("live_grep_args")
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Telescope grep string' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { desc = 'Telescope lsp_definitions' })
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope lsp_definitions' })

--vim.api.nvim_create_autocmd('FileType', {
--  callback = function()
--    -- Enable treesitter highlighting (fall back gracefully)
--    pcall(vim.treesitter.start)
--    -- Enable treesitter-based indentation
--    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--  end,
--})
--
--require('nvim-treesitter').install { 'rust', 'bash', 'python', 'markdown' }

require("jj").setup({})

require("conform").setup({
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

-- Apply suggestion
vim.keymap.set('n', '<leader>fm', function()
    vim.lsp.buf.code_action({apply=false}) end, bufopts)

-- Rename symbol
vim.keymap.set('n', '<leader>r', function()
    vim.lsp.buf.rename() end, bufopts)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.opt.clipboard = "unnamedplus"
