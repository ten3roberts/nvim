return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "Avante" },
    config = function()
      require("render-markdown").setup {
        heading = {
          border = true,
          icons = { "󰼏  ", "󰼐  ", "󰼑  ", "󰼒  ", "󰼓  ", "󰼔  " },
          -- backgrounds = {}, -- Disable header backgrounds
          position = "inline",
          left_pad = 2,
          right_pad = 4,
        },
        bullet = {
          --   enabled = true,
          --   render_modes = false,
          --   -- icons = { "-", "–", "—", "•" },
          --   left_pad = 1,
          --   right_pad = 1,
          --   highlight = "RenderMarkdownBullet",
        },
      }
    end,
  },
}
