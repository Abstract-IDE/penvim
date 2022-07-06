
-- collections of functions that can handle files and directories

local M={}


-- check given path is dir return True else false
function M.is_dir(path)
	local file = io.open(path, 'r')
	local ok, error, code = file:read(1)
	file:close()
	return code == 21
end


function M.dirsplit(inputstr)
	-- https://stackoverflow.com/a/7615129/11812032
	local sep = "/"
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end


-- check if file exist
function M.file_exists(fname)
	local f = io.open(fname, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end


function os.capture(cmd, raw)
	-- https://gist.github.com/dukeofgaming/453cf950abd99c3dc8fc
	local handle = assert(io.popen(cmd, 'r'))
	local output = assert(handle:read('*a'))
	handle:close()
	if raw then return output end
	output = string.gsub(string.gsub(string.gsub(output, '^%s+', ''), '%s+$', ''), '[\n\r]+', ' ')
	return output
end


function M.osuser()
	return os.capture("whoami")
end


--  normalize dir
--  /home/user/../user/download/../ --> /home/user
function M.normalize_dir(dir)
	local stack = {}
	local split_dir = M.dirsplit(dir)
	for _, r in ipairs(split_dir) do
		table.insert(stack, r)
		if r == ".." then
			stack = {unpack(stack, 1, #stack-2)}
		end
	end
	local str = ""
	for _, i in ipairs(stack) do
		str = str .. "/" .. i
	end
	return str .. "/"
end


return M

