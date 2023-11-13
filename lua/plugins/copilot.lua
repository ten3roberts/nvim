return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = true,
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-e>",
            accept_word = false,
            accept_line = false,
            next = "<C-.>",
            prev = "<C-,>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = true,
          help = false,
          gitcommit = true,
          gitrebase = true,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      }
    end,
  },
}
-- return {
--   {
--     "github/copilot.vim",
--     event = "InsertEnter",
--     cmd = "Copilot",
--     -- keys = {
--     --   { "<C-}>", "<Plug>(copilot-next)", mode = "i" },
--     --   { "<C-{>", "<Plug>(copilot-previous)", mode = "i" },
--     --   { "<C-e>", "copilot#Accept('')", mode = "i", expr = true, silent = true },
--     -- },

--     config = function()
--       vim.g.copilot_no_tab_map = true

--       local accept = vim.fn["copilot#Accept"]
--       vim.keymap.set("i", "<C-e>", function()
--         vim.api.nvim_feedkeys(accept(), "n", true)
--       end, { silent = true })
--     end,
--   },
--   -- {
--   --   "zbirenbaum/copilot.lua",
--   --   cmd = "Copilot",
--   --   event = "InsertEnter",
--   --   config = function()
--   --     require("copilot").setup {
--   --       suggestion = {
--   --         -- enabled = true,
--   --         auto_trigger = true,
--   --         -- debounce = 75,
--   --         keymap = {
--   --           accept = "<C-e>",
--   --           next = "<C-.>",
--   --           prev = "<C-,>",
--   --           -- dismiss = "<C-]>",
--   --         },
--   --       },
--   --       -- suggestion = { enabled = false },
--   --       -- panel = { enabled = false },
--   --     }
--   --   end,
--   -- },
--   -- {
--   --   "zbirenbaum/copilot-cmp",
--   --   after = { "copilot.lua" },
--   --   config = function()
--   --     require("copilot_cmp").setup()
--   --   end,
--   -- },
-- }
