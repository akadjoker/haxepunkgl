package com.haxepunk;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.geom.Matrix;

/**
 * Container for the main screen buffer. Can be used to transform the screen.
 */
class Screen
{
	/**
	 * Constructor.
	 */
	public function new()
	{
		_sprite = new Sprite();
		init();
	}

	public function init()
	{
		x = y = originX = originY = 0;
		_angle = _current = 0;
		scale = scaleX = scaleY = 1;
		_color = 0xFF202020;
		update();

		// create screen buffers
		if (HXP.engine.contains(_sprite))
		{
			HXP.engine.removeChild(_sprite);
		}
	
	}


	/**
	 * Resizes the screen by recreating the bitmap buffer.
	 */
	public function resize()
	{
		width = HXP.width;
		height = HXP.height;

	
		_current = 0;
		needsResize = false;
	}

	

	

	

	/** @private Re-applies transformation matrix. */
	public function update()
	{
		
		if (_matrix == null)
		{
			_matrix = new Matrix();
		}
		_matrix.b = _matrix.c = 0;
		_matrix.a = fullScaleX;
		_matrix.d = fullScaleY;
		_matrix.tx = -originX * _matrix.a;
		_matrix.ty = -originY * _matrix.d;
		if (_angle != 0) _matrix.rotate(_angle);
		_matrix.tx += originX * fullScaleX + x;
		_matrix.ty += originY * fullScaleY + y;
		_sprite.transform.matrix = _matrix;
		
	}


	/**
	 * X offset of the screen.
	 */
	public var x(default, set):Int = 0;
	private function set_x(value:Int):Int
	{
		if (x == value) return value;
		x = value;
		update();
		return x;
	}

	/**
	 * Y offset of the screen.
	 */
	public var y(default, set):Int = 0;
	private function set_y(value:Int):Int
	{
		if (y == value) return value;
		y = value;
		update();
		return y;
	}

	/**
	 * X origin of transformations.
	 */
	public var originX(default, set):Int = 0;
	private function set_originX(value:Int):Int
	{
		if (originX == value) return value;
		originX = value;
		update();
		return originX;
	}

	/**
	 * Y origin of transformations.
	 */
	public var originY(default, set):Int = 0;
	private function set_originY(value:Int):Int
	{
		if (originY == value) return value;
		originY = value;
		update();
		return originY;
	}

	/**
	 * X scale of the screen.
	 */
	public var scaleX(default, set):Float = 1;
	private function set_scaleX(value:Float):Float
	{
		if (scaleX == value) return value;
		scaleX = value;
		fullScaleX = scaleX * scale;
		update();
		needsResize = true;
		return scaleX;
	}

	/**
	 * Y scale of the screen.
	 */
	public var scaleY(default, set):Float = 1;
	private function set_scaleY(value:Float):Float
	{
		if (scaleY == value) return value;
		scaleY = value;
		fullScaleY = scaleY * scale;
		update();
		needsResize = true;
		return scaleY;
	}

	/**
	 * Scale factor of the screen. Final scale is scaleX * scale by scaleY * scale, so
	 * you can use this factor to scale the screen both horizontally and vertically.
	 */
	public var scale(default, set):Float = 1;
	private function set_scale(value:Float):Float
	{
		if (scale == value) return value;
		scale = value;
		fullScaleX = scaleX * scale;
		fullScaleY = scaleY * scale;
		update();
		needsResize = true;
		return scale;
	}

	/**
	 * Final X scale value of the screen
	 */
	public var fullScaleX(default, null):Float = 1;

	/**
	 * Final Y scale value of the screen
	 */
	public var fullScaleY(default, null):Float = 1;

	/**
	 * True if the scale of the screen has changed.
	 */
	

	/**
	 * Rotation of the screen, in degrees.
	 */
	public var angle(get, set):Float;
	private function get_angle():Float { return _angle * HXP.DEG; }
	private function set_angle(value:Float):Float
	{
		if (_angle == value * HXP.RAD) return value;
		_angle = value * HXP.RAD;
		update();
		return _angle;
	}

	

	/**
	 * Width of the screen.
	 */
	public var width(default, null):Int;

	/**
	 * Height of the screen.
	 */
	public var height(default, null):Int;

	/**
	 * X position of the mouse on the screen.
	 */
	public var mouseX(get, null):Int;
	private function get_mouseX():Int { return Std.int(_sprite.mouseX); }

	/**
	 * Y position of the mouse on the screen.
	 */
	public var mouseY(get, null):Int;
	private function get_mouseY():Int { return Std.int(_sprite.mouseY); }


	public var needsResize:Bool = true;

	// Screen infromation.
	private var _sprite:Sprite;

	private var _current:Int;
	private var _matrix:Matrix;
	private var _angle:Float;
	private var _color:Int;
}
