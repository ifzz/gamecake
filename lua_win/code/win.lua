-- copy all globals into locals, some locals are prefixed with a G to reduce name clashes
local coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,Gload,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require=coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require

local win={}

local core=require("wetgenes.win.core")

local base={}
local meta={}
meta.__index=base

setmetatable(win,meta)

function win.create(opts)

	local w={}
	setmetatable(w,meta)
	
	w[0]=assert( core.create(opts) )
	
	core.info(w[0],w)
	return w
end

function base.destroy(w)
	core.destroy(w[0],w)
end

function base.info(w)
	core.info(w[0],w)
end

function base.gl(w,opts)
	core.gl(w[0],opts)
end

function base.peek(w)
	return core.peek(w[0])
end

function base.wait(w,t)
	core.wait(w[0],t)
end

function base.msg(w)
	return core.msg(w[0])
end

function base.sleep(...)
	for i,v in ipairs({...}) do
		if type(v)=="number" then
			core.sleep(v)
		end
	end
end
win.sleep=base.sleep


return win
