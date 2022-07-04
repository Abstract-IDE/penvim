
--[[
     create .__nvim__.lua file in your project root directory and
     define options/configs in that file.

     1. check if ~/.__nvim__.lua file exist
         if exists: load ~/.__nvim__.lua
     2. check if .__nvim__.lua file exist in the project
         if exist: load .__nvim__.lua config
    NOTE:
        .__nvim__.lua is default config file name and it can be change
         with 'vim.g.penvim_project_config' (eg: vim.g.penvim_project_config='config.lua')
]]


local M= {}
local filedir = require("penvim.funcs.filedir")
local str = require("penvim.funcs.string")
local os_user = filedir.osuser()
local config_name = vim.g.penvim_project_config -- project_env config name
local home_con_file = "/home/"..os_user.."/"..config_name
-- local buff_num = vim.api.nvim_get_current_buf()
local filetype = vim.bo.filetype


local function conf_file()
	--[[ if .__nvim__.lua file exist, return it with full location else return false ]]

	local conff
	local curr_file_dir = vim.fn.expand('%:p:h') .. "/"

	-- if directory is not a child of /home/use_name/ then return home's config file (if exist)
	if filedir.dirsplit(curr_file_dir)[2] ~= os_user then
		if filedir.file_exists(home_con_file) then
			return home_con_file
		else
			return false
		end
	end

	for _, _ in ipairs(filedir.dirsplit(curr_file_dir)) do
		conff = curr_file_dir .. config_name
		if filedir.file_exists(conff) then
			return curr_file_dir .. config_name
		else
			curr_file_dir = filedir.normalize_dir(curr_file_dir.."../")
		end
	end

	return false
end


local function apply_config(config)
	for option, value in pairs(config) do
        vim.opt[option] = value
	end
end


local function load_config(config_file)

	local configs = dofile(config_file)

	-- exit if config file is empty
	if configs == nil then return end

	-- applying defined configs
	for lang, config in pairs(configs) do
		if lang == "all" then
			apply_config(config)

		elseif string.find(lang, "_") then
			local langs = str.split(lang, "-")
			for _, lan in pairs(langs) do
				if lan == filetype then
					apply_config(config)
				end
			end
		else
			if lang == filetype then
				apply_config(config)
			end
		end
	end
end


function M.load_project_config()
	local config_file = conf_file()

	-- only load config file if config file exist
	if config_file then
		if config_file == home_con_file then
			load_config(home_con_file)
		else
			if filedir.file_exists(home_con_file) then
				load_config(home_con_file)
			end
			load_config(config_file)
		end
	end
end


return M
