return {
  -- "github/copilot.vim",
  -- lazy = false,
  -- cmd = "Copilot",
  -- keys = {
  --   { "<C-}>", "<Plug>(copilot-next)", mode = "i" },
  --   { "<C-{>", "<Plug>(copilot-previous)", mode = "i" },
  --   { "<C-\\>", "<Plug>(copilot-suggest)", mode = "i" },
  -- },
  -- config = function()
  --   vim.g.copilot_no_tab_map = true
  -- end,
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          -- enabled = true,
          auto_trigger = true,
          -- debounce = 75,
          keymap = {
            accept = "<C-e>",
            next = "<C-.>",
            prev = "<C-,>",
            -- dismiss = "<C-]>",
          },
        },
        -- suggestion = { enabled = false },
        -- panel = { enabled = false },
      }
    end,
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua" },
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },
}
