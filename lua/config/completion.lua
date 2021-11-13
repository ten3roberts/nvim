local cmp = require('cmp')
local fn = vim.fn

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local function confirm(fallback)
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
  elseif check_back_space() then
    fallback()
  elseif vim.fn['vsnip#available'](1) then
    fn.feedkeys(t "<Plug>(vsnip-jump-next)", "")
  else
    fallback()
  end
end

local function confirm_insert(fallback)
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }
  elseif check_back_space() then
    fallback()
  elseif vim.fn['vsnip#available'](1) then
    fn.feedkeys(t "<Plug>(vsnip-jump-prev)", "")
  else
    fallback()
  end
end

cmp.setup {
  completion = {
    completeopt = "longest,noinsert,preview,noselect,shortest"
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-e>'] = cmp.config.disable,
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = confirm_insert,
    ['<Tab>'] = confirm,
    ['<S-Tab>'] = confirm,
  },
  sources = {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = "path" },
    { name = 'buffer' },
  },
}
