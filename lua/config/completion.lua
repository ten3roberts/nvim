local cmp = require('cmp')

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function confirm(fallback)
  if cmp.visible() then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }
    print(vim.fn['vsnip#available'](1))
  elseif vim.fn['vsnip#available'](1) then
    return t "<plug>(vsnip-expand-or-jump)"
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
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
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
    ['<TAB>'] = confirm,
    ['<S-Tab>'] = confirm,
  },
  sources = {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = "path" },
    { name = 'buffer' },
  },
}
