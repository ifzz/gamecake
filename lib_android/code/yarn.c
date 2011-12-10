/* San Angeles Observation OpenGL ES version example
 * Copyright 2009 The Android Open Source Project
 * All rights reserved.
 
 * This source is free software; you can redistribute it and/or
 * modify it under the terms of EITHER:
 *   (1) The GNU Lesser General Public License as published by the Free
 *       Software Foundation; either version 2.1 of the License, or (at
 *       your option) any later version. The text of the GNU Lesser
 *       General Public License is included with this source in the
 *       file LICENSE-LGPL.txt.
 *   (2) The BSD-style license that is included with this source in
 *       the file LICENSE-BSD.txt.
 *
 * This source is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the files
 * LICENSE-LGPL.txt and LICENSE-BSD.txt for more details.
 */
#include <jni.h>
#include <sys/time.h>
#include <time.h>
#include <android/log.h>
#include <stdint.h>
#include <string.h>

#include "com_wetgenes_Yarn.h"

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static lua_State *L=0; // keep a global lua state


static unsigned char const font_bits[16*48]={

0x00,0x18,0x66,0x6c,0x18,0x00,0x70,0x18,0x0c,0x30,0x00,0x00,0x00,0x00,0x00,0x06,
0x00,0x18,0x66,0x6c,0x3e,0x66,0xd8,0x18,0x18,0x18,0xcc,0x30,0x00,0x00,0x00,0x0c,
0x00,0x18,0x00,0xfe,0x60,0xac,0xd0,0x00,0x30,0x0c,0x78,0x30,0x00,0x00,0x00,0x18,
0x00,0x18,0x00,0x6c,0x3c,0xd8,0x76,0x00,0x30,0x0c,0xfc,0xfc,0x00,0x7e,0x00,0x30,
0x00,0x18,0x00,0xfe,0x06,0x36,0xdc,0x00,0x30,0x0c,0x78,0x30,0x00,0x00,0x00,0x60,
0x00,0x00,0x00,0x6c,0x7c,0x6a,0xdc,0x00,0x18,0x18,0xcc,0x30,0x18,0x00,0x18,0xc0,
0x00,0x18,0x00,0x6c,0x18,0xcc,0x76,0x00,0x0c,0x30,0x00,0x00,0x18,0x00,0x18,0x80,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x30,0x00,0x00,0x00,

0x78,0x18,0x3c,0x3c,0x1c,0x7e,0x1c,0x7e,0x3c,0x3c,0x00,0x00,0x00,0x00,0x00,0x3c,
0xcc,0x38,0x66,0x66,0x3c,0x60,0x30,0x06,0x66,0x66,0x18,0x18,0x06,0x00,0x60,0x66,
0xdc,0x78,0x06,0x06,0x6c,0x7c,0x60,0x06,0x66,0x66,0x18,0x18,0x18,0x7e,0x18,0x06,
0xfc,0x18,0x0c,0x1c,0xcc,0x06,0x7c,0x0c,0x3c,0x3e,0x00,0x00,0x60,0x00,0x06,0x0c,
0xec,0x18,0x18,0x06,0xfe,0x06,0x66,0x18,0x66,0x06,0x00,0x00,0x18,0x7e,0x18,0x18,
0xcc,0x18,0x30,0x66,0x0c,0x66,0x66,0x18,0x66,0x0c,0x18,0x18,0x06,0x00,0x60,0x00,
0x78,0x18,0x7e,0x3c,0x0c,0x3c,0x3c,0x18,0x3c,0x38,0x18,0x18,0x00,0x00,0x00,0x18,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x30,0x00,0x00,0x00,0x00,

0x7c,0x3c,0x7c,0x1e,0x78,0x7e,0x7e,0x3c,0x66,0x3c,0x06,0xc6,0x60,0xc6,0xc6,0x3c,
0xc6,0x66,0x66,0x30,0x6c,0x60,0x60,0x66,0x66,0x18,0x06,0xcc,0x60,0xee,0xe6,0x66,
0xde,0x66,0x66,0x60,0x66,0x60,0x60,0x60,0x66,0x18,0x06,0xd8,0x60,0xfe,0xf6,0x66,
0xd6,0x7e,0x7c,0x60,0x66,0x78,0x78,0x6e,0x7e,0x18,0x06,0xf0,0x60,0xd6,0xde,0x66,
0xde,0x66,0x66,0x60,0x66,0x60,0x60,0x66,0x66,0x18,0x06,0xd8,0x60,0xc6,0xce,0x66,
0xc0,0x66,0x66,0x30,0x6c,0x60,0x60,0x66,0x66,0x18,0x66,0xcc,0x60,0xc6,0xc6,0x66,
0x78,0x66,0x7c,0x1e,0x78,0x7e,0x60,0x3e,0x66,0x3c,0x3c,0xc6,0x7e,0xc6,0xc6,0x3c,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,

0x7c,0x3c,0x7c,0x3c,0x7e,0x66,0x66,0xc6,0xc6,0xc6,0x7e,0x3c,0x80,0x3c,0x00,0x00,
0x66,0x66,0x66,0x66,0x18,0x66,0x66,0xc6,0x6c,0x6c,0x0c,0x30,0xc0,0x0c,0x18,0x00,
0x66,0x66,0x66,0x70,0x18,0x66,0x66,0xc6,0x38,0x38,0x18,0x30,0x60,0x0c,0x66,0x00,
0x7c,0x66,0x7c,0x3c,0x18,0x66,0x66,0xd6,0x38,0x18,0x30,0x30,0x30,0x0c,0x00,0x00,
0x60,0x66,0x6c,0x0e,0x18,0x66,0x3c,0xfe,0x38,0x18,0x60,0x30,0x18,0x0c,0x00,0x00,
0x60,0x6e,0x66,0x66,0x18,0x66,0x3c,0xee,0x6c,0x18,0xc0,0x30,0x0c,0x0c,0x00,0x00,
0x60,0x3f,0x66,0x3c,0x18,0x3c,0x18,0xc6,0xc6,0x18,0xfe,0x3c,0x06,0x3c,0x00,0x00,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xfe,

0x18,0x00,0x60,0x00,0x06,0x00,0x1c,0x00,0x60,0x18,0x0c,0x60,0x18,0x00,0x00,0x00,
0x18,0x00,0x60,0x00,0x06,0x00,0x30,0x00,0x60,0x00,0x00,0x60,0x18,0x00,0x00,0x00,
0x0c,0x3c,0x7c,0x3c,0x3e,0x3c,0x7c,0x3e,0x7c,0x18,0x0c,0x66,0x18,0xec,0x7c,0x3c,
0x00,0x06,0x66,0x60,0x66,0x66,0x30,0x66,0x66,0x18,0x0c,0x6c,0x18,0xfe,0x66,0x66,
0x00,0x3e,0x66,0x60,0x66,0x7e,0x30,0x66,0x66,0x18,0x0c,0x78,0x18,0xd6,0x66,0x66,
0x00,0x66,0x66,0x60,0x66,0x60,0x30,0x3e,0x66,0x18,0x0c,0x6c,0x18,0xc6,0x66,0x66,
0x00,0x3e,0x7c,0x3c,0x3e,0x3c,0x30,0x06,0x66,0x18,0x0c,0x66,0x0c,0xc6,0x66,0x3c,
0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3c,0x00,0x00,0x78,0x00,0x00,0x00,0x00,0x00,

0x00,0x00,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x0c,0x18,0x30,0xfe,0xff,
0x00,0x00,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x1c,0x18,0x38,0x00,0xff,
0x7c,0x3e,0x7c,0x3c,0x7c,0x66,0x66,0xc6,0xc6,0x66,0x7e,0x18,0x18,0x18,0x00,0xff,
0x66,0x66,0x66,0x60,0x30,0x66,0x66,0xc6,0x6c,0x66,0x0c,0x38,0x18,0x1c,0x00,0xff,
0x66,0x66,0x60,0x3c,0x30,0x66,0x66,0xd6,0x38,0x66,0x18,0x38,0x18,0x1c,0x00,0xff,
0x7c,0x3e,0x60,0x06,0x30,0x66,0x3c,0xfe,0x6c,0x3c,0x30,0x18,0x18,0x18,0x00,0xff,
0x60,0x06,0x60,0x7c,0x1c,0x3e,0x18,0x6c,0xc6,0x18,0x7e,0x1c,0x18,0x38,0x00,0xff,
0x60,0x06,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x30,0x00,0x0c,0x18,0x30,0x00,0xff

};






