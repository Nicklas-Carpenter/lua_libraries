ffi = require("ffi")

ffi.cdef[[
enum {
	NUM_TAGS = 8,
	TM_N = 17
};

typedef void *(*lua_Alloc) (void *ud, void *ptr, size_t osize, size_t nsize);
typedef unsigned char lu_byte;
typedef unsigned int Instruction;
typedef size_t lu_mem;
typedef double lua_Number;

typedef union GCObject GCObject;

typedef union {
	GCObject *gc;
	void *p;
	lua_Number n;
	int b;
} Value;

typedef struct lua_TValue {
Value value;
int tt;
} TValue;;

typedef TValue *StkId;

typedef struct stringtable {
	GCObject **hash;
	lu_int32 nuse;
	int size;
} stringtable;

typedef struct CallInfo {
	SktId base;
	SktId func;
	SktId top;
	const Instruction *savedpc;
	int nresults;
	int tailcalls;
} CallInfo;

typedef struct global_State {
	stringtable strt;
	lua_Alloc frealloc;
	void *ud;
	lu_byte currentwhite;
	lu_byte gcstate;
	int sweepstrgc;
	GCObject *rootgc;
	GCObject **sweepgc;
	GCObject *gray;
	GCObject *grayagain;
	GCObject *weak;
	GCObject *tmudata;
	Mbuffer buff;
	lu_mem GCthreshold;
	lu_mem totalbytes;
	lu_mem estimate;
	lu_mem gcdept;
	int gcpause;	
	int gcstepmul;
	lua_CFunction panic;
	TValue l_registry;
	struct lua_State *mainthread;
	UpVal uvhead;
	struct Table *mt[NUM_TAGS];
	Tstring *tmname[TM_N];
} global_State;

typedef struct lua_State {
	GCObject *next; 
	lu_byte tt; 
	lu_byte marked;
	lu_byte status;
	StkId top;
	StkId; base;
	global_State *l_G;
	CallInfo *ci;
	const Instruction *savedpc;
	StkId stack_last;
	StkId stack;
	CallInfo *end_ci;
	CallInfo *base_ci;
	int stacksize;
	int size_ci;
	unsigned short nCcalls;
	lu_byte hookmask;
	lu_byte allowhook;
	int basehookcount;
	int hookcount;
	lua_Hook hook;
	TValue l_gt;
	TValue enf;
	GCObject *openupval;
	GCObject *gclist;
	struct lua_longjmp *errorJmp;
	ptrdiff_t errfunc; 
} lua_State;

typedef const char * (*lua_Reader) (lua_State *L, void *ud, size_t *sz);
typdef int (*lua_Writer) (lua_State *L, const void *p, size_t sz, void *ud);
typedef int (*lua_CFunction) (lua_State *L);

typedef struct GCheader {
	GCObject *next; 
	lu_byte tt;
	lu_byte marked;
} GCheader;

typedef union {
	double u;
	void* s;
	long l;
} L_Umaxalign;

typedef union TString {
	L_Umaxalign dummy;
	struct {
		GCObject *next;
		lu_byte tt;
		lu_byte marked;
		lu_byte reserved;
		unsigned int hash;
		size_t len;
	} tsv;
} TString;

typedef union Udata {
	L_Umaxalign dummy;
	struct {
		GCObject *next;
		lu_byte tt;
		lu_byte marked;
		struct Table *metatable;
		struct Table *env;
		size_t len;
	} uv;
} Udata;

typedef struct Proto {
	GCObject *next;
	lu_byte tt;
	lu_byte marked;
	TValue *k;
	Instruction *code;
	struct Proto **p;
	int *lineinfo;
	struct LocVar *locvars;
	TString **upvalues;
	TString *source;
	int sizeupvalues;
	int sizek;
	int sizecode;
	int sizelineinfo;
	int sizep;
	int sizelocvars;
	int linedefined;
	int lastlinedefined;
	GCObject *gclist;
	lu_byte nups;
	lu_byte numparams;
	lu_byte is_vararg;
	lu_byte maxstacksize;
} Proto;

typedef struct LocVar {
	TString *varname;
	int startpc; 
	int endpc;
} LocVar;

typedef struct Upval {
	GCObject *next;
	lu_byte tt;
	lu_byte marked;
	TValue *v;
	union {
		TValue value;
		struct {
			struct UpVal *prev;
			struct UpVal *next;
		} l;
	} u;
} UpVal;

typedef struct CClosure {
	GCObject *next;
	lu_byte tt;
	lu_byte marked;
	lu_byte isC;
	lu_byte nupvalues;
	GCObject *gclist;
	lua_CFunction f;
	TValue upvalue[1];
} CClosure;

typedef struct LClosure {
	GCObject *next;
	lu_byte tt;
	lu_byte marked;
	lu_byte isC;
	lu_byte nupvalues; GCObject *gclist;
	struct Proto *p;
	UpVal *upvals[1];
} LClosure;

typedef union Closure {
	CClosure c;
	LClosure l;
} Closure;
	
union GCObject {
	GCheader gch;
	union TString ts;
	union Udata u;
	union Closure cl;
	struct Table h;
	struct Proto p;
	struct Upval uv;
	struct lua_State th;
};

// Lua Standard API
int lua_gettop(lua_State *L);
void lua_settop(lua_State *L, int idx);
void lua_pushvalue(lua_State *L, int idx);
void lua_remove(lua_State *L, int idx);
void lua_insert(lua_State *L, int idx);
void lua_replace(lua_State *L, int idx);
void lua_checkstack(lua_State *L, int sz);

void lua_xmove(lua_State *from, lua_State *to, int n);

int lua_isnumber(lua_State *L, int idx);
int lua_isstring(lua_State *L, int idx);
int lua_iscfunction(lua_State *L, int idx);
int lua_isuserdata(lua_State *L, int idx);
int lua_type(lua_State *L, int idx);
const char *lua_typename(lua_State *L, int tp);

int lua_equal(lua_State *L, int idx1, int idx2);
int lua_rawequal(lua_State *L, int idx1, int idx2);
int lua_lessthan(lua_State *L, int idx1, int idx2);

int lua_tonumber(lua_State *L, int idx);
int lua_tointeger(lua_State *L, int idx);
int lua_toboolean(lua_State *L, int idx);
int lua_tolstring(lua_State *L, int idx, size_t *len);
int lua_objlen(lua_State *L, int idx);
int lua_tocfunction(lua_State *L, int idx);
int lua_touserdata(lua_State *L, int idx);
int lua_tothread(lua_State *L, int idx);
int lua_topointer(lua_State *L, int idx);

void lua_pushnil(lua_State *L);
void lua_pushnumber(lua_State *L, lua_Number n);
void lua_pushinteger(lua_State *L, lua_Integer n);
void lua_pushlstring(lua_State *L, const char *s, size_t l);
void lua_pushstring(lua_State *L, const char *s);
const char* lua_pushvfstring(lua_State *L, const char *fmt, va_list argp);
const char *pushfstring(lua_State *L, const char* fmt, ...);
void lua_pushcclosure(lua_State *L, lua_CFunction fn, int n);
void lua_pushboolean(lua_State *L, int b);
void lua_pushlightuserdata(lua_State *L, void *p);
int lua_pushthread(lua_State *L);

void lua_gettable(lua_State *L, int idx);
void lua_getfield(lua_State *L, int idx, const char *k);
void lua_rawget(lua_State *L, int idx);
void lua_rawgeti(lua_State *L, int idx, int n);
void lua_createtable(lua_State *L, int narr, int nrec);
void *lua_newuserdata(lua_State* L, size_t sz);
int lua_getmetatable(lua_State *L, int objindex);
void lua_getfenv(lua_State *L, int idx);

void lua_settable(lua_State *L, int idx);
void lua_setfield(lua_State *L, int idx, const char* k);
void lua_rawset(lua_State *L, int idx);
void lua_rawseti(lua_State *L, int idx, int n);
int lua_setmetatable(lua_State *L, int objindex);
int lua_setfenv(lua_State *L, int idx);

void lua_call(lua_State *L, int nargs, int nresults);
int lua_pcall(lua_State *L, int nargs, int nresults, int errfunc);
int lua_cpcall(lua_State *L, lua_CFunction func, void *ud);
int lua_load(lua_State *L, lua_Reader reader, void *dt, const char *chunkname);

int lua_error(lua_State *L);
int lua_next(lua_State *L, int idx);
void lua_concat(lua_State *L, int n);
lua_Alloc lua_getallocf(lua_State *L, void **ud);
void lua_setallocf(lua_State *L, lua_Alloc f, void *ud);

// Lua Auxillary library
typedef struct luaL_Reg {
	const char *name;
	lua_CFunction func;
} luaL_Reg;

void luaL_register(lua_State *L, const char *libname, const luaL_Reg *l);
int luaL_getmetafield(lua_State *L, int obj, const char *e);
int luaL_callmeta(lua_State *L, int obj, const char *e);
int luaL_typerror(lua_State *L, int obj, const char *tname);
int luaL_argerror(lua_State *L, int obj, const char *extramsg);
const char *luaL_checklstring(lua_State *L, int numArg, size_t *l);
const char *luaL_optlstring(lua_State *L, int nArg, lua_Integer def);
]]

