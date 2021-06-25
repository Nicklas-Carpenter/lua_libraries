#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>

#include <lua.h>
#include <lauxlib.h>

static int lua_readline(lua_State *L) {
	if (!lua_checkstack(L, 1)) {
		return luaL_error(L, "Out of memory");
	}

	const char *prompt = luaL_optstring(L, 1, "");
	char *line = readline(prompt);
	if (!line) {
		lua_pushnil(L);
	}

	else {
		lua_pushstring(L, line);
	}

	return 1;
}

static int lua_using_history(lua_State *L) {
	using_history();
	return 0;
}

static int lua_add_history(lua_State *L) {
	if (!lua_checkstack(L, 1)) {
		return luaL_error(L, "Out of memory");
	}

	char* string = luaL_optstring(L, 1, "");
	add_history(string);
	
	return 0;
}

static int lua_history_expand(lua_State *L) {
	if (!lua_checkstack(L, 2)) {
		return luaL_error(L, "Out of memory");
	}

	char* string = luaL_optstring(L, 1, "");
	char* output[1];
	
	int result = history_expand(string, output);
	lua_pushnumber(L, (lua_Number)result);
	lua_pushstring(L, *output);

	return 2;
}

static const struct luaL_Reg libreadline[] = {
	{"readline", lua_readline},
	{"using_history", lua_using_history},
	{"add_history", lua_add_history},
	{"history_expand", lua_history_expand},
	{NULL, NULL}
};

int luaopen_libreadline(lua_State *L) {
	luaL_newlib(L, libreadline);
	return 1;
}
