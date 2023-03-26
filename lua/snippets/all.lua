local ls = require "luasnip"
local s = ls.snippet
local f = ls.function_node
local c = ls.choice_node

return {
  s("date", {
    c(1, {
      f(function()
        return os.date "%Y-%d-%d"
      end),
      f(function()
        return os.date "%Y-%m-%dT%H:%M:%s"
      end),
      f(function()
        return os.date "%b %d %Y"
      end),
    }),
  }),
}
