--
-- Copyright (C) 2012 Kriss Blank < Kriss@XIXs.com >
-- This file is distributed under the terms of the MIT license.
-- http://en.wikipedia.org/wiki/MIT_License
-- Please ping me if you use it for anything cool...
--

local string=string
local table=table

local type=type
local pairs=pairs
local ipairs=ipairs
local tostring=tostring
local setmetatable=setmetatable

--
-- Simple sandboxing of lua functions
--


-- make a table to be used as a reasonably "safe" environment
-- code can still lock up in loops or allocate too much memory
-- but it doesnt get to jump out of its sandbox

local function local_make_env_safe()
local env={
	assert=assert,
	error=error,
	ipairs=ipairs,
	pairs=pairs,
	next=next,
	pcall=pcall,
	select=select,
	tonumber=tonumber,
	tostring=tostring,
	type=type,
	unpack=unpack,
	xpcall=xpcall,
	coroutine={
		create=coroutine.create,
		resume=coroutine.resume,
		running=coroutine.running,
		status=coroutine.status,
		wrap=coroutine.wrap,
		yield=coroutine.yield,
	},
	table={
		concat=table.concat,
		insert=table.insert,
		maxn=table.maxn,
		remove=table.remove,
		sort=table.sort,
	},
	string={
		byte=string.byte,
		char=string.char,
		find=string.find,
		format=string.format,
		gmatch=string.gmatch,
		gsub=string.gsub,
		len=string.len,
		lower=string.lower,
		match=string.match,
		rep=string.rep,
		reverse=string.reverse,
		sub=string.sub,
		upper=string.upper,
	},
	math={
		abs=math.abs,
		acos=math.acos,
		asin=math.asin,
		atan=math.atan,
		atan2=math.atan2,
		ceil=math.ceil,
		cos=math.cos,
		cosh=math.cosh,
		deg=math.deg,
		exp=math.exp,
		floor=math.floor,
		fmod=math.fmod,
		frexp=math.frexp,
		huge=math.huge,
		ldexp=math.ldexp,
		log=math.log,
		log10=math.log10,
		max=math.max,
		min=math.min,
		modf=math.modf,
		pi=math.pi,
		pow=math.pow,
		rad=math.rad,
		random=math.random, -- should replace with sandboxed versions
		randomseed=math.randomseed, -- should replace with sandboxed versions
		sin=math.sin,
		sinh=math.sinh,
		sqrt=math.sqrt,
		tan=math.tan,
		tanh=math.tanh,
	},
	os={
		clock=os.clock,
		date=os.date, -- this can go boom in some situations?
		difftime=os.difftime,
		time=os.time,
	},
}

-- a modified loadstring that can set its function environment
-- setfenv is probably quite dangerous to expose, too much opportunity for
-- mischief on any function the sandbox code is given access to
-- it is however safe in this use since its your function that was just
-- loadstringed
	env.loadstring=function(s,newenv)
		local f,e=loadstring(s)
		if f then setfenv(f,newenv or env) end
		return f,e
	end

	return env
end



module("wetgenes.sandbox")

--
-- get a functional environment full of useful but "safe" functions
--
function make_env(opts)

local env=local_make_env_safe()

	return env
end

