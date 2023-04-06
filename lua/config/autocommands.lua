local a = vim.api
local fn = vim.fn

local group = a.nvim_create_augroup("CONFIG", { clear = true })
local function au(event, opts)
    opts.group = group
    a.nvim_create_autocmd(event, opts)
end

au({ "FileType", "BufWinEnter" }, {
    callback = function(o)
        local buftype  = a.nvim_buf_get_option(o.buf, "buftype");
        local filetype = a.nvim_buf_get_option(o.buf, "filetype");
        local bufname  = a.nvim_buf_get_name(o.buf)

        local info     = { filetype = filetype, buftype = buftype, bufname = bufname }
        if filetype ~= "" and buftype == "" then
            -- print("Enabling spell " .. vim.inspect(info))
            vim.wo.spell = true
        else
            -- print("Disabling spell " .. vim.inspect(info))
            vim.wo.spell = false
        end
    end,
})

au({ "ColorScheme" }, { callback = require("config.palette").setup })
au({ "BufRead", "BufNewFile" }, {
    callback = function()
        vim.o.ft = "json"
    end,
    pattern = ".gltf",
})

au(
    { "BufWritePre" }, {
        callback = function()
            if vim.o.buftype == "" then
                fn.mkdir(fn.expand "<afile>:p:h", "p")
            end
        end,
    })


au({ "TermEnter" }, {
    callback = function()
        vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { buffer = true })
    end,
})

au({ "BufReadPost" }, {
    callback = function()
        local l = fn.line [['"]]
        if l > 1 and l < fn.line "$" then
            vim.cmd [[ normal! g`" ]]
        end
    end,
})
