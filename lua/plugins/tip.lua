-- Lazy.nvim
return {
  "TobinPalmer/Tip.nvim",
  event = "VimEnter",
  enabled = false,
  init = function()
    -- Default config
    --- @type Tip.config
    require("tip").setup {
      title = "Tip!",
      url = "https://vtip.43z.one",
    }
  end,
}
