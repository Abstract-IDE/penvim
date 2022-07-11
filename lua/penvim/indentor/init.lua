
--[[
useful links:
	src: https://en.wikipedia.org/wiki/Comparison_of_programming_languages_(syntax)
]]

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


local function block_comment(line)
	-- function to check if current line is the start of block comment

	local c_style = line:match("^/%*") -- /*
	local html_style = line:match("^<!%-%-") -- <!--
	local python_style = line:match("^\"%\"%\"") or line:match("^\'%\'%\'") -- """
	local lua_style = line:match("^-%-%[%[") -- --[[  ]]

	if c_style then return "*/$"
	elseif html_style then return "%-%->$"
	elseif lua_style then return "%]%]$"
	elseif python_style then return "\"%\"%\"$"
	else return nil
	end
end


local function match_pattern(line, pattern)
	return line:match(pattern)
end


local function init_load_indentor()

	local buffer_num = vim.api.nvim_get_current_buf() -- current buffer number
	local loc = vim.api.nvim_buf_line_count(buffer_num) -- total lines of code in current file
	local current_line_num = 1
	local current_line_content, whitespace, whitespace_t
	local stack_tab = 0
	local stack_space = 0
	local space_list = {}
	local accuracy = vim.g.penvim_indentor_accuracy


	if loc == 1 then
		current_line_num = 0
	end

	::continue_loop::

	if current_line_num > loc or stack_space > accuracy or stack_tab > accuracy then
		goto end_loop
	end

	current_line_content = vim.fn.getline(current_line_num)
	whitespace = whitespace_type(current_line_content)
	whitespace_t = whitespace['type']

	if whitespace_t == "blank" then
		current_line_num = current_line_num + 1
		goto continue_loop
	end
	if whitespace_t == "tab" then
		stack_tab = stack_tab + 1
		current_line_num = current_line_num + 1
		goto continue_loop
	end
	if whitespace_t == "space" then
		stack_space = stack_space + 1
		space_list[#space_list+1] = whitespace.no_of_space
		current_line_num = current_line_num + 1
		goto continue_loop
	end

	-- Comment Operations
	Block_comment = block_comment(current_line_content)

	-- if line is not a block comment then it must be lingle line comment
	if not Block_comment then
		current_line_num = current_line_num + 1
		goto continue_loop
	end

	-- check if block comment exist on same single line
	if match_pattern(current_line_content, Block_comment) then
		current_line_num = current_line_num + 1
		goto continue_loop
	end

	-- if Block Comment then Operation until Right pair of comment is found
	if Block_comment then
		current_line_num = current_line_num + 1
		for _=current_line_num, loc do
			current_line_content = vim.fn.getline(current_line_num)
			if match_pattern(current_line_content, Block_comment) then
				current_line_num = current_line_num + 1
				goto continue_loop
			end
		end
	end

	::end_loop::

	local indent_length = vim.g.penvim_indentor_length
	local tab_set = false
	local space_set = false

	-- set tab
	if stack_tab > stack_space then
		-- TODO:
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
		-- local space_length = math.max(unpack(space_list))
		space_set = true
	end

	if not tab_set and not space_set then
		-- use default
		local indent_type = vim.g.penvim_indentor_type   -- default auto,  auto|space|tab

		if indent_type == "tab" then
			vim.opt.softtabstop = indent_length
			vim.opt.shiftwidth = indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
			vim.opt.tabstop = indent_length     -- spaces per tab
			vim.opt.smarttab = true             -- <tab>/<BS> indent/dedent in leading whitespace
			vim.opt.autoindent = true           -- maintain indent of current line
		elseif indent_type == "space" then
			-- TODO
			return -- to ignore error
		else
			-- auto
			--TODO
		end
	end
end


function M.load_indentor()
	-- TODO...
	init_load_indentor()
end


return M

