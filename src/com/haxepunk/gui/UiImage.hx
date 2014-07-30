package com.haxepunk.gui;

import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Texture;
import com.haxepunk.graphics.Image;
import openfl.geom.Matrix;
import openfl.geom.Point;

import com.haxepunk.gl.Clip;
import com.haxepunk.gl.Game;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.gl.Texture;

/**
 * ...
 * @author djoekr
 */
class UiImage extends Image
{

	public function new(source:Texture, ?c:Clip=null) 
	{
		super(source, c);
		
	}
	override public function render(m:Matrix,point:Point, camera:Point)
	{
		_point.x =m.tx+ point.x + x - originX - camera.x * scrollX;
		_point.y =m.ty+ point.y + y - originY - camera.y * scrollY;

			
	//_point.x =- originX - camera.x * scrollX;
	//_point.y =- originY - camera.y * scrollY;
		
		Game.spriteBatch.drawImageEx(tex, _point.x, _point.y, width, height, scaleX, scaleY, 0, originX, originY, clip, false, false, _red, _green, _blue, alpha,blendMode);
		
	//Game.spriteBatch.drawEntity(tex, m, clip, _point.x,  _point.y, flipx, flipy, _red, _green, _blue, _alpha, blendMode);
	
	// trace(_point.x + "<>" + camera.x+"<>"+scrollX+"<>"+x+"<>"+point.x);
	}

	
	
}