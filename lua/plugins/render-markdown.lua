return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "Avante" },
    config = function()
      require("render-markdown").setup {
        -- Enable anti-conceal to show concealed text when cursor is on it
        anti_conceal = {
          enabled = true,
        },
        heading = {
          border = false,
          icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
          position = "left",
          left_pad = 0,
          right_pad = 2,
          sign = false,
          rainbow = true,
        },
        code = {
          enabled = true,
          style = "full",
          position = "left",
          language_pad = 2,
          disable_background = { "diff" },
          width = "full",
          left_pad = 2,
          right_pad = 4,
          min_width = 60,
          border = "thick",
          above = "▄",
          below = "▀",
          highlight = "RenderMarkdownCode",
          highlight_inline = "RenderMarkdownCodeInline",
        },
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
          left_pad = 1,
          right_pad = 1,
          highlight = "RenderMarkdownBullet",
        },
        checkbox = {
          enabled = true,
          position = "inline",
          unchecked = {
            icon = "󰄱 ",
            highlight = "RenderMarkdownUnchecked",
          },
          checked = {
            icon = "󰱒 ",
            highlight = "RenderMarkdownChecked",
          },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          },
        },
        quote = {
          enabled = true,
          icon = "▋",
          repeat_linebreak = false,
          highlight = "RenderMarkdownQuote",
        },
        pipe_table = {
          enabled = true,
          preset = "round",
          style = "full",
          cell = "padded",
          alignment_indicator = "━",
          border = {
            "┌",
            "┬",
            "┐",
            "├",
            "┼",
            "┤",
            "└",
            "┴",
            "┘",
            "│",
            "─",
          },
          head = "RenderMarkdownTableHead",
          row = "RenderMarkdownTableRow",
          filler = "RenderMarkdownTableFill",
        },
        link = {
          enabled = true,
          image = "󰥶 ",
          email = "󰀓 ",
          hyperlink = "󰌹 ",
          highlight = "RenderMarkdownLink",
          custom = {
            web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
          },
        },
        sign = {
          enabled = true,
          highlight = "RenderMarkdownSign",
        },
        indent = {
          enabled = true,
          per_level = 2,
          skip_level = 1,
          skip_heading = true,
        },
      }
    end,
  },
}
