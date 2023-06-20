return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  keys = {
    { "<leader>F", "<cmd>NvimTreeOpen<CR>" },
  },
  config = function()
    -- empty setup using defaults
    require("nvim-tree").setup {
      disable_netrw = false,
      hijack_netrw = false,
      hijack_unnamed_buffer_when_opening = false,
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
      renderer = {
        indent_width = 1,
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "i", api.fs.create, opts "Refresh")
        vim.keymap.del("n", "s", { buffer = bufnr })
        vim.keymap.del("n", "S", { buffer = bufnr })
      end,
    }
  end,
}
