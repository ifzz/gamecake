--
-- (C) 2013 Kriss@XIXs.com
--
local coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,Gload,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require=coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require

--module
local M={ modname=(...) } ; package.loaded[M.modname]=M

function M.bake(oven,buffers)
		
	local gl=oven.gl
	local cake=oven.cake
	
	buffers.data={}

	buffers.create = function(tab)

		local ret={}
		for nam,val in pairs(tab) do -- copy
			ret[nam]=val
		end
		
		ret[0]=gl.GenBuffer()
		ret.bind=buffers.bind
		
		if ret.start then
			ret:start(buffers) -- and call start now
		end
		
		buffers.data[ret]=ret
		
		return ret
	end

	buffers.bind=function(v)
		gl.BindBuffer(gl.ARRAY_BUFFER,v[0])
	end

	buffers.start = function()
		for v,n in pairs(buffers.data) do
			if not v[0] then
				v[0]=gl.GenBuffer()
				if v.start then
					v:start(buffers)
				end
			end
		end
	end

	buffers.stop = function()
		for v,n in pairs(buffers.data) do
			gl.DeleteBuffer(v[0])
			v[0]=nil
			if v.stop then
				v:stop(buffers)
			end
		end

	end


	return buffers
end




