#include <limits.h>
#include <unistd.h>
#include <getopt.h>
#include <lua.h>
#include <lauxlib.h>

static char **argv;

static int lua_table_to_array(lua_State *L, int argc) {
	if (argv) { 				
		free(argv);
		argv = NULL;
	}

	argv = malloc(argc * sizeof(char*));
	
	// Count from 1 to argc since we are using Lua indexing 
	// system which starts at 1.
	for (i = 1; i <= argc; i++) {
		int type = lua_geti(L, -1, 0);
		if (type != LUA_TSTRING) {
			return luaLError("elements of argv must be strings");
		}
		
		argv[i - 1] = lua_tostring(L, -1);
	}
	 
	// Pop the elements added to the stack and the argument passed on the 
	// stack to this function (should be argc + 1).
	lua_pop(argc + 1) 
	return 0;	
}

static int lua_getopt(lua_State *L) {
	int isnum;
	lua_Integer argc = lua_tointegerx(L, 1, &isnum);

	if (!isnum || argc > INT_MAX) {
		return luaL_argerror(L, 1, 
				"too large; must be assignable to int");
	}

	// REVIEW We may allow an empty (or nil) optstring.
	char* optstring = luaL_checkstring(L, 3);
	
	if (!lua_istable(L, 2)) {
		return luaL_argerror(L, "expected a table");
	}

	// Store an upvalue for argv. This prevents us from having to
	// recreate a C array from the table if argv hasn't changed.
	if (!lua_compare(L, 2, lua_upvalueindex(1))) {
		lua_copy(L, 2, lua_upvalueindex(1));
			
		if (!lua_checkstack(L, 1)) {
			return luaL_error("Out of memory");
		}
		lua_pushvalue(L, 2);
		
		lua_table_to_array(L argc);
	}

	int option_char = getopt((int)argc, argv, optstring);
	lua_pushinteger(L, option_char);
	return 1;
}

static int get_optarg(lua_State *L) {
	luaL_checkstack(L, 1, NULL);

	if (optarg) {
		lua_pushstring(L, optarg);
	}
	else {
		lua_pushnil(L);
	}
	
	return 1;
}

static int get_optind(lua_State *L) {
	luaL_checkstack(L, 1, NULL);

	lua_pushinteger(L, optind);
	return 1;
}

static int get_opterr(lua_State *L) {
	luaL_checkstack(L, 1, NULL);

	lua_pushinteger(L, opterr);
	return 1;
}

static int get_optopt(lua_State *L) {
	luaL_checkstack(L, 1 , NULL);

	lua_pushinteger(L, optopt);
	return 1;
}

static int set_optind(lua_State *L) {
	lua_Integer new_optind = luaL_checkinteger(L, 1);
	
	optind = (int)new_optind;
	return 0;
}

static int set_opterr(lua_State *L) {
	lua_Integer new_opterr = luaL_checkinteger(L, 1);
	return 0;
}

// Sets up a metatable that allows the globals from getopt (opind,
// opterror, etc.) to be manipulated from Lua in the same way they are
// manipulated in C.
static int create_getopt_globals_interface(lua_State *L) {
	lua_createtable(L, 0, 2); // metatable
	lua_createtable(L, 0, 2); // set
	lua_pushstring
	
static const struct luaL_Reg libgetopt[] = {
	{"getopt", lua_getopt}
}

int luaopen_getopt(lua_State *L)
	luaL_newlibtable(L, libgetopt);
	lua_pushnil(L);
	luaL_setfuncs(L, libgetopt, 1);
	
	
