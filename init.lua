-- set up plugings etc.
local packer = require("plugins").run()

-- based on https://github.com/wbthomason/packer.nvim#bootstrapping
if packer.bootstrap then
	vim.cmd([[
        autocmd User PackerComplete lua require("config")
    ]])
else
	require("config")
end
