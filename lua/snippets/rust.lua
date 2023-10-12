local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local rep = require("luasnip.extras").rep
local dl = require("luasnip.extras").dynamic_lambda
local l = require("luasnip.extras").lambda

local cache = {}
local cache_dir = nil

local ts_utils = require "nvim-treesitter.ts_utils"
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
      return vim.treesitter.get_node_text(n, 0)
    end
    node = node:parent()
  end
end

local function find_pattern(pattern, extra)
  if cache_dir ~= vim.fn.getcwd() then
    cache = {}
  end

  local match = cache[pattern]
  if match then
    return match
  end

  local args = { "rg", pattern }
  for _, v in ipairs(extra) do
    args[#args + 1] = v
  end

  local result = vim.fn.systemlist(args)
  cache[pattern] = result
  return result
end

local function rust_log_crate()
  local parent = vim.fn.expand "%:p:h"
  local log_count = #find_pattern("\\blog\\b", { parent })
  local tracing_count = #find_pattern("\\btracing\\b", { parent })

  if tracing_count * 5 >= log_count then
    return "tracing"
  else
    return "log"
  end
end

local function pattern_binding(name, prefix)
  return s(
    name,
    fmt(
      string.format(
        [[
  %s({}) = {} {{
      {}
  }}
  ]],
        prefix
      ),
      { i(1, "val"), dl(2, l._1, { 1 }), i(3) }
    )
  )
end

local function rust_ret(idx, placeholder)
  return sn(idx, fmt("-> {}", { placeholder }))
end

local function fn_args(idx)
  return c(idx, {
    i(1),
    fmt("&self{}", i(1)),
    fmt("&mut self{}", i(1)),
    fmt("self{}", i(1)),
  })
end
local function fn_like(trig, vis, name, args, ret, body)
  return s(
    trig,
    fmt(
      [[
      {}fn {}({}) {} {{
          {}
      }}
      ]],
      {
        vis,
        name,
        args,
        ret,
        body,
      }
    )
  )
end

local function tracing_span(level)
  return s(level .. "_span", fmt(string.format("let _span = tracing::%s_span!({}).entered();", level), { i(1) }))
end

local function tracing_instrument(level)
  return s("instrument_" .. level, fmt(string.format('#[tracing::instrument(level = "%s")]', level), {}))
end

local function with_builder(recv, ret)
  return fmt(
    string.format(
      [[
        {}
        pub fn with_{}(%s, {}: {}) -> %s {{
          self.{} = {};
          self
        }}
      ]],
      recv,
      ret
    ),
    {
      d(4, function(args)
        local value = args[1][1]
        return sn(4, { i(1, string.format("/// Set the %s", value)) })
      end, { 1 }),
      i(1, "value"),
      rep(1),
      i(2, "Type"),
      rep(1),
      dl(3, l._1, { 1 }), -- RHS
    }
  )
end

return {
  pattern_binding("if-some", "if let Some"),
  pattern_binding("if-ok", "if let Ok"),
  pattern_binding("while-some", "while let Some"),
  pattern_binding("while-ok", "while let Ok"),
  s(
    "modtests",
    fmt(
      [[
  #[cfg(test)]
  mod tests {{
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
  s("cowstr", fmt("Cow<'{}, {}>", { i(1, "static"), i(2, "str") })),
  s("icowstr", fmt("Into<Cow<'{}, {}>>", { i(1, "static"), i(2, "str") })),
  s("map_into", c(1, { t "map(Into::into)", t "map(|v| v.into())" })),
  s("map_err", c(1, { t "map_err(Into::into)", t "map_err(|v| v.into())" })),

  s(
    "struct-pod",
    fmt(
      [[
    #[repr(C)]
    #[derive(bytemuck::Pod, bytemuck::Zeroable, Clone, Copy, Debug)]
    pub struct {} {{
      {}
    }}
  ]],
      { i(1, "name"), i(2) }
    )
  ),

  fn_like("fn", t "", i(1, "name"), fn_args(2), rust_ret(3, i(1, "_")), i(4, "todo!()")),
  fn_like("pf", t "pub ", i(1, "name"), fn_args(2), rust_ret(3, i(1, "_")), i(4, "todo!()")),
  fn_like(
    "fnew",
    t "pub ",
    t "new",
    fn_args(1),
    rust_ret(nil, t "Self"),
    isn(
      2,
      fmt(
        [[
Self {{
  {}
}}
  ]],
        { i(1) }
      ),
      "$PARENT_INDENT    "
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

  s("with", c(1, { with_builder("&mut self", "&mut Self"), with_builder("mut self", "Self") })),

  s("de_serde", { t "#[derive(serde::Serialize, serde::Deserialize)]" }),
  s("attr_serde", { t '#[cfg_attr(feature = "serde", derive(serde::Serialize, serde::Deserialize))]' }),

  s("trace", fmt([[{}::trace!({}"{}");]], { f(rust_log_crate), i(2), i(1) })),
  s("debug", fmt([[{}::debug!({}"{}");]], { f(rust_log_crate), i(2), i(1) })),
  s("info", fmt([[{}::info!({}"{}");]], { f(rust_log_crate), i(2), i(1) })),
  s("warn", fmt([[{}::warn!({}"{}");]], { f(rust_log_crate), i(2), i(1) })),
  s("error", fmt([[{}::error!({}"{}");]], { f(rust_log_crate), i(2), i(1) })),
  s("instrument", t('#[tracing::instrument(level = "info")]', {})),

  tracing_instrument "trace",
  tracing_instrument "debug",
  tracing_instrument "info",
  tracing_instrument "warn",
  tracing_instrument "error",

  tracing_span "info",
  tracing_span "debug",

  s("doc_hidden", t("#[doc(hidden)]", {})),

  s("cfg_unknown", fmt([[ #[cfg(target_os = "unknown")] ]], {})),
  s("cfg_not_unknown", fmt([[ #[cfg(not(target_os = "unknown"))] ]], {})),

  s("cfg_arch", fmt([[ #[cfg(target_arch = "{}")] ]], { i(1, "") })),
  s("cfg_not_arch", fmt([[ #[cfg(not(target_arch = "{}"))] ]], { i(1, "") })),

  s("cfg_wasm32", fmt([[ #[cfg(target_arch = "wasm32")] ]], {})),
  s("cfg_not_wasm32", fmt([[ #[cfg(not(target_arch = "wasm32"))] ]], {})),

  s("cfgf", fmt([[ #[cfg(feature = "{}")] ]], { i(1, "") })),
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

  s(
    "split_for_impl",
    fmt(
      [[let (impl_generics, ty_generics, where_clause) = {}.split_for_impl();
]],
      { i(1, "generics") }
    )
  ),
}
