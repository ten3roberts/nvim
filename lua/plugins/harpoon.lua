return {
  "ThePrimeagen/harpoon",
  enabled = false,
  keys = {
    {
      "<leader>hh",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
    },
    {
      "<leader>ha",
      function()
        require("harpoon.mark").add_file()
      end,
    },
  },
  config = function()
    require("harpoon").setup {
      menu = {
        width = 50,
        height = 8,
        borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    }

    require("telescope").load_extension "harpoon"
  end,
}
