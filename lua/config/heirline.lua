local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local function pill(component, color)
  return utils.surround({ "", "" }, color, component)
end
local M = {}

local function get_hl(name)
  local v = utils.get_highlight(name)
  if not v or vim.tbl_isempty(v) then
    vim.notify("No highlight for " .. name, vim.log.levels.WARN)
  end
  return v
end

function M.setup_colors()
  return {
    normal_bg = get_hl("Normal").bg,
    bright_bg = get_hl("Folded").bg,
    bright_fg = get_hl("Folded").fg,
    red = get_hl("Red").fg,
    dark_red = get_hl("DiffDelete").bg,
    green = get_hl("Green").fg,
    blue = get_hl("Blue").fg,
    gray = get_hl("NonText").fg,
    orange = get_hl("Orange").fg,
    purple = get_hl("Purple").fg,
    cyan = get_hl("Special").fg,
    diag_warn = get_hl("DiagnosticSignWarn").fg,
    diag_error = get_hl("DiagnosticSignError").fg,
    diag_hint = get_hl("DiagnosticSignHint").fg,
    diag_info = get_hl("DiagnosticSignInfo").fg,
    git_del = get_hl("diffRemoved").fg,
    git_add = get_hl("diffAdded").fg,
    git_change = get_hl("diffChanged").fg,
  }
end

