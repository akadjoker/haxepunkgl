package com.haxepunk.graphics;


import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Game;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.gl.Texture;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * Performance-optimized non-animated image. Can be drawn to the screen with transformations.
 */
class Image extends Graphic
{

	

	/**
	 * X origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originX:Float;

	/**
	 * Y origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originY:Float;



	/**
	 * Constructor.
	 * @param	source		Source image.
	 * @param	clipRect	Optional rectangle defining area of the source image to draw.
	 
	 */
	public function new(source:Texture,?c:Clip=null)
	{
		super();
		
		tex = source;
		if (c!=null)
		{
		clip = c;
		originX = c.offsetX;
		originY = c.offsetY;
		} else
		{
		clip = new Clip(0, 0, tex.width, tex.height);
		originX = originY = 0;
		}
		
	   
		

		
	
	}


	
		/**
	 * Width of the image.
	 */
	public var width(get, never):Int;
	private function get_width():Int { return clip.width; }

	/**
	 * Height of the image.
	 */
	public var height(get, never):Int;
	private function get_height():Int { return clip.height; }
	
	
	override public function render(m:Matrix,point:Point, camera:Point)
	{
		_point.x = point.x + x - originX - camera.x * scrollX;
		_point.y = point.y + y - originY - camera.y * scrollY;

			
	//_point.x =- originX - camera.x * scrollX;
	//_point.y =- originY - camera.y * scrollY;
		
		
	//Game.spriteBatch.drawEntitySize(tex, m, clip,width,height, _point.x,  _point.y, flipx, flipy, _red, _green, _blue, _alpha, blendMode);
	Game.spriteBatch.drawEntity(tex, m, clip, _point.x,  _point.y, flipx, flipy, _red, _green, _blue, _alpha, blendMode);
	
	// trace(_point.x + "<>" + camera.x+"<>"+scrollX+"<>"+x+"<>"+point.x);
	}

	




	



	/**
	 * Centers the Image's originX/Y to its center.
	 */
	public function centerOrigin()
	{
		originX = Std.int(clip.width / 2);
		originY = Std.int(clip.height / 2);
	}






	
	public var tex:Texture;




	// Flipped image information.
	private var _class:String;

	
}
