getopt = require("getopt")

argv = {...}

for i, v in ipairs(argv) do
	print(i, v)
end

while option ~= -1 do
	option = getopt.getopt(#argv, argv, "abdc")
	print(option)
end
