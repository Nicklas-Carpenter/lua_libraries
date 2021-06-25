local libreadline = package.loadlib("./lua_readline.so", "luaopen_libreadline")
readline = libreadline()

return readline
