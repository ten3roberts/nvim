local cmp = require "cmp"
local lspkind = require "lspkind"

require "crates"
require("cmp_git").setup {
  filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
}

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
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end)
end

-- vim.o.completeopt = "menu,menuone"

cmp.setup {
  -- preselect = cmp.PreselectMode.None,
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format {
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
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
  sources = cmp.config.sources {
    { name = "git" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path", option = { trailing_slash = true } },
    -- { name = "treesitter" },
  },
}

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    -- { name = "treesitter" },
  },
})

cmp.setup.cmdline(":", {
  -- completion = {
  --   keyword_length = 2,
  -- },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = "cmdline" },
    { name = "path", option = { trailing_slash = true } },
    -- { name = "treesitter" },
  },
})

-- cmp.setup.filetype("NeogitCommitMessage", {
--   sources = cmp.config.sources {
--     { name = "git" },
--     { name = "buffer" },
--   },
-- })
