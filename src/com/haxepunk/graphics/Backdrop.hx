package com.haxepunk.graphics;
import com.haxepunk.gl.Game;
import com.haxepunk.gl.Texture;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import flash.geom.Point;
import openfl.geom.Matrix;

/**
 * A background texture that can be repeated horizontally and vertically
 * when drawn. Really useful for parallax backgrounds, textures, etc.
 */
class Backdrop extends Image
{
	/**
	 * Constructor.
	 * @param	source		Source texture.
	 * @param	repeatX		Repeat horizontally.
	 * @param	repeatY		Repeat vertically.
	 */
	public function new(source:Texture, repeatX:Bool = true, repeatY:Bool = true)
	{
	
		_textWidth = Std.int(source.width);
		_textHeight = Std.int(source.height);

		_repeatX = repeatX;
		_repeatY = repeatY;

		
		super(source);
		_width  = HXP.width  * (repeatX ? 1 : 0) + _textWidth;
		_height = HXP.height * (repeatY ? 1 : 0) + _textHeight;
		
	}





	override public function render(m:Matrix, point:Point, camera:Point)
	{
		
	    	_point.x = point.x + x - camera.x * scrollX;
		    _point.y = point.y + y - camera.y * scrollY;

			
		if (_repeatX)
		{
			_point.x %= _textWidth;
			if (_point.x > 0) _point.x -= _textWidth;
		}

		if (_repeatY)
		{
			_point.y %= _textHeight;
			if (_point.y > 0) _point.y -= _textHeight;
		}

		var sx = scale * scaleX,
			sy = scale * scaleY,
			fsx = HXP.screen.fullScaleX,
			fsy = HXP.screen.fullScaleY;
			Game.spriteBatch.darwBackDrop(tex, m,clip,originX,originY,-_point.x,-_point.y,_width * sx * fsx, _height * sy * fsy, _width,_height, !flipx, !flipy, _red, _green, _blue, _alpha, blendMode);
	}

	// Backdrop information.
	private var _textWidth:Int;
	private var _textHeight:Int;
	private var _repeatX:Bool;
	private var _repeatY:Bool;
	private var _width:Int;
	private var _height:Int;
}
