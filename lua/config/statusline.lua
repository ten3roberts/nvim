local api = vim.api
local g = vim.g
local fn = vim.fn

local lsp = require "config.lsp"
local icons = require "nvim-web-devicons"

local M = {}

local graphene = require "graphene"

local mode_map = {
  ["n"] = { hl = "%#BlueInv#", val = " N " },
  ["no"] = { hl = "%#BlueInv#", val = " NO " },
  ["niI"] = { hl = "%#BlueInv#", val = " NI " },

  ["v"] = { hl = "%#PurpleInv#", val = " V " },
  ["V"] = { hl = "%#PurpleInv#", val = " VL " },
  ["niV"] = { hl = "%#PurpleInv#", val = " VL " },
  ["\22"] = { hl = "%#PurpleInv#", val = " VB " },

  ["i"] = { hl = "%#GreenInv#", val = " I " },
  ["ic"] = { hl = "%#GreenInv#", val = " I " },
  ["ix"] = { hl = "%#GreenInv#", val = " I " },

  ["R"] = { hl = "%#OrangeInv#", val = " R " },
  ["Rv"] = { hl = "%#OrangeInv#", val = " VR " },
  ["niR"] = { hl = "%#RedInv#", val = " VR " },

  ["t"] = { hl = "%#OrangeInv#", val = " T " },

  ["s"] = { hl = "%#RedInv#", val = " S " },
  ["S"] = { hl = "%#RedInv#", val = " SL " },
  ["^S"] = { hl = "%#RedInv#", val = " SB " },
  ["c"] = { hl = "%#YellowInv#", val = " C " },
  ["cv"] = { hl = "%#YellowInv#", val = " E " },
  ["ce"] = { hl = "%#YellowInv#", val = " E " },
  ["r"] = { hl = "%#YellowInv#", val = " P " },
  ["rm"] = { hl = "%#YellowInv#", val = " M " },
  ["r?"] = { hl = "%#YellowInv#", val = " C " },
  ["!"] = { hl = "%#YellowInv#", val = " SH " },
}

---@param info SL
local function qf_func(info)
  local wininfo = fn.getwininfo(info.winid)
  local q = {}
  if wininfo.loclist == 1 then
    q = fn.getloclist(info.winid, { title = 1, idx = 0, size = 1 })
  else
    q = fn.getqflist { title = 1, idx = 0, size = 1 }
  end

  local idx = q.idx
  local size = q.size
  local percent = ""
  if size > 0 then
    percent = string.format("%3d", idx / size * 100) .. "%%"
  end
  return table.concat {
    "%#Purple# ﴯ %#Normal#",
    q.title,
    "%=",
    "%#Purple#",
    percent,
    string.format(" %s %2d:%-2d ", mode_map.n.hl, idx, size),
  }
end

local special_map = {
  qf = qf_func,
  aerial = {
    [true] = function(_)
      return "%#Purple#  Aerial "
    end,
    [false] = function(_)
      return "  Aerial "
    end,
  },
  graphene = {
    [true] = graphene.make_statusline { icon = true },
    [false] = graphene.make_statusline { icon = true, hl = false },
  },
}

local tab_hide = {
  NvimTree = true,
  qf = true,
  aerial = true,
  fzf = true,
}

local function get_mode()
  local mode = api.nvim_get_mode().mode
  return mode_map[mode] or mode_map[mode:sub(1, 1)] or { val = mode, hl = "%#Red#" }
end

local function get_git(highlight)
  local signs = vim.b.gitsigns_status_dict

  if not signs then
    return "", ""
  end

  local added, changed, removed = signs.added or 0, signs.changed or 0, signs.removed or 0

  local total = added + changed + removed
  local rel_added, rel_changed, rel_removed =
    math.ceil(added / total * 3), math.ceil(changed / total * 3), math.ceil(removed / total * 3)

  if highlight then
    return (rel_added > 0 and ("%#Green#" .. string.rep("+", rel_added)) or "")
      .. (rel_changed > 0 and ("%#Blue#" .. string.rep("~", rel_changed)) or "")
      .. (rel_removed > 0 and ("%#Red#" .. string.rep("-", rel_removed)) or "")
  else
    return (rel_added > 0 and (string.rep("+", rel_added)) or "")
      .. (rel_changed > 0 and (string.rep("~", rel_changed)) or "")
      .. (rel_removed > 0 and (string.rep("-", rel_removed)) or "")
  end
end

local function get_infos(bufnr)
  local ft = api.nvim_buf_get_option(bufnr, "ft")
  local readonly = fn.getbufvar(bufnr, "&readonly") == 1 or fn.getbufvar(bufnr, "&modifiable") == 0

  local _, row, col = unpack(fn.getpos ".")
  local num_lines = #api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local percent = string.format("%3d", row / num_lines * 100) .. "%%"

  return ft, readonly, row, col, percent
end

local function get_path(highlight)
  local modified = vim.o.modified

  if vim.o.buftype == "quickfix" then
    local info = fn.getwininfo(vim.g.statusline_winid or fn.win_getid(fn.winnr()))
    if #info ~= 1 or info[1].quickfix ~= 1 then
      return ""
    end
    if highlight then
      return "%#Normal#" .. (info[1].variables.quickfix_title or "Quickfix")
    else
      return string.gsub(info[1].variables.quickfix_title or "Quickfix", "%%#.-#", "")
    end
  end

  local path, filename, extension = fn.expand "%:~:.", fn.expand "%:t", fn.expand "%:e"
  if filename == "" then
    return "[NO NAME] "
  end

  local icon, icon_hl = icons.get_icon(filename, extension)

  if highlight then
    return string.format(
      "%%#%s#%s %s%s%s ",
      icon_hl or "",
      icon or "",
      modified and "%#Red#" or "%#Normal#",
      path,
      modified and " " or ""
    )
  else
    return string.format("%s %s%s ", icon or "", path, modified and " " or "")
  end
