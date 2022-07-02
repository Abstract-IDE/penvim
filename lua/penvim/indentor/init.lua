
local M={}

local default_indent_length = vim.g.penvim_indentor_length -- default 4
local default_indent_type = vim.g.penvim_indentor_indent   -- default auto,  auto|space|tab

-- current buffer number
local buffer_num = vim.api.nvim_get_current_buf()

function M.load_indentor()
	-- TODO...
end

-- vim.api.nvim_create_autocmd(
-- 	"BufEnter",
-- 	{
-- 		desc = "don't auto comment new line",
-- 		pattern = "*",
-- 		group = group,
-- 		callback = function ()
-- 			local line = vim.api.nvim_buf_get_lines(0, 0, 2, 1)
-- 			line = vim.inspect(line)
-- 			print(line)
-- 		end
-- 	}
-- )
--

-- local function whitespace_count(buff, type, line)
-- 	-- buff=buffer number | type=tab/space | line=line number
-- 	if type == "tab" then
-- 		local math_pattern = "^%\t*"
-- 	else
-- 		local math_pattern = "^%s*"
-- 	end
-- end

local function whitespace_type (line)

	local whitespace = line:match("^%s*"):len()
	if whitespace == 0 then
		return 'blank'
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

local get_lines = function (buff, start, last)
	vim.api.nvim_buf_get_lines(buff, start, last, {})
end


-- local get_line = function (line_num)
-- 	return vim.fn.getline(line_num)
-- end

local function logic()
	local loc = vim.api.nvim_buf_line_count(buffer_num)
	local current_line_num, current_line_content, whitespace
	local next_line_num = current_line_num + 1
	local stack_tab = 0
	local stack_space = 0
	local space_list = {}
	if loc == 1 then
		current_line_num = 0
		next_line_num = 1
	end

	for line_num = current_line_num, next_line_num do
		current_line_content = get_lines(buffer_num, line_num, line_num+1)
		whitespace = whitespace_type(current_line_content)
		type = whitespace.type

		if whitespace ~= 'blank' then
			if type == "tab" then
				stack_tab = stack_tab + 1
			else
				stack_space = stack_space + 1
				space_list[#space_list+1] = whitespace.no_of_space
			end
		end
	end

end

return M

