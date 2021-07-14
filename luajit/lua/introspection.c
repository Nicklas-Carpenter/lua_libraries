#include <string.h>
#include <lua.h>
#include <lauxlib.h>

lua_State *lua_main_state;

lua_State *main_state() {
	return lua_main_state;
}

int acquire_main_state(lua_State *L) {
	lua_main_state = L;
}

int luaopen_introspection(lua_State *L) {
	lua_register(L, "introspection", acquire_main_state);
	return 0;
}
