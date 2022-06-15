
local M={}
local funcs = require("penvim.funcs.filedir")


function M.load_rooter()
	local current_file_dir = vim.fn.expand('%:p:h')
	if not funcs.file_exists(current_file_dir) then
		return
	end
	local current_file_dir_init = current_file_dir
	local splited_dir = funcs.dirsplit(current_file_dir)
	local patterns = vim.g.penvim_rooter_patterns
	local possible_dirs = {current_file_dir.."/"}
	local os_user = funcs.osuser()
	local os_home_dir = "/home/" .. os_user .. "/"
	local final_dir = os_home_dir
	local pattern_exist=false

	for _, dir in ipairs(splited_dir) do
		if dir=="home" or dir== os_user then
			goto continue
		end
		current_file_dir = current_file_dir .. "/../"
		current_file_dir = funcs.normalize_dir(current_file_dir)
		possible_dirs[#possible_dirs+1] = current_file_dir
		::continue::
	end

	for _, dir in ipairs(possible_dirs) do
		for _, pattern in ipairs(patterns) do
			pattern = dir .. pattern
			pattern_exist = funcs.file_exists(pattern)
			if pattern_exist then
				final_dir = dir
				goto bottom
			end
		end
	end
	::bottom::
	-- change directory to directory of current file if no project detects
	if final_dir == os_home_dir then
		final_dir = current_file_dir_init
	end
	vim.api.nvim_set_current_dir(final_dir)
end

return M

