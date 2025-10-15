return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = vim.g.statusline_provider == "lualine",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional, for icons
     config = function()
       local function get_file_info()
         -- Branch
         local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
           or vim.fn.system("git branch --show-current"):gsub("\n", "")
         branch = branch ~= "" and string.format("󰘬 %s", branch) or ""

         -- Diff
         local diff = ""
         if vim.b.gitsigns_status_dict then
           local added = vim.b.gitsigns_status_dict.added or 0
           local removed = vim.b.gitsigns_status_dict.removed or 0
           local changed = vim.b.gitsigns_status_dict.changed or 0
           if added > 0 or removed > 0 or changed > 0 then
             diff = string.format("+%d ~%d -%d", added, changed, removed)
           end
         end

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
         local icon_str = icon and string.format("%%#%s#%s ", "DevIcon" .. extension, icon) or ""
         local modified = vim.bo.modified and " 󰆓" or ""
         local readonly = (not vim.bo.modifiable or vim.bo.readonly) and " " or ""
         return branch
           .. (diff ~= "" and " " .. diff or "")
           .. " "
           .. icon_str
           .. filename
           .. modified
           .. readonly
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

       local function get_theme(mode_color)
         local base = {
           a = { fg = "normal_bg", bg = mode_color, gui = "bold" },
           b = { fg = normal_fg, bg = "normal_bg" },
           c = { fg = normal_fg, bg = "normal_bg" },
         }
         return {
           normal = base,
           insert = base,
           visual = base,
           replace = base,
           command = base,
           inactive = {
             a = { fg = normal_fg, bg = "normal_bg" },
             b = { fg = normal_fg, bg = "normal_bg" },
             c = { fg = normal_fg, bg = "normal_bg" },
           },
           separators = {
             left = { fg = mode_color, bg = "normal_bg" },
             right = { fg = "normal_bg", bg = mode_color },
           },
         }
       end

       require("lualine").setup {
         options = {
           theme = function()
             local mode_color = get_mode_color()
             return get_theme(mode_color)
           end,
          component_separators = { left = "", right = " " }, -- Separators with spacing
          section_separators = { left = "", right = "" }, -- Separator with mode color
           disabled_filetypes = { "NvimTree", "aerial" },
         },
         sections = {
           -- Filled pill: right side components (x, y, z) with mode-colored backgrounds for high contrast
           lualine_a = { "mode" },
           lualine_b = {
             {
               provider = get_file_info,
               color = function()
                 if vim.bo.buftype == "terminal" then
                   return { fg = "green" }
                 else
                   return { fg = "orange" }
                 end
               end,
               padding = { left = 1, right = 0 },
             },
           },
           lualine_c = {},
           lualine_x = {
             {
               require "minuet.lualine",
               display_name = "both",
               provider_model_separator = ":",
               display_on_idle = false,
               padding = { left = 1, right = 0 },
               color = function()
                 return { fg = "normal_fg", bg = get_mode_color() }
               end,
             },
             { "diagnostics", padding = { left = 0, right = 1 } },
             {
               "lsp_status",
               padding = { left = 1, right = 1 },
               color = { fg = "#90EE90" },
             },
           },
           lualine_y = {
             {
               "progress",
               separator = " ",
               padding = { left = 1, right = 1 },
               color = function()
                 return { fg = "normal_fg", bg = get_mode_color() }
               end,
             },
             {
               "location",
               padding = { left = 0, right = 1 },
               color = function()
                 return { fg = "normal_fg", bg = get_mode_color() }
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
           component_separators = { left = '', right = '' },
           section_separators = { left = '', right = '' },
           lualine_a = {
             {
               "tabs",
               mode = 1,
               tabs_color = {
                 active = { fg = "normal_fg", bg = "tabline_sel_bg" },
                 inactive = { fg = "gray", bg = "tabline_bg" },
               },
             },
           },
           lualine_b = {
             {
               function()
                 local tabnr = vim.fn.tabpagenr()
                 local wins = vim.fn.tabpagewinnr(tabnr, '$')
                 local buffers = {}
                 for i = 1, wins do
                   local bufnr = vim.fn.tabpagebuflist(tabnr)[i]
                   local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t')
                   if name ~= '' then
                     table.insert(buffers, name)
                   end
                 end
                 return table.concat(buffers, ' · ')
               end,
               color = { fg = "normal_fg", bg = "tabline_bg" },
             },
           },
           lualine_c = {},
           lualine_x = {},
           lualine_y = {},
           lualine_z = {},
         },
       }
     end,
              padding = { left = 1, right = 0 },
            },
          },
          lualine_c = {},
          lualine_x = {
            {
              require "minuet.lualine",
              display_name = "both",
              provider_model_separator = ":",
              display_on_idle = false,
              padding = { left = 1, right = 0 },
               color = function()
                 return { fg = "normal_fg", bg = get_mode_color() }
               end,
            },
            { "diagnostics", padding = { left = 0, right = 1 } },
            {
              "lsp_status",
              padding = { left = 1, right = 1 },
              color = { fg = "#90EE90" },
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 1 },
               color = function()
                 return { fg = "normal_fg", bg = get_mode_color() }
               end,
            },
            {
              "location",
              padding = { left = 0, right = 1 },
               color = function()
                 return { fg = "normal_fg", bg = get_mode_color() }
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
      }
    end,
  },
}
