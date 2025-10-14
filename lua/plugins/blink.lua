return {
  {
    "saghen/blink.nvim",
    build = "cargo build --release", -- for delimiters
    keys = {
      -- chartoggle
      {
        "<C-;>",
        function()
          require("blink.chartoggle").toggle_char_eol ";"
        end,
        mode = { "n", "v" },
        desc = "Toggle ; at eol",
      },
      {
        ",",
        function()
          require("blink.chartoggle").toggle_char_eol ","
        end,
        mode = { "n", "v" },
        desc = "Toggle , at eol",
      },

      -- tree
      { "<C-e>", "<cmd>BlinkTree reveal<cr>", desc = "Reveal current file in tree" },
      { "<leader>E", "<cmd>BlinkTree toggle<cr>", desc = "Reveal current file in tree" },
      { "<leader>e", "<cmd>BlinkTree toggle-focus<cr>", desc = "Toggle file tree focus" },
    },
    -- all modules handle lazy loading internally
    lazy = false,
    opts = {
      chartoggle = { enabled = true },
    },
  },
  {
    "saghen/blink.pairs",
    version = "*", -- (recommended) only required with prebuilt binaries
    -- download prebuilt binaries from github releases
    dependencies = "saghen/blink.download",
    opts = {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
        enabled = true,
        -- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L10
        pairs = {},
      },
      highlights = {
        enabled = true,
        groups = {
          "BlinkPairsOrange",
          "BlinkPairsPurple",
          "BlinkPairsBlue",
        },
        matchparen = {
          enabled = true,
          group = "MatchParen",
        },
      },
      debug = false,
    },
    config = function()
      -- Disable autopairs in prompt buffers (e.g., Snacks picker)
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        callback = function()
          if vim.bo.buftype == "prompt" then
            require("blink.pairs.mappings").disable()
          else
            require("blink.pairs.mappings").enable()
          end
        end,
      })
    end,
  },
}
