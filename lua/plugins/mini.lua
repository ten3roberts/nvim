-- Mini.nvim ecosystem provides lightweight, focused utilities
-- Chosen for consistency and performance over multiple separate plugins
return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    local keybind = require("config.keybind_definitions").getKeybind

    pcall(function()
      -- require("mini.ai").setup {
      --   custom_textobjects = {
      --     ["b"] = { { "%b()", "%b{}" }, "^.().*().$" },
      --     ["B"] = { { "%b[]", "%b{}" }, "^.().*().$" },
      --   },
      -- }
      require("mini.move").setup {

        mappings = {
          left = "<",
          right = ">",
          down = "<M-j>",
          up = "<M-k>",

          -- Move current line in Normal mode
          line_left = "<",
          line_right = ">",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },
      }

      local hipatterns = require "mini.hipatterns"
      hipatterns.setup {
        highlighters = {
          -- Highlight TODO, FIXME, etc.
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          -- Highlight URLs
          -- url = hipatterns.gen_highlighter.url(),
          -- Highlight hex colors
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }

      require("mini.operators").setup {
        -- Evaluate math expressions
        evaluate = {
          prefix = keybind "mini-eval-math",
        },
        -- Exchange text regions
        exchange = {
          prefix = keybind "mini-exchange-text",
        },
        -- Multiply (duplicate) text
        multiply = {
          prefix = keybind "mini-multiply-text",
        },
        -- Replace with register
        replace = {
          prefix = keybind "mini-replace-register",
        },
        -- Sort text
        sort = {
          prefix = keybind "mini-sort-text",
        },
      }

      require("mini.splitjoin").setup {
        -- Split/join mappings
        mappings = {
          toggle = keybind "mini-splitjoin-toggle",
        },
      }
    end)
  end,
}
