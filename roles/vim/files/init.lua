-- local use = require('packer').use
-- require('packer').startup(function()
--   use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
--   use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
--   use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
--   use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
--   use 'L3MON4D3/LuaSnip' -- Snippets plugin
--   use 'frazrepo/vim-rainbow'
--   use 'hashivim/vim-terraform'
--   use 'airblade/vim-gitgutter'
--   use 'neovim/nvim-lspconfig'
--   use 'simrat39/rust-tools.nvim'
--   use 'nvim-treesitter/nvim-treesitter'
-- end)

vim.cmd([[
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

Plug 'frazrepo/vim-rainbow'
Plug 'hashivim/vim-terraform'
Plug 'airblade/vim-gitgutter'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

" Hybrid numbers for active buffer
" https://jeffkreeftmeijer.com/vim-number/
:set number

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

" Display
set ruler
set scrolloff=5
set wrap
colorscheme slate

" Editing
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
syntax on
set confirm

noremap ; l
noremap j k
noremap k j
noremap j h

" Search
set hlsearch
set incsearch
set smartcase

" Highlight trailing whitespace
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/

" Save with sudo
cnoremap w!! w !sudo tee > /dev/null %
]])

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-- Terraform and HCL
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
-- Format terraform on save
vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])
-- Tearraform language server
require'lspconfig'.terraformls.setup{}
require'lspconfig'.tflint.setup{}

-- keymap("n", "<leader>ti", ":!terraform init<CR>", opts)
-- keymap("n", "<leader>tv", ":!terraform validate<CR>", opts)
-- keymap("n", "<leader>tp", ":!terraform plan<CR>", opts)
-- keymap("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", opts)
