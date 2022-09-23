local cmp = require "cmp"
local lspkind = require "lspkind"

require "crates"
require("cmp_git").setup {}

local ls = require "luasnip"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local function confirm(behavior)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.confirm {
        behavior = behavior,
        select = true,
      }
    elseif has_words_before() and ls.expand_or_jumpable() then
      ls.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end)
end

local default_sources = {
  {
    name = "path",
    option = {
      trailing_slash = true,
      -- get_cwd = function()
      --   if rel_ft[o.ft] == true then
      --
      --     return fn.expand("%:p:h")
      --   else
      --     return fn.getcwd()
      --
      --   end
      -- end
    },
  },

  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "nvim_lua" },
  { name = "treesitter" },
  -- { name = "buffer" },
  -- { name = "spell" },
}
vim.o.completeopt = "menu,menuone"

cmp.setup {
  preselect = cmp.PreselectMode.None,
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format {
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    },
  },
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },
  experimental = {
    ghost_text = false,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete {},
    ["<C-y>"] = confirm(cmp.ConfirmBehavior.Insert),
    ["<Tab>"] = confirm(cmp.ConfirmBehavior.Replace),
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
    { name = "path", option = {
      trailing_slash = true,
    } },
  }, {
    { name = "cmdline" },
  }),
})

cmp.setup.filetype("toml", {
  sources = cmp.config.sources {
    { name = "crates" },
  },
  default_sources,
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources {
    { name = "cmp_git" },
  },
  {
    { name = "buffer" },
  },
})
