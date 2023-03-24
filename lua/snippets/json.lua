local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "recipe-build",
    fmt(
      [[
  "{}": {{
    "cmd": {}
  }}
  ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    "recipe-term",
    fmt(
      [[
  "{}": {{
    "cmd": {},
    "kind": "term"
  }}
  ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    "recipe-debug",
    fmt(
      [[
  "{}": {{
    "cmd": {},
    "kind": "dap",
    "depends_on": [ {} ]
  }}
  ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
}
