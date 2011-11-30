-- copy all globals into locals
local coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require=coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require

-- widget class string
-- a one line string buffer that can be edited




module("fenestra.widget.string")

function mouse(widget,act,x,y,key)

--	local it=widget.string

-- call here so we can use any state changes immediatly	
	local ret=widget.meta.mouse(widget,act,x,y,key)
	
	if widget.master.active==widget then
	
		widget.master.focus=widget
		
		if act=="down" then
			local dx=x-((widget.pxd or 0)+(widget.text_x or 0))
--print(dx)
			if dx<0 then -- catch lessthan
				widget.line_idx=0
			else
				widget.line_idx=widget.master.font.which(dx,widget.line)
				if widget.line_idx<0 then widget.line_idx=#widget.line end -- catch morethan
			end
		end
	end
	
	return ret
end


function key(widget,ascii,key,act)
--	local it=widget.string
	local master=widget.master
	
	local changed=false

--print("gotkey",ascii)
	
	if act=="down" or act=="repeat" then
	
		if key=="left" then

			widget.line_idx=widget.line_idx-1
			if widget.line_idx<0 then widget.line_idx=0 end
			
			master.throb=255
						
		elseif key=="right" then
	
			widget.line_idx=widget.line_idx+1
			if widget.line_idx>#widget.line then widget.line_idx=#widget.line end
			
			master.throb=255
			
		elseif key=="home" then
		
			widget.line_idx=0
		
		elseif key=="end" then
		
			widget.line_idx=#widget.line
		
		elseif key=="backspace" then
	
			if widget.line_idx >= #widget.line then -- at end
			
				widget.line=widget.line:sub(1,-2)
				widget.line_idx=#widget.line
				
				changed=true
			
			elseif widget.line_idx < 1 then -- at start
			
			elseif widget.line_idx == 1 then -- near start
			
				widget.line=widget.line:sub(2)
				widget.line_idx=widget.line_idx-1
			
				changed=true

			else -- somewhere in the line
			
				widget.line=widget.line:sub(1,widget.line_idx-1) .. widget.line:sub(widget.line_idx+1)
				widget.line_idx=widget.line_idx-1
				
				changed=true

			end
			
			master.throb=255
			
		elseif key=="delete" then
	
			if widget.line_idx >= #widget.line then -- at end
			
			elseif widget.line_idx < 1 then -- at start
			
				widget.line=widget.line:sub(2)
				widget.line_idx=0
			
				changed=true

			else -- somewhere in the line
			
				widget.line=widget.line:sub(1,widget.line_idx) .. widget.line:sub(widget.line_idx+2)
				widget.line_idx=widget.line_idx
				
				changed=true

			end
			
			master.throb=255
			
		elseif key=="enter" or key=="return" then
		
			if act=="down" then -- ignore repeats on enter key
			
				if widget.line and widget.onenter then -- callback?
				
					widget:call_hook("click")
					
				end
				
			end
			
--		elseif key=="up" then
--		elseif key=="down" then
		
		elseif ascii~="" then -- not a blank string
			local c=string.byte(ascii)
			
			if c>=32 and c<128 then
			
				if widget.line_idx >= #widget.line then -- put at end
				
					widget.line=widget.line..ascii
					widget.line_idx=#widget.line
					
				elseif widget.line_idx < 1 then -- put at start
				
					widget.line=ascii..widget.line
					widget.line_idx=1
					
				else -- need to insert into line
				
					widget.line=widget.line:sub(1,widget.line_idx) .. ascii .. widget.line:sub(widget.line_idx+1)
					widget.line_idx=widget.line_idx+1
					
				end
				
				master.throb=255
				
				changed=true

			end
		end
	end
	
	if changed then
		widget.text=widget.line
		
		widget:call_hook("update")
	end
	
	return true

end


function update(widget)
end


function setup(widget,def)
--	local it={}
--	widget.string=it
	widget.class="string"
	
	widget.line=""
	widget.line_idx=0
	
--	widget.key=key
	widget.update=update

	widget.key=key
	widget.mouse=mouse

	return widget
end
