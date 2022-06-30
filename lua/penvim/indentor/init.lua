
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

return M

