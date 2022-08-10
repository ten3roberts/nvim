local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node
local types = require "luasnip.util.types"
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local rep = require("luasnip.extras").rep
local dl = require("luasnip.extras").dynamic_lambda
local l = require("luasnip.extras").lambda

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

local cache = {}
local cache_dir = nil

local function find_pattern(pattern, glob)
  if cache_dir ~= vim.fn.getcwd() then
    cache = {}
  end

  local match = cache[pattern]
  if match then
    return match
  end

  local result = vim.fn.systemlist { "rg", pattern, "-g", glob or "*" }
  cache[pattern] = result
  return result
end

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
  s("class", fmt("---@class ", {})),
  s("field", fmt("---@field ", {})),
  s("param", fmt("---@param ", {})),
})

ls.add_snippets("markdown", {
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
})

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
})

local ts_utils = require "nvim-treesitter.ts_utils"
local ts_locals = require "nvim-treesitter.locals"
---@return string|nil
local function get_impl()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return ""
  end

  local node = current_node
  while node do
    local type = node:type()
    if type == "impl_item" then
      local n = node:field("type")[1]
      return vim.treesitter.query.get_node_text(n, 0)
    end
    node = node:parent()
  end
end

_G.get_impl = get_impl

local function rust_log_crate()
  local log_count = #find_pattern("\\blog\\b", "*.toml")
  local tracing_count = #find_pattern("\\btracing\\b", "*.toml")

  if log_count > tracing_count then
    return "log"
  else
    return "tracing"
  end
end

ls.add_snippets("rust", {
  s(
    "if-some",
    fmt(
      [[
  if let Some({}) = {} {{
      {}
  }}
  ]],
      { i(1, "val"), dl(2, l._1, { 1 }), i(3) }
    )
  ),
  s(
    "modtest",
    fmt(
      [[
  #[cfg(test)]
  mod test {{
      {}

      {}
  }}
  ]],
      { c(1, { t "use super::*;", t "use crate::*;", t "" }), i(0) }
    )
  ),

  s("pubuse", fmt("pub use {}::*;", { i(1) })),

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
      pub fn {}({}){} {{
            {}
        }}
      ]],
      {
        i(1, "name"),
        i(2),
        c(3, { t "", sn(1, { t " -> ", i(1, "_") }), sn(1, { t " -> Result<", i(1, "_"), t ">" }) }),
        i(4, "todo!()"),
      }
    )
  ),

  s(
    "struct",
    fmt(
      [[
      #[derive({})]
      struct {} {{
          {}
      }}
    ]],
      {
        c(1, { t "Debug, Clone", t "Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash" }),
        i(2, "Name"),
        i(3, ""),
      }
    )
  ),

  s(
    "enum",
    fmt(
      [[
      #[derive({})]
      enum {} {{
          {}
      }}
    ]],
      {
        c(1, { t "Debug, Clone", t "Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash" }),
        i(2, "Name"),
        i(3, ""),
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
  s("Default", t "Default::default()"),

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
        c(1, { t "Debug, Clone", t "Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash", t "" }),
      }
    )
  ),

  s(
    "with",
    fmt(
      [[
        {} 
        pub fn with_{}(&mut self, {}: {}) -> &mut Self {{
          self.{} = {};
          self
        }}
      ]],
      {
        d(4, function(args)
          local typename = get_impl() or "Type"
          local value = args[1][1]
          return sn(4, { i(1, string.format("/// Set the %s's %s", typename, value)) })
        end, { 1 }),
        i(1, "value"),
        rep(1),
        i(2, "Type"),
        rep(1),
        dl(3, l._1, { 1 }), -- RHS
      }
    )
  ),

  s("de_serde", { t "#[derive(serde::Serialize, serde::Deserialize)]" }),
  s("attr_serde", { t '#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]' }),

  s("trace", fmt([[{}::trace!("{}");]], { f(rust_log_crate), i(1) })),
  s("debug", fmt([[{}::debug!("{}");]], { f(rust_log_crate), i(1) })),
  s("info", fmt([[{}::info!("{}");]], { f(rust_log_crate), i(1) })),
  s("warn", fmt([[{}::warn!("{}");]], { f(rust_log_crate), i(1) })),
  s("error", fmt([[{}::error!("{}");]], { f(rust_log_crate), i(1) })),
  s("instrument", t("#[tracing::instrument]", {})),
  s("instrument_trace", t('#[tracing::instrument(level = "trace")]', {})),
  s("instrument_debug", t('#[tracing::instrument(level = "debug")]', {})),
  s("instrument_info", t('#[tracing::instrument(level = "info")]', {})),
  s("instrument_warn", t('#[tracing::instrument(level = "warn")]', {})),
  s("instrument_error", t('#[tracing::instrument(level = "error")]', {})),
  s("doc_hidden", t("#[doc(hidden)]", {})),
  s(
    "ANCHOR",
    fmt(
      [[
    // ANCHOR: {}
    {}
    // ANCHOR_END: {}
    ]],
      { i(1), i(2), rep(1) }
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
  if ls.jumpable(1) then
    ls.jump(1)
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
