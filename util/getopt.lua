local ffi = require("ffi")

ffi.cdef[[
extern char* optarg;
extern int optind, opterr, optopt;
int getopt(int argc, char *const argv[], const char *optstring);
int getopt_long(int argc, char *const argv[], const char *opstring,
	const struct option *longopts, int *longindex);
int getopt_long_only(int argc, char *const argv[], const char *opstring,
	const struct option *longopts, int *longindex);
]]

getopt = { 
	optarg = ffi.C.optarg,
	optind = ffi.C.optind,
	opterr = ffi.C.opterr,
	optopt = ffi.C.optopt,
}

function getopt.getopt(argc, argv, optstring)
	assert(type(argc) == "number", "argc must be an integer")
	assert(type(argv) == "table", "arv must be an array of strings")
	assert(type(optstring) == "string", "optstring must be a string")

	intermediate_argv = ffi.new("const char*[?]", argc, argv)
	c_argv = ffi.cast("char*[]", intermediate_argv)
	ffi.C.getopt(argc, c_argv, optstring)
end

return getopt
