local ls = require "luasnip"
local types = require "luasnip.util.types"

-- ls.config.set_config {
--   history = false,
--   -- Update more often, :h events for more info.
--   -- update_events = "TextChanged,TextChangedI",
--   ext_opts = {
--     [types.choiceNode] = {
--       active = {
--         virt_text = { { "<<-", "String" } },
--       },
--     },
--   },
--   -- delete_check_events = "TextChanged",
--   -- treesitter-hl has 100, use something higher (default is 200).
--   -- ext_base_prio = 300,
--   -- minimal increase in priority.
--   -- ext_prio_increase = 1,
--   -- enable_autosnippets = true,
-- }

_G.get_impl = get_impl

-- require("luasnip.loaders.from_lua").load { paths = vim.fn.stdpath "config" .. "/lua/snippets" }

-- ls.filetype_extend("svelte", { "javascript" })
-- ls.filetype_extend("typescript", { "javascript" })

-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
--   if ls.jumpable(1) then
--     ls.jump(1)
--   end
-- end)

-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end)

-- vim.keymap.set({ "i", "s" }, "<c-l>", function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end)

-- require("luasnip.loaders.from_vscode").lazy_load()
