return {
  "ten3roberts/qf.nvim",
  keys = {
    {

      "<leader>E",
      function()
        require("qf").filter("visible", function(v)
          return v.type == "E"
        end, true)
      end,
    },
  },
  config = function()
    local qf = require "qf"
    vim.keymap.set("n", "<leader>cc", function()
      qf.toggle "c"
    end)

    vim.keymap.set("n", "<leader>co", function()
      qf.open "c"
    end)

    vim.keymap.set("n", "<leader>ll", function()
      qf.toggle "l"
    end)

    vim.keymap.set("n", "<leader>lo", function()
      qf.open "l"
    end)

    vim.keymap.set("n", "<leader>cf", "<cmd>cc<CR>")

    vim.keymap.set("n", "]l", function()
      qf.below "l"
    end)

    vim.keymap.set("n", "[l", function()
      qf.above "l"
    end)

    vim.keymap.set("n", "]q", function()
      qf.below "c"
    end)

    vim.keymap.set("n", "[q", function()
      qf.above "c"
    end)

    require("qf").setup {
      -- Location list configuration
      ["l"] = {
        auto_follow = "prev",
      },
      -- Quickfix list configuration
      ["c"] = {
        auto_follow = "prev",
        auto_resize = false,
        wide = true,
      },
      close_other = true,
      -- signs = signs,
    }
  end,
}
