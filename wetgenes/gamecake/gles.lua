--
-- (C) 2013 Kriss@XIXs.com
--
local coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,Gload,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require=coroutine,package,string,table,math,io,os,debug,assert,dofile,error,_G,getfenv,getmetatable,ipairs,load,loadfile,loadstring,next,pairs,pcall,print,rawequal,rawget,rawset,select,setfenv,setmetatable,tonumber,tostring,type,unpack,_VERSION,xpcall,module,require

-- this contains mild emulation of the old gl fixed pipeline, such that we can run some code in gles2 and above

local tardis=require("wetgenes.tardis")

--module
local M={ modname=(...) } ; package.loaded[M.modname]=M

function M.bake(oven,gles)

	if not oven.gl then -- need a gles2 wrapped in glescode
	
		oven.gl=require("glescode").create( require("gles").gles2 )
		
		oven.gl.GetExtensions()
		
	end

	local gl=oven.gl
	

-- if there is no normal then assume "special z mode"
-- where the z component is treated as 0 for vire transform
-- but added on at the end, for 2d z "polygon offset" hacks

	gl.shaders.v_pos_tex={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec2 a_texcoord;

varying vec2  v_texcoord;
varying vec4  v_color;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex.xy, 0.0 , 1.0);
    gl_Position.z+=a_vertex.z;
	v_texcoord=a_texcoord;
	v_color=color;
}

	]]
}

	gl.shaders.v_pos_tex_color={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec2 a_texcoord;
attribute vec4 a_color;

varying vec2  v_texcoord;
varying vec4  v_color;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex.xy, 0.0 , 1.0);
    gl_Position.z+=a_vertex.z;
	v_texcoord=a_texcoord;
	v_color=a_color*color;
}

	]]
}

	gl.shaders.v_raw_tex_color={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec2 a_texcoord;
attribute vec4 a_color;

varying vec2  v_texcoord;
varying vec4  v_color;
 
void main()
{
    gl_Position = projection * vec4(a_vertex.xyz , 1.0);
	v_texcoord=a_texcoord;
	v_color=a_color;
}

	]]
}

	gl.shaders.v_pos={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;

varying vec4  v_color;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex.xy, 0.0 , 1.0);
    gl_Position.z+=a_vertex.z;
	v_color=color;
}

	]]
}


	gl.shaders.v_pos_color={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec4 a_color;

varying vec4  v_color;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex.xy, 0.0 , 1.0);
    gl_Position.z+=a_vertex.z;
	v_color=a_color*color;
}

	]]
}

	gl.shaders.f_tex={
	source=gl.defines.shaderprefix..[[

uniform sampler2D tex;

varying vec2  v_texcoord;
varying vec4  v_color;

void main(void)
{
	if( v_texcoord[0] <= -1.0 ) // special uv request to ignore the texture (use -2 as flag)
	{
		gl_FragColor=v_color ;
	}
	else
	{
		gl_FragColor=texture2D(tex, v_texcoord) * v_color ;
	}
}

	]]
}
	gl.shaders.f_tex_discard={
	source=gl.defines.shaderprefix..[[

uniform sampler2D tex;

varying vec2  v_texcoord;
varying vec4  v_color;

void main(void)
{
	if( v_texcoord[0] <= -1.0 ) // special uv request to ignore the texture (use -2 as flag)
	{
		gl_FragColor=v_color ;
	}
	else
	{
		gl_FragColor=texture2D(tex, v_texcoord) * v_color ;
	}
	if((gl_FragColor.a)<0.25) discard;
}

	]]
}

	gl.shaders.f_color={
	source=gl.defines.shaderprefix..[[

varying vec4  v_color;

void main(void)
{
	gl_FragColor=v_color ;
}

	]]
}
	gl.shaders.f_color_discard={
	source=gl.defines.shaderprefix..[[

varying vec4  v_color;

void main(void)
{
	gl_FragColor=v_color ;
	if((gl_FragColor.a)<0.25) discard;
}

	]]
}
	gl.shaders.v_pos_normal={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec3 a_normal;

varying vec4  v_color;
varying vec3  v_normal;
varying vec3  v_pos;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex, 1.0);
    v_normal = normalize( mat3( modelview ) * a_normal );
	v_color=color;
}

	]]
}
	gl.shaders.v_xyz_normal=gl.shaders.v_pos_normal

	gl.shaders.v_pos_normal_tex={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;
attribute vec3 a_normal;
attribute vec2 a_texcoord;

varying vec4  v_color;
varying vec3  v_normal;
varying vec3  v_pos;
varying vec2  v_texcoord;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex, 1.0);
    v_normal = normalize( mat3( modelview ) * a_normal );
	v_texcoord=a_texcoord;
	v_color=color;
}

	]]
}
	gl.shaders.v_xyz_normal_tex=gl.shaders.v_pos_normal_tex

	gl.shaders.v_pos_normal_tex_mat={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3  a_vertex;
attribute vec3  a_normal;
attribute vec2  a_texcoord;
attribute float a_matidx;

varying vec4  v_color;
varying vec3  v_normal;
varying vec3  v_pos;
varying vec2  v_texcoord;
varying float v_matidx;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex, 1.0);
    v_normal = normalize( mat3( modelview ) * a_normal );
	v_texcoord=a_texcoord;
	v_color=color;
	v_matidx=a_matidx;
}

	]]
}
	gl.shaders.v_xyz_normal_tex_mat=gl.shaders.v_pos_normal_tex_mat

	gl.shaders.f_phong={
	source=gl.defines.shaderprefix..[[

varying vec4  v_color;
varying vec3  v_normal;
varying vec3  v_pos;


vec3 d=vec3(0,0,-1);

void main(void)
{
	vec3 n=normalize(v_normal);
	gl_FragColor= vec4(v_color.rgb*max( -n.z, 0.25 ),v_color.a);
}

	]]
}

	gl.shaders.f_phong_mat={
	source=gl.defines.shaderprefix..[[

varying vec4  v_color;
varying vec3  v_normal;
varying vec3  v_pos;
varying float v_matidx;


uniform vec4 colors[4]=vec4[4](
	vec4(1.0,0.0,0.0,1.0),
	vec4(0.0,1.0,0.0,1.0),
	vec4(0.0,0.0,1.0,1.0),
	vec4(1.0,1.0,0.0,1.0)
);

vec3 d=vec3(0,0,1);

void main(void)
{
	vec3 n=normalize(v_normal);

	int matidx=int(v_matidx);
	vec4 c=colors[matidx];
	
	gl_FragColor= vec4(c.rgb*max( n.z, 0.25 ),c.a);
}

	]]
}

	gl.shaders.v_xyz={
	source=gl.defines.shaderprefix..[[

uniform mat4 modelview;
uniform mat4 projection;
uniform vec4 color;

attribute vec3 a_vertex;

varying vec4  v_color;
 
void main()
{
    gl_Position = projection * modelview * vec4(a_vertex , 1.0);
	v_color=color;
}

	]]
}

	gl.programs.pos_normal={
		vshaders={"v_pos_normal"},
		fshaders={"f_phong"},
	}
	gl.programs.pos_color={
		vshaders={"v_pos_color"},
		fshaders={"f_color"},
	}
	gl.programs.pos_color_discard={
		vshaders={"v_pos_color"},
		fshaders={"f_color_discard"},
	}
	gl.programs.pos_tex={
		vshaders={"v_pos_tex"},
		fshaders={"f_tex"},
	}
	gl.programs.pos_tex_discard={
		vshaders={"v_pos_tex"},
		fshaders={"f_tex_discard"},
	}
	gl.programs.pos_tex_color={
		vshaders={"v_pos_tex_color"},
		fshaders={"f_tex"},
	}
	gl.programs.pos_tex_color_discard={
		vshaders={"v_pos_tex_color"},
		fshaders={"f_tex_discard"},
	}
	gl.programs.raw_tex_color={
		vshaders={"v_raw_tex_color"},
		fshaders={"f_tex"},
	}
	gl.programs.raw_tex_color_discard={
		vshaders={"v_raw_tex_color"},
		fshaders={"f_tex_discard"},
	}
	gl.programs.pos={
		vshaders={"v_pos"},
		fshaders={"f_color"},
	}
	gl.programs.pos_discard={
		vshaders={"v_pos"},
		fshaders={"f_color_discard"},
	}

	gl.programs.xyz={
		vshaders={"v_xyz"},
		fshaders={"f_color"},
	}
	gl.programs.xyz_normal={
		vshaders={"v_xyz_normal"},
		fshaders={"f_phong"},
	}	

	gl.programs.xyz_normal_mat={
		vshaders={"v_xyz_normal_tex_mat"},
		fshaders={"f_phong_mat"},
	}	

	-- we have mostly squirted extra stuff into oven.gl

	return gles

end
