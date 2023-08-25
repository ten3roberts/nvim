if os.getenv "NVIM_PROFILE" == "1" then
  vim.defer_fn(function()
    vim.notify("Profiling enabled", vim.log.levels.INFO)
  end, 1000)
  require("plenary.profile").start("profile.log", { flame = true })
  vim.api.nvim_create_autocmd("VimLeavePre", { callback = require("plenary.profile").stop })
end
