local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "petertriho/cmp-git",

    "onsails/lspkind-nvim",
    -- "hrsh7th/cmp-nvim-lsp-signature-help",
    "jose-elias-alvarez/null-ls.nvim",
    "Saecki/crates.nvim",
    -- "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    -- "dcampos/cmp-snippy",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "ray-x/cmp-treesitter",
  },
}

function M.config()
  local api = vim.api
  local cmp = require "cmp"
  local lspkind = require "lspkind"

  require "crates"
  require("cmp_git").setup {
    filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
  }

  -- local ls = require "luasnip"

  local has_words_before = function()
    local line, col = unpack(api.nvim_win_get_cursor(0))
    return col ~= 0 and api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  local function confirm(behavior)
    local ls = require "luasnip"
    return cmp.mapping(function(fallback)
      -- local suggestion = require "copilot.suggestion"
      -- if suggestion.is_visible() then
      --   suggestion.accept()
      if cmp.visible() then
        cmp.confirm {
          behavior = behavior,
          select = true,
        }
      elseif has_words_before() then
        if ls.expand_or_jumpable(1) then
          ls.expand_op_jump(1)
        else
          cmp.complete()
        end
      else
        fallback()
      end
    end)
  end

  vim.o.completeopt = "menu,menuone"

  local menu = {
    treesitter = "󰌪",
    nvim_lsp = "󰀘",
    luasnip = "󰅴",
    path = "󰉋",
    __index = function(_, k)
      return k
    end,
  }
  setmetatable(menu, menu)
  cmp.setup {
    preselect = cmp.PreselectMode.None,
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format {
        mode = "symbol", -- show only symbol annotations
        maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        menu = menu,
      },
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.

        -- require("snippy").expand_snippet(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.complete {}
        end
      end,
      ["<C-n>"] = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete {}
        end
      end,
      -- ["<C-e>"] = cmp.mapping(function()
      --   vim.api.nvim_feedkeys(
      --     vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
      --     "n",
      --     true
      --   )
      -- end),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete {},
      ["<C-y>"] = confirm(cmp.ConfirmBehavior.Insert),
      ["<Tab>"] = confirm(cmp.ConfirmBehavior.Replace),
    },
    sources = cmp.config.sources {
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "treesitter" },
      -- { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path", option = { trailing_slash = true } },
      { name = "crates" },
    },
  }

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "treesitter" },
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
    },
  })
end

return M
