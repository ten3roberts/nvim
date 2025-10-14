return {
  "echasnovski/mini.nvim",
  config = function()
    local hipatterns = require("mini.hipatterns")
    hipatterns.setup {
      highlighters = {
        -- Highlight TODO, FIXME, etc.
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        -- Highlight URLs
        url = hipatterns.gen_highlighter.url(),
        -- Highlight hex colors
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }
  end,
}