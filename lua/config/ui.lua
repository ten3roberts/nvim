local Layout = require "nui.layout"
local Text = require "nui.text"
local Line = require "nui.line"
local Popup = require "nui.popup"

local top_popup = Popup { border = "single" }
local bottom_popup = Popup { border = "double" }

local layout = Layout(
  {
    position = "50%",
    size = {
      width = 80,
      height = 40,
    },
  },
  Layout.Box({
    Layout.Box(top_popup, { size = "40%" }),
    Layout.Box(bottom_popup, { size = "60%" }),
  }, { dir = "col" })
)

local lines = Line()
lines:append("Hello, World!", "String")
lines:append(" > Hello", "Error")

layout:mount()

lines:render(top_popup.bufnr, -1, 1)
