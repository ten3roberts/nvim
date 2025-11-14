return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = vim.g.statusline_provider == "lualine",
    dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.nvim" },
    config = function()
      local components = require "config.lualine.components"
      local tabline = require "config.lualine.tabline"

      -- Setup tabline autocmds for cache management
      tabline.setup_autocmds()

      -- Check for Minuet integration
      local minuet_ok, minuet_lualine = pcall(require, "minuet.lualine")

      require("lualine").setup {
        options = {
          theme = components.get_theme,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { "aerial" },
          tabline = function()
            return #vim.api.nvim_list_tabpages() >= 2
          end,
        },
        sections = {
          lualine_a = { { "mode", padding = { left = 1, right = 1 }, separator = { right = "" } } },
          lualine_b = {
            components.branch(),
            components.diff_source(),
            {
              components.get_file_info,
              separator = { right = "" },
              padding = { left = 0, right = 1 },
            },
          },
          lualine_c = {},
          lualine_x = vim.tbl_filter(function(v)
            return v ~= false
          end, {
            minuet_ok and {
              minuet_lualine,
              display_name = "both",
              provider_model_separator = ":",
              display_on_idle = false,
              padding = { left = 1, right = 0 },
              color = function()
                return { fg = "#000000", bg = components.get_mode_color() }
              end,
            } or false,
            components.diagnostics(),
            components.lsp_status(),
            components.search_count(),
            components.macro_recording(),
            components.dap_status(),
            components.clock(),
          }),
          lualine_y = {
            {
              "progress",
              separator = { left = "" },
              padding = { left = 1, right = 1 },
              color = function()
                return { fg = "#000000", bg = components.get_mode_color() }
              end,
            },
            {
              "location",
              padding = { left = 0, right = 1 },
              color = function()
                return { fg = "#000000", bg = components.get_mode_color() }
              end,
            },
          },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {
            {
              components.get_file_info,
              separator = { right = "" },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_c = {},
          lualine_x = {
            {
              "location",
              separator = { left = "" },
              padding = { left = 1, right = 1 },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          component_separators = {},
          section_separators = {},
          lualine_a = {
            {
              tabline.tabline,
            },
          },
        },
      }

      -- Setup cleanup on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          components.cleanup()
          tabline.cleanup()
        end,
      })
    end,
  },
}
