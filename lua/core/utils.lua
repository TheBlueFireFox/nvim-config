local is_wsl = (function()
    local output = vim.fn.systemlist "uname -r"
    return not not string.find(output[1] or "", "WSL")
end)()

local is_mac = vim.fn.has("macunix") == 1

local is_linux = not is_wsl and not is_mac

local is_diff_mode = (function()
    for _, arg in pairs(vim.v.argv) do
        if arg == '-d' then
            return true
        end
    end
    return false
end)()

return {
    is_wsl = is_wsl,
    is_mac = is_mac,
    is_linux = is_linux,
    is_diff_mode = is_diff_mode
}
