readline = require("readline")

readline.using_history()

while true do
	line = readline.readline("prompt> ")

	if not line then
		break
	end

	if line:len() > 0 then
		local status, output = readline.history_expand(line)

		if status == -2 then
			print("Error calling GNU Readline")
			return
		end

		if status == -3 then
			print("Error in expansion")
			return
		end

		readline.add_history(output)
		print(output)
	end

end
