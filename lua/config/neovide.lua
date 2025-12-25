local o = vim.o
local opt = vim.opt
local g = vim.g

if vim.g.neovide then
  -- Neovide doesn't inherit shell PATH when launched from desktop
  vim.env.PATH = vim.env.HOME .. "/.opencode/bin:" .. vim.env.PATH

  -- Show projects picker when Neovide starts with no arguments
  if vim.fn.argc() == 0 then
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        vim.schedule(function()
          require("snacks").picker.projects()
        end)
      end,
    })
  end
  vim.o.guifont = "JetBrainsMono Nerd Font:h11"
  vim.opt.linespace = 0

  -- Disable Snacks animations (Neovide handles its own)
  vim.g.snacks_animate = false
  -- g.neovide_cursor_animation_length = 0.01
  g.neovide_cursor_antialiasing = true

  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 5.0

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  -- vim.g.neovide_light_angle_degrees = 45
  -- vim.g.neovide_light_radius = 5

  vim.g.neovide_position_animation_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.2

  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.0

  vim.g.neovide_cursor_antialiasing = true

  vim.g.neovide_cursor_animate_command_line = true

  vim.g.neovide_scroll_animation_far_lines = 1
  vim.g.neovide_hide_mouse_when_typing = true
end
