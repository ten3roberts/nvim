local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "fun",
    fmt(
      [[
      function{}({})
        {}
      end{}
    ]],
      { i(1), i(2), i(3), i(0) }
    )
  ),

  s(
    "lfun",
    fmt(
      [[
    local function{}({})
      {}
    end{}
  ]],
      { i(1), i(2), i(3), i(0) }
    )
  ),

  s("append", fmt([[ table.insert({}, {}) ]], { i(1, "t"), i(2) })),

  s(
    "req",
    fmt([[require("{}")]], {
      i(1),
    })
  ),

  s(
    "lreq",
    fmt([[{}require("{}")]], {
      f(function(args)
        local name = string.match(args[1][1], "[^./]*$"):gsub("-", "_")
        return string.format("local %s = ", name or "")
      end, { 1 }),
      i(1),
    })
  ),
  s("class", fmt("---@class ", {})),
  s("field", fmt("---@field ", {})),
  s("param", fmt("---@param ", {})),
}
