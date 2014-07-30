package com.haxepunk.gl;

import com.haxepunk.gl.Game;
import com.haxepunk.math.Vector2;
import com.haxepunk.utils.Util;
import openfl.display.OpenGLView;
import openfl.gl.GL;

import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Rectangle;




/**
 * ...
 * @author djoker
 */
class Camera 
{
	
	public var  worldWidth:Float;
	public var  worldHeight:Float;
	public var viewportWidth:Int;
	public var viewportHeight:Int;
	public var viewportX:Int;
	public var viewportY:Int;
	
	

		
	 public var projMatrix:Matrix3D;
	 public var viewMatrix:Matrix3D;
	 private var width:Float;
	 private var height:Float;
	 private var dirty:Bool;
	 private var viewport:Rectangle;
	 public var position:Vector2;//this value move the world matrix
//	 public var scrollX:Float;
//	 public var scrollY:Float;
//	
	

	public function new(width:Int,height:Int) 
	{
		projMatrix = Util.createOrtho(0, width, height, 0,  -100, 100);
		this.width = width;
		this.height = height;
	worldWidth = viewportWidth = width;
	worldHeight = viewportHeight = height;
	
	
		viewMatrix = new Matrix3D();
		scale = 1;
		viewport = new Rectangle(0,0,Std.int( width), Std.int(height));
		position = new Vector2(0, 0);
	//	scrollX = 0;
	//	scrollY = 0;
		dirty = true;
		
	}


	public function update()
	{
		if (dirty)
		{
	     viewMatrix.identity();
         viewMatrix.appendScale(scale, scale, 0);
		 viewMatrix.appendTranslation(Math.round(position.x), Math.round( position.y), 0);
	
		 dirty = false;
		}
		 

     //  GL.viewport (Std.int (viewport.x), Std.int (viewport.y), Std.int (viewport.width), Std.int (viewport.height));
	   
	  var scaled:Point = Util.getScale(stretch, HXP.width, HXP.height,   HXP.windowWidth , HXP.windowHeight);
	  
	  
	    viewportWidth = Math.round(scaled.x);
		viewportHeight = Math.round(scaled.y);
	
		viewportX = Std.int((HXP.windowWidth  - viewportWidth) / 2);
		viewportY = Std.int((HXP.windowHeight - viewportHeight) / 2);
		
	      GL.viewport (viewportX,viewportY,viewportWidth,viewportHeight);
	
		
	}
	public function resize(rect:Rectangle,width:Float, height:Float) 
	{
	 this.width = width;
	 this.height = height;
	 Util.setMatrix3DOrtho(projMatrix, 0, width, height, 0,  -100, 100);
	 viewport = rect;
    // trace("camera resize");
	
	// trace(HXP.width + "<>" + HXP.height);
	// trace(HXP.windowWidth + "<>" + HXP.windowHeight);
	}
	 	
	
	@:isVar public var scale(get_scale, set_scale):Float;
	private inline function get_scale():Float
	{
		
			return scale;
	}
	private inline function set_scale(v:Float):Float
	{
		dirty = true;
		return scale = v;
	}

	
	 public var x(get_x, set_x):Float;
	private inline function get_x():Float
	{
			return position.x;
	}
	private inline function set_x(v:Float):Float
	{
		dirty = true;
		return position.x = v;
	}
	public var y(get_y, set_y):Float;
	private inline function get_y():Float
	{
			return position.y;
	}
	private inline function set_y(v:Float):Float
	{
		dirty = true;
		return position.y = v;
	}
}