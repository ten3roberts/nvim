-- vim.opt.textwidth = 120

-- local function buf_map(mode, lhs, rhs, ops)
--   vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("error", ops or {}, { buffer = true }))
-- end

-- buf_map("i", "<tab>", "<cmd>AutolistTab<cr>")
-- buf_map("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
-- -- buf_map("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
-- buf_map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
-- buf_map("n", "o", "o<cmd>AutolistNewBullet<cr>")
-- buf_map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
-- buf_map("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
-- buf_map("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

-- -- cycle list types with dot-repeat
-- buf_map("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
-- buf_map("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

-- -- if you don't want dot-repeat
-- -- buf_map("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
-- -- buf_map("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

-- -- functions to recalculate list on edit
-- buf_map("n", ">>", ">><cmd>AutolistRecalculate<cr>")
-- buf_map("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
-- buf_map("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
-- buf_map("v", "d", "d<cmd>AutolistRecalculate<cr>")