local lua = { }

function lua.lua_pop(L, n) lua.lua.settop(L, -n - 1) end
function lua.lua_newtable(L) lua.lua_createtable(L, 0, 0) end

function lua.lua_register(L, n, f) 
	lua_puschcfunction(L, f)
	lua_setglobal(L, n)
end

function lua.lua_isfunction(L, n)
	return lua.lua_type(L, n) == lua.LUA_TFUNCTION
end

function lua.lua_istable(L, n)
	return lua.lua_type(L, n) == lua.LUA_TTABLE
end

function lua.lua_islightuserdata(L, n)
	return lua.lua_type(L, n) == lua.LUA_TLIGHTUSERDATA 
end

function lua.lua_isnil(L, n) 
	return lua.lua_type(L, n) == lua.LUA_TNIL
 end

function lua.lua_isboolean(L, n)
	return lua.lua_type(L, n) == lua.LUA_TBOOLEAN 
end

function lua.lua_isthread(L, n) 
	return lua.lua_type(L, n) == lua.LUA_TTHREAD 
end

function lua.lua_isnone(L, n)
	return lua.lua_type(L, n) == lua.LUA_TNONE 
end

function lua.lua_isnoneornil(L, n) return lua.lua_type(L, n) <= 0 end

function lua.lua_pushliteral(L, s) lua.lua_pushlstring(L, s, #s) end

function lua.lua_setglobal(L, s) 
	lua_setfield(L, lua.LUA_GLOBALSINDEX, s)
end

function lua.lua_getglobal(L, s) 
	lua_getfield(L, LUA_GLOBALSINDEX, s)
end

function lua.lua_tostring(L, i) return lua.lua_tolstring(L, i, nil) end	

return setmetatable(lua, {
	__index = function(table, key)
		table[key] = ffi.C[key]
		return table[key]
	end
})
