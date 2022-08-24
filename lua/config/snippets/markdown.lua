local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
  s("doc-link", fmt("[{}](https://docs.rs/{}/latest/{}/{})", { i(1), i(2), rep(2), i(3) })),
  s(
    "code-include",
    fmt(
      [[
    ```rust
    {{{{ #include {} }}}}
    ```
    ]],
      { i(1) }
    )
  ),
}
