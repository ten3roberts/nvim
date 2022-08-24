local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "import",
    fmt([[import {} from '{}']], {
      f(function(args)
        local name = string.match(args[1][1], "[^/]*."):gsub(".", "")
        return name
      end, { 1 }),
      i(1),
    })
  ),
}
