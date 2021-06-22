local fn = vim.fn
local o = vim.o
local v = vim.v

function _G.clean_fold()
    local line = fn.getline(v.foldstart)

    -- Convert all tabs to spaces since foldtext ignores tabs
    local ts = string.rep(' ', o.tabstop)
    line = string.gsub(line, '\t', ts)

    -- Pad with spaces to the end of line
    -- return line .. string.rep(' ', fn.winwidth(0) - #line - #postline) .. postline
    return string.format('%s …%s', line, string.rep(' ', fn.winwidth(0) - #line))
end
