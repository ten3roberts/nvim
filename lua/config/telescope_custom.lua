local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local log = require "telescope.log"
local transform_mod = require("telescope.actions.mt").transform_mod
local Path = require "plenary.path"

local function edit(command, bufnr)
  vim.cmd(string.format("%s %d", command, bufnr))
end

local function select_default(prompt_bufnr, command)
  local entry = action_state.get_selected_entry()

  if not entry then
    print "[telescope] Nothing currently selected"
    return
  end

  local filename, row, col

  if entry.path or entry.filename then
    filename = entry.path or entry.filename

    -- TODO: Check for off-by-one
    row = entry.row or entry.lnum
    col = entry.col
  elseif not entry.bufnr then
    -- TODO: Might want to remove this and force people
    -- to put stuff into `filename`
    local value = entry.value
    if not value then
      print "Could not do anything with blank line..."
      return
    end

    if type(value) == "table" then
      value = entry.display
    end

    local sections = vim.split(value, ":")

    filename = sections[1]
    row = tonumber(sections[2])
    col = tonumber(sections[3])
  end

  local entry_bufnr = entry.bufnr

  require("telescope.actions").close(prompt_bufnr)

  if entry_bufnr then
    edit(entry_bufnr)
  else

    -- check if we didn't pick a different buffer
    -- prevents restarting lsp server
    if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
      filename = Path:new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
      pcall(vim.cmd, string.format("%s %s", "drop", filename))
    end
  end

  if row and col then
    local ok, err_msg = pcall(a.nvim_win_set_cursor, 0, { row, col })
    if not ok then
      log.debug("Failed to move to cursor:", err_msg, row, col)
    end
  end
end

local actions = transform_mod {
  -- select_default = select_default
  file_vbuffer = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, "vert sbuffer")
  end,
  file_sbuffer = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, "sbuffer")
  end,
  file_drop = function(prompt_bufnr)
    return action_set.edit(prompt_bufnr, "tabedit")
  end
}

return actions
