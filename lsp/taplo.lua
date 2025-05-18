return {
  settings = {
    formatter = {
      arrayAutoExpand = true,
    },
  },
  keymap = function()
    return { hover = require("crates").show_crate_popup }
  end,
}
