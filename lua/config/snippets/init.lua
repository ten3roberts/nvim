local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
  history = true,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<<-", "String" } },
      },
    },
  },
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
}

_G.get_impl = get_impl

local fts = {
  javascript = require "config.snippets.js",
  markdown = require "config.snippets.markdown",
  rust = require "config.snippets.rust",
  lua = require "config.snippets.lua",
  json = require "config.snippets.json",
  all = require "config.snippets.all",
}

for ft, snippets in pairs(fts) do
  ls.add_snippets(ft, snippets, {})
end

ls.filetype_extend("svelte", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end)

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

require("luasnip.loaders.from_vscode").lazy_load()