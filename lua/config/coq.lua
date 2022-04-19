vim.g.coq_settings = {
  ["display.pum.fast_close"] = false,
  ["auto_start"] = "shut-up",

  display = {
    ["pum.source_context"] = {"", ""},
    ["pum.kind_context"] = {"", ""},
    ["icons.spacing"] = 2,
  },
  keymap = {
    pre_select = true,
    recommended = false,
  }
}

vim.keymap.set("i", "<Esc>", 'pumvisible() ? "\\<C-e><Esc>" : "\\<Esc>"', { expr = true })
vim.keymap.set("i", "<C-c>", 'pumvisible() ? "\\<C-e><C-c>" : "\\Esc"', { expr = true })
vim.keymap.set("i", "<BS>",  'pumvisible() ? "\\<C-e><BS>" : "\\<BS>"', { expr = true })
-- vim.keymap.set("<Esc>", 'pumvisible() ? (complete_info().selected == -1 ? "<C-e><Tab>" : "<C-y>") : "<CR>"', { expr = true })
vim.keymap.set("i", "<Tab>", 'pumvisible() ? "\\<C-y>" : "\\<Tab>"', { expr = true })


require "coq"
