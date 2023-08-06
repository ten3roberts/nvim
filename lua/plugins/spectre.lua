return {
  "nvim-pack/nvim-spectre",
  cmd = { "Spectre" },
  keys = {
    {
      "<leader>S",
      '<cmd>lua require("spectre").toggle()<CR>',
      { desc = '<cmd>lua require("spectre").toggle()<CR>', mode = "n" },
    },
    {
      "<leader>sw",
      '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
      { desc = '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', mode = "n" },
    },
    {
      "<leader>sw",
      '<esc><cmd>lua require("spectre").open_visual()<CR>',
      { desc = '<esc><cmd>lua require("spectre").open_visual()<CR>', mode = "v" },
    },
    {
      "<leader>sp",
      '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
      { desc = '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', mode = "n" },
    },
  },
  opts = {},
}
