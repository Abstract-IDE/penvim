
--[[
     create .__nvim__.lua file in your project root directory and
     define options/configs in that file.

     1. check if ~/.__nvim__.lua file exist
         if exists: load ~/.__nvim__.lua
     2. check if .__nvim__.lua file exist in the project
         if exist: load .__nvim__.lua config
    NOTE:
        .__nvim__.lua is default config file name and it can be change
         with 'vim.g.penvim_project_config'
]]


local M= {}
local funcs = require("penvim.funcs.filedir")

local curr_file_dir = vim.fn.expand('%:p:h') .. "/"
-- your user name ( EX: /home/your_user_name )
local user_home = "/home/" .. funcs.osuser()
-- project_env config name
local config_name = vim.g.penvim_project_config


-- if .__nvim__.lua file exist, return it with full location else return false
local function conf_file(cfdir)
	local conff
	-- don't look for .__nvim__.lua if directory is not a chld of /home/user/
	local os_user = funcs.osuser()
	if funcs.dirsplit(cfdir)[2] ~= os_user then return false end

	for _, _ in ipairs(funcs.dirsplit(cfdir)) do
		conff = cfdir .. config_name
		if funcs.file_exists(conff) then
			return cfdir .. config_name
		else
			if cfdir == "/" or cfdir == "/home/" .. os_user .. "/" then
				return false
			else
				cfdir = cfdir .. "../"
				cfdir = funcs.normalize_dir(cfdir)
			end
		end
	end
end


function M.load_project_config()
	if funcs.file_exists(user_home .. "/" .. config_name) then
		dofile(user_home .. "/" .. config_name)
	end

	if curr_file_dir ~= "/" and curr_file_dir ~= user_home.."/" then
		local conff = conf_file(curr_file_dir)
		if conff ~= false then
			dofile(conff)
		end
	end
end


return M

