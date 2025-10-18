return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = vim.g.statusline_provider == "lualine",
    dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.nvim" }, -- Optional, for icons; mini for diff
    config = function()
      local tabline = require "config.tabline"
      tabline.setup_autocmd()

      local function get_file_info()
        -- Filename
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
        if filename == "" then
          filename = "[No Name]"
        end
        local extension = vim.fn.fnamemodify(filename, ":e")
        local icon, icon_color
        if vim.bo.buftype == "terminal" then
          filename = "Terminal"
          icon = ""
          icon_color = "#87af87" -- green
        else
          icon, icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end
        local icon_str = icon and string.format("%%#%s#%s %%*", "DevIcon" .. extension, icon) or ""
        local modified = vim.bo.modified and " 󰆓" or ""
        local readonly = (not vim.bo.modifiable or vim.bo.readonly) and " " or ""
        vim.api.nvim_set_hl(0, "TempFileInfo", { fg = normal_fg, bg = normal_bg })
        return string.format("%%#TempFileInfo#%s", icon_str .. filename .. modified .. readonly)
      end

      local mode_colors = {
        n = "#5f87af", -- blue
        i = "#87af87", -- green
        v = "#87afaf", -- cyan
        V = "#87afaf",
        ["\22"] = "#87afaf",
        c = "#ffaf5f", -- orange
        s = "#af87af", -- purple
        S = "#af87af",
        ["\19"] = "#af87af",
        R = "#ffaf5f",
        r = "#ffaf5f",
        ["!"] = "#ff5f5f", -- red
        t = "#87af87",
      }

      local function get_mode_color()
        local mode = vim.fn.mode()
        return mode_colors[mode] or "#5f87af"
      end

      local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      local normal_fg = normal_hl.fg and string.format("#%06x", normal_hl.fg) or "#ffffff"
      local normal_bg = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "#000000"

      local function get_theme(mode_color)
        local base = {
          a = { fg = normal_bg, bg = mode_color, gui = "bold" },
          b = { fg = normal_fg, bg = normal_bg },
          c = { fg = normal_fg, bg = normal_bg },
        }
        return {
          normal = base,
          insert = base,
          visual = base,
          replace = base,
          command = base,
          inactive = {
            a = { fg = normal_fg, bg = normal_bg },
            b = { fg = normal_fg, bg = normal_bg },
            c = { fg = normal_fg, bg = normal_bg },
          },
          separators = {
            left = { fg = mode_color, bg = normal_bg },
            right = { fg = normal_bg, bg = mode_color },
          },
        }
      end

      local minuet_lualine = pcall(require, "minuet.lualine")

      require("lualine").setup {
        options = {
          theme = function()
            local mode_color = get_mode_color()
            return get_theme(mode_color)
          end,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { "NvimTree", "aerial" },
        },
        sections = {
          -- Filled pill: right side components (x, y, z) with mode-colored backgrounds for high contrast
          lualine_a = { { "mode", padding = { left = 1, right = 1 }, separator = { right = "" } } },
          lualine_b = {
            {
              "branch",
              icon = "󰘬",
              separator = " ",
              color = { fg = "#ffaf5f" },
              padding = { left = 1, right = 1 },
            },
            {
              "diff",
              source = function()
                local ok, mini_diff = pcall(require, "mini.diff")
                if not ok then
                  return { "no diff" }
                end
                local data = mini_diff.get_buf_data() or {}
                local summary = data.summary or {}
                return {
                  added = summary.add or 0,
                  modified = summary.change or 0,
                  removed = summary.delete or 0,
                }
              end,
              separator = "",
              color = { fg = "#ff8800" },
              padding = { left = 0, right = 1 },
            },
            {
              get_file_info,
              separator = "",
              padding = { left = 0, right = 1 },
            },
          },
          lualine_c = {},
          lualine_x = vim.tbl_filter(function(v)
            return v ~= false
          end, {
            minuet_lualine and {
              minuet_lualine,
              display_name = "both",
              provider_model_separator = ":",
              display_on_idle = false,
              padding = { left = 1, right = 0 },
              color = function()
                return { fg = normal_bg, bg = get_mode_color() }
              end,
            } or false,
            { "diagnostics", padding = { left = 0, right = 1 } },
            {
              "lsp_status",
              padding = { left = 1, right = 1 },
              color = { fg = "#90EE90" },
            },
          }),
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 1 },
              color = function()
                return { fg = normal_bg, bg = get_mode_color() }
              end,
            },
            {
              "location",
              padding = { left = 0, right = 1 },
              color = function()
                return { fg = normal_bg, bg = get_mode_color() }
              end,
            },
          },
          lualine_z = {
            {},
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { { "filename", padding = { left = 1, right = 0 } } },
          lualine_c = {},
          lualine_x = { { "location", padding = { left = 0, right = 1 } } },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          component_separators = {},
          section_separators = {},
          lualine_a = {
            {
              function()
                if #vim.api.nvim_list_tabpages() < 2 then
                  return ""
                end
                local tabline_hl = vim.api.nvim_get_hl(0, { name = "TabLine", link = false })
                local tabline_sel_hl = vim.api.nvim_get_hl(0, { name = "TabLineSel", link = false })
                local tabline_fill_hl = vim.api.nvim_get_hl(0, { name = "TabLineFill", link = false })
                local tabline_bg = tabline_fill
                local tabline_sel_bg = tabline_sel_hl.bg
                local tabline_fill = tabline_fill_hl.bg

                local current_tab = vim.api.nvim_get_current_tabpage()
                local parts = {}
                for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
                  local is_active = tabnr == current_tab
                  local hl = is_active and "TabLine" or "TabLineSel"
                  local bg = is_active and tabline_bg or tabline_sel_bg
                  local tabpage = tabline.tabpages[tabnr] or {}
                  local buffers = vim.tbl_map(function(bufnr)
                    return tabline.get_buffer_display(bufnr)
                  end, tabpage)
                  local buffer_str = table.concat(buffers, " · ")
                  local tab_str = string.format("%d. %s", i, buffer_str ~= "" and buffer_str or "[No buffers]")
                  local left_sep_hl_name = "TempTabLeft" .. i
                  vim.api.nvim_set_hl(0, left_sep_hl_name, { fg = bg, bg = tabline_fill })
                  local right_sep_hl_name = "TempTabRight" .. i
                  vim.api.nvim_set_hl(0, right_sep_hl_name, { fg = tabline_fill, bg = bg })
                  local right_sep = i < #vim.api.nvim_list_tabpages() and string.format("%%#%s#", right_sep_hl_name)
                    or ""
                  local tab_part =
                    string.format("%%%dT%%#%s#%%#%s#%s%s", tabnr, left_sep_hl_name, hl, tab_str, right_sep)
                  table.insert(parts, tab_part)
                end
                return table.concat(parts, "   ")
              end,
            },
          },
        },
      }
    end,
  },
}
