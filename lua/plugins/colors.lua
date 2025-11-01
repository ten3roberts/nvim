local colorschemes = {
  sonokai = {
    "sainnhe/sonokai",
    config = function()
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_float_style = "dim"
      -- vim.g.sonokai_style = "andromeda"
      vim.g.sonokai_style = "atlantis"
      vim.cmd.colorscheme "sonokai"
    end,
  },
  nordic = {
    "AlexvZyl/nordic.nvim",
    config = function()
      require("nordic").load()
    end,
  },
  install = {
    colorscheme = { "nord" },
  },
  everforest = {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_background = "hard"
      vim.g.everforest_show_eob = false
      vim.g.everforest_float_style = "dim"
      vim.g.everforest_diagnostic_line_highlight = 1
      vim.g.everforest_better_performance = 1
      vim.g.everforest_ui_contrast = "low"
      vim.g.everforest_current_word = "grey background"
      vim.g.everforest_inlay_hints_background = "dimmed"
      vim.g.everforest_spell_foreground = "colored"
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = "grey"
      vim.g.everforest_statusline_style = "mix"
      vim.g.everforest_tabline_style = "mix"
      vim.cmd.colorscheme "everforest"
    end,
  },
  catppuccin = {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        -- flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          -- light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" }, -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true, -- Using mini.diff instead
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  tokyonight = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },
}

local current_colorscheme = "everforest"

local t = colorschemes[current_colorscheme]

t.lazy = false
t.priority = 1000

return t
