local action_set = require "telescope.actions.set"
local transform_mod = require("telescope.actions.mt").transform_mod

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
