local M = {}
function M.setup(server_conf)
  require("rust-tools").setup {
    tools = { -- rust-tools options
      inlay_hints = {
        auto = true,
        -- prefix for parameter hints
        parameter_hints_prefix = "<- ",

        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "=> ",

        -- padding from the left if max_len_align is true
        -- whether to align to the extreme right or not
        right_align = false,

        -- padding from the right if right_align is true
        right_align_padding = 8,

        -- The color of the hints
        highlight = "InlayHint",
      },
      hover_actions = {
        border = "single",
      },
    },
    dap = {
      adapter = require("recipe.debug_adapters").codelldb,
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = server_conf,
  }
end

return M
