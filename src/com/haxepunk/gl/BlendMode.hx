package com.haxepunk.gl;

import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;

/**
 * ...
 * @author djoker
 */
class BlendMode
{

public static var NORMAL:Int      = 0;
public static var ADD:Int         = 1;
public static var MULTIPLY:Int    = 2;
public static var SCREEN:Int      = 3;
public static var TRANSPARENT:Int      = 4;
public static var OPAQUE:Int      = 5;
public static var ADDMINS:Int      = 6;



static 	public function setBlend(mode:Int ) 
	{
	 switch( mode ) {
    case BlendMode.NORMAL:
		GL.blendFunc(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA );
    case BlendMode.ADD:
        GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );
	case BlendMode.MULTIPLY:
        GL.blendFunc(GL.DST_COLOR,GL.ONE_MINUS_SRC_ALPHA );
    case BlendMode.SCREEN:
       GL.blendFunc(GL.SRC_ALPHA, GL.ZERO );	
	case BlendMode.TRANSPARENT:   
		GL.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA );	
	case BlendMode.OPAQUE:   
		GL.blendFunc(GL.ONE, GL.ZERO );	
	case BlendMode.ADDMINS:   
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE );	    
		default:
        GL.blendFunc(GL.ONE,GL.ONE_MINUS_SRC_ALPHA );
    }
}
	
	
	
	
		
	
}