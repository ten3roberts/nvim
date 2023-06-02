return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- empty setup using defaults
    require("nvim-tree").setup {
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del("n", "s", { buffer = bufnr })
        vim.keymap.del("n", "S", { buffer = bufnr })
      end,
    }
  end,
}
