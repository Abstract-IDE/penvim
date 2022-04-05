
local M={}
local filetype = vim.bo.filetype


function M.load_langs()
	if filetype == "lua" then
		require('penvim/langs/languages/lua')     -- LUA
	else
		if filetype == "javascriptreact" or filetype == "typescriptreact" then
			require('penvim/langs/languages/lua/frameworks/react')    -- REACT
		end
	end
end


return M