function M.setup()
  vim.api.nvim_create_augroup("Heirline", { clear = true })
  -- vim.api.nvim_create_autocmd("ColorScheme", {
  --   callback = function()
  --     utils.on_colorscheme(M.setup_colors)
  --   end,
  --   group = "Heirline",
  -- })

  require("heirline").load_colors(M.setup_colors())

  local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
      self.mode = vim.fn.mode(1) -- :h mode()
    end,
    -- Now we define some dictionaries to map the output of mode() to the
    -- corresponding string and color. We can put these into `static` to compute
    -- them at initialisation time.
    static = {
      mode_names = {
        -- change the strings if you like it vvvvverbose!
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantiated.
    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 2
    -- characters long. Plus a nice Icon.
    provider = function(self)
      return " %-2(" .. (self.mode_names[self.mode] or "__") .. "%)"
    end,
    hl = { fg = "normal_bg", bold = true },
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allorws the statusline to be re-evaluated when entering operator-pending mode
    update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function()
        vim.cmd "redrawstatus"
      end),
    },
  }

  local FileNameBlock = {
    -- let's first set up some attributes needed by this component and it's children
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
  }
  -- We can now define some children separately and add them later

  local FileIcon = {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
      return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  }

  local FileName = {
    init = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":.")
      if filename == "" then
        filename = "[No Name]"
      end
      self.lfilename = filename
    end,
    flexible = 20,
    {
      provider = function(self)
        return self.lfilename
      end,
    },
    {
      provider = function(self)
        return vim.fn.pathshorten(self.lfilename, 5)
      end,
    },
  }

  local FileFlags = {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = " 󰆓",
      hl = { fg = "red" },
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = " ",
      hl = { fg = "purple" },
    },
  }

  -- let's add the children to our FileNameBlock component
  FileNameBlock = utils.insert(
    FileNameBlock,
    FileIcon,
    FileName,
    FileFlags,
    { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
  )

  local nvim_web_devicons = require "nvim-web-devicons"

  local FileType = {
    init = function(self)
      local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
      local ft = vim.bo.filetype
      local icon, color = nvim_web_devicons.get_icon(fname, ft)
      self.icon = icon
      self.color = color
      self.ft = ft
    end,
    provider = function(self)
      return self.ft
    end,
    hl = function(self)
      return self.color
    end,
  }

  -- We're getting minimalists here!
  local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%3l:%-3L",
    hl = { fg = "normal_bg", bold = true },
    -- hl = { bg = "blue" , fg = "normal_bg", bold = true},
  }
  Ruler = pill(Ruler, function(self)
    return self:mode_color()
  end)

  -- I take no credits for this! :lion:
  local ScrollBar = {
    static = {
      -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
      -- Another variant, because the more choice the better.
      sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
    },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local p = lines == 0 and 1 or curr_line / lines
      local i = math.floor(p * (#self.sbar - 1)) + 1
      return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = "blue", bg = "bright_bg" },
  }

  local LSPActive = {
    condition = conditions.lsp_attached,
    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    flexible = 5,
    {
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        return " " .. table.concat(names, " ")
      end,
      hl = { fg = "green" },
    },
    { provider = "" },
  }

  -- I personally use it only to display progress messages!
  -- See lsp-status/README.md for configuration options.

  -- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
  -- local LSPMessages = {
  --   provider = require("lsp-status").status,
  --   hl = { fg = "gray" },
  -- }
  local Diagnostics = {
    update = { "DiagnosticChanged", "BufEnter", "WinResized" },
    condition = conditions.has_diagnostics,
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    flexible = 10,
    {
      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = "diag_error" },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = "diag_warn" },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = "diag_info" },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = "diag_hint" },
      },
    },
    {
      provider = function(self)
        local total = self.errors + self.warnings + self.info + self.hints
        return total > 0 and " " .. total
      end,
      hl = { fg = "orange" },
    },
  }

  local function diff_indicator(sign, count, _)
    if count == 0 then
      return ""
    end

    local n = math.ceil(math.log(count + 1, 2))
    return string.rep(sign, n)
  end

  local Git = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict or {}
      self.total_changes = (self.status_dict.added or 0)
        + (self.status_dict.removed or 0)
        + (self.status_dict.changed or 0)
    end,
    hl = { fg = "orange" },
    flexible = 5,
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
      {
        -- git branch name
        provider = function(self)
          return " " .. self.status_dict.head
        end,
      },

      {
        condition = function(self)
          return self.total_changes > 0
        end,
        provider = "(",
      },
      {
        provider = function(self)
          return diff_indicator("+", (self.status_dict.added or 0), self.total_changes)
        end,
        hl = { fg = "git_add" },
      },
      {
        provider = function(self)
          return diff_indicator("~", (self.status_dict.changed or 0), self.total_changes)
        end,
        hl = { fg = "git_change" },
      },
      {
        provider = function(self)
          return diff_indicator("-", (self.status_dict.removed or 0), self.total_changes)
        end,
        hl = { fg = "git_del" },
      },
      {
        condition = function(self)
          return self.total_changes > 0
        end,
        provider = ")",
      },
    },
    {
      -- git branch name
      provider = function(self)
        return " " .. self.status_dict.head
      end,
    },
    {
      -- git branch name
      provider = function()
        return ""
      end,
    },
  }

  local DAPMessages = {
    condition = function()
      local session = require("dap").session()
      return session ~= nil
    end,
    provider = function()
      return " " .. require("dap").status()
    end,
    hl = "Debug",
    -- see Click-it! section for clickable actions
  }

  local TerminalName = {
    -- we could add a condition to check that buftype == 'terminal'
    -- or we could do that later (see #conditional-statuslines below)
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
      return " " .. tname
    end,
    hl = { fg = "blue", bold = true },
  }

  local Align = { provider = "%=" }
  local Space = { provider = " " }

  ViMode = pill(ViMode, function(self)
    return self:mode_color()
  end)

  local DefaultStatusline = {
    ViMode,
    Space,
    Git,
    Space,
    FileNameBlock,
    Space,
    Align,
    DAPMessages,
    Align,
    Diagnostics,
    Space,
    LSPActive,
    Space,
    ScrollBar,
    Space,
    Ruler,
  }

  local InactiveStatusline = {
    condition = conditions.is_not_active,
    Space,
    FileNameBlock,
    -- Align,
  }

  local SpecialStatusline = {
    condition = function()
      return conditions.buffer_matches {
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      }
    end,
    FileType,
    Space,
    -- HelpFileName,
    Align,
  }

  local TerminalStatusline = {
    condition = function()
      return conditions.buffer_matches { buftype = { "terminal" } }
    end,
    -- hl = { bg = "dark_red" },
    -- Quickly add a condition to the ViMode to only show it when buffer is active!
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
  }

  local AerialStatusline = {
    condition = function()
      return conditions.buffer_matches { filetype = { "aerial" } }
    end,
    provider = "󰀘 Aerial%=",
    hl = { fg = "purple" },
  }

  local GrapheneStatusline = {
    condition = function()
      return conditions.buffer_matches { filetype = { "graphene" } }
    end,
    pill({

      provider = function()
        return "󰀘 Graphene"
      end,
    }, "teal"),
    Space,
    {
      provider = function()
        local graphene = require "graphene"
        local status = graphene.status()

        return status.path or "<no path>"
      end,
      hl = "Directory",
    },
    Align,
  }

  local qf = require "qf"
  local QfStatusline = {
    condition = function()
      return conditions.buffer_matches { filetype = { "qf" } }
    end,
    init = function(self)
      local info = qf.inspect_win(vim.api.nvim_get_current_win())

      self.info = info
    end,
    {
      { provider = "ﴯ", hl = { fg = "purple" } },
      Space,
      {
        provider = function(self)
          return self.info.title or "no title"
        end,
      },
      Space,
      {
        flexible = 5,
        condition = function(self)
          return self.info.tally.total > 0
        end,
        pill({
          {
            provider = function(self)
              return self.info.tally.error > 0 and (self.error_icon .. self.info.tally.error .. " ")
            end,
            hl = { fg = "diag_error" },
          },
          {
            provider = function(self)
              return self.info.tally.warn > 0 and (self.warn_icon .. self.info.tally.warn .. " ")
            end,
            hl = { fg = "diag_warn" },
          },
          {
            provider = function(self)
              return self.info.tally.info > 0 and (self.info_icon .. self.info.tally.info .. " ")
            end,
            hl = { fg = "diag_info" },
          },
          {
            provider = function(self)
              return self.info.tally.hint > 0 and (self.hint_icon .. self.info.tally.hint .. " ")
            end,
            hl = { fg = "diag_hint" },
          },
          {
            provider = function(self)
              return self.info.tally.text > 0 and ("󰌪" .. self.info.tally.text .. " ")
            end,
            hl = { fg = "diag_hint" },
          },
        }, "bright_bg"),
        { provider = "" },
      },
      Align,
      pill({
        provider = function(self)
          return string.format("%2d / %-2d", self.info.idx, self.info.size)
        end,
        hl = { fg = "normal_bg", bold = true },
      }, function(self)
        return self:mode_color()
      end),
    },
  }

  local StatusLines = {
    static = {
      error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
      warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
      mode_colors_map = {
        n = "blue",
        i = "green",
        v = "cyan",
        V = "cyan",
        ["\22"] = "cyan",
        c = "orange",
        s = "purple",
        S = "purple",
        ["\19"] = "purple",
        R = "orange",
        r = "orange",
        ["!"] = "red",
        t = "green",
      },
      mode_color = function(self)
        local mode = conditions.is_active() and vim.fn.mode() or "n"
        return self.mode_colors_map[mode]
      end,
    },
    hl = function()
      if conditions.is_active() then
        return "Normal"
      else
        return "StatusLineNC"
      end
    end,
    -- the first statusline with no condition, or which condition returns true is used.
    -- think of it as a switch case with breaks to stop fallthrough.
    fallthrough = false,
    AerialStatusline,
    GrapheneStatusline,
    QfStatusline,
    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusline,
  }

  require("heirline").setup {
    statusline = StatusLines,
  }
end

return M
