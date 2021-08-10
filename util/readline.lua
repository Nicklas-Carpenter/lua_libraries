local ffi = require("ffi")

ffi.cdef[[
char* readline(const char *prompt);
void using_history(void);
void add_history(const char *string);
int history_expand(char *string, char **output);
]]

lib_readline = ffi.load("readline")

local readline = { }

readline.HISTORY_EXPANSION_ERROR = -1

function readline.readline(prompt)
	local line_ptr = lib_readline.readline(prompt)

	if line_ptr == nil then 
		return nil
	end

	local line = ffi.string(line_ptr)
	return line 
end

function readline.using_history()
	lib_readline.using_history()
end

function readline.add_history(string)
	lib_readline.add_history(line)
end

function readline.history_expand(string)
	local output_ptr = ffi.new("char*[1]")
	local c_string = ffi.new("char[?]", string:len(), string)
	local status = lib_readline.history_expand(c_string, output_ptr)
	
	-- Output refers to a NULL pointer. This shouldn't happen, but 
	-- we track it just in case.
	if output_ptr[0] == nil then
		return -2
	end

	local output = ffi.string(output_ptr[0])

	return status, output
end

return readline
