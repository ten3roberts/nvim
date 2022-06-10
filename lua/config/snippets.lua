local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local types = require "luasnip.util.types"
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node

ls.config.set_config {
  history = false,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<<-", "String" } },
      },
    },
  },
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
}

ls.add_snippets("lua", {
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

  s(
    "req",
    fmt([[require "{}"]], {
      i(1),
    })
  ),

  s(
    "lreq",
    fmt([[{}require "{}"]], {
      f(function(args)
        local name = string.match(args[1][1], "[^./]*$"):gsub("-", "_")
        return string.format("local %s = ", name or "")
      end, { 1 }),
      i(1),
    })
  ),
})

local function rust_vis(pos)
  return c(pos, { t "pub ", t "", t "pub(crate) " })
end

ls.add_snippets("all", {
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
})

ls.add_snippets("json", {
  s(
    "recipe-basic",
    fmt(
      [[
  "{}": {{
    "cmd": {},
    {}
  }}
  ]],
      {
        i(1),
        i(2),
        c(3, {
          t '"interactive": true',
          sn(
            1,
            fmt(
              [[
    "action": [
      "qf",
      {{
        "name": "dap",
        "opts": {{
          "program": "{}"
        }}
      }}
    ]
  ]],
              { i(1) }
            )
          ),
        }),
      }
    )
  ),
})

ls.add_snippets("rust", {
  s(
    "modtest",
    fmt(
      [[
  mod test {{
    {}

    {}
  }}
  ]],
      { c(1, { t "", t "use super::*", t "use crate::*" }), i(0) }
    )
  ),

  s(
    "test",
    fmt(
      [[
    #[test]
    fn {}() {{
      {}
    }}{}
  ]],
      { i(1), i(2), i(0) }
    )
  ),

  s(
    "fn",
    fmt(
      [[
      {}fn {}({}){} {{
            {}
        }}
      ]],
      {
        rust_vis(1),
        i(2, "name"),
        i(3),
        c(4, { t "", sn(1, { t " -> ", i(1, "_") }), sn(1, { t " -> Result<", i(1, "_"), t ">" }) }),
        i(5, "todo!()"),
      }
    )
  ),

  s(
    "struct",
    fmt(
      [[
      #[derive({})]
      {}struct {} {{
          {}
      }}
    ]],
      {
        c(1, { t "Debug, Clone", t "Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash" }),
        rust_vis(2),
        i(3, "Name"),
        i(4, ""),
      }
    )
  ),

  s(
    "enum",
    fmt(
      [[
      #[derive({})]
      {}enum {} {{
          {}
      }}
    ]],
      {
        c(1, { t "Debug, Clone", t "Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash" }),
        rust_vis(2),
        i(3, "Name"),
        i(4, ""),
      }
    )
  ),

  s(
    "impl",
    fmt(
      [[
      impl<{}> {} {{
          {}
      }}
  ]],
      {
        i(1),
        i(2, "Type"),
        i(3),
      }
    )
  ),

  s(
    "impl-trait",
    fmt(
      [[
      impl {} for {} {{
          {}
      }}
  ]],
      {
        i(1, "Trait"),
        i(2, "Type"),
        i(3),
      }
    )
  ),

  s("default", t "Default::default()"),

  s(
    "buf",
    fmt(
      [[
      let mut buf = {}::new();
  ]],
      { c(1, { t "Vec", t "String" }) }
    )
  ),

  s(
    "derive",
    fmt(
      [[
      #[derive({})]
  ]],
      {
        c(1, { t "", t "Debug, Clone", t "Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash" }),
      }
    )
  ),
})

ls.add_snippets("javascript", {
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
})

ls.filetype_extend("svelte", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

require("luasnip.loaders.from_vscode").lazy_load()
