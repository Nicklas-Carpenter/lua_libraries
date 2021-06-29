getopt = require("getopt")

argv = {...}

optstring = "abcdefg"

for k, v in pairs(argv) do
	print(k, v, type(v))
end

print("First iteration")
opt = getopt.getopt(#argv, argv, optstring)

while opt ~= -1 do 
	print("opt:", opt)
	opt = getopt.getopt(#argv, argv, optstring)
	print("optind:", getopt.optind)
end

getopt.optind = 1
opt = getopt.getopt(#argv, argv, optstring)

while opt ~= -1 do 
	print("opt:", opt)
	opt = getopt.getopt(#argv, argv, optstring)
	print("optind:", getopt.optind)
end
