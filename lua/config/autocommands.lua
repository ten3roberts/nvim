local a = vim.api
local fn = vim.fn
local keybinds = require "config.keybind_definitions"

-- Tip display timing constants
local TIP_DISPLAY_DELAY_MS = 5000  -- Show tip 5 seconds after startup
local TIP_TIMEOUT_MS = 30000       -- Display tip for 30 seconds

local group = a.nvim_create_augroup("CONFIG", { clear = true })
local function au(event, opts)
  opts.group = group
  a.nvim_create_autocmd(event, opts)
end

local function setup_spell(o)
  local buftype = vim.bo[o.buf].buftype
  local filetype = vim.bo[o.buf].filetype

  local filetypes = {
    rust = true,
    lua = true,
    c = true,
    cpp = true,
    markdown = true,
    tex = true,
    latex = false,
    json = true,
    yaml = true,
    toml = true,
    typescript = true,
    javascript = true,
  }

  if buftype == "" and filetypes[filetype] then
    vim.wo.spell = true
  elseif vim.wo.spell == true and (filetype ~= "" or buftype == "terminal") then
    vim.wo.spell = false
  end
end

local function setup_palette_with_profiling()
  local start = vim.loop.hrtime()
  require("config.palette").setup()
  local elapsed = (vim.loop.hrtime() - start) / 1e6  -- Convert to ms
  if elapsed > 50 then
    vim.notify(string.format("Palette setup took %.2fms (slow)", elapsed), vim.log.levels.WARN)
  end
end

local autocmds = {
  { {"BufNew", "BufWinEnter", "FileType", "TermOpen"}, { callback = setup_spell } },
  { {"ColorScheme"}, { callback = setup_palette_with_profiling } },
  { {"BufRead", "BufNewFile"}, {
    callback = function() vim.o.ft = "json" end,
    pattern = ".gltf",
  } },
  { {"BufWritePre"}, {
    callback = function()
      if vim.o.buftype == "" then
        fn.mkdir(fn.expand "<afile>:p:h", "p")
      end
    end,
  } },
  { {"BufWritePre"}, {
    pattern = "*.rs",
    callback = function()
      local ok, err = pcall(function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end)
      if not ok then
        vim.notify("Organize imports failed: " .. tostring(err), vim.log.levels.WARN)
      end
    end,
  } },
  { {"TermEnter"}, {
    callback = function()
      vim.keymap.set("t", keybinds.getKeybind "terminal-exit", "<C-\\><C-n>", { buffer = true })
    end,
  } },
  { {"BufReadPost"}, {
    callback = function(args)
      local bufnr = args.buf

      -- Skip special buffer types and filetypes
      local buftype = vim.bo[bufnr].buftype
      local filetype = vim.bo[bufnr].filetype

      -- Exclude list based on LazyVim best practices + user preferences
      local exclude_filetypes = {
        "gitcommit",
        "gitrebase",
        "help",
      }

      local exclude_buftypes = {
        "quickfix",
        "nofile",
        "help",
        "terminal",
      }

      -- Check exclusions
      if buftype ~= "" then
        for _, bt in ipairs(exclude_buftypes) do
          if buftype == bt then
            return
          end
        end
      end

      if filetype ~= "" then
        for _, ft in ipairs(exclude_filetypes) do
          if filetype == ft then
            return
          end
        end
      end

      -- Prevent double-restoration using buffer-local flag
      if vim.b[bufnr].cursor_restored then
        return
      end

      -- Use modern API to get the mark position
      local mark_ok, mark = pcall(vim.api.nvim_buf_get_mark, bufnr, '"')
      if not mark_ok then
        return
      end

      local mark_line = mark[1]
      local last_line = vim.api.nvim_buf_line_count(bufnr)

      -- Validate mark is within buffer bounds
      if mark_line < 1 or mark_line > last_line then
        return
      end

      -- THE KEY FIX: Schedule cursor restoration to run AFTER LSP/picker
      vim.schedule(function()
        -- Double-check buffer is still valid
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        -- Get current window displaying this buffer
        local win = vim.fn.bufwinid(bufnr)
        if win == -1 then
          return
        end

        -- Re-check current cursor position
        -- If LSP/picker moved cursor, it won't be at line 1 anymore
        local current_pos = vim.api.nvim_win_get_cursor(win)
        local current_line = current_pos[1]

        -- Only restore if cursor is still at line 1 (meaning LSP/picker didn't move it)
        if current_line == 1 then
          -- Use modern API for cursor positioning (safer than vim.cmd)
          local ok = pcall(vim.api.nvim_win_set_cursor, win, mark)
          if ok then
            -- Center the cursor line in the window for better visibility (user preference)
            vim.cmd('normal! zz')

            -- Set flag to prevent double-restoration
            vim.b[bufnr].cursor_restored = true
          end
        end
      end)
    end,
  } },
  { {"VimEnter"}, {
    callback = function()
      vim.defer_fn(function()
        local tips = require "config.tips"
        local tip = tips[math.random(#tips)]
        require("snacks").notifier.notify(tip, { title = "Tip", timeout = TIP_TIMEOUT_MS })
      end, TIP_DISPLAY_DELAY_MS)
    end,
  } },
}

for _, cmd in ipairs(autocmds) do
  au(cmd[1], cmd[2])
end