static void llog (const char *msg) {
//  if (pname) fprintf(stderr, "%s: ", pname);
//  fprintf(stderr, "%s\n", msg);
//  fflush(stderr);
  __android_log_print(ANDROID_LOG_INFO, "Yarn", msg);
}


static int report (lua_State *L, int status) {
  if (status && !lua_isnil(L, -1)) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) msg = "(error object is not a string)";
    llog(msg);
    lua_pop(L, 1);
  }
  return status;
}


static int traceback (lua_State *L) {
  if (!lua_isstring(L, 1))  /* 'message' not a string? */
    return 1;  /* keep it intact */
  lua_getfield(L, LUA_GLOBALSINDEX, "debug");
  if (!lua_istable(L, -1)) {
    lua_pop(L, 1);
    return 1;
  }
  lua_getfield(L, -1, "traceback");
  if (!lua_isfunction(L, -1)) {
    lua_pop(L, 2);
    return 1;
  }
  lua_pushvalue(L, 1);  /* pass error message */
  lua_pushinteger(L, 2);  /* skip this function and traceback */
  lua_call(L, 2, 1);  /* call debug.traceback */
  return 1;
}


static int docall (lua_State *L, int narg, int clear) {
  int status;
  int base = lua_gettop(L) - narg;  /* function index */
  lua_pushcfunction(L, traceback);  /* push traceback function */
  lua_insert(L, base);  /* put it under chunk and args */
//  signal(SIGINT, laction);
  status = lua_pcall(L, narg, (clear ? 0 : LUA_MULTRET), base);
//  signal(SIGINT, SIG_DFL);
  lua_remove(L, base);  /* remove traceback function */
  /* force a complete garbage collection in case of errors */
  if (status != 0) lua_gc(L, LUA_GCCOLLECT, 0);
  return status;
}


