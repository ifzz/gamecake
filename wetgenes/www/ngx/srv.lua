-- copy all globals into locals, some locals are prefixed with a G to reduce name clashes
local coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,Gload,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require=coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require

local ngx=require("ngx")

local log=require("wetgenes.www.any.log").log

module(...)

--------------------------------------------------------------------------------
--
-- build a new srv structure for this request
--
--------------------------------------------------------------------------------
function new()
	srv={}
	
	srv.put=function(...)
		ngx.print(...)
	end
	
	srv.set_header=function(n,v)
--		log("srv.set_header:",n,"=",v)
		ngx.header[n] = v;
	end
	
	srv.set_mimetype=function(v)	
		srv.set_header("content_type",v)
--		log("srv.set_mimetype:",v)
	end
	
	srv.set_cookie=function(...)
		log("srv.set_cookie:",...)
	end

	srv.redirect=function(url)
--		log("srv.redirect:",url)
		return ngx.redirect(url)
	end

	srv.reloadcache=function(...)
		log("srv.reloadcache:",...)
	end

	srv.cache={} -- a very local cache
	
	srv.method=ngx.var.request_method -- probably GET or POST
	
	srv.ip=ngx.var.remote_addr -- users IP
	


	local scheme=ngx.var.scheme			-- http or https
	local domain=ngx.var.server_name
	local port=ngx.var.server_port
	local uri=ngx.var.uri				-- begins with /
	
	if port and port~="80" then
	
		srv.url=scheme.."://"..domain..":"..port..uri -- the url requested (not including any query string)

	else

		srv.url=scheme.."://"..domain..uri -- the url requested (not including any query string)

	end
	
	srv.query=ngx.var.args -- the query string
	
	srv.cookies={}
	
	srv.headers={}
	
	srv.posts={}

	srv.uploads={}

	srv.gets={}

	srv.vars={}

	return srv
end
