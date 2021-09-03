local buffer 	= require("string.buffers")

local strings	= require("useful.strings") 
local trim 	= strings.trim
local split	= strings.split

local iterator = {
	function chars(str)
		local str_buffer = buffer.new(#str)
		str_buffer:put(str)

		local index = 0
		local function iter()
			if #buf == 0 then 
				return nil 
			end

			index = index + 1

			return str_buffer:get(1), index
		end

		return iter
	end,

	function lines(file)
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

			return line, index
		end

		return iter
	end,

	function continuable_line_iter(file)
		local line_src = iterators.trimmed_string_iter(lines(file))
		local line_buffer = buffer.new()
		
		local function iter()
			repeat
				local line = line_src()

				if line == nil then
					break		
				end

				line_buffer.put(line_src(), ' ')
			
				if line:sub(#line, #line) ~= '\\' then
					break
				end
			until false

			if #line_buffer == 0 then
				return nil
			end

			-- Remove the trailing space
			return line_buffer.get(#line_buffer - 1)
		end

		return iter
	end,
	
	-- TODO Allow user to specify index of result to trim.
	function trimmed_string_iter(iter)
		function trimmed_iter()
			local results = = {iter()}

			if results[1] == nil then 
				return nil 
			end

			trim(results[1])

			return strings.strip(str), index	
		end
		
		return trimmed_iter
	end,
	
	function panic_on_nil(iter, error_message)
		results = {iter()}

		if results[1]  == nil then
			print(error_message)
			os.exit(-1)
		end
		
		return unpack(results)
	end,
	
	function word_subiter(src_iter)
		local index = 1
		local words = split(src_iter(), ' ')

		local function iter()
			repeat
				if words == nil then 
					return nil
				end 

				local word = words[index]
				if word == nil then
					local chunk = src_iter()
					if chunk == nil then
						words = nil
						return nil
					end
					
					words = split(chunk, ' ')
					index = 1
				else 
					return word
				end
			until false
		end

		return iter
	end,
				
	function char_subiter(src_iter)
		local index = 1
		local word = src_iter()				
		
		local function iter()
			repeat
				if word == nil then
					return nil
				end
				
				if index > #word then
					word = src_iter()
					index = 1 
				else
					return word:sub(index, index)
				end
			until false
		end

		return iter
	end
}

return iterator
