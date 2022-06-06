local cmp = require('cmp')
local lspkind = require "lspkind"
local fn = vim.fn
local o = vim.o

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local ls = require "luasnip"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function confirm(behavior)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.confirm {
        behavior = behavior,
        select = true,
      }
    elseif ls.expand_or_jumpable() then
      ls.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end)
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
  { name = 'nvim_lsp' },
  { name = 'nvim_lua' },
  { name = 'luasnip' },
  { name = 'treesitter' },
  { name = 'buffer' },
  { name = "nvim_lsp_signature_help" },
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
      ls.lsp_expand(args.body)
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
    ['<C-y>'] = confirm(cmp.ConfirmBehavior.Insert),
    ['<Tab>'] = confirm(cmp.ConfirmBehavior.Replace),
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
  completion = {
    keyword_length = 2,
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
