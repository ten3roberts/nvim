require "config.dap"
local overseer = require "overseer"
overseer.setup {
  dap = true,
}

overseer.add_template_hook({}, function(task_defn, util)
  util.add_component(task_defn, { "on_output_quickfix", open = true })
end)

vim.api.nvim_create_user_command("WatchRun", function()
  overseer.run_template({ name = "test" }, function(task)
    if task then
      task:add_component { "restart_on_save", path = vim.fn.expand "%:p" }
      local main_win = vim.api.nvim_get_current_win()
      overseer.run_action(task, "open vsplit")
      vim.api.nvim_set_current_win(main_win)
    else
      vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
    end
  end)
end, {})
