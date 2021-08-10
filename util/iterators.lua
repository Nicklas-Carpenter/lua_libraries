local buffer 	= require("string.buffers")
local strings	= require("useful.strings") 

local iterator = {
	function chars(str, return_index)
		local str_buffer = buffer.new(#str)
		str_buffer:put(str)

		local index = 0
		local function iter()
			if #buf == 0 then
				return nil
			end

			index = index + 1

			if return_index then
				return str_buffer:get(1), index
			else
				return str_buffer:get(1)
			end
		end

		return iter
	end,

	function lines(file, return_index)
		local param_was_filename = false

		if type(file) == "string" then
			param_was_filename = true
		end

		local function iter()
			local line = file:read()
			if line == nil then
				if param_was_filename then
					-- test if file is open.
					if io.type(file) == "file" then
						file:close()
					end
				end

				return nil
			end

			if return_index then
				return line, index
			else
				return line
			end
		end

		return iter
	end,
	
	function no_index_iter(iter) 
		function indexless_iter()
			return (iter())	
		end
	
		return indexless_inter
	end,
	
	function trimmed_string_iter(iter)
		function trimmed_iter()
			str, index = iter()
			return strings.strip(str), index	
		end
		
		return trimmed_iter
	end
}

return iterator
