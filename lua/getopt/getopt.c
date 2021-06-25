#include <limits.h>
#include <unistd.h>
#include <getopt.h>
#include <lua.h>
#include <lauxlib.h>

static int lua_getopt(lua_State *L) {
	int isnum;
	lua_Integer argc = lua_tointegerx(L, 1, &isnum);

	if (!isnum || argc > INT_MAX) {
		return luaL_argerror(L, 1, 
				"too large; must be assignable to int");
	}

	char* optstring = 	
	
}
