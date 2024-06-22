local o = vim.o
local opt = vim.opt
local g = vim.g

if vim.g.neovide then
  vim.defer_fn(function()
    vim.notify(string.format "Neovide version")
  end, 1000)
  -- o.guifont = "Fira Code:h14:#h-slight"
  -- g.neovide_cursor_animation_length = 0.01
  -- g.neovide_cursor_antialiasing = true

  vim.gneovide_floating_blur_amount_x = 2.0
  vim.gneovide_floating_blur_amount_y = 2.0

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.g.neovide_position_animation_length = 0.15
  vim.g.neovide_scroll_animation_length = 0.3

  vim.g.neovide_cursor_animation_length = 0.01
  vim.g.neovide_cursor_trail_size = 0.2

  vim.g.neovide_cursor_antialiasing = true

  vim.g.neovide_cursor_animate_command_line = true

  -- g.neovide_floating_blur_amount_x = 2.0
  -- g.neovide_floating_blur_amount_y = 2.0
  -- g.neovide_hide_mouse_when_typing = true
  -- g.neovide_scroll_animation_length = 0.5
  -- g.neovide_fullscreen = true
end