end

local separator = "/"

local function subtbl(tbl, first, last)
  if type(tbl) == "string" then
    return string.sub(tbl, first, last)
  end

  if first < 0 then
    first = #tbl + 1 + first
  end

  if last ~= nil and last < 0 then
    last = #tbl + 1 + last
  end

  local sliced = {}

  for i = first or 1, last or #tbl do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

local function get_unique_name(a, b)
  local a_parts = fn.split(a, separator)
  local b_parts = fn.split(b, separator)

  local shortest = math.min(#a_parts, #b_parts)

  -- Find the last index of the common divisors
  local common_divisor = 1
  for i = 1, shortest do
    local a_part = a_parts[i]
    local b_part = b_parts[i]

    if a_part ~= b_part then
      common_divisor = i
      break
    end
  end

  return fn.join(subtbl(a_parts, common_divisor), separator), fn.join(subtbl(b_parts, common_divisor), separator)
end

local buffer_names = {}
local buffer_ids = {}

local function get_buffername(bufnr)
  if tab_hide[api.nvim_buf_get_option(bufnr, "filetype")] then
    return
  end

  local filename = fn.fnamemodify(fn.bufname(bufnr), ":t")

  if filename == "" then
    return
  end

  if buffer_names[filename] ~= nil then
    local other = buffer_names[filename]

    local cur_bufname = fn.bufname(bufnr)
    local other_bufname = fn.bufname(other)

    if cur_bufname ~= other_bufname then
      local new_other, new_cur = get_unique_name(other_bufname, cur_bufname)

      buffer_names[new_other] = bufnr
      buffer_ids[other] = new_other

      filename = new_cur
    end
  end
  buffer_names[filename] = bufnr
  buffer_ids[bufnr] = filename
end

local function get_session()
  if vim.g.persisting then
    return " "
  elseif vim.g.persisting == false then
    return " "
  end
end

function M.update()
  local winid = api.nvim_get_current_win()
  local bufnr = api.nvim_win_get_buf(winid)
  local actual_curwin = tonumber(g.actual_curwin)

  local branch = vim.fn.FugitiveHead()
  branch = branch and ("%#Orange# " .. branch) or ""

  local is_current = winid == actual_curwin

  local ft, readonly, row, col, percent = get_infos(bufnr)

  local special = special_map[ft]
  local opts = { bufnr = bufnr, winid = winid, is_current = is_current, ft = ft }
  if special then
    if type(special) == "function" then
      return special(opts) or ""
    elseif type(special) == "table" then
      return special[is_current](opts) or ""
    end
  end

  if is_current then
    local mode = get_mode()
    local path = get_path(true)
    local git = get_git(true)
    local diag = lsp.statusline(bufnr, true)

    local sep = " "
    return table.concat {
      "%#Normal#",
      branch,
      sep,
      git,
      sep,
      path,
      sep,
      readonly and "%#Purple#" or "",
      "%#Normal#%=%#Normal#",
      diag,
      "%#Comment#",
      get_session(),
      sep,
      "%#Purple#",
      percent,
      sep,
      string.format("%s %2d:%-2d ", mode.hl, row, col),
    }
  else
    local path = get_path(false)

    return table.concat {
      " ",
      path,
      readonly and "" or "",
      "%=",
      percent,
      string.format("  %2d:%-2d ", row, col),
    }
  end
end

function M.update_tabline()
  local t = {}
  local tabpagenr = fn.tabpagenr()

  -- Generate buffer names

  buffer_names = {}
  buffer_ids = {}

  for bufnr = 1, fn.bufnr "$" do
    if fn.bufloaded(bufnr) == 1 then
      get_buffername(bufnr)
    end
  end

  for i = 1, fn.tabpagenr "$" do
    -- select the highlighting
    local highlight = "%#TabLine#"
    if i == tabpagenr then
      highlight = "%#Normal#"
    end

    local buflist = fn.tabpagebuflist(i)

    local windows = {}
    for _, bufnr in ipairs(buflist) do
      local name = buffer_ids[bufnr]
      if name then
        windows[#windows + 1] = " " .. name .. " "
      end
    end

    t[#t + 1] = highlight .. "  %" .. i .. "T" .. i .. table.concat(windows, "·")
  end

  -- after the last tab fill with TabLineFill and reset tab page nr
  t[#t + 1] = "%#TabLineFill#%T"

  return table.concat(t, " 🮇")
end

_G.config_sl_update = M.update

function M.setup()
  vim.g.qf_disable_statusline = 1
  vim.o.statusline = "%{%v:lua.config_sl_update()%}"
  vim.o.tabline = "%{%v:lua.require'config.statusline'.update_tabline()%}"

  -- cmd [[
  -- augroup Statusline
  -- autocmd!
  -- autocmd BufWinEnter,WinEnter,BufEnter,WinLeave,BufLeave * lua vim.wo.statusline='%{%v:lua.config_sl_update()%}'
  -- augroup END
  -- ]]
end

return M
