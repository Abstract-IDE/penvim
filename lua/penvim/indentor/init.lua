
local M = {}
local g = vim.g
local fn = vim.fn
local api = vim.api
local opt = vim.opt


local function whitespace_type(line)

	local whitespace = line:match("^%s*"):len()
	if whitespace == 0 then
		return { type = "blank", }
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
	-- and if yes then return its right pair

	local white_space = " "
	::loop::
	local space = line:match("^%"..white_space)
	if space == white_space then
		white_space = white_space .. " "
		goto loop
	end

	local c_style = line:match("^/%*") -- /*
	local html_style = line:match("^<!%-%-") -- <!--
	local python_style_double = line:match("^\"%\"%\"") -- """
	local python_style_single = line:match("^\'%\'%\'") -- '''
	local lua_style = line:match("^-%-%[=*%[") -- --[[  ]]

	if c_style then return "*/$"
	elseif html_style then return "%-%->$"
	elseif lua_style then return "%]=*%]$"
	elseif python_style_double then return "\"%\"%\"$"
	elseif python_style_single then return "\'%\'%\'$"
	else return nil
	end
end


local function match_pattern(line, pattern)
	return line:match(pattern)
end


function M.load_indentor()

	local buffer_num = api.nvim_get_current_buf() -- current buffer number
	local loc = api.nvim_buf_line_count(buffer_num) -- total lines of code in current file
	local current_line_num = 1
	local current_line_content, whitespace, whitespace_t
	local stack_tab = 0
	local stack_space = 0
	local space_list = {}
	local accuracy = g.penvim_indentor_accuracy

	if loc == 1 then
		goto loop_end
	end

	::loop_continue::

	if current_line_num > loc or stack_space > accuracy or stack_tab > accuracy then
		goto loop_end
	end

	current_line_content = fn.getline(current_line_num)

	-----------------------------------------------
	-- operations for BLOCK COMMENT
	-----------------------------------------------
	Block_comment = block_comment(current_line_content)

	-- if line is not a block comment, handle the operation to the whitespace
	if not Block_comment then
		goto whitespace
	end

	-- any block comment on same line have length of > 3 means bolck comment doesn't exist on same line
	if #current_line_content < 4 then
		goto loop_block
	end
	-- check if block comment exist on same single line
	if match_pattern(current_line_content, Block_comment) then
		current_line_num = current_line_num + 1
		goto loop_continue
	end

	::loop_block::
	-- if Block Comment, then operate until Right pair of comment is found
	if Block_comment then
		for _=current_line_num, loc do
			current_line_num = current_line_num + 1
			current_line_content = fn.getline(current_line_num)
			if match_pattern(current_line_content, Block_comment) then
				current_line_num = current_line_num + 1
				goto loop_continue
			end
		end
	end
	-----------------------------------------------

	-----------------------------------------------
	-- operations for WHITESPACE
	-----------------------------------------------
	::whitespace::
	whitespace = whitespace_type(current_line_content)
	whitespace_t = whitespace['type']

	if whitespace_t == "blank" then
		current_line_num = current_line_num + 1
		goto loop_continue
	end
	if whitespace_t == "tab" then
		stack_tab = stack_tab + 1
		current_line_num = current_line_num + 1
		goto loop_continue
	end
	if whitespace_t == "space" then
		stack_space = stack_space + 1
		space_list[#space_list+1] = whitespace.no_of_space
		current_line_num = current_line_num + 1
		goto loop_continue
	end
	-----------------------------------------------
	::loop_end::

	local indent_length = g.penvim_indentor_length
	local tab_set = false
	local space_set = false

	opt.smarttab = true             -- <tab>/<BS> indent/dedent in leading whitespace
	opt.autoindent = true           -- maintain indent of current line

	if stack_tab > stack_space then
		-- set tab
		opt.tabstop = indent_length     -- spaces per tab
		opt.shiftwidth = indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
		opt.softtabstop = indent_length -- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
		opt.expandtab = false           -- Always uses spaces instead of tab characters (et).
		tab_set = true
	end
	if stack_space > stack_tab then
		-- set space
		local space_length
		if #space_list <= 1 then
			space_length = space_list[1]
		else
			space_length = math.min(unpack(space_list))
		end

		opt.tabstop = space_length     -- Size of a hard tabstop (ts).
		opt.shiftwidth = space_length  -- Size of an indentation (sw).
		opt.softtabstop = 0            -- Number of spaces a <Tab> counts for. When 0, featuer is off (sts).
		opt.expandtab = true           -- Always uses spaces instead of tab characters (et).
		space_set = true
	end

	if not tab_set and not space_set then
		-- use default
		local indent_type = g.penvim_indentor_type -- default auto,  auto|space|tab

		if indent_type == "tab" then
			-- TAB
			opt.softtabstop = indent_length
			opt.shiftwidth = indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
			opt.tabstop = indent_length     -- Size of a hard tabstop (ts).
		elseif indent_type == "space" then
			-- SPACE
			opt.softtabstop = 0  -- Number of spaces a <Tab> counts for. When 0, featuer is off (sts).
			opt.expandtab = true -- Always uses spaces instead of tab characters (et).
			opt.shiftwidth = indent_length  -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
			opt.tabstop = indent_length     -- Size of a hard tabstop (ts).
		else
			-- TODO --
			-- auto
			return
		end
	end
end


return M

