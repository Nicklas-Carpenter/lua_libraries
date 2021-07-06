ffi = require("ffi")

ffi.cdef[[
typedef  void * (*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);
typedef int (*lua_CFunction) (lua_State *L);

 lua_CFunction lua_atpanic(lua_State *L, lua_CFunction
