
local M = {}


function M.split(inputstr, sep)
	-- https://stackoverflow.com/a/7615129
	if sep == nil then sep = "%s" end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end


return M
