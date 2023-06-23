local filetypes = { "aerial", "dapui.*", "notify", "NvimTree" }
local buftypes = { "terminal", "quickfix", "prompt", "help" }

local cache_ft = {}
local cache_bt = {}

local function matched(cache, list, val)
  local c = cache[val]
  if c ~= nil then
    return c
  end

  for _, pat in ipairs(list) do
    if string.match(val, pat) ~= nil then
      cache[val] = true
      return true
    end
  end

  cache[val] = false
  return false
end

local function get_pin(bufnr)
  -- You can return "bufnr", "buftype", "filetype", or a custom function to set how the window will be pinned
  -- The function below encompasses the default logic. Inspect the source to see what it does.
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype

  if matched(cache_ft, filetypes, filetype) then
    return "filetype"
  end
  if matched(cache_bt, buftypes, buftype) then
    return "buftype"
  end
end

return {
  "stevearc/stickybuf.nvim",
  config = function()
    require("stickybuf").setup {
      get_auto_pin = function(bufnr)
        local v = get_pin(bufnr)
        if v then
          vim.notify(
            string.format(
              "Pinning %d %q %q %q: %s",
              bufnr,
              vim.bo[bufnr].buftype,
              vim.bo[bufnr].filetype,
              vim.api.nvim_buf_get_name(bufnr),
              v
            )
          )
        end
        return v
      end,
    }
  end,
}