static void print_version (void) {
  llog(LUA_RELEASE "  " LUA_COPYRIGHT);
}

static int dofile (lua_State *L, const char *name) {
  int status = luaL_loadfile(L, name) || docall(L, 0, 1);
  return report(L, status);
}


static int dostring (lua_State *L, const char *s, const char *name) {
  int status = luaL_loadbuffer(L, s, strlen(s), name) || docall(L, 0, 1);
  return report(L, status);
}


static int dolibrary (lua_State *L, const char *name) {
  lua_getglobal(L, "require");
  lua_pushstring(L, name);
  return report(L, docall(L, 1, 1));
}




JNIEXPORT void JNICALL
	Java_com_wetgenes_Yarn_setup(
		JNIEnv*  env,
		jclass class
	)
{
	L = lua_open();  /* create state */
	luaL_openlibs(L);  /* open libraries */

	dostring(L,"\
	yarndata={}\
	yarn=require(\"yarn\")\
	yarn.setup(yarndata)\
	yarn.update()\
	","yarn.setup");
}

JNIEXPORT void JNICALL
	Java_com_wetgenes_Yarn_clean(
		JNIEnv*  env,
		jclass class
	)
{
	lua_close(L);
}

JNIEXPORT void JNICALL
	Java_com_wetgenes_Yarn_update(
		JNIEnv*  env,
		jclass class
	)
{
	dostring(L,"\
	yarn.update()\
	","yarn.update");
}

