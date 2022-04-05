
local M={}

local default_indent_length = vim.g.penvim_indentor_length
local detected_indent_length = default_indent_length


-- local filename_without_location = vim.fn.expand("%:t")
-- current buffer
local buffer_num = vim.api.nvim_get_current_buf()
-- current filename with full location
local filename = vim.api.nvim_buf_get_name(buffer_num)


-- return a table with space/tab with indent size
	-- or return 'defaut'
local function indent_value()

	local total_spaces = 0
	local total_tabs = 0
	local command_loc = "wc -l " .. filename .. " | awk '{print $1}'"
	local max_loc = tonumber(vim.fn.systemlist(command_loc)[1])
	local min_loc = 2

	if max_loc == nil or max_loc < min_loc then
		return 'default'
	end

end

indent_value()

function M.load_indentor()

	vim.opt.softtabstop = detected_indent_length
	vim.opt.shiftwidth = detected_indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
	vim.opt.tabstop = detected_indent_length     -- spaces per tab
	vim.opt.smarttab = true             -- <tab>/<BS> indent/dedent in leading whitespace
	vim.opt.autoindent = true           -- maintain indent of current line
	-- -- vim.opt.expandtab = false -- don't expand tabs into spaces
end

return M

