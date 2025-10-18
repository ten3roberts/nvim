return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    local keybind = require("config.keybind_definitions").getKeybind

    pcall(function()
      require("mini.ai").setup {
      custom_textobjects = {
        ["B"] = { { "%b[]", "%b{}" }, "^.().*().$" },
      },
    }
    -- require("mini.bracketed").setup {}
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

    require("mini.diff").setup {
      -- Minimal config for thin getters
      view = {
        style = "sign",
        signs = { add = "│", change = "▔", delete = "▁" },
      },
      mappings = {
        apply = keybind "mini-diff-apply",
        reset = keybind "mini-diff-reset",
        textobject = keybind "mini-diff-textobject",
        goto_first = keybind "mini-diff-first",
        goto_prev = keybind "mini-diff-prev",
        goto_next = keybind "mini-diff-next",
        goto_last = keybind "mini-diff-last",
      },
      options = {
        algorithm = "histogram",
        indent_heuristic = true,
        linematch = 60,
        wrap = true,
      },
    }

    -- Set up toggle overlay keybind
    vim.keymap.set("n", keybind "mini-diff-toggle-overlay", function()
      require("mini.diff").toggle_overlay()
    end)

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
