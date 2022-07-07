
local M = {}


local function whitespace_type (line)

	local whitespace = line:match("^%s*"):len()
	if whitespace == 0 then
		return {
			type = "blank",
		}
	end

	local tabspace = line:match("^%\t*"):len()
	if tabspace > 0 then
		return {
			type = "tab",
			no_of_tab = tabspace
		}
	end

	return {
		type = "space",
		no_of_space = whitespace
	}
end


local function init_load_indentor()

	local buffer_num = vim.api.nvim_get_current_buf() -- current buffer number
	local loc = vim.api.nvim_buf_line_count(buffer_num)
	local current_line_num = 1
	local current_line_content, whitespace, whitespace_t
	local stack_tab = 0
	local stack_space = 0
	local space_list = {}

	if loc == 1 then
		current_line_num = 0
	end

	for line_num = current_line_num, loc do
		current_line_content = vim.fn.getline(line_num)
		whitespace = whitespace_type(current_line_content)
		whitespace_t = whitespace['type']

		if whitespace_t ~= 'blank' then
			if whitespace_t == "tab" then
				stack_tab = stack_tab + 1
			else
				stack_space = stack_space + 1
				space_list[#space_list+1] = whitespace.no_of_space
			end
		end
		if stack_space >= 5 or stack_tab >= 5 then
			break
		end
	end

	local indent_length = vim.g.penvim_indentor_length
	local tab_set = false
	local space_set = false

	-- set tab
	if stack_tab > stack_space then
		vim.opt.softtabstop = indent_length
		vim.opt.shiftwidth = indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
		vim.opt.tabstop = indent_length     -- spaces per tab
		vim.opt.smarttab = true             -- <tab>/<BS> indent/dedent in leading whitespace
		vim.opt.autoindent = true           -- maintain indent of current line
		tab_set = true
	end

	-- set space
	if stack_space > stack_tab then
		-- TODO
		local space_length = math.max(unpack(space_list))
		space_set = true
	end

	if not tab_set or not space_set then
		-- use default
		local indent_type = vim.g.penvim_indentor_type   -- default auto,  auto|space|tab

		if indent_type == "tab" then
			vim.opt.softtabstop = indent_length
			vim.opt.shiftwidth = indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
			vim.opt.tabstop = indent_length     -- spaces per tab
			vim.opt.smarttab = true             -- <tab>/<BS> indent/dedent in leading whitespace
			vim.opt.autoindent = true           -- maintain indent of current line
		end
		if indent_type == "space" then
			-- TODO
			return -- to ignore error
		end
	end

end


function M.load_indentor()
	-- TODO...
	init_load_indentor()
end


return M

