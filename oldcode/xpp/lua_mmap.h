/*+-----------------------------------------------------------------------------------------------------------------+*/
//
// (C) Kriss Daniels 2003 http://www.XIXs.com
//
/*+-----------------------------------------------------------------------------------------------------------------+*/


#define LUA_MMAPLIBNAME	"mmap"
int luaopen_mmap (lua_State *L);


#define MMAPHANDLE "mmap"
#define MMAPTHANDLE "mmapt"



metamap *lua_mmap_to_mmap (lua_State *L, int index);
metamap *lua_mmap_to_mmap_from_table (lua_State *L, int index);
