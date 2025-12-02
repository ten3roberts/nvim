-- Blink provides fast, Rust-based completion
-- Chosen over nvim-cmp for better performance and modern architecture
return {
  {
    "saghen/blink.nvim",
    build = "cargo build --release", -- for delimiters
    keys = {
      -- chartoggle
      {
        "<C-;>",
        function()
          pcall(function()
            require("blink.chartoggle").toggle_char_eol ";"
          end)
        end,
        mode = { "n", "v" },
        desc = "Toggle ; at eol",
      },
      {
        ",",
        function()
          pcall(function()
            require("blink.chartoggle").toggle_char_eol ","
          end)
        end,
        mode = { "n", "v" },
        desc = "Toggle , at eol",
      },

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
        disabled_filetypes = { "snacks", "snacks_picker", "snacks.picker" },
      },
      -- highlights = {
      --   enabled = true,
      --   groups = {
      --     "BlinkPairsOrange",
      --     "BlinkPairsPurple",
      --     "BlinkPairsBlue",
      --   },
      --   matchparen = {
      --     enabled = true,
      --     group = "MatchParen",
      --   },
      -- },
      debug = false,
    },
  },
}
