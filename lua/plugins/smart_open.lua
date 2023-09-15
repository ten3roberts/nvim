return {
  {
    "danielfalk/smart-open.nvim",
    config = function()
      vim.notify "Loading smart-open.nvim"
      require("telescope").load_extension "smart_open"
      vim.notify "Registered smart-open.nvim"
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
}
