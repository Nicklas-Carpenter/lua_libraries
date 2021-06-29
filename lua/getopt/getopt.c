#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <getopt.h>
#include <lua.h>
#include <lauxlib.h>

#include <stdio.h>

static char **argv;

static int lua_table_to_array(lua_State *L, int argc) {
	if (argv) { 				
		free(argv);
		argv = NULL;
	}

	// NOTE We need to allocate one more element than we have
	// arguments since we can't use argv[0] as getopt expects that
	// to be the name of the process.
	argv = malloc(argc * sizeof(char*) + 1);
	int table_index = lua_absindex(L, -1);
	
	// Count from 1 to argc since we are using Lua indexing 
	// system which starts at 1.
	for (int i = 1; i <= argc; i++) {
		int type = lua_geti(L, table_index, i);
		
		// printf("%d: type = %s%d\n", i, lua_typename(L, type), type);
		if (type != LUA_TSTRING) {
			return luaL_error(L, "elements of argv must be strings");
		}
		
		argv[i] = lua_tostring(L, -1);
	}
	 
	// Pop the elements added to the stack to initialize argv. 
	// lua_pop(L, argc); 
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
	const char* optstring = luaL_checkstring(L, 3);
	
	if (!lua_istable(L, 2)) {
		return luaL_argerror(L, 2, "expected a table");
	}

	// Store an upvalue for argv. This prevents us from having to
	// recreate a C array from the table if argv hasn't changed.
	if (!lua_compare(L, 2, lua_upvalueindex(1), LUA_OPEQ)) {
		lua_copy(L, 2, lua_upvalueindex(1));
			
		if (!lua_checkstack(L, 1)) {
			return luaL_error(L, "Out of memory");
		}
		lua_pushvalue(L, 2);
		
		lua_table_to_array(L, argc);
	}

	// NOTE we add 1 to argc since getopt expects argc to include
	// the name of the process which Lua does not provide.
	int option_char = getopt((int)argc + 1, argv, optstring);
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

static int getopt_meta_index(lua_State *L) {
	luaL_checkstack(L, 1, NULL);
	lua_gettable(L, lua_upvalueindex(1));
	lua_call(L, 0, 1);
	return 1;
}

// function __newindex(table, key, value)
static int getopt_meta_newindex(lua_State *L) {
	luaL_checkstack(L, 1, NULL);

	// Push the key onto the top of the stack
	lua_pushvalue(L, 2);
	lua_gettable(L, lua_upvalueindex(1));

	// Push the value to set on the stack for the call.
	lua_pushvalue(L, 3);
	
	lua_call(L, 1, 0);
	return 0;
}

// REVIEW Specify error messages for attempts to set immutable globals.
// Sets up a metatable that allows the globals from getopt (opind,
// opterror, etc.) to be manipulated from Lua in the same way they are
// manipulated in C.
static int create_getopt_globals_interface(lua_State *L) {
	luaL_checkstack(L, 3, NULL);
	lua_createtable(L, 0, 2); // metatable
	
	// Set getopt globals (__newindex)
	lua_createtable(L, 0, 2); 
	lua_pushcfunction(L, set_optind);
	lua_setfield(L, -2, "optind");
	lua_pushcfunction(L, set_opterr);
	lua_setfield(L, -2, "opterr");
	lua_pushcclosure(L, getopt_meta_newindex, 1);
	lua_setfield(L, -2, "__newindex");
	
	// Get getopt globals (__index)	
	lua_createtable(L, 0, 4); 
	lua_pushcfunction(L, get_optarg);
	lua_setfield(L, -2, "optarg");
	lua_pushcfunction(L, get_optind);
	lua_setfield(L, -2, "optind");
	lua_pushcfunction(L, get_opterr);
	lua_setfield(L, -2, "opterr");
	lua_pushcfunction(L, get_optopt);
	lua_setfield(L, -2, "optopt");
	lua_pushcclosure(L, getopt_meta_index, 1);
	lua_setfield(L, -2, "__index");
	
	lua_setmetatable(L, -2);
	return 1;
}
	
static const struct luaL_Reg libgetopt[] = {
	{"getopt", lua_getopt},
	{NULL, NULL}
};

int luaopen_getopt(lua_State *L) {
	luaL_newlibtable(L, libgetopt);
	lua_pushnil(L);
	luaL_setfuncs(L, libgetopt, 1);
	create_getopt_globals_interface(L);
	return  1;
}	
