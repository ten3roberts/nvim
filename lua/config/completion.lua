local cmp = require('cmp')
local lspkind = require "lspkind"
local fn = vim.fn
local o = vim.o

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
  elseif check_back_space then
    fallback()
  elseif fn['vsnip#available'](1) then
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
  elseif vim.fn['vsnip#available'](1) then
    fn.feedkeys(t "<Plug>(vsnip-jump-prev)", "")
  else
    fallback()
  end
end

local rel_ft = {
  markdown = true,
  tex = true,
}


local default_sources = {

  {
    name = "path",
    option = {
      get_cwd = function()
        if rel_ft[o.ft] == true then

          return fn.expand("%:p:h")
        else
          return fn.getcwd()

        end
      end
    }
  },
  { name = "nvim_lsp_signature_help" },
  { name = 'vsnip' },
  { name = 'nvim_lsp' },
  { name = 'nvim_lua' },
  { name = 'treesitter' },
  { name = 'buffer' },
}

cmp.setup {
  completion = {
    completeopt = "longest,noinsert,preview,noselect,shortest",
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    })
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  experimental = {
    ghost_text = false
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-y>'] = confirm_insert,
    ['<Tab>'] = confirm,
    ['<S-Tab>'] = confirm,
  },
  sources = default_sources,
}

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
