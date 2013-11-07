--
-- (C) 2013 Kriss@XIXs.com
--
local coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require=coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require

--module
local M={ modname=(...) } ; package.loaded[M.modname]=M

function M.bake(oven,wbutton)
wbutton=wbutton or {}


function wbutton.mouse(widget,act,x,y,key)
	return widget.meta.mouse(widget,act,x,y,key)
end


function wbutton.key(widget,ascii,key,act)
	return widget.meta.key(widget,ascii,key,act)
end


function wbutton.update(widget)

	if widget.data then
		widget.text=widget.data:tostring()
	end

	return widget.meta.update(widget)
end

function wbutton.draw(widget)
	return widget.meta.draw(widget)
end


function wbutton.setup(widget,def)
--	local it={}
--	widget.button=it
	widget.class="button"
	
	widget.key=key
	widget.mouse=mouse
	widget.update=update
	widget.draw=draw

	widget.solid=true

	return widget
end

return wbutton
end
