return {
  "nvim-pack/nvim-spectre",
  event = "VeryLazy",
  config = function()
    local keybinds = require("config.keybind_definitions")
    vim.keymap.set("n", keybinds.getKeybind("spectre-toggle"), '<cmd>lua require("spectre").toggle()<CR>', {
      desc = keybinds.getDesc("spectre-toggle"),
    })
    vim.keymap.set("n", keybinds.getKeybind("spectre-word-search"), '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = keybinds.getDesc("spectre-word-search"),
    })
    vim.keymap.set("v", keybinds.getKeybind("spectre-visual-search"), '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = keybinds.getDesc("spectre-visual-search"),
    })
    vim.keymap.set("n", keybinds.getKeybind("spectre-file-search"), '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = keybinds.getDesc("spectre-file-search"),
    })
  end,
}