JNIEXPORT void JNICALL
	Java_com_wetgenes_Yarn_keypress(
		JNIEnv *env,
		jclass class,
		jstring ascii_wank,
		jstring name_wank,
		jstring act_wank)
{
//    llog("keypress");

	jboolean wank;
	
	const char *ascii=(*env)->GetStringUTFChars(env,ascii_wank,&wank);
	const char *name=(*env)->GetStringUTFChars(env,name_wank,&wank);
	const char *act=(*env)->GetStringUTFChars(env,act_wank,&wank);
    	
	lua_getglobal(L, "yarn");
	lua_getfield(L, -1, "keypress");
	
	lua_pushstring(L,ascii);
	lua_pushstring(L,name);
	lua_pushstring(L,act);
	
	docall(L, 3, 1);
	
	lua_pop(L,1); //remove junk from stack
	
	(*env)->ReleaseStringUTFChars(env, act_wank, act);
	(*env)->ReleaseStringUTFChars(env, name_wank, name);
	(*env)->ReleaseStringUTFChars(env, ascii_wank, ascii);
}


JNIEXPORT jstring JNICALL
	Java_com_wetgenes_Yarn_getstring(
		JNIEnv*  env,
		jclass class
	)
{
	const char *slua="return yarn.draw(2)";	
	luaL_loadbuffer(L, slua, strlen(slua), "yarn.string");
	docall(L, 0, 0);
	
	
    const char *s = lua_tostring(L, -1);
    lua_pop(L, 1);
	
	return (*env)->NewStringUTF(env, s);
}

JNIEXPORT void JNICALL
	Java_com_wetgenes_Yarn_draw(
		JNIEnv*  env,
		jclass class,
		jintArray a_wank
	)
{
	int i;
	int xp,yp;
	int xc,yc;
	int *bp;
	int *bpc;
	int c,ch;
	const unsigned char *cp;

//get the display string	
	const char *slua="return yarn.draw(1)";	
	luaL_loadbuffer(L, slua, strlen(slua), "yarn.string");
	docall(L, 0, 0);
    const char *s = lua_tostring(L, -1);
    lua_pop(L, 1);

	int *a = (int *)(*env)->GetPrimitiveArrayCritical(env,a_wank,0);

	for(yp=0;yp<240;yp+=8)
	{
		for(xp=0;xp<320;xp+=8)
		{
			bp=a+yp*320+xp; // char base
			
			c=0; while(c<32) { c=*(s++); } // step through draw string but skip endoflines 
			
			c=c-32; if(c>95) { c=95; } // sanitize 0-95

			cp=font_bits + (c&0x0f) + ((c<<3)&0x780);
			
//			if(c==32) ch=0xff000000; else ch=0xffffffff;
			
			for(yc=0;yc<8;yc++)
			{
				c=(*cp);
				cp=cp+16;
				
				bpc=bp+yc*320;
				for(xc=0;xc<8;xc++)
				{
					if(c&0x80) { *(bpc++)=0xff00ff00; }
					else { *(bpc++)=0xff000000; }
					c=c<<1;
				}
			}
			
		}
	}
	
		
/*	for(i=0;i<320*240;i++)
	{
		a[i]=0xff000000 | (a[i]+i);
	}*/
	
	llog("drawn stuff");
	
	(*env)->ReleasePrimitiveArrayCritical(env,a_wank,a,0);
}


JNIEXPORT jint JNICALL
	JNI_OnLoad(
		JavaVM *vm,
		void *reserved
	)
{
/*
 * void *jni_export_funcs[]=
{
	Java_com_wetgenes_Yarn_setup,
	Java_com_wetgenes_Yarn_clean,
	Java_com_wetgenes_Yarn_c_1update,
	Java_com_wetgenes_Yarn_getstring,
	0
};*/

    llog("Booting Yarn...");
    print_version();
    
	return JNI_VERSION_1_6;
}
